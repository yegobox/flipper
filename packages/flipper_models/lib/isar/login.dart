// To parse this JSON data, do
//
//     final login = loginFromJson(jsonString);
library flipper_models;

import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  Login({
    required this.token,
    required this.email,
    required this.synced,
    required this.name,
    required this.newUser,
    this.avatar,
    required this.id,
    this.subscription,
    this.expiresAt,
  });

  String token;
  String email;
  int synced;
  String name;
  bool newUser;
  dynamic avatar;
  late String id;
  dynamic subscription;
  dynamic expiresAt;

  factory Login.fromJson(Map<String, dynamic> json) => Login(
        token: json["token"],
        email: json["email"],
        synced: json["synced"],
        name: json["name"],
        newUser: json["newUser"],
        avatar: json["avatar"],
        id: json["id"],
        subscription: json["subscription"],
        expiresAt: json["expiresAt"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "email": email,
        "synced": synced,
        "name": name,
        "newUser": newUser,
        "avatar": avatar,
        "id": id,
        "subscription": subscription,
        "expiresAt": expiresAt,
      };
}
