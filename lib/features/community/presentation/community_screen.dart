import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/spinning_nav_button.dart';
import '../../../data/models/post_model.dart';

import '../../notifications/data/notification_mock_data.dart';
import '../mockdata/profile_mock_data.dart';
import 'widgets/social_post_card.dart';
import 'widgets/comment_overlay.dart';
import 'widgets/your_latest_post_section.dart';
import '../../notifications/presentation/screens/notification_screen.dart';
import 'screens/personal_profile_screen.dart';
import 'screens/create_post_screen.dart';
import '../../chat/data/repositories/firebase_chat_repository.dart';
import '../../chat/presentation/screens/chat_list_screen.dart';
import '../../chat/mockdata/chat_mock_data.dart';
import 'providers/community_providers.dart';

class CommunityScreen extends ConsumerWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const _CommunityScreenContent();
  }
}

class _CommunityScreenContent extends ConsumerStatefulWidget {
  const _CommunityScreenContent();

  @override
  ConsumerState<_CommunityScreenContent> createState() =>
      _CommunityScreenContentState();
}

class _CommunityScreenContentState
    extends ConsumerState<_CommunityScreenContent> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.85) {
      ref.read(communityFeedProvider.notifier).loadMorePosts();
    }
  }

  void _navigateToProfile(String authorId) {
    final user = ProfileMockData.getUserByAuthorId(authorId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalProfileScreen(user: user),
      ),
    );
  }

  void _navigateToProfileByUsername(String mention) {
    final user = ProfileMockData.getUserByUsername(mention);
    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PersonalProfileScreen(user: user),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile not found for $mention'),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  void _handleNewPostCreated(Post newPost) {
    ref.read(userLatestPostProvider.notifier).setLatestPost(newPost);
  }

  void _deletePost(String postId) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    ref.read(communityFeedProvider.notifier).deletePost(postId, currentUser.uid);
  }

  void _deleteLatestPost() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;
    ref.read(userLatestPostProvider.notifier).deleteLatestPost(currentUser.uid);
  }

  void _toggleLikeOnLatestPost() {
    ref.read(userLatestPostProvider.notifier).toggleLike();
  }

  void _toggleLikeOnPost(String postId) {
    ref.read(communityFeedProvider.notifier).toggleLike(postId);
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(communityFeedProvider);
    final latestPostState = ref.watch(userLatestPostProvider);
    final shouldShowLatestPost = ref.watch(shouldShowLatestPostProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const SpinningNavButton(iconColor: AppColors.textPrimary),
        title: const Text('Feeds', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.iconColor),
            onPressed: () {},
          ),
          Badge(
            isLabelVisible: NotificationMockData.getUnreadCount() > 0,
            label: Text('${NotificationMockData.getUnreadCount()}'),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            offset: const Offset(-4, 4),
            child: IconButton(
              icon: const Icon(Icons.notifications, color: AppColors.iconColor),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
            ),
          ),
          Badge(
            isLabelVisible: ChatMockData.getTotalUnreadCount() > 0,
            label: Text('${ChatMockData.getTotalUnreadCount()}'),
            backgroundColor: AppColors.accentOrange,
            textColor: Colors.white,
            offset: const Offset(-4, 4),
            child: IconButton(
              icon: const Icon(
                Icons.chat_bubble_outline,
                color: AppColors.iconColor,
              ),
              onPressed: () {
                final currentUserId = FirebaseAuth.instance.currentUser?.uid;
                if (currentUserId == null) return;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatListScreen(
                      repository: FirebaseChatRepository(),
                      currentUserId: currentUserId,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.cardGradient),
        child: RefreshIndicator(
          color: AppColors.accentOrange,
          onRefresh: () =>
              ref.read(communityFeedProvider.notifier).refreshPosts(),
          child: feedState.posts.isEmpty && feedState.isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentOrange,
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                  itemCount: feedState.posts.length +
                      1 +
                      (shouldShowLatestPost ? 1 : 0),
                  itemBuilder: (context, index) {
                    // ── Latest post section ──────────────────────────────────
                    if (shouldShowLatestPost && index == 0) {
                      return YourLatestPostSection(
                        post: latestPostState.post!,
                        isLikedByMe: latestPostState.isLikedByMe,
                        onLike: _toggleLikeOnLatestPost,
                        onComment: () {
                          showCommentOverlay(
                            context,
                            latestPostState.post!,
                            // isLikedByMe lấy từ latestPostState
                            isLikedByMe: latestPostState.isLikedByMe,
                          );
                        },
                        onAvatarTap: () =>
                            _navigateToProfile(latestPostState.post!.authorId),
                        onAuthorNameTap: () =>
                            _navigateToProfile(latestPostState.post!.authorId),
                        onMentionTap: _navigateToProfileByUsername,
                        onPostTap: () {},
                        onDelete: _deleteLatestPost,
                      );
                    }

                    final adjustedIndex =
                        shouldShowLatestPost ? index - 1 : index;

                    // ── Loading / end indicator ──────────────────────────────
                    if (adjustedIndex == feedState.posts.length) {
                      if (feedState.isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accentOrange,
                            ),
                          ),
                        );
                      } else if (!feedState.hasMore) {
                        return Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Text(
                              'Bạn đã xem hết tất cả bài viết 🎉',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    }

                    // ── Post card ────────────────────────────────────────────
                    // feedState.posts là List<Post>; isLikedByMe tra qua likedPostIds
                    final post = feedState.posts[adjustedIndex];
                    final isLiked =
                        feedState.likedPostIds.contains(post.postId);

                    return SocialPostCard(
                      post: post,
                      isLikedByMe: isLiked,
                      onLike: () => _toggleLikeOnPost(post.postId),
                      onComment: () => showCommentOverlay(
                        context,
                        post,
                        // isLikedByMe lấy từ feedState.likedPostIds
                        isLikedByMe: isLiked,
                      ),
                      onAvatarTap: () => _navigateToProfile(post.authorId),
                      onAuthorNameTap: () => _navigateToProfile(post.authorId),
                      onMentionTap: _navigateToProfileByUsername,
                      onPostTap: () {},
                      onDelete: () => _deletePost(post.postId),
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Post>(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
          if (result != null) {
            _handleNewPostCreated(result);
          }
        },
        backgroundColor: AppColors.accentOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
