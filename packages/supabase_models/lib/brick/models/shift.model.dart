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
  final int businessId;

  @Sqlite(index: true)
  final int userId;

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

  Shift({
    required this.id,
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
  });
  //copyWith
  Shift copyWith({
    String? id,
    int? businessId,
    int? userId,
    DateTime? startAt,
    DateTime? endAt,
    num? openingBalance,
    num? closingBalance,
    ShiftStatus? status,
    num? cashSales,
    num? expectedCash,
    num? cashDifference,
  }) {
    return Shift(
      id: id ?? this.id,
      businessId: businessId ?? this.businessId,
      userId: userId ?? this.userId,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      openingBalance: openingBalance ?? this.openingBalance,
      closingBalance: closingBalance ?? this.closingBalance,
      status: status ?? this.status,
      cashSales: cashSales ?? this.cashSales,
      expectedCash: expectedCash ?? this.expectedCash,
      cashDifference: cashDifference ?? this.cashDifference,
    );
  }
}
