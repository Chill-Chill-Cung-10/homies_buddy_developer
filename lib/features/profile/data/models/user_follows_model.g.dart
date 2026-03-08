// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_follows_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserFollow _$UserFollowFromJson(Map<String, dynamic> json) => _UserFollow(
  followerId: json['followerId'] as String,
  followingId: json['followingId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$UserFollowToJson(_UserFollow instance) =>
    <String, dynamic>{
      'followerId': instance.followerId,
      'followingId': instance.followingId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
