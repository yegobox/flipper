import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:uuid/uuid.dart';

@ConnectOfflineFirstWithSupabase(
  supabaseConfig: SupabaseSerializable(tableName: 'transactions'),
)
class ITransaction extends OfflineFirstWithSupabaseModel {
  @Supabase(unique: true)
  @Sqlite(index: true, unique: true)
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

  DateTime? createdAt;
  // add receipt type offerered on this transaction
  /// remember we also have receipt model where each receipt generated is saved.
  String? receiptType;
  DateTime? updatedAt;

  String? customerId;
  String? customerType;
  String? note;

  DateTime? lastTouched;

  // int categoryId;

  String? ticketName;

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
  bool? isDigitalReceiptGenerated;
  String? receiptFileName;
  String? currentSaleCustomerPhoneNumber;
  String? sarNo;
  String? orgSarNo;
  // LOAN TICKET: Add this property to mark a transaction as a loan
  @Supabase(defaultValue: "false")
  bool? isLoan;
  // DUE DATE: Nullable field for due date of ticket (loan or in progress)
  DateTime? dueDate;

  // LOAN RECOVERY: Fields for loan recovery/auto-billing
  @Supabase(defaultValue: "false")
  bool? isAutoBilled;

  DateTime? nextBillingDate;

  @Supabase(defaultValue: "monthly")
  String? billingFrequency; // 'daily', 'weekly', 'monthly'

  @Supabase(defaultValue: "0.0")
  num? billingAmount;

  @Supabase(defaultValue: "1")
  int? totalInstallments;

  @Supabase(defaultValue: "0")
  int? paidInstallments;

  DateTime? lastBilledDate;

  // LOAN TRACKING: Additional fields for better loan management
  @Supabase(defaultValue: "0.0")
  num? originalLoanAmount;

  @Supabase(defaultValue: "0.0")
  num? remainingBalance;

  DateTime? lastPaymentDate;

  @Supabase(defaultValue: "0.0")
  num? lastPaymentAmount;

  String? originalTransactionId;
  bool? isOriginalTransaction;

  num? taxAmount;

  ITransaction({
    this.ticketName,
    String? id,
    String? categoryId,
    this.transactionNumber,
    this.currentSaleCustomerPhoneNumber,
    this.reference,
    required this.branchId,
    required this.status,
    required this.transactionType,
    double? subTotal,
    required this.paymentType,
    required this.cashReceived,
    required this.customerChangeDue,
    DateTime? createdAt,
    this.receiptType,
    required this.updatedAt,
    String? customerId,
    this.customerType,
    this.note,
    DateTime? lastTouched,
    int? supplierId,
    bool? ebmSynced,
    required this.isIncome,
    required this.isExpense,
    this.isRefunded,
    this.customerName,
    this.customerTin,
    this.remark,
    this.customerBhfId,
    this.receiptFileName,
    this.sarTyCd,
    this.receiptNumber,
    this.totalReceiptNumber,
    bool? isDigitalReceiptGenerated,
    this.invoiceNumber,
    this.sarNo,
    this.orgSarNo,
    // LOAN TICKET: Add to constructor
    bool? isLoan,
    this.dueDate,
    bool? isAutoBilled,
    this.nextBillingDate,
    String? billingFrequency,
    num? billingAmount,
    int? totalInstallments,
    int? paidInstallments,
    this.lastBilledDate,
    num? originalLoanAmount,
    num? remainingBalance,
    this.lastPaymentDate,
    num? lastPaymentAmount,
    this.originalTransactionId,
    bool? isOriginalTransaction,
    num? taxAmount,
  })  : id = id ?? const Uuid().v4(),
        isLoan = isLoan ?? false,
        isAutoBilled = isAutoBilled ?? false,
        taxAmount = taxAmount ?? 0.0,
        billingFrequency = billingFrequency ?? 'monthly',
        billingAmount = billingAmount ?? 0.0,
        totalInstallments = totalInstallments ?? 1,
        paidInstallments = paidInstallments ?? 0,
        isOriginalTransaction = isOriginalTransaction ?? true,
        originalLoanAmount = originalLoanAmount ?? subTotal,
        remainingBalance =
            remainingBalance ?? (originalLoanAmount ?? subTotal ?? 0.0),
        lastPaymentAmount = lastPaymentAmount ?? 0.0,
        subTotal = subTotal ?? 0.0,
        isDigitalReceiptGenerated = isDigitalReceiptGenerated ?? false,
        customerId =
            (customerId != null && customerId.isEmpty) ? null : customerId,
        categoryId =
            (categoryId != null && categoryId.isEmpty) ? null : categoryId,
        ebmSynced = ebmSynced ?? false,
        createdAt = createdAt ?? DateTime.now().toUtc(),
        lastTouched = lastTouched ?? DateTime.now().toUtc();
}
