// To parse this JSON data, do
//
//     final voucher = voucherFromMap(jsonString);

import 'dart:convert';

import 'package:flipper_models/models/models.dart';

Voucher voucherFromMap(String str) => Voucher.fromMap(json.decode(str));

String voucherToMap(Voucher data) => json.encode(data.toMap());

class Voucher {
  Voucher(
      {required this.id,
      required this.value,
      required this.interval,
      required this.used,
      required this.createdAt,
      required this.usedAt,
      required this.features,
      required this.descriptor});

  int id;
  int value;
  int interval;
  bool used;
  int createdAt;
  int usedAt;
  List<Feature> features;
  String descriptor;

  // Voucher copyWith({
  //   required int id,
  //   required int value,
  //   required int interval,
  //   required bool used,
  //   required int createdAt,
  //   required int usedAt,
  //   required List<Feature> features,
  // }) =>
  //     Voucher(
  //       id: id,
  //       value: value,
  //       interval: interval,
  //       used: used,
  //       createdAt: createdAt,
  //       usedAt: usedAt,
  //       features: features,
  //     );

  factory Voucher.fromMap(Map<String, dynamic> json) => Voucher(
        id: json["id"],
        value: json["value"],
        interval: json["interval"],
        used: json["used"],
        createdAt: json["createdAt"],
        usedAt: json["usedAt"],
        features:
            List<Feature>.from(json["features"].map((x) => Feature.fromMap(x))),
        descriptor: json["descriptor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "value": value,
        "interval": interval,
        "used": used,
        "createdAt": createdAt,
        "usedAt": usedAt,
        // "features": List<dynamic>.from(features.map((x) => x.toMap())),
        "descriptor": descriptor,
      };
}
