// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mediadetails.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MediaDetails _$MediaDetailsFromJson(Map<String, dynamic> json) {
  return MediaDetails(
    json['width'] as int,
    json['height'] as int,
    json['file'] as String,
    json['sizes'] == null
        ? null
        : Sizes.fromJson(json['sizes'] as Map<String, dynamic>),
    json['image_meta'] == null
        ? null
        : ImageMeta.fromJson(json['image_meta'] as Map<String, dynamic>),
    json['optimus'] == null
        ? null
        : Optimus.fromJson(json['optimus'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MediaDetailsToJson(MediaDetails instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'file': instance.file,
      'sizes': instance.sizes,
      'image_meta': instance.imageMeta,
      'optimus': instance.optimus,
    };
