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
  final double openingBalance;

  // Closing cash amount
  final double? closingBalance;

  @Sqlite(columnType: Column.text)
  final ShiftStatus status;

  // Expected cash from sales, minus refunds etc.
  final double? cashSales;

  // Total cash expected at the end of the shift
  final double? expectedCash;

  // Difference between closingBalance and expectedCash
  final double? cashDifference;

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
    double? openingBalance,
    double? closingBalance,
    ShiftStatus? status,
    double? cashSales,
    double? expectedCash,
    double? cashDifference,
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
