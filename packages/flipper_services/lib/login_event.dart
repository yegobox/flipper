class LoginData {
  LoginData({
    required this.channel,
    required this.userId,
    required this.businessId,
    required this.branchId,
    required this.phone,
    required this.defaultApp,
  });

  String channel;

  int userId;
  int businessId;
  int branchId;
  String phone;
  int defaultApp;

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        channel: json["channel"],
        userId: json["userId"],
        businessId: json["businessId"],
        branchId: json["branchId"],
        phone: json["phone"],
        defaultApp: json["defaultApp"],
      );

  Map<String, dynamic> toMap() => {
        "channel": channel,
        "userId": userId,
        "businessId": businessId,
        "branchId": branchId,
        "phone": phone,
        "defaultApp": defaultApp,
      };
}
