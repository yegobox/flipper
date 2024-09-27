// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: (json['id'] as num?)?.toInt(),
      amount: (json['amount'] as num).toInt(),
      interval: (json['interval'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      createdAt: (json['createdAt'] as num).toInt(),
      paymentType: json['paymentType'] as String,
      requestGuid: json['requestGuid'] as String,
      note: json['note'] as String,
      itemName: json['itemName'] as String,
      phoneNumber: json['phoneNumber'] as String,
    );

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'interval': instance.interval,
      'userId': instance.userId,
      'createdAt': instance.createdAt,
      'paymentType': instance.paymentType,
      'requestGuid': instance.requestGuid,
      'note': instance.note,
      'itemName': instance.itemName,
      'phoneNumber': instance.phoneNumber,
    };
