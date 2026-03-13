/// [Refactored] Phase 3.2 — Integrated PostRepository for real post fetching
///   - Fetch posts from feed_post table via PostRepositoryImpl.getUserPosts()
///   - Pagination: 5 posts/page, load more on scroll
///   - currentUserId from FirebaseAuth (consistent with follow/chat logic)
library;

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_shapes.dart';
import '../../../../data/models/user_model.dart';
import '../../../../data/models/post_model.dart';
import '../../../chat/data/repositories/firebase_chat_repository.dart';
import '../../../chat/presentation/screens/chat_detail_screen.dart';
import '../../../community/data/repositories/post_repository.dart';
import '../../../community/data/repositories/post_repository_impl.dart';
import '../../../community/data/repositories/media_repository_impl.dart';
import '../widgets/comment_overlay.dart';
import '../widgets/profile/profile_hero_header.dart';
import '../widgets/profile/profile_stats_section.dart';
import '../widgets/profile/profile_buddies_section.dart';
import '../widgets/profile/profile_post_feed.dart';

/// Personal Profile Screen
///
/// Layout 1: Hero Screen - Fullscreen cover image with user info overlay
/// Layout 2: Detailed view - Shows buddies list and user posts (revealed on scroll)
///
/// Posts are fetched from feed_post table via PostRepository.
/// Pagination: 5 posts per page, auto-loads more on scroll.
class PersonalProfileScreen extends StatefulWidget {
  final UserModel user;

  const PersonalProfileScreen({super.key, required this.user});

  @override
  State<PersonalProfileScreen> createState() => _PersonalProfileScreenState();
}

class _PersonalProfileScreenState extends State<PersonalProfileScreen> {
  // ── User state ────────────────────────────────────────────────────────────
  late UserModel _user;
  late List<UserModel> _allBuddies;

  // ── Post state ────────────────────────────────────────────────────────────
  final List<Post> _posts = [];
  final List<bool> _likedStatus = [];
  bool _isLoadingPosts = false;
  bool _hasMorePosts = true;
  int _currentPage = 0;
  static const int _pageSize = 5;

  // ── Repositories ──────────────────────────────────────────────────────────
  final SupabaseClient _supabase = Supabase.instance.client;
  final FirebaseChatRepository _chatRepository = FirebaseChatRepository();
  late final PostRepository _postRepository;

  // ── Scroll ────────────────────────────────────────────────────────────────
  final ScrollController _scrollController = ScrollController();

  // ── Misc ──────────────────────────────────────────────────────────────────
  bool _isRefreshingProfile = false;
  bool _isFollowUpdating = false;

  String? get _currentUserId => FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _allBuddies = _user.allHomies;

    // Init PostRepository (MediaRepository required by impl but not used for reads)
    _postRepository = PostRepositoryImpl(
      mediaRepository: MediaRepositoryImpl(),
    );

    _scrollController.addListener(_onScroll);

    _refreshProfileFromRepository();
    _fetchPosts();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Scroll listener ───────────────────────────────────────────────────────

