// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sizes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sizes _$SizesFromJson(Map<String, dynamic> json) {
  return Sizes(
    json['medium'] == null
        ? null
        : CrpThumbnail.fromJson(json['medium'] as Map<String, dynamic>),
    json['large'] == null
        ? null
        : CrpThumbnail.fromJson(json['large'] as Map<String, dynamic>),
    json['thumbnail'] == null
        ? null
        : CrpThumbnail.fromJson(json['thumbnail'] as Map<String, dynamic>),
    json['mediumLarge'] == null
        ? null
        : CrpThumbnail.fromJson(json['mediumLarge'] as Map<String, dynamic>),
    json['sidebarFeatured'] == null
        ? null
        : CrpThumbnail.fromJson(
            json['sidebarFeatured'] as Map<String, dynamic>),
    json['homePost'] == null
        ? null
        : CrpThumbnail.fromJson(json['homePost'] as Map<String, dynamic>),
    json['crpThumbnail'] == null
        ? null
        : CrpThumbnail.fromJson(json['crpThumbnail'] as Map<String, dynamic>),
    json['full'] == null
        ? null
        : CrpThumbnail.fromJson(json['full'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SizesToJson(Sizes instance) => <String, dynamic>{
      'medium': instance.medium,
      'large': instance.large,
      'thumbnail': instance.thumbnail,
      'mediumLarge': instance.mediumLarge,
      'sidebarFeatured': instance.sidebarFeatured,
      'homePost': instance.homePost,
      'crpThumbnail': instance.crpThumbnail,
      'full': instance.full,
    };
