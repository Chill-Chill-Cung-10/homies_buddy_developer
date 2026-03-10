/// Profile User Entity — Pure Dart, không import Flutter/Firebase
///
/// Social profile entity với đầy đủ thông tin:
/// - Identity (id, username, fullName)
/// - Visual (avatarUrl, coverUrl)
/// - Bio & Location
/// - Social graph (follower, following counts)
class ProfileEntity {
  final String id;
  final String username;
  final String fullName;
  final String avatarUrl;
  final String? coverUrl;
  final String? headline;
  final String? bio;
  final String? location;
  final int followerCount;
  final int followingCount;
  final bool isFollowedByMe;
  final DateTime? createdAt;

  const ProfileEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.avatarUrl,
    this.coverUrl,
    this.headline,
    this.bio,
    this.location,
    this.followerCount = 0,
    this.followingCount = 0,
    this.isFollowedByMe = false,
    this.createdAt,
  });

  /// Display name: fullName or username if empty
  String get displayName => fullName.isNotEmpty ? fullName : username;

  /// Check if profile has cover image
  bool get hasCover => coverUrl != null && coverUrl!.isNotEmpty;

  /// Check if profile has bio
  bool get hasBio => bio != null && bio!.isNotEmpty;

  ProfileEntity copyWith({
    String? id,
    String? username,
    String? fullName,
    String? avatarUrl,
    String? coverUrl,
    String? headline,
    String? bio,
    String? location,
    int? followerCount,
    int? followingCount,
    bool? isFollowedByMe,
    DateTime? createdAt,
  }) {
    return ProfileEntity(
      id: id ?? this.id,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      headline: headline ?? this.headline,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      followerCount: followerCount ?? this.followerCount,
      followingCount: followingCount ?? this.followingCount,
      isFollowedByMe: isFollowedByMe ?? this.isFollowedByMe,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProfileEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProfileEntity(id: $id, username: $username, fullName: $fullName)';
}
