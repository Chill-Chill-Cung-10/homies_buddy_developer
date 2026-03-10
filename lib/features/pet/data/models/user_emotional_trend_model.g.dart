// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_emotional_trend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserEmotionalTrend _$UserEmotionalTrendFromJson(Map<String, dynamic> json) =>
    _UserEmotionalTrend(
      id: json['id'] as String,
      userId: json['userId'] as String,
      emotionalTrend: $enumDecode(
        _$EmotionalTrendEnumMap,
        json['emotionalTrend'],
      ),
      emotionalMomentum: (json['emotionalMomentum'] as num).toDouble(),
      toneHistory7d: (json['toneHistory7d'] as List<dynamic>)
          .map((e) => $enumDecode(_$UserToneEnumMap, e))
          .toList(),
      dominantTone: $enumDecode(_$UserToneEnumMap, json['dominantTone']),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$UserEmotionalTrendToJson(_UserEmotionalTrend instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'emotionalTrend': _$EmotionalTrendEnumMap[instance.emotionalTrend]!,
      'emotionalMomentum': instance.emotionalMomentum,
      'toneHistory7d': instance.toneHistory7d
          .map((e) => _$UserToneEnumMap[e]!)
          .toList(),
      'dominantTone': _$UserToneEnumMap[instance.dominantTone]!,
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$EmotionalTrendEnumMap = {
  EmotionalTrend.improving: 'improving',
  EmotionalTrend.declining: 'declining',
  EmotionalTrend.stable: 'stable',
  EmotionalTrend.volatile: 'volatile',
};

const _$UserToneEnumMap = {
  UserTone.happy: 'happy',
  UserTone.neutral: 'neutral',
  UserTone.sad: 'sad',
  UserTone.anxious: 'anxious',
  UserTone.angry: 'angry',
};
