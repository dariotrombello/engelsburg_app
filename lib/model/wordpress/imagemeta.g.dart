// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'imagemeta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageMeta _$ImageMetaFromJson(Map<String, dynamic> json) {
  return ImageMeta(
    json['aperture'] as String,
    json['credit'] as String,
    json['camera'] as String,
    json['caption'] as String,
    json['created_timestamp'] as String,
    json['copyright'] as String,
    json['focal_length'] as String,
    json['iso'] as String,
    json['shutter_speed'] as String,
    json['title'] as String,
    json['orientation'] as String,
    (json['keywords'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ImageMetaToJson(ImageMeta instance) => <String, dynamic>{
      'aperture': instance.aperture,
      'credit': instance.credit,
      'camera': instance.camera,
      'caption': instance.caption,
      'created_timestamp': instance.createdTimestamp,
      'copyright': instance.copyright,
      'focal_length': instance.focalLength,
      'iso': instance.iso,
      'shutter_speed': instance.shutterSpeed,
      'title': instance.title,
      'orientation': instance.orientation,
      'keywords': instance.keywords,
    };
