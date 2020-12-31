class FlipperConfig {
  String gateway;
  String password;
  String username;

  FlipperConfig.fromData(Map<String, dynamic> data)
      : gateway = data['gateway'],
        password = data['password'],
        username = data['username'];
}
