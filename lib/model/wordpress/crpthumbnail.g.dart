// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crpthumbnail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CrpThumbnail _$CrpThumbnailFromJson(Map<String, dynamic> json) {
  return CrpThumbnail(
    json['file'] as String,
    json['width'] as int,
    json['height'] as int,
    json['mime_type'] as String,
    json['source_url'] as String,
  );
}

Map<String, dynamic> _$CrpThumbnailToJson(CrpThumbnail instance) =>
    <String, dynamic>{
      'file': instance.file,
      'width': instance.width,
      'height': instance.height,
      'mime_type': instance.mimeType,
      'source_url': instance.sourceUrl,
    };
