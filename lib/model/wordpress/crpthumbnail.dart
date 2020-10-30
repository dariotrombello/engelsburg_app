import 'package:json_annotation/json_annotation.dart';
part 'crpthumbnail.g.dart';

@JsonSerializable()
class CrpThumbnail {
  CrpThumbnail(
    this.file,
    this.width,
    this.height,
    this.mimeType,
    this.sourceUrl,
  );

  final String file;
  final int width;
  final int height;

  @JsonKey(name: 'mime_type')
  final String mimeType;

  @JsonKey(name: 'source_url')
  final String sourceUrl;

  factory CrpThumbnail.fromJson(Map<String, dynamic> json) =>
      _$CrpThumbnailFromJson(json);

  Map<String, dynamic> toJson() => _$CrpThumbnailToJson(this);
}
