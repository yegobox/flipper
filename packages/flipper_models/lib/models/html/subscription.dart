library flipper_models;

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

  int id;
  int interval;
  String lastBillingDate;
  String nextBillingDate;
  int userId;
  double recurring;

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
