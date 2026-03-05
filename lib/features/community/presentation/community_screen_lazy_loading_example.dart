import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/spinning_nav_button.dart';
import '../../../core/widgets/loading_indicators.dart';
import '../../../core/mixins/pagination_mixin.dart';
import '../../notifications/data/notification_mock_data.dart';
import '../../notifications/presentation/screens/notification_screen.dart';
import '../../chat/presentation/screens/chat_list_screen.dart';
import '../../chat/mockdata/chat_mock_data.dart';
import '../../../data/models/post_model.dart';
import '../mockdata/community_mock_data.dart';
import '../mockdata/profile_mock_data.dart';
import 'widgets/social_post_card.dart';
import 'widgets/comment_overlay.dart';
import 'screens/personal_profile_screen.dart';

/// Community Screen với Lazy Loading và Pagination
/// 
/// Features:
/// - Infinite scroll pagination
/// - Pull to refresh
/// - Lazy image loading
/// - Loading states & error handling
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with PaginationMixin<Post, CommunityScreen> {
  
  // Repository để fetch posts (trong thực tế sẽ dùng Firebase/API)
  // final _postRepository = PostRepository();
  
  @override
  int get itemsPerPage => 10;
  
  @override
  double get loadMoreThreshold => 0.8; // Load khi scroll 80%
  
  String? _error;
  
  @override
  Future<void> loadInitialItems() async {
    setState(() {
      isLoading = true;
      _error = null;
    });
    
    try {
      // TODO: Replace with actual API call
      // final posts = await _postRepository.getFeed(
      //   page: 0,
      //   limit: itemsPerPage,
      // );
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Mock data for now
      final allPosts = CommunityMockData.mockPosts;
      final posts = allPosts.take(itemsPerPage).toList();
      
      setState(() {
        items.clear();
        items.addAll(posts);
        currentPage = 0;
        hasMore = posts.length >= itemsPerPage;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load posts. Please try again.';
        isLoading = false;
      });
      debugPrint('Error loading posts: $e');
    }
  }
  
  @override
  Future<void> loadMoreItems() async {
    if (isLoading || !hasMore) return;
    
    setState(() => isLoading = true);
    
    try {
      // TODO: Replace with actual API call
      // final posts = await _postRepository.getFeed(
      //   page: currentPage + 1,
      //   limit: itemsPerPage,
      // );
      
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 600));
      
      // Mock pagination
      final allPosts = CommunityMockData.mockPosts;
      final startIndex = (currentPage + 1) * itemsPerPage;
      final endIndex = startIndex + itemsPerPage;
      
      if (startIndex >= allPosts.length) {
        setState(() {
          hasMore = false;
          isLoading = false;
        });
        return;
      }
      
      final posts = allPosts.sublist(
        startIndex,
        endIndex > allPosts.length ? allPosts.length : endIndex,
      );
      
      setState(() {
        items.addAll(posts);
        currentPage++;
        hasMore = posts.length >= itemsPerPage;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load more posts: $e'),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: loadMoreItems,
            ),
          ),
        );
      }
      debugPrint('Error loading more posts: $e');
    }
  }
  
  void _navigateToProfile(BuildContext context, String authorId) {
    final user = ProfileMockData.getUserByAuthorId(authorId);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PersonalProfileScreen(user: user),
      ),
    );
  }
  
  void _navigateToProfileByUsername(BuildContext context, String mention) {
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
  
  void _handleLike(int index) {
    setState(() {
      final post = items[index];
      final updatedPost = post.copyWith(
        isLikedByMe: !post.isLikedByMe,
        reactsCount: post.isLikedByMe
            ? post.reactsCount - 1
            : post.reactsCount + 1,
      );
      items[index] = updatedPost;
    });
    
    // TODO: Call API to update like status
    // await _postRepository.toggleLike(post.postId);
  }
  
  void _handleComment(Post post) {
    showCommentOverlay(context, post);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SpinningNavButton(
          iconColor: AppColors.textPrimary,
        ),
        title: const Text(
          'Feeds',
          style: AppTextStyles.h2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: AppColors.iconColor,
            ),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          Badge(
            isLabelVisible: NotificationMockData.getUnreadCount() > 0,
            label: Text('${NotificationMockData.getUnreadCount()}'),
            backgroundColor: Colors.red,
            textColor: Colors.white,
            offset: const Offset(-4, 4),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                color: AppColors.iconColor,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                ).then((_) {
                  setState(() {});
                });
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChatListScreen(),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
        ),
        child: _buildBody(),
      ),
    );
  }
  
  Widget _buildBody() {
    // Error state
    if (_error != null && items.isEmpty) {
      return ErrorStateWidget(
        message: _error,
        onRetry: loadInitialItems,
      );
    }
    
    // Initial loading state
    if (isLoading && items.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: 3,
        itemBuilder: (context, index) => const PostCardSkeleton(),
      );
    }
    
    // Empty state
    if (items.isEmpty) {
      return const EmptyStateWidget(
        title: 'No posts yet',
        subtitle: 'Check back later for new content from your community',
        icon: Icons.feed_outlined,
      );
    }
    
    // List with items
    return RefreshIndicator(
      color: AppColors.accentOrange,
      onRefresh: refresh,
      child: ListView.builder(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: items.length + (isLoading ? 1 : hasMore ? 1 : 1),
        itemBuilder: (context, index) {
          // Loading indicator at bottom
          if (index >= items.length) {
            if (isLoading) {
              return const BottomLoadingIndicator(
                message: 'Loading more posts...',
              );
            } else if (!hasMore) {
              return const EndOfListWidget(
                message: "You're all caught up! 🎉",
              );
            } else {
              return const SizedBox.shrink();
            }
          }
          
          final post = items[index];
          return SocialPostCard(
            post: post,
            onLike: () => _handleLike(index),
            onComment: () => _handleComment(post),
            onAvatarTap: () => _navigateToProfile(context, post.authorId),
            onAuthorNameTap: () => _navigateToProfile(context, post.authorId),
            onMentionTap: (mention) => _navigateToProfileByUsername(context, mention),
          );
        },
      ),
    );
  }
}
