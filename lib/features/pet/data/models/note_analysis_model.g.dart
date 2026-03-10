// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NoteAnalysis _$NoteAnalysisFromJson(Map<String, dynamic> json) =>
    _NoteAnalysis(
      id: json['id'] as String,
      noteId: json['noteId'] as String,
      userId: json['userId'] as String,
      lastUserTone: $enumDecodeNullable(
        _$UserToneEnumMap,
        json['lastUserTone'],
      ),
      currentTonePredict: $enumDecode(
        _$UserToneEnumMap,
        json['currentTonePredict'],
      ),
      toneRepeat: json['toneRepeat'] as bool,
      level: (json['level'] as num).toInt(),
      analyzedAt: DateTime.parse(json['analyzedAt'] as String),
      rawLLMResponse: json['rawLLMResponse'] as String?,
    );

Map<String, dynamic> _$NoteAnalysisToJson(_NoteAnalysis instance) =>
    <String, dynamic>{
      'id': instance.id,
      'noteId': instance.noteId,
      'userId': instance.userId,
      'lastUserTone': _$UserToneEnumMap[instance.lastUserTone],
      'currentTonePredict': _$UserToneEnumMap[instance.currentTonePredict]!,
      'toneRepeat': instance.toneRepeat,
      'level': instance.level,
      'analyzedAt': instance.analyzedAt.toIso8601String(),
      'rawLLMResponse': instance.rawLLMResponse,
    };

const _$UserToneEnumMap = {
  UserTone.happy: 'happy',
  UserTone.neutral: 'neutral',
  UserTone.sad: 'sad',
  UserTone.anxious: 'anxious',
  UserTone.angry: 'angry',
};
