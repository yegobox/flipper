// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      id: json['id'] as int?,
      amount: json['amount'] as int,
      interval: json['interval'] as int,
      userId: json['userId'] as int,
      createdAt: json['createdAt'] as int,
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
