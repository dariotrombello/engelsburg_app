import 'package:json_annotation/json_annotation.dart';

import 'about.dart';
import 'cury.dart';

part 'termlinks.g.dart';

@JsonSerializable()
class TermLinks {
  TermLinks(
    this.self,
    this.collection,
    this.about,
    this.wpPostType,
    this.curies,
  );

  final List<About> self;
  final List<About> collection;
  final List<About> about;

  @JsonKey(name: 'wp:post_type')
  final List<About> wpPostType;

  final List<Cury> curies;

  factory TermLinks.fromJson(Map<String, dynamic> json) =>
      _$TermLinksFromJson(json);

  Map<String, dynamic> toJson() => _$TermLinksToJson(this);
}
