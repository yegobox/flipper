import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaTransactionMixin implements TransactionInterface {
  Repository get repository;
  Talker get talker;

  @override
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
  }) async {
    throw UnimplementedError('transactions needs to be implemented for Capella');
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
    throw UnimplementedError('getByTaxType needs to be implemented for Capella');
  }

  @override
  Future<ITransaction?> manageTransaction({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async {
    throw UnimplementedError('manageTransaction needs to be implemented for Capella');
  }

  @override
  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) {
    throw UnimplementedError('manageTransactionStream needs to be implemented for Capella');
  }

  @override
  FutureOr<void> removeCustomerFromTransaction({required ITransaction transaction}) async {
    throw UnimplementedError('removeCustomerFromTransaction needs to be implemented for Capella');
  }
}
