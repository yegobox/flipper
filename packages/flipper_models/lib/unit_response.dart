// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);
library flipper_models;

import 'dart:convert';

List<LoginResponse> loginResponseFromJson(String str) =>
    List<LoginResponse>.from(
        json.decode(str).map((x) => LoginResponse.fromJson(x)));

String loginResponseToJson(List<LoginResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class LoginResponse {
  LoginResponse({
    this.id,
    this.branchId,
    this.name,
    this.table,
    this.focused,
    this.channels,
  });

  String id;
  String branchId;
  String name;
  String table;
  bool focused;
  List<String> channels;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["id"],
        branchId: json["branchId"],
        name: json["name"],
        table: json["table"],
        focused: json["focused"],
        channels: List<String>.from(json["channels"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "branchId": branchId,
        "name": name,
        "table": table,
        "focused": focused,
        "channels": List<dynamic>.from(channels.map((x) => x)),
      };
}
