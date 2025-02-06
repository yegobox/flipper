import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'business_analytics'),
)
class BusinessAnalytic extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final DateTime date;
  final String itemName; // Added
  final num price;
  final num profit;
  final int unitsSold;
  final num taxRate;
  final int trafficCount;
  int? branchId;

  BusinessAnalytic({
    String? id,
    required this.date,
    required this.itemName,
    required this.price,
    required this.profit,
    required this.unitsSold,
    required this.taxRate,
    required this.trafficCount,
    this.branchId,
  }) : id = id ?? const Uuid().v4();

  @override
  String toString() {
    return 'BusinessAnalytic{id: $id, date: $date, itemName: $itemName, price: $price, profit: $profit, unitsSold: $unitsSold, taxRate: $taxRate, trafficCount: $trafficCount, branchId: $branchId}';
  }
}
