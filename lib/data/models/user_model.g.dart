// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String,
      coverUrl: json['coverUrl'] as String?,
      headline: json['headline'] as String?,
      bio: json['bio'] as String?,
      location: json['location'] as String?,
      humanBuddies:
          (json['humanBuddies'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      petBuddies:
          (json['petBuddies'] as List<dynamic>?)
              ?.map((e) => PetProfile.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      isFollowedByMe: json['isFollowedByMe'] as bool? ?? false,
      posts:
          (json['posts'] as List<dynamic>?)
              ?.map((e) => Post.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      role:
          $enumDecodeNullable(_$UserRoleEnumMap, json['role']) ?? UserRole.user,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'coverUrl': instance.coverUrl,
      'headline': instance.headline,
      'bio': instance.bio,
      'location': instance.location,
      'humanBuddies': instance.humanBuddies,
      'petBuddies': instance.petBuddies,
      'followerCount': instance.followerCount,
      'followingCount': instance.followingCount,
      'isFollowedByMe': instance.isFollowedByMe,
      'posts': instance.posts,
      'role': _$UserRoleEnumMap[instance.role]!,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$UserRoleEnumMap = {
  UserRole.user: 'user',
  UserRole.vet: 'vet',
  UserRole.shop: 'shop',
  UserRole.admin: 'admin',
};
