// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Message _$MessageFromJson(Map<String, dynamic> json) => _Message(
  id: json['id'] as String,
  conversationId: json['conversationId'] as String,
  senderId: json['senderId'] as String,
  content: json['content'] as String,
  mediaUrls:
      (json['mediaUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  type: $enumDecode(_$MessageTypeEnumMap, json['type']),
  createdAt: DateTime.parse(json['createdAt'] as String),
  status: $enumDecode(_$MessageStatusEnumMap, json['status']),
);

Map<String, dynamic> _$MessageToJson(_Message instance) => <String, dynamic>{
  'id': instance.id,
  'conversationId': instance.conversationId,
  'senderId': instance.senderId,
  'content': instance.content,
  'mediaUrls': instance.mediaUrls,
  'type': _$MessageTypeEnumMap[instance.type]!,
  'createdAt': instance.createdAt.toIso8601String(),
  'status': _$MessageStatusEnumMap[instance.status]!,
};

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
};

const _$MessageStatusEnumMap = {
  MessageStatus.sending: 'sending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.seen: 'seen',
  MessageStatus.failed: 'failed',
};
