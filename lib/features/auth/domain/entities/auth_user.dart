/// Auth User Entity — Pure Dart, không import Flutter/Firebase
///
/// Đây là domain entity, khác với:
/// - `auth/data/models/user_model.dart` (DataModel với fromJson/toJson)
/// - `data/models/user_model.dart` (Community social profile model)
///
/// Entity này chỉ chứa identity cốt lõi, không có serialization logic.
class AuthUserEntity {
  final String id;
  final String email;
  final String fullName;
  final String username;
  final String? avatarUrl;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final bool isEmailVerified;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const AuthUserEntity({
    required this.id,
    required this.email,
    required this.fullName,
    required this.username,
    this.avatarUrl,
    this.phoneNumber,
    this.dateOfBirth,
    this.isEmailVerified = false,
    this.createdAt,
    this.updatedAt,
  });

  /// Kiểm tra xem user đã hoàn thiện profile chưa
  bool get isProfileComplete {
    return fullName.isNotEmpty && phoneNumber != null && dateOfBirth != null;
  }

  /// Lấy tên hiển thị (fullName hoặc email nếu chưa có tên)
  String get displayName {
    return fullName.isNotEmpty ? fullName : email.split('@').first;
  }

  /// Lấy initial của tên (để hiển thị avatar placeholder)
  String get initials {
    if (fullName.isEmpty) {
      return email.substring(0, 1).toUpperCase();
    }
    final parts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return fullName.substring(0, 1).toUpperCase();
  }

  AuthUserEntity copyWith({
    String? id,
    String? email,
    String? fullName,
    String? username,
    String? avatarUrl,
    String? phoneNumber,
    DateTime? dateOfBirth,
    bool? isEmailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AuthUserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'AuthUserEntity(id: $id, email: $email, fullName: $fullName)';
}
