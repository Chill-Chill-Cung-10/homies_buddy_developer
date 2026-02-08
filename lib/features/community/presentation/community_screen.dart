import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../mockdata/community_mock_data.dart';
import 'widgets/social_post_card.dart';
import 'widgets/comment_overlay.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Community',
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
          IconButton(
            icon: const Icon(
              Icons.add_circle_outline,
              color: AppColors.iconColor,
            ),
            onPressed: () {
              // TODO: Create new post
            },
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
                  // TODO: Navigate to profile
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Profile: ${post.authorName}'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
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
