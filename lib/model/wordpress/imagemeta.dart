import 'package:json_annotation/json_annotation.dart';
part 'imagemeta.g.dart';

@JsonSerializable()
class ImageMeta {
  ImageMeta(
    this.aperture,
    this.credit,
    this.camera,
    this.caption,
    this.createdTimestamp,
    this.copyright,
    this.focalLength,
    this.iso,
    this.shutterSpeed,
    this.title,
    this.orientation,
    this.keywords,
  );

  final String aperture;
  final String credit;
  final String camera;
  final String caption;

  @JsonKey(name: 'created_timestamp')
  final String createdTimestamp;

  final String copyright;

  @JsonKey(name: 'focal_length')
  final String focalLength;
  final String iso;

  @JsonKey(name: 'shutter_speed')
  final String shutterSpeed;

  final String title;
  final String orientation;
  final List<String> keywords;

  factory ImageMeta.fromJson(Map<String, dynamic> json) =>
      _$ImageMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ImageMetaToJson(this);
}
