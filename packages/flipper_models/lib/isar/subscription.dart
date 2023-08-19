library flipper_models;

import 'package:isar/isar.dart';

import 'package:json_annotation/json_annotation.dart';

part 'subscription.g.dart'; // This will be generated

@JsonSerializable()
@Collection()
class Subscription {
  Subscription({
    required this.id,
    required this.interval,
    required this.lastBillingDate,
    required this.nextBillingDate,
    required this.userId,
    required this.recurring,
    required this.descriptor,
  });

  late String id;
  late int interval;
  late String lastBillingDate;
  late String nextBillingDate;
  @Index()
  late int userId;
  late double recurring;

  late String descriptor;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionToJson(this);
}
