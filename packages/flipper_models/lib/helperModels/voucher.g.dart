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

const _$VoucherFieldMap = <String, String>{
  'id': 'id',
  'value': 'value',
  'interval': 'interval',
  'used': 'used',
  'createdAt': 'createdAt',
  'usedAt': 'usedAt',
  'descriptor': 'descriptor',
};

// ignore: unused_element
abstract class _$VoucherPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? value(int? instance) => instance;
  // ignore: unused_element
  static Object? interval(int? instance) => instance;
  // ignore: unused_element
  static Object? used(bool? instance) => instance;
  // ignore: unused_element
  static Object? createdAt(int? instance) => instance;
  // ignore: unused_element
  static Object? usedAt(int? instance) => instance;
  // ignore: unused_element
  static Object? descriptor(String? instance) => instance;
}

Map<String, dynamic> _$VoucherToJson(Voucher instance) => <String, dynamic>{
      'id': instance.id,
      'value': instance.value,
      'interval': instance.interval,
      'used': instance.used,
      'createdAt': instance.createdAt,
      'usedAt': instance.usedAt,
      'descriptor': instance.descriptor,
    };
