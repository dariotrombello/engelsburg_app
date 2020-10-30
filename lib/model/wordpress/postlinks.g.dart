// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'postlinks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PostLinks _$PostLinksFromJson(Map<String, dynamic> json) {
  return PostLinks(
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
    (json['version-history'] as List)
        ?.map((e) => e == null
            ? null
            : VersionHistory.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['wp:attachment'] as List)
        ?.map(
            (e) => e == null ? null : About.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['wp:term'] as List)
        ?.map(
            (e) => e == null ? null : Term.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['curies'] as List)
        ?.map(
            (e) => e == null ? null : Cury.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['wp:featuredmedia'] as List)
        ?.map((e) =>
            e == null ? null : ReplyElement.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$PostLinksToJson(PostLinks instance) => <String, dynamic>{
      'self': instance.self,
      'collection': instance.collection,
      'about': instance.about,
      'author': instance.author,
      'replies': instance.replies,
      'version-history': instance.versionHistory,
      'wp:attachment': instance.wpAttachment,
      'wp:term': instance.wpTerm,
      'curies': instance.curies,
      'wp:featuredmedia': instance.wpFeaturedmedia,
    };
