// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'embedded.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Embedded _$EmbeddedFromJson(Map<String, dynamic> json) {
  return Embedded(
    (json['author'] as List)
        ?.map((e) => e == null
            ? null
            : EmbeddedAuthor.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['wp:term'] as List)
        ?.map((e) => (e as List)
            ?.map((e) => e == null
                ? null
                : EmbeddedTerm.fromJson(e as Map<String, dynamic>))
            ?.toList())
        ?.toList(),
    (json['wp:featuredmedia'] as List)
        ?.map((e) => e == null
            ? null
            : FeaturedMedia.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$EmbeddedToJson(Embedded instance) => <String, dynamic>{
      'author': instance.author,
      'wp:term': instance.wpTerm,
      'wp:featuredmedia': instance.wpFeaturedmedia,
    };
