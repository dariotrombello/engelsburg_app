// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featuredmedialinks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedMediaLinks _$FeaturedMediaLinksFromJson(Map<String, dynamic> json) {
  return FeaturedMediaLinks(
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
    (json['author'] as List)
        ?.map((e) =>
            e == null ? null : ReplyElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['replies'] as List)
        ?.map((e) =>
            e == null ? null : ReplyElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FeaturedMediaLinksToJson(FeaturedMediaLinks instance) =>
    <String, dynamic>{
      'self': instance.self,
      'collection': instance.collection,
      'about': instance.about,
      'author': instance.author,
      'replies': instance.replies,
    };
