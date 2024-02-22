library flipper_models;

import 'dart:convert';
import 'package:isar/isar.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flipper_models/sync_service.dart';
part 'counter.g.dart';

@JsonSerializable()
@Collection()
class Counter extends IJsonSerializable {
  int id;
  int? businessId;
  int? branchId;
  String? receiptType;
  int? totRcptNo;
  int? curRcptNo;
  @JsonKey(includeIfNull: true)
  DateTime? lastTouched;
  String action;

  Counter({
    this.id = 0,
    this.businessId,
    this.branchId,
    this.receiptType,
    this.totRcptNo,
    this.curRcptNo,
    this.lastTouched,
    this.action = "created",
  });

  factory Counter.fromRawJson(String str) => Counter.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CounterToJson(this);

  static List<Counter> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((item) => Counter.fromJson(item)).toList();
  }
}
