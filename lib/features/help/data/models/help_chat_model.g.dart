// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'help_chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HelpChatMessage _$HelpChatMessageFromJson(Map<String, dynamic> json) =>
    _HelpChatMessage(
      id: json['id'] as String,
      conversationId: json['conversationId'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      imageUrls:
          (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$HelpChatMessageToJson(_HelpChatMessage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'conversationId': instance.conversationId,
      'text': instance.text,
      'isUser': instance.isUser,
      'timestamp': instance.timestamp.toIso8601String(),
      'imageUrls': instance.imageUrls,
    };

_HelpConversationHistory _$HelpConversationHistoryFromJson(
  Map<String, dynamic> json,
) => _HelpConversationHistory(
  id: json['id'] as String,
  userId: json['userId'] as String,
  title: json['title'] as String,
  preview: json['preview'] as String,
  lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
  messages:
      (json['messages'] as List<dynamic>?)
          ?.map((e) => HelpChatMessage.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$HelpConversationHistoryToJson(
  _HelpConversationHistory instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'title': instance.title,
  'preview': instance.preview,
  'lastMessageAt': instance.lastMessageAt.toIso8601String(),
  'messages': instance.messages,
};

_HelpSuggestion _$HelpSuggestionFromJson(Map<String, dynamic> json) =>
    _HelpSuggestion(
      id: json['id'] as String,
      title: json['title'] as String,
      iconType: $enumDecode(_$IconTypeEnumMap, json['iconType']),
    );

Map<String, dynamic> _$HelpSuggestionToJson(_HelpSuggestion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'iconType': _$IconTypeEnumMap[instance.iconType]!,
    };

const _$IconTypeEnumMap = {
  IconType.plant: 'plant',
  IconType.pet: 'pet',
  IconType.health: 'health',
  IconType.training: 'training',
  IconType.nutrition: 'nutrition',
  IconType.grooming: 'grooming',
};
