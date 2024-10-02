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

const _$PaymentFieldMap = <String, String>{
  'id': 'id',
  'amount': 'amount',
  'interval': 'interval',
  'userId': 'userId',
  'createdAt': 'createdAt',
  'paymentType': 'paymentType',
  'requestGuid': 'requestGuid',
  'note': 'note',
  'itemName': 'itemName',
  'phoneNumber': 'phoneNumber',
};

// ignore: unused_element
abstract class _$PaymentPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? amount(int instance) => instance;
  // ignore: unused_element
  static Object? interval(int instance) => instance;
  // ignore: unused_element
  static Object? userId(int instance) => instance;
  // ignore: unused_element
  static Object? createdAt(int instance) => instance;
  // ignore: unused_element
  static Object? paymentType(String instance) => instance;
  // ignore: unused_element
  static Object? requestGuid(String instance) => instance;
  // ignore: unused_element
  static Object? note(String instance) => instance;
  // ignore: unused_element
  static Object? itemName(String instance) => instance;
  // ignore: unused_element
  static Object? phoneNumber(String instance) => instance;
}

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
