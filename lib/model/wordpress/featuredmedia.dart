import 'package:json_annotation/json_annotation.dart';

import 'featuredmedialinks.dart';
import 'guid.dart';
import 'mediadetails.dart';

part 'featuredmedia.g.dart';

@JsonSerializable()
class FeaturedMedia {
  FeaturedMedia(
    this.id,
    this.date,
    this.slug,
    this.type,
    this.link,
    this.title,
    this.author,
    this.caption,
    this.altText,
    this.mediaType,
    this.mimeType,
    this.mediaDetails,
    this.sourceUrl,
    this.links,
  );

  final int id;
  final DateTime date;
  final String slug;
  final String type;
  final String link;
  final Guid title;
  final int author;
  final Guid caption;

  @JsonKey(name: 'alt_text')
  final String altText;

  @JsonKey(name: 'media_type')
  final String mediaType;

  @JsonKey(name: 'mime_type')
  final String mimeType;

  @JsonKey(name: 'media_details')
  final MediaDetails mediaDetails;

  @JsonKey(name: 'source_url')
  final String sourceUrl;

  @JsonKey(name: '_links')
  final FeaturedMediaLinks links;

  factory FeaturedMedia.fromJson(Map<String, dynamic> json) =>
      _$FeaturedMediaFromJson(json);

  Map<String, dynamic> toJson() => _$FeaturedMediaToJson(this);
}
