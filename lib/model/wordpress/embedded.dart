import 'package:json_annotation/json_annotation.dart';

import 'embeddedauthor.dart';
import 'embeddedterm.dart';
import 'featuredmedia.dart';
part 'embedded.g.dart';

@JsonSerializable()
class Embedded {
  Embedded(
    this.author,
    this.wpTerm,
    this.wpFeaturedmedia,
  );

  final List<EmbeddedAuthor> author;

  @JsonKey(name: 'wp:term')
  final List<List<EmbeddedTerm>> wpTerm;

  @JsonKey(name: 'wp:featuredmedia')
  final List<FeaturedMedia> wpFeaturedmedia;

  factory Embedded.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddedToJson(this);
}
