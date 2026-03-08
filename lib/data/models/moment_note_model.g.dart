// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'moment_note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MomentNote _$MomentNoteFromJson(Map<String, dynamic> json) => _MomentNote(
  id: json['id'] as String,
  userId: json['userId'] as String,
  authorName: json['authorName'] as String,
  authorAvatarUrl: json['authorAvatarUrl'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  textContent: json['textContent'] as String? ?? '',
  mediaUrls:
      (json['mediaUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$MomentNoteToJson(_MomentNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'authorName': instance.authorName,
      'authorAvatarUrl': instance.authorAvatarUrl,
      'createdAt': instance.createdAt.toIso8601String(),
      'textContent': instance.textContent,
      'mediaUrls': instance.mediaUrls,
    };
