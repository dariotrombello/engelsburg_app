// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featuredmedia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedMedia _$FeaturedMediaFromJson(Map<String, dynamic> json) {
  return FeaturedMedia(
    json['id'] as int,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['slug'] as String,
    json['type'] as String,
    json['link'] as String,
    json['title'] == null
        ? null
        : Guid.fromJson(json['title'] as Map<String, dynamic>),
    json['author'] as int,
    json['caption'] == null
        ? null
        : Guid.fromJson(json['caption'] as Map<String, dynamic>),
    json['alt_text'] as String,
    json['media_type'] as String,
    json['mime_type'] as String,
    json['media_details'] == null
        ? null
        : MediaDetails.fromJson(json['media_details'] as Map<String, dynamic>),
    json['source_url'] as String,
    json['_links'] == null
        ? null
        : FeaturedMediaLinks.fromJson(json['_links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FeaturedMediaToJson(FeaturedMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'slug': instance.slug,
      'type': instance.type,
      'link': instance.link,
      'title': instance.title,
      'author': instance.author,
      'caption': instance.caption,
      'alt_text': instance.altText,
      'media_type': instance.mediaType,
      'mime_type': instance.mimeType,
      'media_details': instance.mediaDetails,
      'source_url': instance.sourceUrl,
      '_links': instance.links,
    };
