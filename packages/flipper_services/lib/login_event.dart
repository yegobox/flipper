class LoginData {
  LoginData({
    required this.channel,
    required this.userId,
    required this.pin,
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

  String userId;
  int pin;
  String businessId;
  String branchId;
  String phone;
  String defaultApp;
  String linkingCode;
  String deviceName;
  String deviceVersion;
  String tokenUid;
  String?
      responseChannel; // Optional channel for sending login status back to mobile device

  factory LoginData.fromMap(Map<String, dynamic> json) => LoginData(
        channel: json["channel"] ?? '',
        userId: json["userId"] ?? 0,
        pin: json["pin"] ?? 0,
        businessId: json["businessId"] ?? 0,
        branchId: json["branchId"] ?? 0,
        phone: json["phone"] ?? '',
        linkingCode: json["linkingCode"] ?? '',
        defaultApp: json["defaultApp"] ?? '',
        deviceName: json["deviceName"] ?? '',
        deviceVersion: json["deviceVersion"] ?? '',
        tokenUid: json["tokenUid"] ?? '',
        responseChannel: json["responseChannel"],
      );

  Map<String, dynamic> toMap() => {
        "channel": channel,
        "userId": userId,
        "pin": pin,
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
