import 'package:json_annotation/json_annotation.dart';
part 'replyelement.g.dart';

@JsonSerializable()
class ReplyElement {
  ReplyElement(
    this.embeddable,
    this.href,
  );

  final bool embeddable;
  final String href;

  factory ReplyElement.fromJson(Map<String, dynamic> json) =>
      _$ReplyElementFromJson(json);

  Map<String, dynamic> toJson() => _$ReplyElementToJson(this);
}
