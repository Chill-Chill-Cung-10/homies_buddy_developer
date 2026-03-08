// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Pet _$PetFromJson(Map<String, dynamic> json) => _Pet(
  id: json['id'] as String,
  userId: json['userId'] as String,
  name: json['name'] as String,
  avatarType: $enumDecode(_$PetAvatarTypeEnumMap, json['avatarType']),
  baselineEnergy: (json['baselineEnergy'] as num).toDouble(),
  energy: (json['energy'] as num).toDouble(),
  currentMood: $enumDecode(_$PetMoodEnumMap, json['currentMood']),
  streak: (json['streak'] as num?)?.toInt() ?? 0,
  lastInteractedAt: DateTime.parse(json['lastInteractedAt'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$PetToJson(_Pet instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'name': instance.name,
  'avatarType': _$PetAvatarTypeEnumMap[instance.avatarType]!,
  'baselineEnergy': instance.baselineEnergy,
  'energy': instance.energy,
  'currentMood': _$PetMoodEnumMap[instance.currentMood]!,
  'streak': instance.streak,
  'lastInteractedAt': instance.lastInteractedAt.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

const _$PetAvatarTypeEnumMap = {
  PetAvatarType.catA: 'cat_a',
  PetAvatarType.catB: 'cat_b',
  PetAvatarType.catC: 'cat_c',
};

const _$PetMoodEnumMap = {
  PetMood.idle: 'idle',
  PetMood.sleep: 'sleep',
  PetMood.tired: 'tired',
  PetMood.sad: 'sad',
  PetMood.grumpy: 'grumpy',
  PetMood.lookAway: 'look_away',
  PetMood.happy: 'happy',
  PetMood.playful: 'playful',
  PetMood.curious: 'curious',
  PetMood.clingy: 'clingy',
  PetMood.content: 'content',
  PetMood.startled: 'startled',
};
