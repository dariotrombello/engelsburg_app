import 'package:json_annotation/json_annotation.dart';

part 'meta.g.dart';

@JsonSerializable()
class Meta {
  Meta(
    this.genesisHideTitle,
    this.genesisHideBreadcrumbs,
    this.genesisHideSingularImage,
    this.genesisHideFooterWidgets,
    this.genesisCustomBodyClass,
    this.genesisCustomPostClass,
    this.genesisLayout,
  );

  @JsonKey(name: '_genesis_hide_title')
  final bool genesisHideTitle;

  @JsonKey(name: '_genesis_hide_breadcrumbs')
  final bool genesisHideBreadcrumbs;

  @JsonKey(name: '_genesis_hide_singular_image')
  final bool genesisHideSingularImage;

  @JsonKey(name: '_genesis_hide_footer_widgets')
  final bool genesisHideFooterWidgets;

  @JsonKey(name: '_genesis_custom_body_class')
  final String genesisCustomBodyClass;

  @JsonKey(name: '_genesis_custom_post_class')
  final String genesisCustomPostClass;

  @JsonKey(name: '_genesis_layout')
  final String genesisLayout;

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);

  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
