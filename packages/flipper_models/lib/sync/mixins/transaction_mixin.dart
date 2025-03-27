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
        if (includeSubTotalCheck) Where('subTotal').isGreaterThan(0),
      ]);

      final List<ITransaction> transactions =
          await repository.get<ITransaction>(
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
  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction}) {
    transaction.customerId = null;
    repository.upsert(transaction);
  }

  @override
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
  }) async {
    try {
      // Save the transaction item
      await saveTransaction(
        variation: variant,
        amountTotal: variant.retailPrice!,
        customItem: false,
        currentStock: variant.stock!.currentStock!,
        pendingTransaction: pendingTransaction,
        partOfComposite: false,
        compositePrice: 0,
        item: item,
        sarTyCd: sarTyCd,
        useTransactionItemForQty: useTransactionItemForQty,
      );

      // Update the transaction status to PARKED
      await _parkTransaction(
        pendingTransaction: pendingTransaction,
        variant: variant,
        sarTyCd: sarTyCd,
        business: business,
        randomNumber: randomNumber,
      );
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }

  ///Parks the transaction
  Future<void> _parkTransaction({
    required ITransaction pendingTransaction,
    required Variant variant,
    required dynamic business,
    required int randomNumber,
    required String sarTyCd,
  }) async {
    await ProxyService.strategy.updateTransaction(
      transaction: pendingTransaction,
      status: PARKED,
      sarTyCd: sarTyCd, //Incoming- Adjustment
      receiptNumber: randomNumber,
      reference: randomNumber.toString(),
      invoiceNumber: randomNumber,
      receiptType: TransactionType.adjustment,
      customerTin: ProxyService.box.tin().toString(),
      customerBhfId: await ProxyService.box.bhfId() ?? "00",
      subTotal: pendingTransaction.subTotal! + (variant.splyAmt ?? 0),
      cashReceived: -(pendingTransaction.subTotal! + (variant.splyAmt ?? 0)),
      customerName: business.name,
    );
  }

  @override
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
      String? sarTyCd}) async {
    try {
      TransactionItem? existTransactionItem = await ProxyService.strategy
          .getTransactionItem(
              variantId: variation.id, transactionId: pendingTransaction.id);

      await addTransactionItems(
        doneWithTransaction: true,
        variationId: variation.id,
        pendingTransaction: pendingTransaction,
        name: variation.name,
        sarTyCd: sarTyCd,
        variation: variation,
        currentStock: currentStock,
        amountTotal: amountTotal,
        isCustom: customItem,
        partOfComposite: partOfComposite,
        compositePrice: compositePrice,
        item: existTransactionItem ?? item,
        useTransactionItemForQty: useTransactionItemForQty,
      );

      return true;
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }

  Future<void> addTransactionItems({
    required String variationId,
    required ITransaction pendingTransaction,
    required String name,
    required Variant variation,
    required double currentStock,
    required double amountTotal,
    required bool isCustom,
    TransactionItem? item,
    double? compositePrice,
    required bool partOfComposite,
    bool useTransactionItemForQty = false,
    String? sarTyCd,
    bool? doneWithTransaction,
  }) async {
    try {
      // First check if there's an existing active transaction item for this variant
      final existingItems = await ProxyService.strategy.transactionItems(
        transactionId: pendingTransaction.id,
        branchId: ProxyService.box.getBranchId()!,
        active: true,
      );

      // If item is provided, use it. Otherwise find an existing one.
      TransactionItem? existingItem;
      if (item != null) {
        existingItem = item;
      } else {
        existingItem = existingItems
            .where((i) => i.variantId == variationId && !i.doneWithTransaction!)
            .firstOrNull;
      }

      // Update existing item if found and not custom
      if (existingItem != null && !isCustom) {
        await _updateExistingTransactionItem(
          item: existingItem,
          quantity: sarTyCd == "02"
              ? variation.stock!.currentStock!
              : existingItem.qty + 1,
          variation: variation,
          amountTotal: amountTotal,
        );
        await updatePendingTransactionTotals(pendingTransaction,
            sarTyCd: sarTyCd ?? "11");
        return;
      }

      // Add a new item
      double computedQty = await _calculateQuantity(
        isCustom: isCustom,
        partOfComposite: partOfComposite,
        variation: variation,
      );
      final quantity =
          useTransactionItemForQty && item != null ? item.qty : computedQty;
      final sarQty =
          sarTyCd == "02" ? variation.stock!.currentStock! : quantity;

      await ProxyService.strategy.addTransactionItem(
        doneWithTransaction: doneWithTransaction,
        transaction: pendingTransaction,
        lastTouched: DateTime.now(),
        discount: 0.0,
        compositePrice: partOfComposite ? compositePrice ?? 0.0 : 0.0,
        quantity: sarTyCd == null ? quantity : sarQty,
        currentStock: currentStock,
        partOfComposite: partOfComposite,
        variation: variation,
        name: name,
        amountTotal: amountTotal,
      );

      // Reactivate inactive items if necessary
      await _reactivateInactiveItems(pendingTransaction);

      await updatePendingTransactionTotals(pendingTransaction,
          sarTyCd: sarTyCd ?? "11");
    } catch (e, s) {
      talker.warning(e);
      talker.error(s);
      rethrow;
    }
  }

// Helper: Update existing transaction item
  Future<void> _updateExistingTransactionItem({
    required TransactionItem item,
    required double quantity,
    required Variant variation,
    required double amountTotal,
  }) async {
    await ProxyService.strategy.updateTransactionItem(
      transactionItemId: item.id,
      doneWithTransaction: false,
      qty: quantity,
      taxblAmt: variation.retailPrice! * quantity,
      price: variation.retailPrice!,
      totAmt: variation.retailPrice! * quantity,
      prc: item.prc + variation.retailPrice! * quantity,
      splyAmt: variation.supplyPrice,
      active: true,
      quantityRequested: quantity.toInt(),
      quantityShipped: 0,
    );
  }

// Helper: Calculate quantity
  Future<double> _calculateQuantity({
    required bool isCustom,
    required bool partOfComposite,
    required Variant variation,
  }) async {
    if (isCustom) return 1.0;

    /// because for composite we might have more than one item to be added to the cart at once hence why we have this
    if (partOfComposite) {
      final composite =
          (await ProxyService.strategy.composites(variantId: variation.id))
              .firstOrNull;
      return composite?.qty ?? 0.0;
    }

    return 1;
  }

// Helper: Reactivate inactive items
  Future<void> _reactivateInactiveItems(ITransaction pendingTransaction) async {
    final inactiveItems = await ProxyService.strategy.transactionItems(
      branchId: ProxyService.box.getBranchId()!,
      transactionId: pendingTransaction.id,
      doneWithTransaction: false,
      active: false,
    );

    if (inactiveItems.isNotEmpty) {
      markItemAsDoneWithTransaction(
        inactiveItems: inactiveItems,
        pendingTransaction: pendingTransaction,
      );
    }
  }

  @override
  Future<void> markItemAsDoneWithTransaction(
      {required List<TransactionItem> inactiveItems,
      required ITransaction pendingTransaction,
      bool isDoneWithTransaction = false}) async {
    if (inactiveItems.isNotEmpty) {
      for (TransactionItem inactiveItem in inactiveItems) {
        inactiveItem.active = true;
        if (isDoneWithTransaction) {
          await ProxyService.strategy.updateTransactionItem(
            transactionItemId: inactiveItem.id,
            doneWithTransaction: true,
          );
        }
      }
    }
  }

  Future<void> updatePendingTransactionTotals(ITransaction pendingTransaction,
      {required String sarTyCd}) async {
    List<TransactionItem> items = await ProxyService.strategy.transactionItems(
      branchId: ProxyService.box.getBranchId()!,
      transactionId: pendingTransaction.id,
      doneWithTransaction: false,
      active: true,
    );

    // Calculate the new values
    double newSubTotal = items.fold(0, (a, b) => a + (b.price * b.qty));
    DateTime newUpdatedAt = DateTime.now();
    DateTime newLastTouched = DateTime.now();

    // Check if we're already in a write transaction
    await ProxyService.strategy.updateTransaction(
      transaction: pendingTransaction,
      subTotal: newSubTotal,
      updatedAt: newUpdatedAt,
      lastTouched: newLastTouched,
      receiptType: "NS",
      isProformaMode: false,
      sarTyCd: sarTyCd,
      isTrainingMode: false,
    );
  }
}
