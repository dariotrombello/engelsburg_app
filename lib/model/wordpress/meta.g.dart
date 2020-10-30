// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meta _$MetaFromJson(Map<String, dynamic> json) {
  return Meta(
    json['_genesis_hide_title'] as bool,
    json['_genesis_hide_breadcrumbs'] as bool,
    json['_genesis_hide_singular_image'] as bool,
    json['_genesis_hide_footer_widgets'] as bool,
    json['_genesis_custom_body_class'] as String,
    json['_genesis_custom_post_class'] as String,
    json['_genesis_layout'] as String,
  );
}

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      '_genesis_hide_title': instance.genesisHideTitle,
      '_genesis_hide_breadcrumbs': instance.genesisHideBreadcrumbs,
      '_genesis_hide_singular_image': instance.genesisHideSingularImage,
      '_genesis_hide_footer_widgets': instance.genesisHideFooterWidgets,
      '_genesis_custom_body_class': instance.genesisCustomBodyClass,
      '_genesis_custom_post_class': instance.genesisCustomPostClass,
      '_genesis_layout': instance.genesisLayout,
    };
