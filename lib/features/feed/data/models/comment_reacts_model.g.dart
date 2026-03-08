// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment_reacts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CommentReact _$CommentReactFromJson(Map<String, dynamic> json) =>
    _CommentReact(
      userId: json['userId'] as String,
      commentId: json['commentId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CommentReactToJson(_CommentReact instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'commentId': instance.commentId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
