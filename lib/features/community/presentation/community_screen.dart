import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/spinning_nav_button.dart';
import '../mockdata/community_mock_data.dart';

/// [Refactored] Phase 3.6 — Import notification from its own feature module
import '../../notifications/data/notification_mock_data.dart';
import '../mockdata/profile_mock_data.dart';
import 'widgets/social_post_card.dart';
import 'widgets/comment_overlay.dart';
import '../../notifications/presentation/screens/notification_screen.dart';
import 'screens/personal_profile_screen.dart';
import 'screens/create_post_screen.dart';
import '../../chat/presentation/screens/chat_list_screen.dart';
import '../../chat/mockdata/chat_mock_data.dart';

/// Community Screen - Community Feed với Social Post Cards
///
/// Hiển thị feed của các bài post từ community
class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  // Pagination state
  final List<dynamic> _posts = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  static const int _postsPerPage = 10;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialPosts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Load initial posts
  Future<void> _loadInitialPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      final allPosts = CommunityMockData.mockPosts;
      final initialPosts = allPosts.take(_postsPerPage).toList();

      setState(() {
        _posts.addAll(initialPosts);
        _currentPage = 1;
        _hasMore = allPosts.length > _postsPerPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Load more posts when scrolling
  Future<void> _loadMorePosts() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network delay
      final allPosts = CommunityMockData.mockPosts;
      final startIndex = _currentPage * _postsPerPage;
      final endIndex = startIndex + _postsPerPage;

      final morePosts = allPosts.skip(startIndex).take(_postsPerPage).toList();

      setState(() {
        _posts.addAll(morePosts);
        _currentPage++;
        _hasMore = endIndex < allPosts.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Detect scroll position and load more
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.85) {
      _loadMorePosts();
    }
  }

  // Refresh posts
  Future<void> _refreshPosts() async {
    setState(() {
      _posts.clear();
      _currentPage = 0;
      _hasMore = true;
    });
    await _loadInitialPosts();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SpinningNavButton(iconColor: AppColors.textPrimary),
        title: const Text('Feeds', style: AppTextStyles.h2),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.iconColor),
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
              icon: const Icon(Icons.notifications, color: AppColors.iconColor),
              onPressed: () {
                // Navigate to Notification Screen
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const NotificationScreen(),
                      ),
                    )
                    .then((_) {
                      // Refresh badge count after returning from notifications
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
                // Navigate to Chat List Screen
                Navigator.of(context)
                    .push(
                      MaterialPageRoute(
                        builder: (context) => const ChatListScreen(),
                      ),
                    )
                    .then((_) {
                      // Refresh badge count after returning from chat
                      setState(() {});
                    });
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppColors.cardGradient),
        child: RefreshIndicator(
          color: AppColors.accentOrange,
          onRefresh: _refreshPosts,
          child: _posts.isEmpty && _isLoading
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
                  itemCount: _posts.length + 1, // +1 for loading indicator
                  itemBuilder: (context, index) {
                    // Show loading indicator at bottom
                    if (index == _posts.length) {
                      if (_isLoading) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.accentOrange,
                            ),
                          ),
                        );
                      } else if (!_hasMore) {
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

                    // Show post card
                    final post = _posts[index];
                    return SocialPostCard(
                      post: post,
                      onLike: () {
                        setState(() {
                          // Toggle like state
                          final updatedPost = post.copyWith(
                            isLikedByMe: !post.isLikedByMe,
                            reactsCount: post.isLikedByMe
                                ? post.reactsCount - 1
                                : post.reactsCount + 1,
                          );
                          _posts[index] = updatedPost;
                        });
                      },
                      onComment: () {
                        // Show comment overlay
                        showCommentOverlay(context, post);
                      },
                      onAvatarTap: () {
                        _navigateToProfile(context, post.authorId);
                      },
                      onAuthorNameTap: () {
                        _navigateToProfile(context, post.authorId);
                      },
                      onMentionTap: (mention) {
                        _navigateToProfileByUsername(context, mention);
                      },
                      onPostTap: () {
                        // TODO: Navigate to post detail
                      },
                    );
                  },
                ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreen(),
            ),
          );
        },
        backgroundColor: AppColors.accentOrange,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
