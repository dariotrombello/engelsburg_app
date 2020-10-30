import 'package:json_annotation/json_annotation.dart';

import 'imagemeta.dart';
import 'optimus.dart';
import 'sizes.dart';
part 'mediadetails.g.dart';

@JsonSerializable()
class MediaDetails {
  MediaDetails(
    this.width,
    this.height,
    this.file,
    this.sizes,
    this.imageMeta,
    this.optimus,
  );

  final int width;
  final int height;
  final String file;
  final Sizes sizes;

  @JsonKey(name: 'image_meta')
  final ImageMeta imageMeta;

  final Optimus optimus;

  factory MediaDetails.fromJson(Map<String, dynamic> json) =>
      _$MediaDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$MediaDetailsToJson(this);
}
