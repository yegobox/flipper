import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:synchronized/synchronized.dart';

mixin TransactionMixin implements TransactionInterface {
  Repository get repository;

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
    final query = Query(where: [
      if (branchId != null) Where('branchId').isExactly(branchId),
      if (id != null) Where('id').isExactly(id),
      if (status != null) Where('status').isExactly(status),
      if (transactionType != null) Where('type').isExactly(transactionType),
      if (startDate != null)
        Where('createdAt').isGreaterThanOrEqualTo(startDate),
      if (endDate != null) Where('createdAt').isLessThanOrEqualTo(endDate),
    ]);

    return await repository.get<ITransaction>(query: query);
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) async {
    return await repository.get<Configurations>(
      query: Query(where: [
        Where('branchId').isExactly(branchId),
        Where('type').isExactly('tax'),
      ]),
    );
  }

  @override
  Future<Configurations> saveTax({
    required String configId,
    required double taxPercentage,
  }) async {
    final config = Configurations(
        id: configId, taxPercentage: taxPercentage, taxType: 'vat');

    return (await repository.upsert<Configurations>(config));
  }

  @override
  FutureOr<Configurations?> getByTaxType({required String taxtype}) async {
    return (await repository.get<Configurations>(
      query: Query(where: [
        Where('type').isExactly('tax'),
        Where('taxType').isExactly(taxtype),
      ]),
    ))
        .firstOrNull;
  }

  Future<ITransaction?> _pendingTransaction({
    required int branchId,
    required String transactionType,
    required bool isExpense,
    bool includeSubTotalCheck = true,
  }) async {
    try {
      final query = Query(where: [
        Where('branchId').isExactly(branchId),
        Where('isExpense').isExactly(isExpense),
        Where('status').isExactly(PENDING),
        Where('transactionType').isExactly(transactionType),
        if (includeSubTotalCheck)
          Where('subTotal').isGreaterThan(0),
      ]);

      final List<ITransaction> transactions = await repository.get<ITransaction>(
        query: query,
        policy: OfflineFirstGetPolicy.localOnly,
      );

      return transactions.isNotEmpty ? transactions.last : null;
    } catch (e, s) {
      talker.error('Error in _pendingTransaction: $e');
      talker.error('Stack trace: $s');
      return null;
    }
  }

  bool _isProcessingTransaction = false;
  final Lock _transactionLock = Lock();

  @override
  Future<ITransaction?> manageTransaction({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async {
    return await _transactionLock.synchronized(() async {
      if (_isProcessingTransaction) return null;

      _isProcessingTransaction = true;
      try {
        final existTransaction = await _pendingTransaction(
          branchId: branchId,
          isExpense: isExpense,
          transactionType: transactionType,
          includeSubTotalCheck: includeSubTotalCheck,
        );

        if (existTransaction != null) return existTransaction;

        final now = DateTime.now();
        final randomRef = randomNumber().toString();

        final transaction = ITransaction(
          lastTouched: now,
          reference: randomRef,
          transactionNumber: randomRef,
          status: PENDING,
          isExpense: isExpense,
          isIncome: !isExpense,
          transactionType: transactionType,
          subTotal: 0.0,
          cashReceived: 0.0,
          updatedAt: now,
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "Cash",
          branchId: branchId,
          createdAt: now,
        );

        await repository.upsert<ITransaction>(transaction);
        return transaction;
      } catch (e) {
        talker.error('Error processing transaction: $e');
        rethrow;
      } finally {
        _isProcessingTransaction = false;
      }
    });
  }

  final Map<int, bool> _isProcessingTransactionMap = {};

  @override
  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async* {
    _isProcessingTransactionMap[branchId] ??= false;

    ITransaction? transaction = await _pendingTransaction(
      branchId: branchId,
      isExpense: isExpense,
      transactionType: transactionType,
      includeSubTotalCheck: includeSubTotalCheck,
    );

    if (transaction == null && !_isProcessingTransactionMap[branchId]!) {
      _isProcessingTransactionMap[branchId] = true;

      transaction = ITransaction(
        lastTouched: DateTime.now(),
        reference: randomNumber().toString(),
        transactionNumber: randomNumber().toString(),
        status: PENDING,
        isExpense: isExpense,
        isIncome: !isExpense,
        transactionType: transactionType,
        subTotal: 0.0,
        cashReceived: 0.0,
        updatedAt: DateTime.now(),
        customerChangeDue: 0.0,
        paymentType: ProxyService.box.paymentType() ?? "Cash",
        branchId: branchId,
        createdAt: DateTime.now(),
      );

      await repository.upsert<ITransaction>(transaction);

      _isProcessingTransactionMap[branchId] = false;
    }
    if (transaction != null) {
      yield transaction;
    }

    while (true) {
      final updatedTransaction = await _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: includeSubTotalCheck,
      );

      if (updatedTransaction != null) {
        yield updatedTransaction;
      }

      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  FutureOr<void> removeCustomerFromTransaction({required ITransaction transaction}) {
    transaction.customerId = null;
    repository.upsert(transaction);
  }
}
