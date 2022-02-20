library flipper_models;

import 'package:isar/isar.dart';

import 'feature.dart';
part 'subscription.g.dart';

@Collection()
class Subscription {
  Subscription({
    this.id = 0,
    required this.interval,
    required this.lastBillingDate,
    required this.nextBillingDate,
    required this.userId,
    required this.recurring,
    required this.descriptor,
  });

  late int id = Isar.autoIncrement;
  late int interval;
  late String lastBillingDate;
  late String nextBillingDate;
  late int userId;
  late double recurring;

  late String descriptor;
  final features = IsarLink<Feature>();

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        interval: json["interval"],
        lastBillingDate: json["lastBillingDate"],
        nextBillingDate: json["nextBillingDate"],
        userId: json["userId"],
        recurring: json["recurring"],
        descriptor: json["descriptor"],
      );

  Map<String, dynamic> toJson() => {
        "id": id.toString(),
        "interval": interval.toString(),
        "lastBillingDate": lastBillingDate,
        "nextBillingDate": nextBillingDate,
        "userId": userId.toString(),
        "recurringAmount": recurring.toString(),
        "descriptor": descriptor,
      };
}
