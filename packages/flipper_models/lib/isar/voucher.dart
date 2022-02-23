// To parse this JSON data, do
//
//     final voucher = voucherFromMap(jsonString);

import 'dart:convert';

import 'package:flipper_models/models/models.dart';
import 'package:isar/isar.dart';
part 'voucher.g.dart';

VoucherM voucherFromMap(String str) => VoucherM.fromMap(json.decode(str));

String voucherToMap(VoucherM data) => json.encode(data.toMap());

@Collection()
class VoucherM {
  VoucherM(
      {required this.id,
      required this.value,
      required this.interval,
      required this.used,
      required this.createdAt,
      required this.usedAt,
      required this.descriptor});

  late int id = Isar.autoIncrement;
  late int value;
  late int interval;
  late bool used;
  late int createdAt;
  late int usedAt;
  final features = IsarLinks<Feature>();
  late String descriptor;

  factory VoucherM.fromMap(Map<String, dynamic> json) => VoucherM(
        id: json["id"],
        value: json["value"],
        interval: json["interval"],
        used: json["used"],
        createdAt: json["createdAt"],
        usedAt: json["usedAt"],
        descriptor: json["descriptor"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "value": value,
        "interval": interval,
        "used": used,
        "createdAt": createdAt,
        "usedAt": usedAt,
        "descriptor": descriptor,
      };
}
