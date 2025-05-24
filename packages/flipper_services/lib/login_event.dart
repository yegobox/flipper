class LoginData {
  LoginData({
    required this.channel,
    required this.userId,
    required this.businessId,
    required this.branchId,
    required this.phone,
    required this.defaultApp,
    required this.linkingCode,
    required this.deviceName,
    required this.deviceVersion,
    required this.tokenUid,
    this.responseChannel,
  });

  String channel;

  int userId;
  int businessId;
  int branchId;
  String phone;
  String defaultApp;
  String linkingCode;
  String deviceName;
  String deviceVersion;
  String tokenUid;
  String?
      responseChannel; // Optional channel for sending login status back to mobile device

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        channel: json["channel"],
        userId: json["userId"],
        businessId: json["businessId"],
        branchId: json["branchId"],
        phone: json["phone"],
        linkingCode: json["linkingCode"],
        defaultApp: json["defaultApp"],
        deviceName: json["deviceName"],
        deviceVersion: json["deviceVersion"],
        tokenUid: json["tokenUid"],
        responseChannel: json["responseChannel"],
      );

  Map<String, dynamic> toMap() => {
        "channel": channel,
        "userId": userId,
        "businessId": businessId,
        "branchId": branchId,
        "phone": phone,
        "defaultApp": defaultApp,
        "linkingCode": linkingCode,
        "deviceName": deviceName,
        "deviceVersion": deviceVersion,
        "tokenUid": tokenUid,
        if (responseChannel != null) "responseChannel": responseChannel,
      };
}
