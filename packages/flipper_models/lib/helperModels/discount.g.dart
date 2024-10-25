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

Map<String, dynamic> _$DiscountToJson(Discount instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'amount': instance.amount,
      'branchId': instance.branchId,
    };
