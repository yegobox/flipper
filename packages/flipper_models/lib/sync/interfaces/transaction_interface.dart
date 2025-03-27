import 'dart:async';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';

abstract class TransactionInterface {
  FutureOr<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
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
    bool includeSubTotalCheck = false,
  });

  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  });

  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction});

  Future<void> assignTransaction({
    required Variant variant,
    required ITransaction pendingTransaction,
    required Business business,
    required int randomNumber,
    required String sarTyCd,

    /// usualy the flag useTransactionItemForQty is needed when we are dealing with adjustment
    /// transaction i.e not original transaction
    bool useTransactionItemForQty = false,
    TransactionItem? item,
  });

  Future<bool> saveTransaction(
      {double? compositePrice,
      required Variant variation,
      required double amountTotal,
      required bool customItem,
      required ITransaction pendingTransaction,
      required double currentStock,
      bool useTransactionItemForQty = false,
      required bool partOfComposite,
      TransactionItem? item,
      String? sarTyCd});

  Future<void> markItemAsDoneWithTransaction(
      {required List<TransactionItem> inactiveItems,
      required ITransaction pendingTransaction,
      bool isDoneWithTransaction = false});
}
