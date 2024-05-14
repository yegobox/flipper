// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Pointss _$PointssFromJson(Map<String, dynamic> json) => Pointss(
      id: (json['id'] as num?)?.toInt(),
      value: (json['value'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$PointssToJson(Pointss instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'userId': instance.userId,
    };
