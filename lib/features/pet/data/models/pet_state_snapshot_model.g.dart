// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_state_snapshot_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PetStateSnapshot _$PetStateSnapshotFromJson(Map<String, dynamic> json) =>
    _PetStateSnapshot(
      id: json['id'] as String,
      petId: json['petId'] as String,
      userId: json['userId'] as String,
      deltaT: (json['deltaT'] as num).toDouble(),
      visitCountToday: (json['visitCountToday'] as num).toInt(),
      interactionCountToday: (json['interactionCountToday'] as num).toInt(),
      energyAtSnapshot: (json['energyAtSnapshot'] as num).toDouble(),
      moodAtSnapshot: $enumDecode(_$PetMoodEnumMap, json['moodAtSnapshot']),
      timeOfDay: (json['timeOfDay'] as num).toInt(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );

Map<String, dynamic> _$PetStateSnapshotToJson(_PetStateSnapshot instance) =>
    <String, dynamic>{
      'id': instance.id,
      'petId': instance.petId,
      'userId': instance.userId,
      'deltaT': instance.deltaT,
      'visitCountToday': instance.visitCountToday,
      'interactionCountToday': instance.interactionCountToday,
      'energyAtSnapshot': instance.energyAtSnapshot,
      'moodAtSnapshot': _$PetMoodEnumMap[instance.moodAtSnapshot]!,
      'timeOfDay': instance.timeOfDay,
      'recordedAt': instance.recordedAt.toIso8601String(),
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
