// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Discount _$DiscountFromJson(Map<String, dynamic> json) => Discount(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      amount: (json['amount'] as num?)?.toDouble(),
      branchId: (json['branchId'] as num).toInt(),
    );

const _$DiscountFieldMap = <String, String>{
  'id': 'id',
  'name': 'name',
  'amount': 'amount',
  'branchId': 'branchId',
};

// ignore: unused_element
abstract class _$DiscountPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? name(String instance) => instance;
  // ignore: unused_element
  static Object? amount(double? instance) => instance;
  // ignore: unused_element
  static Object? branchId(int instance) => instance;
}

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'branchId': instance.branchId,
    };
