// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cury.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Cury _$CuryFromJson(Map<String, dynamic> json) {
  return Cury(
    json['name'] as String,
    json['href'] as String,
    json['templated'] as bool,
  );
}

Map<String, dynamic> _$CuryToJson(Cury instance) => <String, dynamic>{
      'name': instance.name,
      'href': instance.href,
      'templated': instance.templated,
    };
