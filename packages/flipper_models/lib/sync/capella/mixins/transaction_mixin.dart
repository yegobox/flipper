import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaTransactionMixin implements TransactionInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    bool isCashOut = false,
    String? id,
    bool fetchRemote = false,
    FilterType? filterType,
    int? branchId,
    bool isExpense = false,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool skipOriginalTransactionCheck = false,
  }) async {
    throw UnimplementedError(
        'transactions needs to be implemented for Capella');
  }

  @override
  FutureOr<void> addTransaction({required ITransaction transaction}) {
    throw UnimplementedError(
        'addTransaction needs to be implemented for Capella');
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) async {
    throw UnimplementedError('taxes needs to be implemented for Capella');
  }

  @override
  Future<Configurations> saveTax({
    required String configId,
    required double taxPercentage,
  }) async {
    throw UnimplementedError('saveTax needs to be implemented for Capella');
  }

  @override
  FutureOr<Configurations?> getByTaxType({required String taxtype}) async {
    throw UnimplementedError(
        'getByTaxType needs to be implemented for Capella');
  }

  @override
  Future<ITransaction?> manageTransaction({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async {
    throw UnimplementedError(
        'manageTransaction needs to be implemented for Capella');
  }

  @override
  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) {
    throw UnimplementedError(
        'manageTransactionStream needs to be implemented for Capella');
  }

  @override
  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction}) async {
    throw UnimplementedError(
        'removeCustomerFromTransaction needs to be implemented for Capella');
  }

  @override
  Future<void> assignTransaction({
    required Variant variant,
    required ITransaction pendingTransaction,
    Purchase? purchase,
    double? updatableQty,
    required bool doneWithTransaction,
    int? invoiceNumber,
    required Business business,
    required int randomNumber,
    required String sarTyCd,

    /// usualy the flag useTransactionItemForQty is needed when we are dealing with adjustment
    /// transaction i.e not original transaction
    bool useTransactionItemForQty = false,
    TransactionItem? item,
  }) {
    throw UnimplementedError(
        'assignTransaction needs to be implemented for Capella');
  }

  @override
  Future<bool> saveTransactionItem(
      {double? compositePrice,
      bool? ignoreForReport,
      double? updatableQty,
      required Variant variation,
      required bool doneWithTransaction,
      required double amountTotal,
      required bool customItem,
      required ITransaction pendingTransaction,
      required double currentStock,
      bool useTransactionItemForQty = false,
      required bool partOfComposite,
      TransactionItem? item,
      String? sarTyCd}) {
    throw UnimplementedError(
        'saveTransaction needs to be implemented for Capella');
  }

  @override
  Future<void> markItemAsDoneWithTransaction(
      {required List<TransactionItem> inactiveItems,
      bool? ignoreForReport,
      required ITransaction pendingTransaction,
      bool isDoneWithTransaction = false}) {
    throw UnimplementedError(
        'markItemAsDoneWithTransaction needs to be implemented for Capella');
  }

  /// Updates a transaction with the provided details.
  ///
  /// The [transaction] parameter is required and represents the transaction to update.
  /// The [isUnclassfied] parameter is used to mark the transaction as unclassified,
  /// meaning it is neither income nor expense. This helps avoid incorrect computations
  /// on the dashboard.
  @override
  FutureOr<void> updateTransaction({
    required ITransaction? transaction,
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
    num? taxAmount,
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
  }) {
    throw UnimplementedError(
        'updateTransaction needs to be implemented for Capella');
  }

  @override
  Future<ITransaction?> getTransaction(
      {String? sarNo, required int branchId, String? id}) {
    throw UnimplementedError(
        'getTransaction needs to be implemented for Capella');
  }

  @override
  Future<bool> deleteTransaction({required ITransaction transaction}) async {
    throw UnimplementedError(
        'deleteTransaction needs to be implemented for Capella');
  }

  @override
  Future<bool> migrateToNewDateTime({required int branchId}) async {
    // TODO: implement migrateToNewDateTime
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> pendingTransactionFuture(
      {int? branchId,
      required String transactionType,
      required bool isExpense}) {
    throw UnimplementedError(
        'pendingTransactionFuture needs to be implemented for Capella');
  }
}
