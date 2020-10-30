import 'package:json_annotation/json_annotation.dart';
part 'optimus.g.dart';

@JsonSerializable()
class Optimus {
  Optimus(
    this.profit,
    this.quantity,
    this.webp,
    this.error,
  );

  final String profit;
  final int quantity;
  final int webp;
  final String error;

  factory Optimus.fromJson(Map<String, dynamic> json) =>
      _$OptimusFromJson(json);

  Map<String, dynamic> toJson() => _$OptimusToJson(this);
}
