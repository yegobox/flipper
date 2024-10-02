// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: (json['id'] as num?)?.toInt(),
      interval: (json['interval'] as num).toInt(),
      lastBillingDate: json['lastBillingDate'] as String,
      nextBillingDate: json['nextBillingDate'] as String,
      userId: (json['userId'] as num).toInt(),
      recurring: (json['recurring'] as num).toDouble(),
      descriptor: json['descriptor'] as String,
    );

const _$SubscriptionFieldMap = <String, String>{
  'id': 'id',
  'interval': 'interval',
  'lastBillingDate': 'lastBillingDate',
  'nextBillingDate': 'nextBillingDate',
  'userId': 'userId',
  'recurring': 'recurring',
  'descriptor': 'descriptor',
};

// ignore: unused_element
abstract class _$SubscriptionPerFieldToJson {
  // ignore: unused_element
  static Object? id(int? instance) => instance;
  // ignore: unused_element
  static Object? interval(int instance) => instance;
  // ignore: unused_element
  static Object? lastBillingDate(String instance) => instance;
  // ignore: unused_element
  static Object? nextBillingDate(String instance) => instance;
  // ignore: unused_element
  static Object? userId(int instance) => instance;
  // ignore: unused_element
  static Object? recurring(double instance) => instance;
  // ignore: unused_element
  static Object? descriptor(String instance) => instance;
}

Map<String, dynamic> _$SubscriptionToJson(Subscription instance) =>
    <String, dynamic>{
      'id': instance.id,
      'interval': instance.interval,
      'lastBillingDate': instance.lastBillingDate,
      'nextBillingDate': instance.nextBillingDate,
      'userId': instance.userId,
      'recurring': instance.recurring,
      'descriptor': instance.descriptor,
    };
