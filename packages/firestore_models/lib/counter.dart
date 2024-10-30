import 'package:json_annotation/json_annotation.dart';
import 'package:cloud_firestore_odm/cloud_firestore_odm.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'counter.g.dart';

@JsonSerializable()
@Collection<Counter>('counters')
class Counter {
  Counter({
    this.id,
    this.businessId,
    this.branchId,
    this.receiptType,
    this.totRcptNo,
    this.curRcptNo,
    this.invcNo,
    this.lastTouched,
  });

  @Id()
  final int? id;
  final int? businessId;
  final int? branchId;
  final String? receiptType;
  final int? totRcptNo;
  final int? curRcptNo;
  final int? invcNo;

  @JsonKey(
    fromJson: _dateTimeFromTimestamp,
    toJson: _dateTimeToTimestamp,
  )
  final DateTime? lastTouched;

  // JsonSerializable factory
  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);

  // ToJson method
  Map<String, dynamic> toJson() => _$CounterToJson(this);

  // Helper methods for Timestamp conversion
  static DateTime? _dateTimeFromTimestamp(Timestamp? timestamp) {
    return timestamp?.toDate();
  }

  static Timestamp? _dateTimeToTimestamp(DateTime? dateTime) {
    return dateTime != null ? Timestamp.fromDate(dateTime) : null;
  }

  // CopyWith method
  Counter copyWith({
    int? id,
    int? businessId,
    int? branchId,
    String? receiptType,
    int? totRcptNo,
    int? curRcptNo,
    int? invcNo,
    DateTime? lastTouched,
  }) {
    return Counter(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      branchId: branchId ?? this.branchId,
      receiptType: receiptType ?? this.receiptType,
      totRcptNo: totRcptNo ?? this.totRcptNo,
      curRcptNo: curRcptNo ?? this.curRcptNo,
      invcNo: invcNo ?? this.invcNo,
      lastTouched: lastTouched ?? this.lastTouched,
    );
  }
}

final counterRef = CounterCollectionReference();
