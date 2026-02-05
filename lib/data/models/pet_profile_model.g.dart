// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PetProfileImpl _$$PetProfileImplFromJson(Map<String, dynamic> json) =>
    _$PetProfileImpl(
      petId: json['petId'] as String,
      petName: json['petName'] as String,
      petAvatar: json['petAvatar'] as String,
      petOwner: PetOwner.fromJson(json['petOwner'] as Map<String, dynamic>),
      petPitching: json['petPitching'] as String,
      isFollowedByMe: json['isFollowedByMe'] as bool,
      followerCount: (json['followerCount'] as num).toInt(),
    );

Map<String, dynamic> _$$PetProfileImplToJson(_$PetProfileImpl instance) =>
    <String, dynamic>{
      'petId': instance.petId,
      'petName': instance.petName,
      'petAvatar': instance.petAvatar,
      'petOwner': instance.petOwner,
      'petPitching': instance.petPitching,
      'isFollowedByMe': instance.isFollowedByMe,
      'followerCount': instance.followerCount,
    };
