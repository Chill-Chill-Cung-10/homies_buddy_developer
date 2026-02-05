// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_file_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MediaFileImpl _$$MediaFileImplFromJson(Map<String, dynamic> json) =>
    _$MediaFileImpl(
      id: json['id'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      mediaAspectRatio: (json['mediaAspectRatio'] as num).toDouble(),
      mediaUrl: json['mediaUrl'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
      durationSeconds: (json['durationSeconds'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MediaFileImplToJson(_$MediaFileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'thumbnailUrl': instance.thumbnailUrl,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType]!,
      'mediaAspectRatio': instance.mediaAspectRatio,
      'mediaUrl': instance.mediaUrl,
      'width': instance.width,
      'height': instance.height,
      'durationSeconds': instance.durationSeconds,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'image',
  MediaType.video: 'video',
  MediaType.album: 'album',
};
