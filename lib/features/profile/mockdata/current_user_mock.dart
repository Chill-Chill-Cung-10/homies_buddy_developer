/// Mock data cho current user (Profile tab)
/// Sử dụng community mock data để tạo profile cho user hiện tại
library;
import '../../../data/models/user_model.dart';
import '../../community/mockdata/mock_users.dart';
import '../../community/mockdata/mock_user_posts.dart';

class CurrentUserMock {
  /// Current user — giả lập user đang đăng nhập
  static final UserModel currentUser = UserModel(
    id: 'current_user',
    username: 'manh_dev',
    fullName: 'Manh Developer',
    avatarUrl: 'https://picsum.photos/150/150?random=500',
    coverUrl: 'https://picsum.photos/800/1200?random=500',
    headline: 'HOMIES FOR LIFE',
    bio:
        'Pet lover & developer. Building a world where every pet finds a buddy.',
    location: 'Ho Chi Minh, Vietnam',
    humanBuddies: [MockUsers.jackUser, MockUsers.haiiaUser],
    followerCount: 2450,
    followingCount: 310,
    isFollowedByMe: false,
    posts: MockUserPosts.salahPosts,
    role: UserRole.user,
  );
}
