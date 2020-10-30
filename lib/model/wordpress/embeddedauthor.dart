import 'package:json_annotation/json_annotation.dart';

import 'data.dart';
part 'embeddedauthor.g.dart';

@JsonSerializable()
class EmbeddedAuthor {
  EmbeddedAuthor(
    this.code,
    this.message,
    this.data,
  );

  final String code;
  final String message;
  final Data data;

  factory EmbeddedAuthor.fromJson(Map<String, dynamic> json) =>
      _$EmbeddedAuthorFromJson(json);

  Map<String, dynamic> toJson() => _$EmbeddedAuthorToJson(this);
}
