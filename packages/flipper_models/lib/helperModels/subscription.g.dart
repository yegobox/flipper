// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subscription _$SubscriptionFromJson(Map<String, dynamic> json) => Subscription(
      id: json['id'] as int?,
      interval: json['interval'] as int,
      lastBillingDate: json['lastBillingDate'] as String,
      nextBillingDate: json['nextBillingDate'] as String,
      userId: json['userId'] as int,
      recurring: (json['recurring'] as num).toDouble(),
      descriptor: json['descriptor'] as String,
    );

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
