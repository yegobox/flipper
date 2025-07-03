import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:brick_sqlite/brick_sqlite.dart';
import 'package:brick_supabase/brick_supabase.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
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
  String? shiftId;
  // LOAN TICKET: Add this property to mark a transaction as a loan
  @Supabase(defaultValue: "false")
  bool? isLoan;
  // DUE DATE: Nullable field for due date of ticket (loan or in progress)
  DateTime? dueDate;

  // LOAN RECOVERY: Fields for loan recovery/auto-billing
  @Supabase(defaultValue: "false")
  bool? isAutoBilled;

  DateTime? nextBillingDate;

  String? billingFrequency;

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
  int? numberOfItems;
  // all discount found on this transaction
  num? discountAmount;
  @Supabase(ignore: true)
  @OfflineFirst(where: {'transactionId': 'id'})
  List<TransactionItem>? items;

  String? customerPhone;

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
    String? sarNo,
    this.orgSarNo,
    String? shiftId,
    // LOAN TICKET: Add to constructor
    bool? isLoan,
    this.dueDate,
    bool? isAutoBilled,
    this.nextBillingDate,
    this.billingFrequency,
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
    this.numberOfItems,
    num? discountAmount,
    this.items,
    this.customerPhone,
  })  : id = id ?? const Uuid().v4(),
        isLoan = isLoan ?? false,
        isAutoBilled = isAutoBilled ?? false,
        taxAmount = taxAmount ?? 0.0,
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
        sarNo = sarNo ?? randomNumber().toString(),
        createdAt = createdAt ?? DateTime.now().toUtc(),
        lastTouched = lastTouched ?? DateTime.now().toUtc(),
        shiftId = shiftId;

  ITransaction copyWith({
    String? id,
    String? reference,
    String? categoryId,
    String? transactionNumber,
    int? branchId,
    String? status,
    String? transactionType,
    double? subTotal,
    String? paymentType,
    double? cashReceived,
    double? customerChangeDue,
    DateTime? createdAt,
    String? receiptType,
    DateTime? updatedAt,
    String? customerId,
    String? customerType,
    String? note,
    DateTime? lastTouched,
    int? supplierId,
    bool? ebmSynced,
    bool? isIncome,
    bool? isExpense,
    bool? isRefunded,
    String? customerName,
    String? customerTin,
    String? remark,
    String? customerBhfId,
    String? sarTyCd,
    int? receiptNumber,
    int? totalReceiptNumber,
    int? invoiceNumber,
    bool? isDigitalReceiptGenerated,
    String? receiptFileName,
    String? currentSaleCustomerPhoneNumber,
    String? sarNo,
    String? orgSarNo,
    String? shiftId,
    bool? isLoan,
    DateTime? dueDate,
    bool? isAutoBilled,
    DateTime? nextBillingDate,
    String? billingFrequency,
    num? billingAmount,
    int? totalInstallments,
    int? paidInstallments,
    DateTime? lastBilledDate,
    num? originalLoanAmount,
    num? remainingBalance,
    DateTime? lastPaymentDate,
    num? lastPaymentAmount,
    String? originalTransactionId,
    bool? isOriginalTransaction,
    num? taxAmount,
    int? numberOfItems,
    num? discountAmount,
    List<TransactionItem>? items,
    String? customerPhone,
  }) {
    return ITransaction(
      id: id ?? this.id,
      reference: reference ?? this.reference,
      categoryId: categoryId ?? this.categoryId,
      transactionNumber: transactionNumber ?? this.transactionNumber,
      branchId: branchId ?? this.branchId,
      status: status ?? this.status,
      transactionType: transactionType ?? this.transactionType,
      subTotal: subTotal ?? this.subTotal,
      paymentType: paymentType ?? this.paymentType,
      cashReceived: cashReceived ?? this.cashReceived,
      customerChangeDue: customerChangeDue ?? this.customerChangeDue,
      createdAt: createdAt ?? this.createdAt,
      receiptType: receiptType ?? this.receiptType,
      updatedAt: updatedAt ?? this.updatedAt,
      customerId: customerId ?? this.customerId,
      customerType: customerType ?? this.customerType,
      note: note ?? this.note,
      lastTouched: lastTouched ?? this.lastTouched,
      supplierId: supplierId ?? this.supplierId,
      ebmSynced: ebmSynced ?? this.ebmSynced,
      isIncome: isIncome ?? this.isIncome,
      isExpense: isExpense ?? this.isExpense,
      isRefunded: isRefunded ?? this.isRefunded,
      customerName: customerName ?? this.customerName,
      customerTin: customerTin ?? this.customerTin,
      remark: remark ?? this.remark,
      customerBhfId: customerBhfId ?? this.customerBhfId,
      sarTyCd: sarTyCd ?? this.sarTyCd,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      totalReceiptNumber: totalReceiptNumber ?? this.totalReceiptNumber,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      isDigitalReceiptGenerated:
          isDigitalReceiptGenerated ?? this.isDigitalReceiptGenerated,
      receiptFileName: receiptFileName ?? this.receiptFileName,
      currentSaleCustomerPhoneNumber:
          currentSaleCustomerPhoneNumber ?? this.currentSaleCustomerPhoneNumber,
      sarNo: sarNo ?? this.sarNo,
      orgSarNo: orgSarNo ?? this.orgSarNo,
      shiftId: shiftId ?? this.shiftId,
      isLoan: isLoan ?? this.isLoan,
      dueDate: dueDate ?? this.dueDate,
      isAutoBilled: isAutoBilled ?? this.isAutoBilled,
      nextBillingDate: nextBillingDate ?? this.nextBillingDate,
      billingFrequency: billingFrequency ?? this.billingFrequency,
      billingAmount: billingAmount ?? this.billingAmount,
      totalInstallments: totalInstallments ?? this.totalInstallments,
      paidInstallments: paidInstallments ?? this.paidInstallments,
      lastBilledDate: lastBilledDate ?? this.lastBilledDate,
      originalLoanAmount: originalLoanAmount ?? this.originalLoanAmount,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      lastPaymentDate: lastPaymentDate ?? this.lastPaymentDate,
      lastPaymentAmount: lastPaymentAmount ?? this.lastPaymentAmount,
      originalTransactionId:
          originalTransactionId ?? this.originalTransactionId,
      isOriginalTransaction:
          isOriginalTransaction ?? this.isOriginalTransaction,
      taxAmount: taxAmount ?? this.taxAmount,
      numberOfItems: numberOfItems ?? this.numberOfItems,
      discountAmount: discountAmount ?? this.discountAmount,
      items: items ?? this.items,
      customerPhone: customerPhone ?? this.customerPhone,
      ticketName: ticketName ?? this.ticketName,
    );
  }
}
