import 'package:freezed_annotation/freezed_annotation.dart';
import 'post_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// User Role - Vai trò của user
enum UserRole {
  @JsonValue('user')
  user,
  @JsonValue('admin')
  admin,
}

/// [Refactored] Phase 2.3 — Community social profile model (SINGLE SOURCE OF TRUTH).
///
/// Đây là model chính cho user profile, chứa đầy đủ:
/// identity, social graph, posts, followers, role, etc.
///
/// Khác với `features/auth/data/models/user_model.dart` (auth-only, lightweight).
/// Model này được thiết kế để hỗ trợ UI Visual (như màn hình "Yoga In Life")
/// và Social Graph (Homies với cả người và thú cưng).
@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    // --- 1. Identity (Định danh) ---
    required String id,
    required String username, // @salahhh (Unique ID)
    required String fullName, // "Salahhh Home" / "Robert Fox"
    required String avatarUrl, // Avatar tròn nhỏ
    // --- 2. Visual & Profile Header (Phần Yoga UI) ---
    String? coverUrl, // Ảnh nền full màn hình (như cô gái tập Yoga)
    String? headline, // Title lớn: "YOGA IN LIFE"
    String? bio, // Subtitle/Quote: "To the degree that..."
    String? location, // "California, USA"
    // --- 3. Social Graph (Mạng lưới bạn bè - Homies) ---
    @Default([])
    List<UserModel> humanBuddies, // List bạn bè (human) (Jack, Jane...)
    // Stats
    @Default(0) int followerCount,
    @Default(0) int followingCount,
    @Default(false) bool isFollowedByMe,

    // --- 4. Content (Bài đăng) ---
    // Lưu ý: Trong thực tế, Post List thường được fetch riêng (pagination API).
    // Tuy nhiên, để map với UI Model mong muốn, ta có thể để trường này ở đây.
    @Default([]) List<Post> posts,

    // --- 5. System Fields ---
    @Default(UserRole.user) UserRole role,
    DateTime? createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

/// Extension hỗ trợ UI logic
extension UserModelX on UserModel {
  /// Lấy danh sách tất cả "Homies" (user buddies)
  /// Để hiển thị ở list tròn ngang "Salahhh's Homies"
  List<UserModel> get allHomies {
    return [...humanBuddies];
  }

  /// Kiểm tra có headline lớn không (để render UI Yoga)
  bool get hasFeaturedHeader => headline != null && headline!.isNotEmpty;

  /// Lấy tên hiển thị ưu tiên
  String get displayName => fullName.isNotEmpty ? fullName : username;
}
