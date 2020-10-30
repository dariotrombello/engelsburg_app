import 'package:json_annotation/json_annotation.dart';

part 'versionhistory.g.dart';

@JsonSerializable()
class VersionHistory {
  VersionHistory(
    this.count,
    this.href,
  );

  final int count;
  final String href;

  factory VersionHistory.fromJson(Map<String, dynamic> json) =>
      _$VersionHistoryFromJson(json);

  Map<String, dynamic> toJson() => _$VersionHistoryToJson(this);
}
