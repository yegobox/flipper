library flipper_models;

import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
part 'counter.g.dart';

@JsonSerializable()
@Collection()
class ICounter extends IJsonSerializable {
  Id? id;
  final int businessId;
  final int branchId;
  late String receiptType;
  late int totRcptNo;
  late int curRcptNo;
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  String action;

  ICounter({
    required this.id,
    required this.businessId,
    required this.branchId,
    required this.receiptType,
    required this.totRcptNo,
    required this.curRcptNo,
    this.lastTouched,
    this.action = "created",
  });

  factory ICounter.fromRawJson(String str) =>
      ICounter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ICounter.fromJson(Map<String, dynamic> json) =>
      _$ICounterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ICounterToJson(this);

  static List<ICounter> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => ICounter.fromJson(item)).toList();
  }
}
