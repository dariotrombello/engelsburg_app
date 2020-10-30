// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Content _$ContentFromJson(Map<String, dynamic> json) {
  return Content(
    json['rendered'] as String,
    json['protected'] as bool,
  );
}

Map<String, dynamic> _$ContentToJson(Content instance) => <String, dynamic>{
      'rendered': instance.rendered,
      'protected': instance.protected,
    };
