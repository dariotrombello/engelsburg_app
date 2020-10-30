// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Term _$TermFromJson(Map<String, dynamic> json) {
  return Term(
    json['taxonomy'] as String,
    json['embeddable'] as bool,
    json['href'] as String,
  );
}

Map<String, dynamic> _$TermToJson(Term instance) => <String, dynamic>{
      'taxonomy': instance.taxonomy,
      'embeddable': instance.embeddable,
      'href': instance.href,
    };
