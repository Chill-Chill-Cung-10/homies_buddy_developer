import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../mockdata/community_mock_data.dart';
import '../mockdata/notification_mock_data.dart';
import '../mockdata/profile_mock_data.dart';
import 'widgets/social_post_card.dart';
import 'widgets/comment_overlay.dart';
import 'notification_screen.dart';
import 'screens/personal_profile_screen.dart';
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
  final _posts = CommunityMockData.mockPosts;

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
        title: const Text(
          'Amicute',
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
                // Navigate to Notification Screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                ).then((_) {
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ChatListScreen(),
                  ),
                ).then((_) {
                  // Refresh badge count after returning from chat
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
        child: RefreshIndicator(
          color: AppColors.accentOrange,
          onRefresh: () async {
            // TODO: Implement refresh
            await Future.delayed(const Duration(seconds: 1));
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemCount: _posts.length,
            itemBuilder: (context, index) {
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
          // TODO: Create new post
        },
        backgroundColor: AppColors.accentOrange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
