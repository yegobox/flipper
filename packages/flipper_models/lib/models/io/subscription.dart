library flipper_models;

import './branch.dart';
import './feature.dart';
import 'package:objectbox/objectbox.dart';

@Entity()
@Sync()
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

  @Id(assignable: true)
  int id;
  int interval;
  String lastBillingDate;
  String nextBillingDate;
  int userId;
  @Property(uid: 85196549376690194)
  double recurring;

  @Backlink()
  final branches = ToMany<BranchSync>();

  @Backlink()
  final features = ToMany<Feature>();

  String descriptor;

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
