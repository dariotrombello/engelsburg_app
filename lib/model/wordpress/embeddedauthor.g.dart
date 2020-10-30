// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embeddedauthor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmbeddedAuthor _$EmbeddedAuthorFromJson(Map<String, dynamic> json) {
  return EmbeddedAuthor(
    json['code'] as String,
    json['message'] as String,
    json['data'] == null
        ? null
        : Data.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EmbeddedAuthorToJson(EmbeddedAuthor instance) =>
    <String, dynamic>{
      'code': instance.code,
      'message': instance.message,
      'data': instance.data,
    };
