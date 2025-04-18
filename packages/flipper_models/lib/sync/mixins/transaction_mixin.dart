import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/helperModels/random.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/proxy.dart';
import 'package:synchronized/synchronized.dart';

extension DateOnly on DateTime {
  DateTime get toDateOnly => DateTime(year, month, day);
}

mixin TransactionMixin implements TransactionInterface {
  Repository get repository;

  @override
  Future<List<ITransaction>> transactions({
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
  }) async {
    final List<Where> conditions = [
      Where('status').isExactly(status ?? COMPLETE), // Ensure default value
      if (!includeZeroSubTotal)
        Where('subTotal').isGreaterThan(0), // Optional condition
      if (id != null) Where('id').isExactly(id),
      if (branchId != null) Where('branchId').isExactly(branchId),
      Where('isExpense').isExactly(isExpense),
      if (includePending) Where('status').isExactly(PENDING),
      if (filterType != null) Where('type').isExactly(filterType.toString()),
      if (transactionType != null)
        Where('transactionType').isExactly(transactionType),
    ];

    if (startDate != null && endDate != null) {
      if (startDate == endDate) {
        talker.info('Date Given ${startDate.toIso8601String()}');
        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            startDate.toIso8601String(),
          ),
        );
        // Add condition for the end of the same day
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            endDate.add(const Duration(days: 1)).toIso8601String(),
          ),
        );
      } else {
        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            startDate.toIso8601String(),
          ),
        );
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            endDate.add(const Duration(days: 1)).toIso8601String(),
          ),
        );
      }
    }

    // Add ordering to fetch transactions with latest lastTouched first (for consistency)
    final queryString = Query(
      where: conditions,
      orderBy: [OrderBy('lastTouched', ascending: false)],
    );

    // When fetchRemote is true, we need to ensure we're using alwaysHydrate policy
    // to force fetching fresh data from the remote source
    final result = await repository.get<ITransaction>(
      policy: fetchRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
      query: queryString,
    );

    return result;
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
      // Base query to find PENDING transactions matching the criteria
      final baseWhere = [
        Where('branchId').isExactly(branchId),
        Where('isExpense').isExactly(isExpense),
        Where('status').isExactly(PENDING),
        Where('transactionType').isExactly(transactionType),
      ];

      // First try to find transactions with subtotal > 0
      if (includeSubTotalCheck) {
        final queryWithSubtotal = Query(where: [
          ...baseWhere,
          Where('subTotal').isGreaterThan(0),
        ]);

        final transactionsWithSubtotal = await repository.get<ITransaction>(
          query: queryWithSubtotal,
          policy: OfflineFirstGetPolicy.localOnly,
        );

        if (transactionsWithSubtotal.isNotEmpty) {
          return transactionsWithSubtotal.first;
        }
      }

      // If no transaction with subtotal > 0 found or includeSubTotalCheck is false,
      // find any pending transaction regardless of subtotal
      final query = Query(where: baseWhere);

      final transactions = await repository.get<ITransaction>(
        query: query,
        policy: OfflineFirstGetPolicy.localOnly,
      );

      return transactions.isNotEmpty ? transactions.first : null;
    } catch (e, s) {
      talker.error('Error in _pendingTransaction: $e');
      talker.error('Stack trace: $s');
      return null;
    }
  }

  bool _isProcessingTransaction = false;
  final Lock _transactionLock = Lock();

  final Map<int, bool> _isProcessingTransactionMap = {};

  @override
  Future<ITransaction?> manageTransaction({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async {
    return await _transactionLock.synchronized(() async {
      if (_isProcessingTransaction) return null; // Ensure return

      _isProcessingTransaction = true;
      try {
        // Always pass includeSubTotalCheck: false to find any existing PENDING transaction
        // regardless of subtotal to prevent duplicate transactions
        final existTransaction = await _pendingTransaction(
          branchId: branchId,
          isExpense: isExpense,
          transactionType: transactionType,
          includeSubTotalCheck: true,
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
        print('Error processing transaction: $e');
        rethrow;
      } finally {
        _isProcessingTransaction = false;
      }
    });
  }

  @override
  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required int branchId,
    bool includeSubTotalCheck = false,
  }) async* {
    _isProcessingTransactionMap[branchId] ??= false;

    // Check for an existing transaction - always use includeSubTotalCheck: false
    // to find any existing PENDING transaction regardless of subtotal
    ITransaction? transaction = await _pendingTransaction(
      branchId: branchId,
      isExpense: isExpense,
      transactionType: transactionType,
      includeSubTotalCheck: true,
    );

    // If no transaction exists, create and insert a new one
    if (transaction == null && !_isProcessingTransactionMap[branchId]!) {
      _isProcessingTransactionMap[branchId] =
          true; // Lock processing for this branch

      transaction = ITransaction(
        lastTouched: DateTime.now().toUtc(),
        reference: randomNumber().toString(),
        transactionNumber: randomNumber().toString(),
        status: PENDING,
        isExpense: isExpense,
        isIncome: !isExpense,
        transactionType: transactionType,
        subTotal: 0.0,
        cashReceived: 0.0,
        updatedAt: DateTime.now().toUtc(),
        customerChangeDue: 0.0,
        paymentType: ProxyService.box.paymentType() ?? "Cash",
        branchId: branchId,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.upsert<ITransaction>(transaction);

      _isProcessingTransactionMap[branchId] =
          false; // Unlock processing for this branch
    }
    if (transaction != null) {
      yield transaction;
    }
    // Listen for changes in the transaction data
    while (true) {
      // Always use includeSubTotalCheck: true to find any existing PENDING transaction
      final updatedTransaction = await _pendingTransaction(
        branchId: branchId,
        isExpense: isExpense,
        transactionType: transactionType,
        includeSubTotalCheck: true,
      );

      if (updatedTransaction != null) {
        yield updatedTransaction;
      }

      // Add a delay to avoid busy-waiting
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
    int? invoiceNumber,
    required String sarTyCd,
    Purchase? purchase,
    required bool doneWithTransaction,
    double? updatableQty,

    /// usualy the flag useTransactionItemForQty is needed when we are dealing with adjustment
    /// transaction i.e not original transaction
    bool useTransactionItemForQty = false,
    TransactionItem? item,
  }) async {
    try {
      // Save the transaction item
      await saveTransactionItem(
        variation: variant,
        updatableQty: updatableQty,
        doneWithTransaction: doneWithTransaction,
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
        purchase: purchase,
        invoiceNumber: invoiceNumber,
        pendingTransaction: pendingTransaction,
        variant: variant,
        sarTyCd: sarTyCd,
        business: business,
        randomNumber: randomNumber,
        updatableQty: updatableQty,
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
    Purchase? purchase,
    int? invoiceNumber,
    double? updatableQty,
  }) async {
    if (purchase != null && invoiceNumber != null) {
      throw ArgumentError(
          'Both purchase and invoiceNumber cannot be provided at the same time.');
    }

    await updateTransaction(
      transaction: pendingTransaction,
      status: PARKED,
      sarNo: invoiceNumber != null
          ? invoiceNumber.toString()
          : purchase?.spplrInvcNo.toString(),
      orgSarNo: invoiceNumber != null
          ? invoiceNumber.toString()
          : purchase?.spplrInvcNo.toString(),
      sarTyCd: sarTyCd,
      receiptNumber: randomNumber,
      reference: randomNumber.toString(),
      invoiceNumber: invoiceNumber ?? randomNumber,
      receiptType: TransactionType.adjustment,
      customerTin: ProxyService.box.tin().toString(),
      customerBhfId: await ProxyService.box.bhfId() ?? "00",
      subTotal: pendingTransaction.subTotal! > 0
          ? pendingTransaction.subTotal!
          : (variant.retailPrice! * (updatableQty ?? 1)),
      cashReceived: -(pendingTransaction.subTotal! > 0
          ? pendingTransaction.subTotal!
          : (variant.retailPrice! * (updatableQty ?? 1))),
      customerName: business.name,
    );
  }

  @override
  Future<bool> saveTransactionItem(
      {double? compositePrice,
      required Variant variation,
      required double amountTotal,
      required bool customItem,
      required ITransaction pendingTransaction,
      required double currentStock,
      bool useTransactionItemForQty = false,
      required bool partOfComposite,
      required bool doneWithTransaction,
      TransactionItem? item,
      double? updatableQty,
      String? sarTyCd}) async {
    try {
      TransactionItem? existTransactionItem = await ProxyService.strategy
          .getTransactionItem(
              variantId: variation.id, transactionId: pendingTransaction.id);

      await addTransactionItems(
        doneWithTransaction: doneWithTransaction,
        variationId: variation.id,
        pendingTransaction: pendingTransaction,
        name: variation.name,
        sarTyCd: sarTyCd,
        variation: variation,
        currentStock: currentStock,
        amountTotal: amountTotal,
        updatableQty: updatableQty,
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

  Future<void> addTransactionItems(
      {required String variationId,
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
      double? updatableQty}) async {
    try {
      // Update existing item if found and not custom
      if (item != null && !isCustom) {
        await _updateExistingTransactionItem(
          item: item,

          /// 02 is when we are dealing with purchase whereas 01 is when we are dealing with import
          quantity: updatableQty != null
              ? updatableQty
              : sarTyCd == "02" || sarTyCd == "01"
                  ? variation.stock!.currentStock!
                  : item.qty + 1,
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
      final sarQty = sarTyCd == "02" || sarTyCd == "01"
          ? variation.stock!.currentStock!
          : quantity;

      await ProxyService.strategy.addTransactionItem(
        doneWithTransaction: doneWithTransaction,
        transaction: pendingTransaction,
        lastTouched: DateTime.now().toUtc(),
        discount: 0.0,
        compositePrice: partOfComposite ? compositePrice ?? 0.0 : 0.0,
        quantity: updatableQty != null
            ? updatableQty
            : sarTyCd == null
                ? quantity
                : sarQty,
        currentStock: currentStock,
        partOfComposite: partOfComposite,
        variation: variation,
        name: name,
        amountTotal: amountTotal,
      );

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
  }) async {
    if (transaction == null) {
      print("Error: Transaction is null in updateTransaction.");
      return; // Exit if transaction is null.
    }

    // Determine receipt type based on mode (or use the provided value if available)
    if (isProformaMode != null || isTrainingMode != null) {
      String newReceiptType = TransactionReceptType.NS;
      if (isProformaMode == true) {
        newReceiptType = TransactionReceptType.PS;
      }
      if (isTrainingMode == true) {
        newReceiptType = TransactionReceptType.TS;
      }
      receiptType = newReceiptType; // Use the determined value for receiptType
    }

    // update to avoid the same issue, make sure that every parameter is update correctly.
    transaction.receiptType = receiptType ?? transaction.receiptType;
    transaction.subTotal = subTotal ?? transaction.subTotal;
    transaction.note = note ?? transaction.note;
    transaction.supplierId = supplierId ?? transaction.supplierId;
    transaction.status = status ?? transaction.status;
    transaction.ticketName = ticketName ?? transaction.ticketName;
    transaction.updatedAt = updatedAt ?? transaction.updatedAt;
    transaction.customerId = customerId ?? transaction.customerId;
    transaction.isRefunded = isRefunded ?? transaction.isRefunded;
    transaction.ebmSynced = ebmSynced ?? transaction.ebmSynced;
    transaction.sarNo = sarNo ?? transaction.sarNo;
    transaction.orgSarNo = orgSarNo ?? transaction.orgSarNo;
    transaction.invoiceNumber = invoiceNumber ?? transaction.invoiceNumber;
    transaction.receiptNumber = receiptNumber ?? transaction.receiptNumber;
    transaction.totalReceiptNumber =
        totalReceiptNumber ?? transaction.totalReceiptNumber;
    transaction.sarTyCd = sarTyCd ?? transaction.sarTyCd;
    transaction.reference = reference ?? transaction.reference;
    transaction.customerTin = customerTin ?? transaction.customerTin;
    transaction.customerBhfId = customerBhfId ?? transaction.customerBhfId;
    transaction.cashReceived = cashReceived ?? transaction.cashReceived;
    transaction.customerName = customerName ?? transaction.customerName;
    transaction.lastTouched = lastTouched ?? transaction.lastTouched;
    transaction.isExpense = isUnclassfied ? null : transaction.isExpense;
    transaction.isIncome = isUnclassfied ? null : transaction.isIncome;

    await repository.upsert<ITransaction>(
        policy: OfflineFirstUpsertPolicy.optimisticLocal, transaction);
  }

  @override
  Future<ITransaction?> getTransaction(
      {String? sarNo, required int branchId, String? id}) async {
    try {
      final query = Query(where: [
        if (sarNo != null) Where('sarNo').isExactly(sarNo),
        Where('branchId').isExactly(branchId),
        if (id != null) Where('id').isExactly(id)
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

  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    String? id,
    required bool removeAdjustmentTransactions,
    FilterType? filterType,
    bool includePending = false,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    final List<Where> conditions = [
      Where('status').isExactly(status ?? COMPLETE),
      Where('subTotal').isGreaterThan(0),
      if (id != null) Where('id').isExactly(id),
      if (branchId != null) Where('branchId').isExactly(branchId),
      if (isCashOut) Where('isExpense').isExactly(isCashOut),
      if (removeAdjustmentTransactions)
        Where('transactionType').isNot('Adjustment'),
    ];
    // talker.warning(conditions.toString());
    if (startDate != null && endDate != null) {
      if (startDate == endDate) {
        talker.info('Date Given ${startDate.toIso8601String()}');
        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            startDate.toIso8601String(),
          ),
        );
        // Add condition for the end of the same day
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            endDate.add(const Duration(days: 1)).toIso8601String(),
          ),
        );
      } else {
        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            startDate.toIso8601String(),
          ),
        );
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            endDate.add(const Duration(days: 1)).toIso8601String(),
          ),
        );
      }
    }
    final queryString = Query(
        // limit: 5000,
        where: conditions,
        orderBy: [OrderBy('lastTouched', ascending: false)]);
    // Directly return the stream from the repository
    return repository
        .subscribe<ITransaction>(
            query: queryString, policy: OfflineFirstGetPolicy.alwaysHydrate)
        .map((data) {
      print('Transaction stream data: ${data.length} records');
      return data;
    });
  }

  @override
  Future<bool> deleteTransaction({required ITransaction transaction}) async {
    return await repository.delete<ITransaction>(transaction);
  }

  @override
  Future<bool> migrateToNewDateTime({required int branchId}) async {
    // get all transactions for the branch
    // final transactions = await repository.get<ITransaction>(
    //   query: Query(where: [Where('branchId').isExactly(branchId)]),
    // );
    // update lastTouched for each transaction
    // for (final transaction in transactions) {
    //   if (transaction.lastTouched == null) continue;
    //   transaction.lastTouched = transaction.lastTouched!.toDateOnly;
    //   transaction.createdAt = transaction.updatedAt!.toDateOnly;
    //   await repository.upsert<ITransaction>(transaction);
    // }
    return true;
  }
}
