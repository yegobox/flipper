import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'transactions'),
)
class ITransaction extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(unique: true)
  final String id;

  String? reference;
  String? categoryId;
  String? transactionNumber;

  int? branchId;

  String? status;

  String? transactionType;
  @Supabase(defaultValue: "0.0")
  double? subTotal;
  String? paymentType;
  @Supabase(defaultValue: "0.0")
  double? cashReceived;
  @Supabase(defaultValue: "0.0")
  double? customerChangeDue;

  String? createdAt;
  // add receipt type offerered on this transaction
  /// remember we also have receipt model where each receipt generated is saved.
  String? receiptType;
  String? updatedAt;

  int? customerId;
  String? customerType;
  String? note;

  DateTime? lastTouched;

  // int categoryId;

  String? ticketName;
  DateTime? deletedAt;

  // fields when a transaction is created for ordering system
  int? supplierId;

  /// because we can call EBM server to notify about new item saved into our stock
  /// and this operation might fail at time of us making the call and our software can work offline
  /// with no disturbing the operation, we added this field to help us know when to try to re-submit the data
  /// to EBM in case of failure
  @Supabase(defaultValue: "false")
  bool? ebmSynced;

  // Add methods to check type
  @Supabase(defaultValue: "true")
  bool? isIncome;
  @Supabase(defaultValue: "false")
  bool? isExpense;
  @Supabase(defaultValue: "false")
  bool? isRefunded;
  String? customerName;
  String? customerTin;
  String? remark;
  String? customerBhfId;
  String? sarTyCd;
  int? receiptNumber;
  int? totalReceiptNumber;
  int? invoiceNumber;
  ITransaction({
    this.ticketName,
    this.deletedAt,
    String? id,
    this.categoryId,
    this.transactionNumber,
    this.reference,
    required this.branchId,
    required this.status,
    required this.transactionType,
    required this.subTotal,
    required this.paymentType,
    required this.cashReceived,
    required this.customerChangeDue,
    required this.createdAt,
    this.receiptType,
    required this.updatedAt,
    this.customerId,
    this.customerType,
    this.note,
    this.lastTouched,
    this.supplierId,
    this.ebmSynced,
    required this.isIncome,
    required this.isExpense,
    this.isRefunded,
    this.customerName,
    this.customerTin,
    this.remark,
    this.customerBhfId,
    this.sarTyCd,
    this.receiptNumber,
    this.totalReceiptNumber,
    this.invoiceNumber,
 }) : id = id ?? const Uuid().v4();
}
