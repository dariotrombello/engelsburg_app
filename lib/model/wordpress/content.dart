import 'package:json_annotation/json_annotation.dart';
part 'content.g.dart';

@JsonSerializable()
class Content {
  Content(
    this.rendered,
    this.protected,
  );

  final String rendered;
  final bool protected;

  factory Content.fromJson(Map<String, dynamic> json) =>
      _$ContentFromJson(json);

  Map<String, dynamic> toJson() => _$ContentToJson(this);
}
