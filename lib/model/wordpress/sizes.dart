import 'package:json_annotation/json_annotation.dart';

import 'crpthumbnail.dart';
part 'sizes.g.dart';

@JsonSerializable()
class Sizes {
  Sizes(
    this.medium,
    this.large,
    this.thumbnail,
    this.mediumLarge,
    this.sidebarFeatured,
    this.homePost,
    this.crpThumbnail,
    this.full,
  );

  final CrpThumbnail medium;
  final CrpThumbnail large;
  final CrpThumbnail thumbnail;
  final CrpThumbnail mediumLarge;
  final CrpThumbnail sidebarFeatured;
  final CrpThumbnail homePost;
  final CrpThumbnail crpThumbnail;
  final CrpThumbnail full;

  factory Sizes.fromJson(Map<String, dynamic> json) => _$SizesFromJson(json);

  Map<String, dynamic> toJson() => _$SizesToJson(this);
}
