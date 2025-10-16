import 'package:brick_core/query.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:supabase_models/brick/repository.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:uuid/uuid.dart';

part 'stock.model.ditto_sync_adapter.g.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stocks'),
)
@DittoAdapter(
  'stocks',
  syncDirection: SyncDirection.bidirectional,
  enableBackupPull: true,
  
)
class Stock extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String id;

  int? tin;

  String? bhfId;

  /// we kee both branchId and businessId as int as we are storing in it
  /// the server it, but local id will be uuid
  int? branchId;
  @Supabase(defaultValue: "0.0")
  double? currentStock;

  @Supabase(defaultValue: "0.0")
  double? lowStock;
  @Sqlite(defaultValue: "true")
  @Supabase(defaultValue: "true")
  bool? canTrackingStock;
  @Supabase(defaultValue: "true")
  bool? showLowStockAlert;

  bool? active;
  double? value;
  double? rsdQty;
  DateTime? lastTouched;
  @Sqlite(defaultValue: "false")
  @Supabase(defaultValue: "false")
  bool? ebmSynced;
  @Supabase(defaultValue: "0.0")
  double? initialStock;

  Stock({
    String? id,
    this.tin,
    this.bhfId,
    required this.branchId,
    double? currentStock,
    double? lowStock,
    bool? canTrackingStock,
    bool? showLowStockAlert,
    bool? active,
    double? value,
    double? rsdQty,
    DateTime? lastTouched,
    bool? ebmSynced,
    double? initialStock,
  })  : id = id ?? const Uuid().v4(),
        currentStock = currentStock ?? 0.0,
        lowStock = lowStock ?? 0.0,
        canTrackingStock = canTrackingStock ?? true,
        showLowStockAlert = showLowStockAlert ?? true,
        value = value ?? 0.0,
        rsdQty = rsdQty ?? 0.0,
        ebmSynced = ebmSynced ?? false,
        initialStock = initialStock ?? 0.0,
        active = active ?? true,
        lastTouched = lastTouched ?? DateTime.now();

  // add copyWith
  Stock copyWith({
    String? id,
    int? tin,
    String? bhfId,
    int? branchId,
    double? currentStock,
    double? lowStock,
    bool? canTrackingStock,
    bool? showLowStockAlert,
    bool? active,
    double? value,
    double? rsdQty,
    DateTime? lastTouched,
    bool? ebmSynced,
    double? initialStock,
  }) {
    return Stock(
      id: id ?? this.id,
      tin: tin ?? this.tin,
      bhfId: bhfId ?? this.bhfId,
      branchId: branchId ?? this.branchId,
      currentStock: currentStock ?? this.currentStock,
      lowStock: lowStock ?? this.lowStock,
      canTrackingStock: canTrackingStock ?? this.canTrackingStock,
      showLowStockAlert: showLowStockAlert ?? this.showLowStockAlert,
      active: active ?? this.active,
      value: value ?? this.value,
      rsdQty: rsdQty ?? this.rsdQty,
      lastTouched: lastTouched ?? this.lastTouched,
      ebmSynced: ebmSynced ?? this.ebmSynced,
      initialStock: initialStock ?? this.initialStock,
    );
  }
}
