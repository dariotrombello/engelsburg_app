import 'package:json_annotation/json_annotation.dart';

import 'termlinks.dart';

part 'embeddedterm.g.dart';

@JsonSerializable()
class EmbeddedTerm {
  EmbeddedTerm(
    this.id,
    this.link,
    this.name,
    this.slug,
    this.taxonomy,
    this.links,
  );

  final int id;
  final String link;
  final String name;
  final String slug;
  final String taxonomy;

  @JsonKey(name: '_links')
  final TermLinks links;

  factory EmbeddedTerm.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedTermFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddedTermToJson(this);
}
