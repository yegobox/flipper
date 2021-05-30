// To parse this JSON data, do
//
//     final sync = syncFromJson(jsonString);
library flipper_models;

import 'dart:convert';

SyncF syncFromJson(String str) => SyncF.fromJson(json.decode(str));

String syncToJson(SyncF data) => json.encode(data.toJson());

class SyncF {
  SyncF({
    required this.userId,
    this.channels,
    required this.token,
  });
  // @Id()
  int? tracker;
  String userId;
  List<dynamic>? channels;
  String token;

  factory SyncF.fromJson(Map<String, dynamic> json) => SyncF(
        userId: json["userId"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "channels": List<dynamic>.from(channels!.map((x) => x)),
        "token": token,
      };
}
