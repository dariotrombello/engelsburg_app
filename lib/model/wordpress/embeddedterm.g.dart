// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embeddedterm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmbeddedTerm _$EmbeddedTermFromJson(Map<String, dynamic> json) {
  return EmbeddedTerm(
    json['id'] as int,
    json['link'] as String,
    json['name'] as String,
    json['slug'] as String,
    json['taxonomy'] as String,
    json['_links'] == null
        ? null
        : TermLinks.fromJson(json['_links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$EmbeddedTermToJson(EmbeddedTerm instance) =>
    <String, dynamic>{
      'id': instance.id,
      'link': instance.link,
      'name': instance.name,
      'slug': instance.slug,
      'taxonomy': instance.taxonomy,
      '_links': instance.links,
    };
