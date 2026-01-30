import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

/// Variance reason categories (SAP-aligned)
enum VarianceReason {
  machine, // Machine downtime or malfunction
  material, // Material shortage or quality issues
  labor, // Labor shortage or skill issues
  quality, // Quality control rejection
  planning, // Planning or scheduling issues
  other, // Other reasons
}

/// Actual Output model for recording production results
///
/// Represents the actual produced quantity for a work order,
/// including variance tracking and reason codes.
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'actual_outputs'),
)
class ActualOutput extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  String id;

  /// Reference to the work order
  @Sqlite(index: true)
  String workOrderId;

  /// Reference to the branch
  @Sqlite(index: true)
  String branchId;

  /// The actual produced quantity
  double actualQuantity;

  /// Timestamp when output was recorded
  DateTime recordedAt;

  /// User who recorded the output
  String userId;

  /// User name (denormalized for display)
  String? userName;

  /// Variance reason category (SAP-aligned)
  /// Values: 'machine', 'material', 'labor', 'quality', 'planning', 'other'
  String? varianceReason;

  /// Detailed notes about the variance or production
  String? notes;

  /// Shift during which production occurred
  String? shiftId;

  /// Quality indicator (e.g., 'good', 'rework', 'scrap')
  String? qualityStatus;

  /// Quantity that needs rework
  @Sqlite(defaultValue: '0.0', columnType: Column.num)
  @Supabase(defaultValue: '0.0')
  double reworkQuantity;

  /// Quantity scrapped
  @Sqlite(defaultValue: '0.0', columnType: Column.num)
  @Supabase(defaultValue: '0.0')
  double scrapQuantity;

  /// Last modification timestamp
  DateTime? lastTouched;

  /// Good quantity (actual - rework - scrap)
  @Sqlite(ignore: true)
  @Supabase(ignore: true)
  double get goodQuantity => actualQuantity - reworkQuantity - scrapQuantity;

  ActualOutput({
    String? id,
    required this.workOrderId,
    required this.branchId,
    required this.actualQuantity,
    DateTime? recordedAt,
    required this.userId,
    this.userName,
    this.varianceReason,
    this.notes,
    this.shiftId,
    this.qualityStatus,
    double? reworkQuantity,
    double? scrapQuantity,
    this.lastTouched,
  })  : id = id ?? const Uuid().v4(),
        recordedAt = recordedAt ?? DateTime.now().toUtc(),
        reworkQuantity = reworkQuantity ?? 0.0,
        scrapQuantity = scrapQuantity ?? 0.0;

  /// Factory constructor from JSON
  factory ActualOutput.fromJson(Map<String, dynamic> json) {
    return ActualOutput(
      id: json['id'] as String?,
      workOrderId:
          json['workOrderId'] as String? ?? json['work_order_id'] as String,
      branchId: json['branchId'] as String? ?? json['branch_id'] as String,
      actualQuantity: (json['actualQuantity'] as num? ??
              json['actual_quantity'] as num? ??
              0)
          .toDouble(),
      recordedAt: json['recordedAt'] != null
          ? DateTime.parse(json['recordedAt'] as String)
          : json['recorded_at'] != null
              ? DateTime.parse(json['recorded_at'] as String)
              : null,
      userId: json['userId'] as String? ?? json['user_id'] as String,
      userName: json['userName'] as String? ?? json['user_name'] as String?,
      varianceReason: json['varianceReason'] as String? ??
          json['variance_reason'] as String?,
      notes: json['notes'] as String?,
      shiftId: json['shiftId'] as String? ?? json['shift_id'] as String?,
      qualityStatus:
          json['qualityStatus'] as String? ?? json['quality_status'] as String?,
      reworkQuantity: (json['reworkQuantity'] as num? ??
              json['rework_quantity'] as num? ??
              0)
          .toDouble(),
      scrapQuantity:
          (json['scrapQuantity'] as num? ?? json['scrap_quantity'] as num? ?? 0)
              .toDouble(),
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
      'work_order_id': workOrderId,
      'branch_id': branchId,
      'actual_quantity': actualQuantity,
      'recorded_at': recordedAt.toIso8601String(),
      'user_id': userId,
      'user_name': userName,
      'variance_reason': varianceReason,
      'notes': notes,
      'shift_id': shiftId,
      'quality_status': qualityStatus,
      'rework_quantity': reworkQuantity,
      'scrap_quantity': scrapQuantity,
      'last_touched': lastTouched?.toIso8601String(),
    };
  }

  /// Copy with method
  ActualOutput copyWith({
    String? id,
    String? workOrderId,
    String? branchId,
    double? actualQuantity,
    DateTime? recordedAt,
    String? userId,
    String? userName,
    String? varianceReason,
    String? notes,
    String? shiftId,
    String? qualityStatus,
    double? reworkQuantity,
    double? scrapQuantity,
    DateTime? lastTouched,
  }) {
    return ActualOutput(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      branchId: branchId ?? this.branchId,
      actualQuantity: actualQuantity ?? this.actualQuantity,
      recordedAt: recordedAt ?? this.recordedAt,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      varianceReason: varianceReason ?? this.varianceReason,
      notes: notes ?? this.notes,
      shiftId: shiftId ?? this.shiftId,
      qualityStatus: qualityStatus ?? this.qualityStatus,
      reworkQuantity: reworkQuantity ?? this.reworkQuantity,
      scrapQuantity: scrapQuantity ?? this.scrapQuantity,
      lastTouched: lastTouched ?? this.lastTouched,
    );
  }
}
