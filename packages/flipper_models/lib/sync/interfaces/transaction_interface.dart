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

  FutureOr<void> removeCustomerFromTransaction({required ITransaction transaction});
}
