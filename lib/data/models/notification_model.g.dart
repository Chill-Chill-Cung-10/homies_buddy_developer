// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    _NotificationModel(
      actorId: json['actorId'] as String,
      recipientId: json['recipientId'] as String,
      actorName: json['actorName'] as String,
      actorAvatar: json['actorAvatar'] as String,
      notificationId: json['notificationId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      postId: json['postId'] as String,
      commentId: json['commentId'] as String?,
      deepLink: json['deepLink'] as String,
      contentPreview: json['contentPreview'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(_NotificationModel instance) =>
    <String, dynamic>{
      'actorId': instance.actorId,
      'recipientId': instance.recipientId,
      'actorName': instance.actorName,
      'actorAvatar': instance.actorAvatar,
      'notificationId': instance.notificationId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'isRead': instance.isRead,
      'postId': instance.postId,
      'commentId': instance.commentId,
      'deepLink': instance.deepLink,
      'contentPreview': instance.contentPreview,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.react: 'react',
  NotificationType.comment: 'comment',
  NotificationType.follow: 'follow',
  NotificationType.mention: 'mention',
  NotificationType.share: 'share',
};
