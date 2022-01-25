// To parse this JSON data, do
//
//     final sync = syncFromJson(jsonString);
library flipper_models;

import 'dart:convert';

SyncF syncFromJson(String str) => SyncF.fromJson(json.decode(str));

String syncToJson(SyncF data) => json.encode(data.toJson());

class SyncF {
  SyncF({
    required this.id,
    required this.phoneNumber,
    required this.token,
    required this.channels,
  });

  int id;
  String phoneNumber;
  String token;
  List<String> channels;

  factory SyncF.fromJson(Map<String, dynamic> json) => SyncF(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "channels": [],
        "token": token,
      };

  factory SyncF.fromMap(Map<String, dynamic> json) => SyncF(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        token: json["token"],
        channels: List<String>.from(json["channels"].map((x) => x)),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "token": token,
        "channels": List<dynamic>.from(channels.map((x) => x)),
      };
}
