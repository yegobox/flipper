import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';
part 'business_analytic.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'business_analytics'),
)
@DittoAdapter(
  'business_analytics',
  syncDirection: SyncDirection.bidirectional,
)
class BusinessAnalytic extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  final DateTime date;
  final String itemName;
  final num? price;
  final num? profit;
  final int? unitsSold;

  final num? stockRemainedAtTheTimeOfSale;
  final num? taxRate;
  final int? trafficCount;
  int? branchId;
  String? categoryName;
  String? categoryId;
  String? transactionId;

  // Additional fields for comprehensive analytics
  final num? value; // Total transaction value
  final num? supplyPrice; // Cost of goods sold per item
  final num? retailPrice; // Retail price per item
  final num? currentStock; // Current stock level
  final num? stockValue; // Value of current stock
  final String? paymentMethod; // Payment method used
  final String? customerType; // Customer type (walk-in, regular, etc.)
  final num? discountAmount; // Discount applied
  final num? taxAmount; // Tax amount

  BusinessAnalytic({
    String? id,
    required this.transactionId,
    required this.date,
    this.stockRemainedAtTheTimeOfSale,
    required this.itemName,
    this.price,
    this.profit,
    this.unitsSold,
    this.taxRate,
    this.trafficCount,
    this.value,
    this.supplyPrice,
    this.retailPrice,
    this.currentStock,
    this.stockValue,
    this.paymentMethod,
    this.customerType,
    this.discountAmount,
    this.taxAmount,
    this.categoryName,
    this.categoryId,
    this.branchId,
  }) : id = id ?? const Uuid().v4();

  @override
  String toString() {
    return 'BusinessAnalytic{id: $id, date: $date, itemName: $itemName, price: $price, profit: $profit, unitsSold: $unitsSold, value: $value, stockValue: $stockValue, paymentMethod: $paymentMethod, customerType: $customerType}';
  }
}