  void _onScroll() {
    // Trigger load more when within 200px of the bottom
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _fetchMorePosts();
    }
  }

  // ── Fetch user profile ────────────────────────────────────────────────────

  Future<void> _refreshProfileFromRepository() async {
    if (_isRefreshingProfile) return;
    setState(() => _isRefreshingProfile = true);

    try {
      // Fetch from Supabase
      final response = await _supabase
          .from('user_profile')
          .select()
          .eq('id', _user.id)
          .maybeSingle();

      if (response == null) return;

      final fetched = UserModel(
        id: response['id'] as String,
        username: response['username'] as String? ?? '',
        fullName: response['full_name'] as String? ?? '',
        avatarUrl: response['avatar_url'] as String? ?? '',
        coverUrl: response['cover_url'] as String?,
        bio: response['bio'] as String?,
        location: response['location'] as String?,
        followerCount: (response['follower_count'] as num?)?.toInt() ?? 0,
        followingCount: (response['following_count'] as num?)?.toInt() ?? 0,
        createdAt: response['created_at'] != null
            ? DateTime.tryParse(response['created_at'] as String)
            : null,
      );

      bool? isFollowing;
      if (_currentUserId != null && _currentUserId != fetched.id) {
        isFollowing = await _checkIsFollowing(fetched.id);
      }

      if (!mounted) return;

      final mergedUser = fetched.copyWith(
        humanBuddies: fetched.humanBuddies.isNotEmpty
            ? fetched.humanBuddies
            : _user.humanBuddies,
        isFollowedByMe: isFollowing ?? fetched.isFollowedByMe,
        // Posts are managed separately — do not merge here
        posts: const [],
      );

      setState(() {
        _user = mergedUser;
        _allBuddies = _user.allHomies;
      });
    } catch (_) {
      // Keep existing UI data if network fetch fails.
    } finally {
      if (mounted) setState(() => _isRefreshingProfile = false);
    }
  }

  // ── Helper: Check following status ────────────────────────────────────────

  Future<bool> _checkIsFollowing(String targetUserId) async {
    if (_currentUserId == null) return false;
    try {
      final response = await _supabase
          .from('user_follows')
          .select()
          .eq('follower_id', _currentUserId!)
          .eq('following_id', targetUserId)
          .maybeSingle();
      return response != null;
    } catch (_) {
      return false;
    }
  }

  // ── Fetch posts (initial) ─────────────────────────────────────────────────

  Future<void> _fetchPosts() async {
    if (_isLoadingPosts) return;
    setState(() => _isLoadingPosts = true);

    try {
      final result = await _postRepository.getUserPosts(
        userId: _user.id,
        page: 0,
        limit: _pageSize,
        currentUserId: _currentUserId,
      );

      if (!mounted) return;
      setState(() {
        _posts
          ..clear()
          ..addAll(result.posts.map((p) => p.post));
        _likedStatus
          ..clear()
          ..addAll(result.posts.map((p) => p.isLikedByMe));
        _hasMorePosts = result.hasMore;
        _currentPage = 1;
      });
    } catch (e) {
      if (!mounted) return;
      // Silently fail — show empty state in feed
    } finally {
      if (mounted) setState(() => _isLoadingPosts = false);
    }
  }

  // ── Fetch posts (pagination) ──────────────────────────────────────────────

  Future<void> _fetchMorePosts() async {
    if (_isLoadingPosts || !_hasMorePosts) return;
    setState(() => _isLoadingPosts = true);

    try {
      final result = await _postRepository.getUserPosts(
        userId: _user.id,
        page: _currentPage,
        limit: _pageSize,
        currentUserId: _currentUserId,
      );

      if (!mounted) return;
      setState(() {
        _posts.addAll(result.posts.map((p) => p.post));
        _likedStatus.addAll(result.posts.map((p) => p.isLikedByMe));
        _hasMorePosts = result.hasMore;
        _currentPage++;
      });
    } catch (e) {
      // Silently fail — user can scroll again to retry
    } finally {
      if (mounted) setState(() => _isLoadingPosts = false);
    }
  }

  // ── Toggle like ───────────────────────────────────────────────────────────

  Future<void> _toggleLike(int index) async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) return;

    final post = _posts[index];
    final wasLiked = _likedStatus[index];

    // Optimistic update
    setState(() {
      _likedStatus[index] = !wasLiked;
      _posts[index] = post.copyWith(
        reactsCount: wasLiked
            ? (post.reactsCount - 1).clamp(0, double.maxFinite).toInt()
            : post.reactsCount + 1,
      );
    });

    try {
      await _postRepository.toggleLike(post.postId, currentUserId);
    } catch (e) {
      // Revert on failure
      if (!mounted) return;
      setState(() {
        _likedStatus[index] = wasLiked;
        _posts[index] = post;
      });
    }
  }

  // ── Follow ────────────────────────────────────────────────────────────────

  Future<void> _toggleFollow() async {
    if (_isFollowUpdating) return;

    final currentUserId = _currentUserId;
    if (currentUserId == null || currentUserId == _user.id) return;

    final wasFollowing = _user.isFollowedByMe;

    setState(() {
      _isFollowUpdating = true;
      _user = _user.copyWith(
        isFollowedByMe: !wasFollowing,
        followerCount: wasFollowing
            ? _user.followerCount - 1
            : _user.followerCount + 1,
      );
    });

    try {
      if (wasFollowing) {
        // Unfollow: delete from user_follows
        await _supabase
            .from('user_follows')
            .delete()
            .eq('follower_id', currentUserId)
            .eq('following_id', _user.id);
      } else {
        // Follow: insert into user_follows
        await _supabase.from('user_follows').insert({
          'follower_id': currentUserId,
          'following_id': _user.id,
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _user = _user.copyWith(
          isFollowedByMe: wasFollowing,
          followerCount: wasFollowing
              ? _user.followerCount + 1
              : _user.followerCount - 1,
        );
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Follow update failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _isFollowUpdating = false);
    }
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _navigateToBuddyProfile(UserModel buddy) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalProfileScreen(user: buddy),
      ),
    );
  }

  // ── Chat ──────────────────────────────────────────────────────────────────

  Future<void> _startChatWithUser() async {
    final currentUserId = _currentUserId;
    if (currentUserId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to chat.')),
      );
      return;
    }

    if (currentUserId == _user.id) return;

    try {
      final conversation = await _chatRepository.getOrCreateConversation(
        currentUserId: currentUserId,
        otherUserId: _user.id,
        otherUserName: _user.displayName,
        otherUserAvatar: _user.avatarUrl,
      );

      if (!mounted) return;
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            conversation: conversation,
            repository: _chatRepository,
            currentUserId: currentUserId,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot open chat: $e')),
      );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Layout 1: Hero Header
          ProfileHeroHeader(user: _user),

          // Layout 2: Detail content (stats + buddies)
          SliverToBoxAdapter(child: _buildDetailSection()),

          // Post feed with pagination
          ProfilePostFeed(
            posts: _posts,
            likedStatus: _likedStatus,
            onLike: _toggleLike,
            onComment: (post) {
              final index = _posts.indexOf(post);
              showCommentOverlay(
                context,
                post,
                isLikedByMe: index >= 0 ? _likedStatus[index] : false,
              );
            },
          ),

          // Load more indicator
          if (_isLoadingPosts && _posts.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.accentOrange,
                    strokeWidth: 2,
                  ),
                ),
              ),
            ),

          // No more posts indicator
          if (!_hasMorePosts && _posts.isNotEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    '— No more posts —',
                    style: TextStyle(color: AppColors.textHint, fontSize: 13),
                  ),
                ),
              ),
            ),

          // Bottom spacing
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  // ── Detail section ────────────────────────────────────────────────────────

  Widget _buildDetailSection() {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.cardGradient),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppShapes.paddingL),

          ProfileStatsSection(
            user: _user,
            onFollowToggle: _toggleFollow,
            onChatTap: _startChatWithUser,
          ),

          const SizedBox(height: AppShapes.paddingL),

          if (_allBuddies.isNotEmpty) ...[
            ProfileBuddiesSection(
              displayName: _user.displayName,
              allBuddies: _allBuddies,
              onBuddyTap: _navigateToBuddyProfile,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppShapes.paddingM),
              child: Divider(height: 1, color: AppColors.surfaceColor),
            ),
            const SizedBox(height: AppShapes.paddingM),
          ],
        ],
      ),
    );
  }
}
