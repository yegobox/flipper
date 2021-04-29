library flipper_models;

class LoginResponse {
  // String token;
  // String email;
  // int synced;
  // String name;
  // bool newUser;
  // dynamic avatar;
  // int id;
  dynamic subscription;
  dynamic expiresAt;

  LoginResponse({
    // required this.token,
    // required this.email,
    // required this.synced,
    // required this.name,
    // required this.newUser,
    // this.avatar,
    // required this.id,
    this.subscription,
    this.expiresAt,
  });
}
