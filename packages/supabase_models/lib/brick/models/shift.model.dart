// ignore_for_file: constant_identifier_names

import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';

enum ShiftStatus { Open, Closed }

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'shifts'),
)
class Shift extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(
    unique: true,
  )
  final String id;

  @Sqlite(index: true)
  final String businessId;

  @Sqlite(index: true)
  final String userId;

  final DateTime startAt;
  final DateTime? endAt;

  // Opening cash float
  final num openingBalance;

  // Closing cash amount
  final num? closingBalance;

  @Supabase(enumAsString: true)
  @Sqlite(enumAsString: true)
  final ShiftStatus status;

  // Expected cash from sales, minus refunds etc.
  final num? cashSales;

  // Total cash expected at the end of the shift
  final num? expectedCash;

  // Difference between closingBalance and expectedCash
  final num? cashDifference;

  String? note;

  // Total cash given back as refunds
  final num? refunds;

  Shift(
      {required this.id,
      required this.businessId,
      required this.userId,
      required this.startAt,
      this.endAt,
      required this.openingBalance,
      this.closingBalance,
      this.status = ShiftStatus.Open,
      this.cashSales,
      this.expectedCash,
      this.cashDifference,
      this.note,
      this.refunds});
  //copyWith
  Shift copyWith(
      {String? id,
      String? businessId,
      String? userId,
      DateTime? startAt,
      DateTime? endAt,
      num? openingBalance,
      num? closingBalance,
      ShiftStatus? status,
      num? cashSales,
      num? expectedCash,
      num? cashDifference,
      String? note,
      num? refunds}) {
    return Shift(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      userId: userId ?? this.userId,
      note: note ?? this.note,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      status: status ?? this.status,
      cashSales: cashSales ?? this.cashSales,
      expectedCash: expectedCash ?? this.expectedCash,
      cashDifference: cashDifference ?? this.cashDifference,
      refunds: refunds ?? this.refunds,
    );
  }

  /// Document shape for Ditto `shifts` collection (direct store access).
  Map<String, dynamic> toDittoDocument() {
    return {
      '_id': id,
      'id': id,
      'businessId': businessId,
      'userId': userId,
      'startAt': startAt.toUtc().toIso8601String(),
      if (endAt != null) 'endAt': endAt!.toUtc().toIso8601String(),
      'openingBalance': openingBalance,
      if (closingBalance != null) 'closingBalance': closingBalance,
      'status': status.name,
      if (cashSales != null) 'cashSales': cashSales,
      if (expectedCash != null) 'expectedCash': expectedCash,
      if (cashDifference != null) 'cashDifference': cashDifference,
      if (note != null) 'note': note,
      if (refunds != null) 'refunds': refunds,
    };
  }

  static Shift fromDittoDocument(Map<String, dynamic> raw) {
    DateTime? parseDt(dynamic v) {
      if (v == null) return null;
      if (v is DateTime) return v.toUtc();
      return DateTime.tryParse(v.toString())?.toUtc();
    }

    num? parseNum(dynamic v) {
      if (v == null) return null;
      if (v is num) return v;
      return num.tryParse(v.toString());
    }

    final statusRaw = (raw['status'] ?? ShiftStatus.Open.name).toString();
    final status = ShiftStatus.values.firstWhere(
      (s) => s.name == statusRaw,
      orElse: () => ShiftStatus.Open,
    );

    return Shift(
      id: (raw['id'] ?? raw['_id'] ?? '').toString(),
      businessId: (raw['businessId'] ?? '').toString(),
      userId: (raw['userId'] ?? '').toString(),
      startAt: parseDt(raw['startAt']) ?? DateTime.now().toUtc(),
      endAt: parseDt(raw['endAt']),
      openingBalance: parseNum(raw['openingBalance']) ?? 0,
      closingBalance: parseNum(raw['closingBalance']),
      status: status,
      cashSales: parseNum(raw['cashSales']),
      expectedCash: parseNum(raw['expectedCash']),
      cashDifference: parseNum(raw['cashDifference']),
      note: raw['note']?.toString(),
      refunds: parseNum(raw['refunds']),
    );
  }
}
