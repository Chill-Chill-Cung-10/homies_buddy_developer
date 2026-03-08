// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Conversation _$ConversationFromJson(Map<String, dynamic> json) =>
    _Conversation(
      id: json['id'] as String,
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      participantName: json['participantName'] as String,
      participantAvatar: json['participantAvatar'] as String,
      lastMessage: json['lastMessage'] as String,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      unreadCount: (json['unreadCount'] as num).toInt(),
      nickname: json['nickname'] as String?,
      mutedUntil: json['mutedUntil'] == null
          ? null
          : DateTime.parse(json['mutedUntil'] as String),
    );

Map<String, dynamic> _$ConversationToJson(_Conversation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantIds': instance.participantIds,
      'participantName': instance.participantName,
      'participantAvatar': instance.participantAvatar,
      'lastMessage': instance.lastMessage,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'nickname': instance.nickname,
      'mutedUntil': instance.mutedUntil?.toIso8601String(),
    };
