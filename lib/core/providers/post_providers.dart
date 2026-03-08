import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/post_model.dart';
import '../../data/models/media_file_model.dart';
import '../../data/models/enums/post_privacy.dart';
import '../../data/repositories/post_repository.dart';
import 'core_providers.dart';

// =============================================================================
// POST FEED PROVIDERS
// =============================================================================

/// Community feed (public posts) - stream
final communityFeedProvider = StreamProvider<List<Post>>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getFeed(limit: 20);
});

/// User's posts - stream
final userPostsProvider = StreamProvider.family<List<Post>, String>((
  ref,
  userId,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getUserPosts(userId, limit: 20);
});

/// Get single post by ID - stream
final postStreamProvider = StreamProvider.family<Post?, String>((ref, postId) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostStream(postId);
});

/// Get single post by ID - future (one-time)
final postFutureProvider = FutureProvider.family<Post?, String>((ref, postId) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostById(postId);
});

/// Check if user has reacted to a post
final hasReactedPostProvider = FutureProvider.family<bool, String>((
  ref,
  postId,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.hasReacted(postId);
});

/// Get posts by hashtag
final postsByHashtagProvider = StreamProvider.family<List<Post>, String>((
  ref,
  hashtag,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsByHashtag(hashtag, limit: 30);
});

/// Get posts by mention
final postsByMentionProvider = StreamProvider.family<List<Post>, String>((
  ref,
  username,
) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsByMention(username, limit: 30);
});

// =============================================================================
// POST ACTIONS PROVIDER
// =============================================================================

/// Provider cho các actions liên quan đến posts
///
/// Usage:
/// ```dart
/// final postActions = ref.read(postActionsProvider);
/// await postActions.createPost(contentText: '...', mediaFiles: [...]);
/// ```
final postActionsProvider = Provider<PostActions>((ref) {
  final repository = ref.watch(postRepositoryProvider);
  return PostActions(repository: repository, ref: ref);
});

class PostActions {
  final PostRepository repository;
  final Ref ref;

  PostActions({required this.repository, required this.ref});

  /// Create new post
  Future<String> createPost({
    required String contentText,
    required List<MediaFile> mediaFiles,
    List<String>? hashtags,
    List<String>? mentions,
    PostPrivacy privacy = PostPrivacy.public,
  }) async {
    // Extract hashtags from content if not provided
    final extractedHashtags = hashtags ?? _extractHashtags(contentText);

    // Extract mentions from content if not provided
    final extractedMentions = mentions ?? _extractMentions(contentText);

    return await repository.createPost(
      contentText: contentText,
      mediaFiles: mediaFiles,
      hashtags: extractedHashtags,
      mentions: extractedMentions,
      privacy: privacy,
    );
  }

  /// Update post
  Future<void> updatePost(
    String postId, {
    String? contentText,
    List<String>? hashtags,
    PostPrivacy? privacy,
  }) async {
    await repository.updatePost(
      postId,
      contentText: contentText,
      hashtags: hashtags,
      privacy: privacy,
    );
  }

  /// Delete post
  Future<void> deletePost(String postId) async {
    await repository.deletePost(postId);
  }

  /// Toggle react (like/unlike)
  Future<void> toggleReact(String postId) async {
    await repository.toggleReact(postId);
  }

  /// Extract hashtags from text
  List<String> _extractHashtags(String text) {
    final regex = RegExp(r'#(\w+)');
    final matches = regex.allMatches(text);
    return matches.map((match) => match.group(1)!).toList();
  }

  /// Extract mentions from text
  List<String> _extractMentions(String text) {
    final regex = RegExp(r'@(\w+)');
    final matches = regex.allMatches(text);
    return matches.map((match) => '@${match.group(1)!}').toList();
  }
}

// =============================================================================
// POST STATE NOTIFIER (for complex state management)
// =============================================================================

/// State cho post creation flow
class PostCreationState {
  final String contentText;
  final List<MediaFile> mediaFiles;
  final PostPrivacy privacy;
  final bool isUploading;
  final String? error;

  PostCreationState({
    this.contentText = '',
    this.mediaFiles = const [],
    this.privacy = PostPrivacy.public,
    this.isUploading = false,
    this.error,
  });

  PostCreationState copyWith({
    String? contentText,
    List<MediaFile>? mediaFiles,
    PostPrivacy? privacy,
    bool? isUploading,
    String? error,
  }) {
    return PostCreationState(
      contentText: contentText ?? this.contentText,
      mediaFiles: mediaFiles ?? this.mediaFiles,
      privacy: privacy ?? this.privacy,
      isUploading: isUploading ?? this.isUploading,
      error: error ?? this.error,
    );
  }
}

/// Post creation notifier
class PostCreationNotifier extends StateNotifier<PostCreationState> {
  PostCreationNotifier() : super(PostCreationState());

  void updateContent(String text) {
    state = state.copyWith(contentText: text);
  }

  void addMediaFile(MediaFile file) {
    state = state.copyWith(mediaFiles: [...state.mediaFiles, file]);
  }

  void removeMediaFile(int index) {
    final newFiles = List<MediaFile>.from(state.mediaFiles)..removeAt(index);
    state = state.copyWith(mediaFiles: newFiles);
  }

  void setPrivacy(PostPrivacy privacy) {
    state = state.copyWith(privacy: privacy);
  }

  void setUploading(bool uploading) {
    state = state.copyWith(isUploading: uploading);
  }

  void setError(String? error) {
    state = state.copyWith(error: error);
  }

  void reset() {
    state = PostCreationState();
  }
}

/// Provider cho post creation state
final postCreationProvider =
    StateNotifierProvider<PostCreationNotifier, PostCreationState>((ref) {
      return PostCreationNotifier();
    });
