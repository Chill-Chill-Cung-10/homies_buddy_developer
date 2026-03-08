// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_likes_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PostLike _$PostLikeFromJson(Map<String, dynamic> json) => _PostLike(
  userId: json['userId'] as String,
  postId: json['postId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$PostLikeToJson(_PostLike instance) => <String, dynamic>{
  'userId': instance.userId,
  'postId': instance.postId,
  'createdAt': instance.createdAt.toIso8601String(),
};
