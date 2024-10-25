import 'package:freezed_annotation/freezed_annotation.dart';

part 'counter.freezed.dart';
part 'counter.g.dart';

@freezed
class Counter with _$Counter {
  const factory Counter({
    int? id,
    int? businessId,
    int? branchId,
    String? receiptType,
    int? totRcptNo,
    int? curRcptNo,
    int? invcNo,
    DateTime? lastTouched,
  }) = _Counter;

  factory Counter.fromJson(Map<String, dynamic> json) =>
      _$CounterFromJson(json);
}
