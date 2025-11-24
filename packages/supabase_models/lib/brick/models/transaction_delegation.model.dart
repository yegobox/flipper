import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:brick_ditto_generators/ditto_sync_adapter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:uuid/uuid.dart';
import 'package:supabase_models/sync/ditto_sync_adapter.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
import 'package:supabase_models/sync/ditto_sync_generated.dart';
import 'package:supabase_models/brick/repository.dart';
part 'transaction_delegation.model.ditto_sync_adapter.g.dart';

/// Represents a transaction delegation for receipt printing
///
/// Sync behavior:
/// - Filtered by branchId
/// - Automatically syncs to Ditto collection: 'transaction_delegations'
/// - Supports offline-first with Supabase backend
@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(
    tableName: 'transaction_delegations',
  ),
)
@DittoAdapter('transaction_delegations',
    syncDirection: SyncDirection.bidirectional)
class TransactionDelegation extends OfflineFirstWithSupabaseModel {
  /// Unique identifier for this delegation
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
  final String id;

  /// The transaction ID being delegated
  @Sqlite(index: true)
  final String transactionId;

  /// Branch ID for multi-location filtering
  @Sqlite(index: true)
  final int branchId;

  /// Status of the delegation (e.g., 'delegated', 'completed', 'failed')
  @Sqlite(index: true)
  final String status;

  /// Type of receipt (e.g., 'NS', 'TS')
  final String receiptType;

  /// Payment type (e.g., 'Cash', 'Card')
  final String paymentType;

  /// Subtotal amount
  @Supabase(defaultValue: "0.0")
  final double subTotal;

  /// Customer name (nullable)
  final String? customerName;

  /// Customer TIN (Tax Identification Number)
  final String? customerTin;

  /// Customer BHF ID
  final String? customerBhfId;

  /// Whether to auto-print the receipt
  @Supabase(defaultValue: "false")
  final bool isAutoPrint;

  /// Device that delegated this transaction
  final String delegatedFromDevice;

  /// When the delegation was created
  final DateTime delegatedAt;

  /// Last update timestamp
  final DateTime updatedAt;

  /// Additional data as JSON (stored as Map)
  @Sqlite(ignore: true)
  @Supabase(name: 'additional_data')
  final Map<String, dynamic>? additionalData;

  TransactionDelegation({
    String? id,
    required this.transactionId,
    required this.branchId,
    required this.status,
    required this.receiptType,
    required this.paymentType,
    double? subTotal,
    this.customerName,
    this.customerTin,
    this.customerBhfId,
    bool? isAutoPrint,
    required this.delegatedFromDevice,
    DateTime? delegatedAt,
    DateTime? updatedAt,
    this.additionalData,
  })  : id = id ?? const Uuid().v4(),
        subTotal = subTotal ?? 0.0,
        isAutoPrint = isAutoPrint ?? false,
        delegatedAt = delegatedAt ?? DateTime.now().toUtc(),
        updatedAt = updatedAt ?? DateTime.now().toUtc();

  /// Create from JSON
  factory TransactionDelegation.fromJson(Map<String, dynamic> json) {
    return TransactionDelegation(
      id: json['_id'] as String? ?? json['id'] as String?,
      transactionId: json['transactionId'] as String,
      branchId: json['branchId'] as int,
      status: json['status'] as String,
      receiptType: json['receiptType'] as String,
      paymentType: json['paymentType'] as String,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      customerName: json['customerName'] as String?,
      customerTin: json['customerTin'] as String?,
      customerBhfId: json['customerBhfId'] as String?,
      isAutoPrint: json['isAutoPrint'] as bool? ?? false,
      delegatedFromDevice: json['delegatedFromDevice'] as String,
      delegatedAt: json['delegatedAt'] != null
          ? DateTime.parse(json['delegatedAt'] as String)
          : DateTime.now().toUtc(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now().toUtc(),
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'transactionId': transactionId,
      'branchId': branchId,
      'status': status,
      'receiptType': receiptType,
      'paymentType': paymentType,
      'subTotal': subTotal,
      'customerName': customerName,
      'customerTin': customerTin,
      'customerBhfId': customerBhfId,
      'isAutoPrint': isAutoPrint,
      'delegatedFromDevice': delegatedFromDevice,
      'delegatedAt': delegatedAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  /// Create a copy with updated fields
  TransactionDelegation copyWith({
    String? id,
    String? transactionId,
    int? branchId,
    String? status,
    String? receiptType,
    String? paymentType,
    double? subTotal,
    String? customerName,
    String? customerTin,
    String? customerBhfId,
    bool? isAutoPrint,
    String? delegatedFromDevice,
    DateTime? delegatedAt,
    DateTime? updatedAt,
    Map<String, dynamic>? additionalData,
  }) {
    return TransactionDelegation(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      branchId: branchId ?? this.branchId,
      status: status ?? this.status,
      receiptType: receiptType ?? this.receiptType,
      paymentType: paymentType ?? this.paymentType,
      subTotal: subTotal ?? this.subTotal,
      customerName: customerName ?? this.customerName,
      customerTin: customerTin ?? this.customerTin,
      customerBhfId: customerBhfId ?? this.customerBhfId,
      isAutoPrint: isAutoPrint ?? this.isAutoPrint,
      delegatedFromDevice: delegatedFromDevice ?? this.delegatedFromDevice,
      delegatedAt: delegatedAt ?? this.delegatedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      additionalData: additionalData ?? this.additionalData,
    );
  }
}
