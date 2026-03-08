// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Comment _$CommentFromJson(Map<String, dynamic> json) => _Comment(
  commentId: json['commentId'] as String,
  postId: json['postId'] as String,
  authorId: json['authorId'] as String,
  authorName: json['authorName'] as String,
  authorAvatar: json['authorAvatar'] as String,
  contentText: json['contentText'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  reactCount: (json['reactCount'] as num).toInt(),
);

Map<String, dynamic> _$CommentToJson(_Comment instance) => <String, dynamic>{
  'commentId': instance.commentId,
  'postId': instance.postId,
  'authorId': instance.authorId,
  'authorName': instance.authorName,
  'authorAvatar': instance.authorAvatar,
  'contentText': instance.contentText,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'reactCount': instance.reactCount,
};
