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

part 'stock_recount_item.model.ditto_sync_adapter.g.dart';

/// Represents an individual item in a stock recount session
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stock_recount_items'),
)
@DittoAdapter('stock_recount_items')
class StockRecountItem extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Reference to the parent recount session
  @Sqlite(index: true)
  @Supabase(foreignKey: 'stock_recount_id')
  final String recountId;

  /// Variant (product) being counted
  @Sqlite(index: true)
  @Supabase(foreignKey: 'variant_id')
  final String variantId;

  /// Stock record being updated
  @Sqlite(index: true)
  @Supabase(foreignKey: 'stock_id')
  final String stockId;

  /// Product name for display (denormalized for UI performance)
  final String productName;

  /// Previous stock quantity before recount
  @Sqlite(defaultValue: "0.0", columnType: Column.num)
  @Supabase(defaultValue: "0.0")
  final double previousQuantity;

  /// Newly counted quantity
  @Sqlite(defaultValue: "0.0", columnType: Column.num)
  @Supabase(defaultValue: "0.0")
  final double countedQuantity;

  /// Calculated difference (countedQuantity - previousQuantity)
  @Sqlite(defaultValue: "0.0", columnType: Column.num)
  @Supabase(defaultValue: "0.0")
  final double difference;

  /// Optional notes for this item
  final String? notes;

  /// When this item was counted
  final DateTime createdAt;

  StockRecountItem({
    String? id,
    required this.recountId,
    required this.variantId,
    required this.stockId,
    required this.productName,
    double? previousQuantity,
    double? countedQuantity,
    double? difference,
    this.notes,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        previousQuantity = previousQuantity ?? 0.0,
        countedQuantity = countedQuantity ?? 0.0,
        difference =
            difference ?? (countedQuantity ?? 0.0) - (previousQuantity ?? 0.0),
        createdAt = createdAt ?? DateTime.now().toUtc();

  /// Create a copy with updated fields
  StockRecountItem copyWith({
    String? id,
    String? recountId,
    String? variantId,
    String? stockId,
    String? productName,
    double? previousQuantity,
    double? countedQuantity,
    double? difference,
    String? notes,
    DateTime? createdAt,
  }) {
    return StockRecountItem(
      id: id ?? this.id,
      recountId: recountId ?? this.recountId,
      variantId: variantId ?? this.variantId,
      stockId: stockId ?? this.stockId,
      productName: productName ?? this.productName,
      previousQuantity: previousQuantity ?? this.previousQuantity,
      countedQuantity: countedQuantity ?? this.countedQuantity,
      difference: difference ?? this.difference,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Validate that counted quantity is not below previous quantity
  /// Returns error message if invalid, null if valid
  String? validate() {
    if (countedQuantity < 0) {
      return 'Counted quantity cannot be negative';
    }
    if (countedQuantity < previousQuantity) {
      return 'Cannot count below existing stock quantity ($previousQuantity)';
    }
    return null; // Valid
  }

  /// Update counted quantity and recalculate difference
  StockRecountItem updateCount(double newCountedQuantity) {
    return copyWith(
      countedQuantity: newCountedQuantity,
      difference: newCountedQuantity - previousQuantity,
    );
  }
}
