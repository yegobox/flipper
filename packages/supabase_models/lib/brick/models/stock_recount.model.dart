import 'package:brick_core/query.dart';
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

part 'stock_recount.model.ditto_sync_adapter.g.dart';

/// Represents a stock recounting session that can be synced via Ditto P2P
/// Status flow: draft -> submitted -> synced
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'stock_recounts'),
)
@DittoAdapter('stock_recounts')
class StockRecount extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// Branch where the recount is being performed
  @Sqlite(index: true)
  final int branchId;

  /// Status: 'draft', 'submitted', 'synced'
  @Sqlite(defaultValue: "'draft'")
  @Supabase(defaultValue: "'draft'")
  final String status;

  /// User who created the recount
  final String? userId;

  /// Device identifier where recount was created
  final String? deviceId;

  /// Human-readable device name
  final String? deviceName;

  /// When the recount session was created
  final DateTime createdAt;

  /// When the recount was submitted for processing
  final DateTime? submittedAt;

  /// When the recount was fully synced to Supabase and processed
  final DateTime? syncedAt;

  /// Optional notes about the recount
  final String? notes;

  /// Total items counted in this session
  @Sqlite(defaultValue: "0")
  @Supabase(defaultValue: "0")
  final int totalItemsCounted;

  StockRecount({
    String? id,
    required this.branchId,
    String? status,
    this.userId,
    this.deviceId,
    this.deviceName,
    DateTime? createdAt,
    this.submittedAt,
    this.syncedAt,
    this.notes,
    int? totalItemsCounted,
  })  : id = id ?? const Uuid().v4(),
        status = status ?? 'draft',
        createdAt = createdAt ?? DateTime.now().toUtc(),
        totalItemsCounted = totalItemsCounted ?? 0;

  /// Create a copy with updated fields
  StockRecount copyWith({
    String? id,
    int? branchId,
    String? status,
    String? userId,
    String? deviceId,
    String? deviceName,
    DateTime? createdAt,
    DateTime? submittedAt,
    DateTime? syncedAt,
    String? notes,
    int? totalItemsCounted,
  }) {
    return StockRecount(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      status: status ?? this.status,
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      deviceName: deviceName ?? this.deviceName,
      createdAt: createdAt ?? this.createdAt,
      submittedAt: submittedAt ?? this.submittedAt,
      syncedAt: syncedAt ?? this.syncedAt,
      notes: notes ?? this.notes,
      totalItemsCounted: totalItemsCounted ?? this.totalItemsCounted,
    );
  }

  /// Validate status transition
  bool canTransitionTo(String newStatus) {
    switch (status) {
      case 'draft':
        return newStatus == 'submitted';
      case 'submitted':
        return newStatus == 'synced';
      case 'synced':
        return false; // Cannot transition from synced
      default:
        return false;
    }
  }

  /// Transition to submitted state
  StockRecount submit() {
    if (!canTransitionTo('submitted')) {
      throw StateError('Cannot submit recount in $status state');
    }
    return copyWith(
      status: 'submitted',
      submittedAt: DateTime.now().toUtc(),
    );
  }

  /// Transition to synced state
  StockRecount markSynced() {
    if (!canTransitionTo('synced')) {
      throw StateError('Cannot mark recount as synced in $status state');
    }
    return copyWith(
      status: 'synced',
      syncedAt: DateTime.now().toUtc(),
    );
  }
}
