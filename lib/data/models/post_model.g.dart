// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PostImpl _$$PostImplFromJson(Map<String, dynamic> json) => _$PostImpl(
  authorName: json['authorName'] as String,
  authorId: json['authorId'] as String,
  authorAvatar: json['authorAvatar'] as String,
  postId: json['postId'] as String,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  contentText: json['contentText'] as String,
  hashtags: (json['hashtags'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  mentions: (json['mentions'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  mediaFiles: (json['mediaFiles'] as List<dynamic>)
      .map((e) => MediaFile.fromJson(e as Map<String, dynamic>))
      .toList(),
  reactsCount: (json['reactsCount'] as num).toInt(),
  commentCount: (json['commentCount'] as num).toInt(),
  isLikedByMe: json['isLikedByMe'] as bool,
  privacy: $enumDecode(_$PostPrivacyEnumMap, json['privacy']),
);

Map<String, dynamic> _$$PostImplToJson(_$PostImpl instance) =>
    <String, dynamic>{
      'authorName': instance.authorName,
      'authorId': instance.authorId,
      'authorAvatar': instance.authorAvatar,
      'postId': instance.postId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'contentText': instance.contentText,
      'hashtags': instance.hashtags,
      'mentions': instance.mentions,
      'mediaFiles': instance.mediaFiles,
      'reactsCount': instance.reactsCount,
      'commentCount': instance.commentCount,
      'isLikedByMe': instance.isLikedByMe,
      'privacy': _$PostPrivacyEnumMap[instance.privacy]!,
    };

const _$PostPrivacyEnumMap = {
  PostPrivacy.public: 'public',
  PostPrivacy.friends: 'friends',
  PostPrivacy.private: 'private',
};
