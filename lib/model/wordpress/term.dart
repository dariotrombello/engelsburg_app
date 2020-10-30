import 'package:json_annotation/json_annotation.dart';

part 'term.g.dart';

@JsonSerializable()
class Term {
  Term(
    this.taxonomy,
    this.embeddable,
    this.href,
  );

  final String taxonomy;
  final bool embeddable;
  final String href;

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);

  Map<String, dynamic> toJson() => _$TermToJson(this);
}
