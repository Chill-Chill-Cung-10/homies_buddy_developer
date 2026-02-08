import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/models/post_model.dart';
import '../mockdata/notification_mock_data.dart';
import '../mockdata/community_mock_data.dart';
import 'widgets/notification_item.dart';
import 'widgets/comment_overlay.dart';

/// Notification Screen - Màn hình hiển thị danh sách thông báo
/// 
/// Instagram-style notification screen với scrollable list
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late List<NotificationModel> _notifications;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      _notifications = NotificationMockData.getAllNotifications();
    });
  }

  void _handleNotificationTap(NotificationModel notification) {
    // Mark as read first
    NotificationMockData.markAsRead(notification.notificationId);
    _loadNotifications();

    // Parse deepLink and navigate
    final params = _parseDeepLink(notification.deepLink);
    
    switch (params['type']) {
      case 'profile':
        _navigateToProfile(params['userId']!);
        break;
      case 'post':
        _navigateToPost(params['postId']!);
        break;
      case 'comment':
        _navigateToComment(params['postId']!, params['commentId']!);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unknown notification type: ${notification.deepLink}'),
            backgroundColor: AppColors.errorRed,
          ),
        );
    }
  }

  /// Parse deepLink string to extract navigation parameters
  Map<String, String> _parseDeepLink(String deepLink) {
    final uri = Uri.parse(deepLink);
    final segments = uri.pathSegments;
    
    // Format: /community/post/1 → {type: 'post', postId: '1'}
    // Format: /community/post/1/comment/c1_1 → {type: 'comment', postId: '1', commentId: 'c1_1'}
    // Format: /profile/user4 → {type: 'profile', userId: 'user4'}
    
    if (segments.contains('profile')) {
      return {'type': 'profile', 'userId': segments.last};
    } else if (segments.contains('comment')) {
      return {
        'type': 'comment',
        'postId': segments[2],
        'commentId': segments[4],
      };
    } else if (segments.contains('post')) {
      return {'type': 'post', 'postId': segments[2]};
    }
    
    return {'type': 'unknown'};
  }

  /// Navigate to user profile
  void _navigateToProfile(String userId) {
    Navigator.pop(context); // Back to Community
    
    // TODO: Implement proper Profile tab navigation
    // This requires access to the main tab controller/navigator
    // For now, show a message
    Future.delayed(const Duration(milliseconds: 300), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Navigate to Profile - User: $userId (Coming soon)'),
          duration: const Duration(seconds: 2),
          backgroundColor: AppColors.accentOrange,
        ),
      );
    });
  }

  /// Navigate to post (open comment overlay)
  void _navigateToPost(String postId) {
    // Find post from mock data
    final post = CommunityMockData.mockPosts.cast<Post?>().firstWhere(
      (p) => p?.postId == postId,
      orElse: () => null,
    );
    
    if (post != null) {
      Navigator.pop(context); // Back to Community
      
      // Open comment overlay after short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        showCommentOverlay(context, post);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post not found'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  /// Navigate to comment (open overlay and highlight specific comment)
  void _navigateToComment(String postId, String commentId) {
    // Find post from mock data
    final post = CommunityMockData.mockPosts.cast<Post?>().firstWhere(
      (p) => p?.postId == postId,
      orElse: () => null,
    );
    
    if (post != null) {
      Navigator.pop(context); // Back to Community
      
      // Open comment overlay with highlight after short delay
      Future.delayed(const Duration(milliseconds: 300), () {
        showCommentOverlay(
          context,
          post,
          highlightCommentId: commentId,
        );
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post or comment not found'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.iconColor,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: AppTextStyles.h2,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : _buildNotificationList(),
    );
  }

  /// Empty state when no notifications
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 64,
            color: AppColors.textHint.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications yet',
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textHint,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you get notifications, they\'ll show up here',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Notification list
  Widget _buildNotificationList() {
    return ListView.separated(
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => Divider(
        height: 1,
        color: AppColors.textHint.withValues(alpha: 0.1),
      ),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return NotificationItem(
          notification: notification,
          onTap: () => _handleNotificationTap(notification),
        );
      },
    );
  }
}
