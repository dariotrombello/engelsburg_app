// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'termlinks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermLinks _$TermLinksFromJson(Map<String, dynamic> json) {
  return TermLinks(
    (json['self'] as List)
        ?.map(
            (e) => e == null ? null : About.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['collection'] as List)
        ?.map(
            (e) => e == null ? null : About.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['about'] as List)
        ?.map(
            (e) => e == null ? null : About.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['wp:post_type'] as List)
        ?.map(
            (e) => e == null ? null : About.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['curies'] as List)
        ?.map(
            (e) => e == null ? null : Cury.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$TermLinksToJson(TermLinks instance) => <String, dynamic>{
      'self': instance.self,
      'collection': instance.collection,
      'about': instance.about,
      'wp:post_type': instance.wpPostType,
      'curies': instance.curies,
    };
