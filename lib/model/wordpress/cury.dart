import 'package:json_annotation/json_annotation.dart';

part 'cury.g.dart';

@JsonSerializable()
class Cury {
  Cury(
    this.name,
    this.href,
    this.templated,
  );

  final String name;
  final String href;
  final bool templated;

  factory Cury.fromJson(Map<String, dynamic> json) => _$CuryFromJson(json);

  Map<String, dynamic> toJson() => _$CuryToJson(this);
}
