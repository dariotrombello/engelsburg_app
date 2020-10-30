// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Post _$PostFromJson(Map<String, dynamic> json) {
  return Post(
    json['id'] as int,
    json['date'] == null ? null : DateTime.parse(json['date'] as String),
    json['date_gmt'] == null
        ? null
        : DateTime.parse(json['date_gmt'] as String),
    json['guid'] == null
        ? null
        : Guid.fromJson(json['guid'] as Map<String, dynamic>),
    json['modified'] == null
        ? null
        : DateTime.parse(json['modified'] as String),
    json['modified_gmt'] == null
        ? null
        : DateTime.parse(json['modified_gmt'] as String),
    json['slug'] as String,
    json['status'] as String,
    json['type'] as String,
    json['link'] as String,
    json['title'] == null
        ? null
        : Guid.fromJson(json['title'] as Map<String, dynamic>),
    json['content'] == null
        ? null
        : Content.fromJson(json['content'] as Map<String, dynamic>),
    json['excerpt'] == null
        ? null
        : Content.fromJson(json['excerpt'] as Map<String, dynamic>),
    json['author'] as int,
    json['featured_media'] as int,
    json['comment_status'] as String,
    json['ping_status'] as String,
    json['sticky'] as bool,
    json['template'] as String,
    json['format'] as String,
    json['meta'] == null
        ? null
        : Meta.fromJson(json['meta'] as Map<String, dynamic>),
    (json['categories'] as List)?.map((e) => e as int)?.toList(),
    (json['tags'] as List)?.map((e) => e as int)?.toList(),
    json['_links'] == null
        ? null
        : PostLinks.fromJson(json['_links'] as Map<String, dynamic>),
    json['_embedded'] == null
        ? null
        : Embedded.fromJson(json['_embedded'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PostToJson(Post instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'date_gmt': instance.dateGmt?.toIso8601String(),
      'guid': instance.guid,
      'modified': instance.modified?.toIso8601String(),
      'modified_gmt': instance.modifiedGmt?.toIso8601String(),
      'slug': instance.slug,
      'status': instance.status,
      'type': instance.type,
      'link': instance.link,
      'title': instance.title,
      'content': instance.content,
      'excerpt': instance.excerpt,
      'author': instance.author,
      'featured_media': instance.featuredMedia,
      'comment_status': instance.commentStatus,
      'ping_status': instance.pingStatus,
      'sticky': instance.sticky,
      'template': instance.template,
      'format': instance.format,
      'meta': instance.meta,
      'categories': instance.categories,
      'tags': instance.tags,
      '_links': instance.links,
      '_embedded': instance.embedded,
    };
