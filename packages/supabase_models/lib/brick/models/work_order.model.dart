import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
part 'work_order.model.ditto_sync_adapter.g.dart';

/// Work Order model for production planning (SAP-inspired)
///
/// Represents a planned production quantity for a specific product/variant
/// on a target date. This is the "planned output" in planned vs actual tracking.
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'work_orders'),
)
@DittoAdapter(
  'work_orders',
  syncDirection: SyncDirection.bidirectional,
)
class WorkOrder extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String id;

  /// Reference to the branch
  @Sqlite(index: true)
  String branchId;

  /// Reference to the business
  @Sqlite(index: true)
  String businessId;

  /// Reference to the product variant being produced
  @Sqlite(index: true)
  String variantId;

  /// Name of the product/variant (denormalized for display)
  String? variantName;

  /// The planned production quantity
  double plannedQuantity;

  /// The actual produced quantity (updated when output is recorded)
  @Sqlite(defaultValue: '0.0', columnType: Column.num)
  @Supabase(defaultValue: '0.0')
  double actualQuantity;

  /// Target date for production
  DateTime targetDate;

  /// Optional shift ID for shift-based tracking
  String? shiftId;

  /// Work order status: 'planned', 'in_progress', 'completed', 'cancelled'
  @Sqlite(defaultValue: "'planned'")
  @Supabase(defaultValue: "'planned'")
  String status;

  /// Unit of measure (e.g., 'pcs', 'kg', 'liters')
  String? unitOfMeasure;

  /// Notes or comments
  String? notes;

  /// User who created the work order
  String? createdBy;

  /// Creation timestamp
  DateTime? createdAt;

  /// Timestamp when work order was started (status changed to in_progress)
  DateTime? startedAt;

  /// Timestamp when work order was completed (status changed to completed)
  DateTime? completedAt;

  /// Last modification timestamp
  DateTime? lastTouched;

  /// Calculated variance (actual - planned)
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  double get variance => actualQuantity - plannedQuantity;

  /// Calculated variance percentage
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  double get variancePercentage =>
      plannedQuantity > 0 ? (variance / plannedQuantity) * 100 : 0;

  /// Whether the work order is completed
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  bool get isCompleted => status == 'completed';

  /// SAP-style efficiency rating
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  double get efficiency =>
      plannedQuantity > 0 ? (actualQuantity / plannedQuantity) * 100 : 0;

  WorkOrder({
    String? id,
    required this.branchId,
    required this.businessId,
    required this.variantId,
    this.variantName,
    required this.plannedQuantity,
    double? actualQuantity,
    required this.targetDate,
    this.shiftId,
    String? status,
    this.unitOfMeasure,
    this.notes,
    this.createdBy,
    DateTime? createdAt,
    this.startedAt,
    this.completedAt,
    this.lastTouched,
  })  : id = id ?? const Uuid().v4(),
        actualQuantity = actualQuantity ?? 0.0,
        status = status ?? 'planned',
        createdAt = createdAt ?? DateTime.now().toUtc();

  /// Factory constructor from JSON
  factory WorkOrder.fromJson(Map<String, dynamic> json) {
    return WorkOrder(
      id: json['id'] as String?,
      branchId: json['branchId'] as String? ?? json['branch_id'] as String,
      businessId:
          json['businessId'] as String? ?? json['business_id'] as String,
      variantId: json['variantId'] as String? ?? json['variant_id'] as String,
      variantName:
          json['variantName'] as String? ?? json['variant_name'] as String?,
      plannedQuantity: (json['plannedQuantity'] as num? ??
              json['planned_quantity'] as num? ??
              0)
          .toDouble(),
      actualQuantity: (json['actualQuantity'] as num? ??
              json['actual_quantity'] as num? ??
              0)
          .toDouble(),
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : json['target_date'] != null
              ? DateTime.parse(json['target_date'] as String)
              : DateTime.now(),
      shiftId: json['shiftId'] as String? ?? json['shift_id'] as String?,
      status: json['status'] as String? ?? 'planned',
      unitOfMeasure: json['unitOfMeasure'] as String? ??
          json['unit_of_measure'] as String?,
      notes: json['notes'] as String?,
      createdBy: json['createdBy'] as String? ?? json['created_by'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : json['created_at'] != null
              ? DateTime.parse(json['created_at'] as String)
              : null,
      startedAt: json['startedAt'] != null
          ? DateTime.parse(json['startedAt'] as String)
          : json['started_at'] != null
              ? DateTime.parse(json['started_at'] as String)
              : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : json['completed_at'] != null
              ? DateTime.parse(json['completed_at'] as String)
              : null,
      lastTouched: json['lastTouched'] != null
          ? DateTime.parse(json['lastTouched'] as String)
          : json['last_touched'] != null
              ? DateTime.parse(json['last_touched'] as String)
              : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branchId,
      'business_id': businessId,
      'variant_id': variantId,
      'variant_name': variantName,
      'planned_quantity': plannedQuantity,
      'actual_quantity': actualQuantity,
      'target_date': targetDate.toIso8601String(),
      'shift_id': shiftId,
      'status': status,
      'unit_of_measure': unitOfMeasure,
      'notes': notes,
      'created_by': createdBy,
      'created_at': createdAt?.toIso8601String(),
      'started_at': startedAt?.toIso8601String(),
      'completed_at': completedAt?.toIso8601String(),
      'last_touched': lastTouched?.toIso8601String(),
    };
  }

  /// Copy with method
  WorkOrder copyWith({
    String? id,
    String? branchId,
    String? businessId,
    String? variantId,
    String? variantName,
    double? plannedQuantity,
    double? actualQuantity,
    DateTime? targetDate,
    String? shiftId,
    String? status,
    String? unitOfMeasure,
    String? notes,
    String? createdBy,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    DateTime? lastTouched,
  }) {
    return WorkOrder(
      id: id ?? this.id,
      branchId: branchId ?? this.branchId,
      businessId: businessId ?? this.businessId,
      variantId: variantId ?? this.variantId,
      variantName: variantName ?? this.variantName,
      plannedQuantity: plannedQuantity ?? this.plannedQuantity,
      actualQuantity: actualQuantity ?? this.actualQuantity,
      targetDate: targetDate ?? this.targetDate,
      shiftId: shiftId ?? this.shiftId,
      status: status ?? this.status,
      unitOfMeasure: unitOfMeasure ?? this.unitOfMeasure,
      notes: notes ?? this.notes,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      lastTouched: lastTouched ?? this.lastTouched,
    );
  }
}
