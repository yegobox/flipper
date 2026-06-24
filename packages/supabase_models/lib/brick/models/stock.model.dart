import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
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
  syncDirection: SyncDirection.sendOnly,
)
class Stock extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String id;

  int? tin;

  String? bhfId;

  /// SQLite may contain NULL legacy rows; Brick's default `as String` throws.
  @Sqlite(
    fromGenerator:
        "data['branch_id'] == null ? '' : data['branch_id'].toString()",
  )
  @Supabase(
    fromGenerator:
        "data['branch_id'] == null ? '' : data['branch_id'].toString()",
  )
  String branchId;

  @Supabase(defaultValue: "0.0")
  @Sqlite(
    fromGenerator:
        "data['current_stock'] == null ? null : (data['current_stock'] as num).toDouble()",
  )
  double? currentStock;

  @Supabase(defaultValue: "0.0")
  @Sqlite(
    fromGenerator:
        "data['low_stock'] == null ? null : (data['low_stock'] as num).toDouble()",
  )
  double? lowStock;
  @Sqlite(defaultValue: "true")
  @Supabase(defaultValue: "true")
  bool? canTrackingStock;
  @Supabase(defaultValue: "true")
  bool? showLowStockAlert;

  bool? active;

  @Sqlite(
    fromGenerator:
        "data['value'] == null ? null : (data['value'] as num).toDouble()",
  )
  double? value;

  @Sqlite(
    fromGenerator:
        "data['rsd_qty'] == null ? null : (data['rsd_qty'] as num).toDouble()",
  )
  double? rsdQty;
  DateTime? lastTouched;
  @Sqlite(defaultValue: "false")
  @Supabase(defaultValue: "false")
  bool? ebmSynced;
  @Supabase(defaultValue: "0.0")
  @Sqlite(
    fromGenerator:
        "data['initial_stock'] == null ? null : (data['initial_stock'] as num).toDouble()",
  )
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
    String? branchId,
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

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'id': id,
      'tin': tin,
      'bhfId': bhfId,
      'branchId': branchId,
      'currentStock': currentStock,
      'lowStock': lowStock,
      'canTrackingStock': canTrackingStock,
      'showLowStockAlert': showLowStockAlert,
      'active': active,
      'value': value,
      'rsdQty': rsdQty,
      'lastTouched': lastTouched?.toIso8601String(),
      'ebmSynced': ebmSynced,
      'initialStock': initialStock,
    };
  }
}
