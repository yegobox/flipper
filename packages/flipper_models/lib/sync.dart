// To parse this JSON data, do
//
//     final sync = syncFromJson(jsonString);
library flipper_models;

import 'dart:convert';

import 'package:flipper/objectbox.g.dart';

Sync syncFromJson(String str) => Sync.fromJson(json.decode(str));

String syncToJson(Sync data) => json.encode(data.toJson());

class Sync {
  Sync({
    required this.userId,
    required this.channels,
    required this.token,
  });
  @Id()
  int? tracker;
  String userId;
  List<String> channels;
  String token;

  factory Sync.fromJson(Map<String, dynamic> json) => Sync(
        userId: json["userId"],
        channels: List<String>.from(json["channels"].map((x) => x)),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "channels": List<dynamic>.from(channels.map((x) => x)),
        "token": token,
      };
}
