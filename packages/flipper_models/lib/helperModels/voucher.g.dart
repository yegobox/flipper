// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      id: (json['id'] as num?)?.toInt(),
      value: (json['value'] as num?)?.toInt(),
      interval: (json['interval'] as num?)?.toInt(),
      used: json['used'] as bool?,
      createdAt: (json['createdAt'] as num?)?.toInt(),
      usedAt: (json['usedAt'] as num?)?.toInt(),
      descriptor: json['descriptor'] as String?,
    );

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'interval': instance.interval,
      'used': instance.used,
      'createdAt': instance.createdAt,
      'usedAt': instance.usedAt,
      'descriptor': instance.descriptor,
    };
