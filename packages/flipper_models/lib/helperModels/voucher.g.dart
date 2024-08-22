// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voucher.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Voucher _$VoucherFromJson(Map<String, dynamic> json) => Voucher(
      id: json['id'] as int?,
      value: json['value'] as int?,
      interval: json['interval'] as int?,
      used: json['used'] as bool?,
      createdAt: json['createdAt'] as int?,
      usedAt: json['usedAt'] as int?,
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
