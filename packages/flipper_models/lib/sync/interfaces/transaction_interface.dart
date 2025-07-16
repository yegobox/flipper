import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/models/transaction_with_items.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/sars.model.dart';

abstract class TransactionInterface {
  Future<Sar?> getSar({required int branchId});
  Future<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    String? id,
    bool isExpense = false,
    FilterType? filterType,
    bool includeZeroSubTotal = false,
    bool fetchRemote = false,
    bool includePending = false,
    bool skipOriginalTransactionCheck = false,
    bool forceRealData = true,
  });

  FutureOr<void> addTransaction({required ITransaction transaction});

  Stream<ITransaction> pendingTransaction({
    int? branchId,
    required String transactionType,
    required bool isExpense,
    bool forceRealData = true,
  });

  Future<ITransaction?> pendingTransactionFuture({
    int? branchId,
    required String transactionType,
    required bool isExpense,
    bool forceRealData = true,
  });

  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    bool includePending = false,
    DateTime? startDate,
    DateTime? endDate,
    required bool removeAdjustmentTransactions,
    bool forceRealData = true,
  });

  Future<List<Configurations>> taxes({required int branchId});

  Future<Configurations> saveTax({
    required String configId,
    required double taxPercentage,
  });

  FutureOr<Configurations?> getByTaxType({required String taxtype});

  Future<ITransaction?> manageTransaction({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    String status = PENDING,
    bool includeSubTotalCheck = false,
    String? shiftId,
  });

  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  });

  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction});

  Future<ITransaction> assignTransaction({
    double? updatableQty,
    required Variant variant,
    required bool doneWithTransaction,
    required ITransaction pendingTransaction,
    required Business business,
    required int randomNumber,
    required String sarTyCd,

    /// usualy the flag useTransactionItemForQty is needed when we are dealing with adjustment
    /// transaction i.e not original transaction
    bool useTransactionItemForQty = false,
    TransactionItem? item,
    Purchase? purchase,
    int? invoiceNumber,
  });

  Future<bool> saveTransactionItem(
      {double? compositePrice,
      required Variant variation,
      required double amountTotal,
      required bool ignoreForReport,
      required bool customItem,
      required bool doneWithTransaction,
      required ITransaction pendingTransaction,
      required double currentStock,
      bool useTransactionItemForQty = false,
      required bool partOfComposite,
      double? updatableQty,
      TransactionItem? item,
      int? invoiceNumber,
      String? sarTyCd});

  Future<void> markItemAsDoneWithTransaction(
      {required List<TransactionItem> inactiveItems,
      required ITransaction pendingTransaction,
      required bool ignoreForReport,
      bool isDoneWithTransaction = false});
  FutureOr<void> updateTransaction({
    ITransaction? transaction,
    String? receiptType,
    double? subTotal,
    String? note,
    String? status,
    String? customerId,
    bool? ebmSynced,
    String? sarTyCd,
    String? reference,
    String? customerTin,
    String? customerBhfId,
    double? cashReceived,
    bool? isRefunded,
    String? customerName,
    String? ticketName,
    DateTime? updatedAt,
    int? invoiceNumber,
    DateTime? lastTouched,
    int? supplierId,
    int? receiptNumber,
    int? totalReceiptNumber,
    bool? isProformaMode,
    String? sarNo,
    String? orgSarNo,

    /// because transaction is involved in account reporting
    /// and in other ways to facilitate that everything in flipper has attached transaction
    /// we want to make it unclassified i.e neither it is income or expense
    /// this help us having wrong computation on dashboard of what is income or expenses.
    bool isUnclassfied = false,
    bool? isTrainingMode,
    num taxAmount = 0.0,
    String? transactionId,
  });
  Future<ITransaction?> getTransaction(
      {String? sarNo, required int branchId, String? id});
  Future<bool> deleteTransaction({required ITransaction transaction});

  Future<bool> migrateToNewDateTime({required int branchId});
  Future<List<TransactionWithItems>> transactionsAndItems({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool fetchRemote = false,
    String? id,
    bool isExpense = false,
    FilterType? filterType,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool skipOriginalTransactionCheck = false,
  });
}
