class FlipperConfig {
  String gateway;
  String password;
  String username;
  String pusherAppId;
  String pusherAppKey;
  String pusherAppSecret;

  FlipperConfig.fromData(Map<String, dynamic> data)
      : gateway = data['gateway'],
        password = data['password'],
        pusherAppId = data['pusherAppId'],
        pusherAppKey = data['pusherAppKey'],
        pusherAppSecret = data['pusherAppSecret'],
        username = data['username'];
}
