import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction.freezed.dart';
part 'transaction.g.dart';

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    int? id,
    String? reference,
    String? categoryId,
    String? transactionNumber,
    @Default(null)  int? branchId,
    @Default(null)  String? status,
    @Default(null)  String? transactionType,
    @Default(0.0) double subTotal,
    String? paymentType,
    @Default(0.0) double cashReceived,
    @Default(0.0) double customerChangeDue,
    @Default(null)  String? createdAt,
    String? receiptType,
    String? updatedAt,
    @Default(null)  int? customerId,
    String? customerType,
    String? note,
    DateTime? lastTouched,
    String? ticketName,
    DateTime? deletedAt,
    int? supplierId,
    @Default(false) bool ebmSynced,
    @Default(false) bool isIncome,
    @Default(false) bool isExpense,
    @Default(false) bool isRefunded,
    String? customerName,
    String? customerTin,
    String? remark,
    String? customerBhfId,
    String? sarTyCd,
    int? receiptNumber,
    int? totalReceiptNumber,
    int? invoiceNumber,
  }) = _Transaction;

  factory Transaction.fromJson(Map<String, dynamic> json) => 
      _$TransactionFromJson(json);
}