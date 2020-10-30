// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'optimus.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Optimus _$OptimusFromJson(Map<String, dynamic> json) {
  return Optimus(
    json['profit'] as String,
    json['quantity'] as int,
    json['webp'] as int,
    json['error'] as String,
  );
}

Map<String, dynamic> _$OptimusToJson(Optimus instance) => <String, dynamic>{
      'profit': instance.profit,
      'quantity': instance.quantity,
      'webp': instance.webp,
      'error': instance.error,
    };
