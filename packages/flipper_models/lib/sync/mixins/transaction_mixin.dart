import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/models/transaction_with_items.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/utils/test_data/dummy_transaction_generator.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
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
  Stream<ITransaction> pendingTransaction({
    int? branchId,
    required bool isExpense,
    required String transactionType,
    bool forceRealData = true,
  }) {
    if (!forceRealData) {
      return Stream.value(DummyTransactionGenerator.generateDummyTransactions(
        count: 1,
        branchId: branchId ?? 1,
        status: PENDING,
        transactionType: transactionType,
        withItems: false,
      ).first);
    }
    return repository
        .subscribe<ITransaction>(
          query: Query(where: [
            Where('isExpense').isExactly(isExpense),
            Where('transactionType').isExactly(transactionType),
            Where('status').isExactly(PENDING),
            if (branchId != null) Where('branchId').isExactly(branchId),
          ]),
        )
        .map((event) => event.first);
  }

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
    bool skipOriginalTransactionCheck = false,
    bool forceRealData = true,
    List<String>? receiptNumber,
  }) async {
    if (!forceRealData) {
      return DummyTransactionGenerator.generateDummyTransactions(
        count: 10,
        branchId: branchId ?? 1,
        status: status,
        transactionType: transactionType,
      );
    }

    if (receiptNumber != null && receiptNumber.isNotEmpty) {
      final response = await repository.get<ITransaction>(
        query: Query(where: [
          Or('invoiceNumber').isIn(receiptNumber),
          Where('receiptNumber').isIn(receiptNumber),
          if (branchId != null) Where('branchId').isExactly(branchId),
        ]),
        policy: fetchRemote
            ? OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
            : OfflineFirstGetPolicy.localOnly,
      );
      return response;
    }
    final List<Where> conditions = [
      if (id != null)
        Where('id').isExactly(id)
      else ...[
        Where('status').isExactly(status ?? COMPLETE), // Ensure default value
        if (skipOriginalTransactionCheck == false)
          Where('isOriginalTransaction').isExactly(true),
        if (!includeZeroSubTotal)
          Where('subTotal').isGreaterThan(0), // Optional condition
        if (branchId != null) Where('branchId').isExactly(branchId),
        Where('isExpense').isExactly(isExpense),
        if (includePending) Where('status').isExactly(PENDING),
        if (filterType != null) Where('type').isExactly(filterType.toString()),
        if (transactionType != null)
          Where('transactionType').isExactly(transactionType),
      ]
    ];

    if (startDate != null && endDate != null) {
      // Convert to UTC to match database timezone
      final utcStartDate = startDate.toUtc();
      final utcEndDate = endDate.toUtc().add(const Duration(days: 1));

      talker.info(
          'Date Range: ${utcStartDate.toIso8601String()} to ${utcEndDate.toIso8601String()}');

      conditions.add(
        Where('lastTouched').isGreaterThanOrEqualTo(
          utcStartDate.toIso8601String(),
        ),
      );
      conditions.add(
        Where('lastTouched').isLessThanOrEqualTo(
          utcEndDate.toIso8601String(),
        ),
      );
    }

    // Add ordering to fetch transactions with latest lastTouched first (for consistency)
    final queryString = Query(
      where: conditions,
      orderBy: [OrderBy('lastTouched', ascending: false)],
    );

    // When fetchRemote is true, we need to ensure we're using alwaysHydrate policy
    // to force fetching fresh data from the remote source
    if (ProxyService.box.enableDebug() ?? false) {
      return DummyTransactionGenerator.generateDummyTransactions(
        count: 100,
        branchId:
            branchId ?? 0, // Provide a default or handle null appropriately
        status: status,
        transactionType: transactionType,
      );
    }
    final result = await repository.get<ITransaction>(
      policy: fetchRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.localOnly,
      query: queryString,
    );

    return result;
  }

  @override
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
  }) async {
    // Step 1: Fetch transactions using the same logic as the transactions() method
    final transactionss = await transactions(
      startDate: startDate,
      endDate: endDate,
      status: status,
      transactionType: transactionType,
      branchId: branchId,
      isCashOut: isCashOut,
      fetchRemote: fetchRemote,
      id: id,
      isExpense: isExpense,
      filterType: filterType,
      includeZeroSubTotal: includeZeroSubTotal,
      includePending: includePending,
      skipOriginalTransactionCheck: skipOriginalTransactionCheck,
    );
    if (transactionss.isEmpty) return [];

    // Step 2: Fetch all items for these transactions in one batch
    final List<String> transactionIds = transactionss
        .map((t) => t.id) // t.id is non-nullable String
        .where((id) => id.isNotEmpty) // Only check for isNotEmpty
        .toSet() // Remove duplicates
        .toList(); // Convert the Set back to a List

    List<TransactionItem> items = []; // Default to empty list

    if (transactionIds.isNotEmpty) {
      // Construct the list of OR conditions for transaction IDs
      final List<WhereCondition> orConditions = transactionIds.map((id) {
        // Each Where condition for an ID is optional (OR'd with the next)
        return Where('transactionId',
            value: id, compare: Compare.exact, isRequired: false);
      }).toList();

      // Create a WherePhrase to group these OR conditions.
      // This phrase itself is required for the query.
      final WherePhrase transactionIdInPhrase =
          WherePhrase(orConditions, isRequired: true);

      items = await repository.get<TransactionItem>(
        policy: fetchRemote
            ? OfflineFirstGetPolicy.awaitRemoteWhenNoneExist
            : OfflineFirstGetPolicy.localOnly,
        query: Query(where: [transactionIdInPhrase]),
      );
    }

    // Step 3: Map items to their transactions
    final Map<String, List<TransactionItem>> itemsByTransactionId = {};
    for (final item in items) {
      final tid = item.transactionId;
      if (tid == null) continue;
      itemsByTransactionId.putIfAbsent(tid, () => []).add(item);
    }

    // Step 4: Build the result list, skipping transactions with no items
    final List<TransactionWithItems> result = [];
    for (final t in transactionss) {
      final List<TransactionItem>? transactionSpecificItems =
          itemsByTransactionId[t.id];
      // Only include the transaction if it has associated items
      if (transactionSpecificItems != null &&
          transactionSpecificItems.isNotEmpty) {
        result.add(TransactionWithItems(
          transaction: t,
          items: transactionSpecificItems,
        ));
      }
    }
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
    required String status,
    String? shiftId,
  }) async {
    try {
      // Base query to find PENDING transactions matching the criteria
      final baseWhere = [
        Where('branchId').isExactly(branchId),
        Where('isExpense').isExactly(isExpense),
        Where('status').isExactly(status),
        Where('transactionType').isExactly(transactionType),
        if (shiftId != null) Where('shiftId').isExactly(shiftId),
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
    String status = PENDING,
    bool includeSubTotalCheck = false,
    String? shiftId,
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
          status: status,
          shiftId: shiftId,
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
          receiptType: getReceiptType(),
          customerChangeDue: 0.0,
          paymentType: ProxyService.box.paymentType() ?? "CASH",
          branchId: branchId,
          createdAt: now,
          shiftId: shiftId,
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

  String getReceiptType() {
    if (ProxyService.box.isProformaMode()) {
      return "PS";
    } else if (ProxyService.box.isTrainingMode()) {
      return "TS";
    } else {
      return "NS";
    }
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
      status: PENDING,
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

      // Re-fetch the transaction to ensure it has its brick_id populated
      final committedTransaction = (await repository.get<ITransaction>(
        query: Query(where: [Where('id').isExactly(transaction.id)]),
        policy: OfflineFirstGetPolicy.localOnly,
      ))
          .firstOrNull;

      if (committedTransaction == null) {
        throw Exception(
            'Failed to retrieve committed ITransaction after upsert.');
      }
      transaction = committedTransaction; // Use the committed version

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
        status: PENDING,
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
  Future<ITransaction> assignTransaction({
    required Variant variant,
    required ITransaction pendingTransaction,
    required Business business,
    required int randomNumber,
    int? invoiceNumber,
    required String sarTyCd,
    Purchase? purchase,
    required bool doneWithTransaction,
    double? updatableQty,
    bool ignoreForReport = false,

    /// usualy the flag useTransactionItemForQty is needed when we are dealing with adjustment
    /// transaction i.e not original transaction
    bool useTransactionItemForQty = false,
    TransactionItem? item,
  }) async {
    try {
      // Save the transaction item
      await saveTransactionItem(
        variation: variant,
        ignoreForReport: ignoreForReport,
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
      return await _parkTransaction(
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
  Future<ITransaction> _parkTransaction({
    required ITransaction pendingTransaction,
    required Variant variant,
    required dynamic business,
    required int randomNumber,
    required String sarTyCd,
    Purchase? purchase,
    int? invoiceNumber,
    double? updatableQty,
  }) async {
    final effectiveInvoiceNumber = purchase?.spplrInvcNo ?? invoiceNumber;

    final transaction = await updateTransaction(
      transaction: pendingTransaction,
      status: PARKED,
      taxAmount: pendingTransaction.taxAmount ?? 0,
      sarNo: effectiveInvoiceNumber?.toString(),
      orgSarNo: effectiveInvoiceNumber?.toString(),
      sarTyCd: sarTyCd,
      receiptNumber: randomNumber,
      reference: randomNumber.toString(),
      invoiceNumber:
          invoiceNumber, // Optional: still pass the original int if needed
      receiptType: TransactionType.adjustment,
      customerTin: pendingTransaction.customerTin,
      customerBhfId: await ProxyService.box.bhfId() ?? "00",
      subTotal: pendingTransaction.subTotal! > 0
          ? pendingTransaction.subTotal!
          : (variant.retailPrice! * (updatableQty ?? 1)),
      cashReceived: -(pendingTransaction.subTotal! > 0
          ? pendingTransaction.subTotal!
          : (variant.retailPrice! * (updatableQty ?? 1))),
      customerName: business.name,
    );

    return transaction;
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
      int? invoiceNumber,
      TransactionItem? item,
      double? updatableQty,
      String? sarTyCd,
      required bool ignoreForReport}) async {
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
        ignoreForReport: ignoreForReport,
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

  @override
  FutureOr<void> addTransaction({required ITransaction transaction}) {
    repository.upsert(transaction);
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
      double? updatableQty,
      required bool ignoreForReport}) async {
    try {
      // Update existing item if found and not custom
      if (item != null && !isCustom) {
        await _updateExistingTransactionItem(
          item: item,
          ignoreForReport: ignoreForReport,

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
        ignoreForReport: false,
        lastTouched: DateTime.now().toUtc(),
        discount: 0.0,
        compositePrice: partOfComposite ? compositePrice ?? 0.0 : 0.0,
        quantity: updatableQty != null
            ? updatableQty.toDouble()
            : sarTyCd == null
                ? quantity.toDouble()
                : sarQty.toDouble(),
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
    required bool ignoreForReport,
  }) async {
    await ProxyService.strategy.updateTransactionItem(
      transactionItemId: item.id,
      ignoreForReport: ignoreForReport,
      doneWithTransaction: false,
      qty: quantity,
      taxblAmt: variation.retailPrice! * quantity,
      price: variation.retailPrice!,
      totAmt: variation.retailPrice! * quantity,
      prc: item.prc + variation.retailPrice! * quantity,
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
      required bool ignoreForReport,
      bool isDoneWithTransaction = false}) async {
    if (inactiveItems.isNotEmpty) {
      for (TransactionItem inactiveItem in inactiveItems) {
        inactiveItem.active = true;
        if (isDoneWithTransaction) {
          await ProxyService.strategy.updateTransactionItem(
            transactionItemId: inactiveItem.id,
            ignoreForReport: ignoreForReport,
            doneWithTransaction: true,
          );
        }
      }
    }
  }

  Future<void> updatePendingTransactionTotals(ITransaction pendingTransaction,
      {required String sarTyCd}) async {
    DateTime newUpdatedAt = DateTime.now();
    DateTime newLastTouched = DateTime.now();

    // Check if we're already in a write transaction
    await repository.upsert<ITransaction>(pendingTransaction.copyWith(
      updatedAt: newUpdatedAt,
      lastTouched: newLastTouched,
      receiptType: "NS",
      sarTyCd: sarTyCd,
    ));
  }

  /// Updates a transaction with the provided details.
  ///
  /// The [transaction] parameter is required and represents the transaction to update.
  /// The [isUnclassfied] parameter is used to mark the transaction as unclassified,
  /// meaning it is neither income nor expense. This helps avoid incorrect computations
  /// on the dashboard.
  @override
  FutureOr<ITransaction> updateTransaction({
    ITransaction? transaction,
    num taxAmount = 0.0,
    String? receiptType,
    double? subTotal,
    String? note,
    String? status,
    String? customerId,
    String? transactionId,
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
      if (transactionId == null) {
        throw ArgumentError(
            "Transaction and transactionId are both null in updateTransaction."); // Exit if transaction is null.
      }
      transaction = await getTransaction(
          id: transactionId, branchId: ProxyService.box.getBranchId()!);
      if (transaction == null) {
        throw ArgumentError("Transaction with ID $transactionId not found.");
      }
    }

    // Determine receipt type based on mode (or use the provided value if available)
    receiptType = isProformaMode == true
        ? TransactionReceptType.PS
        : isTrainingMode == true
            ? TransactionReceptType.TS
            : receiptType;

    // update to avoid the same issue, make sure that every parameter is update correctly.
    transaction.receiptType = receiptType ?? transaction.receiptType;
    transaction.subTotal = subTotal ?? transaction.subTotal;
    transaction.note = note ?? transaction.note;
    transaction.supplierId = supplierId ?? transaction.supplierId;
    transaction.status = status ?? transaction.status;
    transaction.ticketName = ticketName ?? transaction.ticketName;
    transaction.taxAmount = taxAmount;
    transaction.updatedAt = updatedAt ?? transaction.updatedAt;
    transaction.customerId = customerId ?? transaction.customerId;
    transaction.isRefunded = isRefunded ?? transaction.isRefunded;
    transaction.ebmSynced = ebmSynced ?? transaction.ebmSynced;
    transaction.sarNo = sarNo ?? transaction.sarNo;
    transaction.orgSarNo = orgSarNo ?? transaction.orgSarNo;
    if (receiptType != "NR" && receiptType != "CR" && receiptType != "TR") {
      transaction.invoiceNumber = invoiceNumber ?? transaction.invoiceNumber;
    }
    transaction.receiptNumber = receiptNumber ?? transaction.receiptNumber;
    transaction.totalReceiptNumber =
        totalReceiptNumber ?? transaction.totalReceiptNumber;
    transaction.sarTyCd = sarTyCd ?? transaction.sarTyCd;
    transaction.reference = reference ?? transaction.reference;
    // transaction.receiptFileName = transaction.receiptFileName;
    transaction.customerTin = customerTin ?? transaction.customerTin;
    transaction.customerBhfId = customerBhfId ?? transaction.customerBhfId;
    transaction.cashReceived = cashReceived ?? transaction.cashReceived;
    transaction.customerName = customerName ?? transaction.customerName;
    transaction.lastTouched = lastTouched ?? transaction.lastTouched;
    transaction.isExpense = isUnclassfied ? null : transaction.isExpense;
    transaction.isIncome = isUnclassfied ? null : transaction.isIncome;

    final result = await repository.upsert<ITransaction>(transaction);
    return result;
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
    bool forceRealData = true,
    required bool skipOriginalTransactionCheck,
  }) {
    if (!forceRealData) {
      return Stream.value(DummyTransactionGenerator.generateDummyTransactions(
        count: 100,
        branchId: branchId ?? 1,
        status: status,
        transactionType: transactionType,
      ));
    }
    final List<Where> conditions = [
      Where('status').isExactly(status ?? COMPLETE),
      Where('subTotal').isGreaterThan(0),
      if (skipOriginalTransactionCheck == false)
        Where('isOriginalTransaction').isExactly(true),
      if (id != null) Where('id').isExactly(id),
      if (branchId != null) Where('branchId').isExactly(branchId),
      if (isCashOut) Where('isExpense').isExactly(isCashOut),
      if (removeAdjustmentTransactions)
        Where('transactionType').isNot('Adjustment'),
      if (removeAdjustmentTransactions)
        Where('transactionType').isNot('adjustment'),
    ];
    // talker.warning(conditions.toString());
    // Handle date filtering with proper support for single date scenarios
    if (startDate != null || endDate != null) {
      // Case 1: Both dates provided (date range)
      if (startDate != null && endDate != null) {
        // Convert to UTC to match database timezone
        final utcStartDate = startDate.toUtc();
        final utcEndDate = endDate.toUtc().add(const Duration(days: 1));

        talker.info(
            'Transaction Date Range: \x1B[35m${utcStartDate.toIso8601String()} to ${utcEndDate.toIso8601String()}\x1B[0m');

        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            utcStartDate.toIso8601String(),
          ),
        );
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            utcEndDate.toIso8601String(),
          ),
        );
      }
      // Case 2: Only startDate provided (everything from this date onwards)
      else if (startDate != null) {
        final utcStartDate = startDate.toUtc();
        talker.info(
            'Transactions From Date: \x1B[35m${utcStartDate.toIso8601String()}\x1B[0m onwards');
        conditions.add(
          Where('lastTouched').isGreaterThanOrEqualTo(
            utcStartDate.toIso8601String(),
          ),
        );
      }
      // Case 3: Only endDate provided (everything up to this date)
      else if (endDate != null) {
        final utcEndDate = endDate.toUtc().add(const Duration(days: 1));
        talker.info(
            'Transactions Until Date: \x1B[35m${utcEndDate.toIso8601String()}\x1B[0m');
        conditions.add(
          Where('lastTouched').isLessThanOrEqualTo(
            utcEndDate.toIso8601String(),
          ),
        );
      }
    }
    final queryString = Query(
        // limit: 5000,
        where: conditions,
        orderBy: [OrderBy('lastTouched', ascending: false)]);
    if (ProxyService.box.enableDebug() ?? false) {
      return Stream.value(DummyTransactionGenerator.generateDummyTransactions(
        count: 100,
        branchId:
            branchId ?? 0, // Provide a default or handle null appropriately
        status: status,
        transactionType: transactionType,
      ));
    }
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
    return true;
  }

  @override
  Future<ITransaction?> pendingTransactionFuture(
      {int? branchId,
      required String transactionType,
      bool forceRealData = true,
      required bool isExpense}) async {
    if (!forceRealData) {
      return DummyTransactionGenerator.generateDummyTransactions(
        count: 1,
        branchId: branchId ?? 1,
        status: PENDING,
        transactionType: transactionType,
      ).firstOrNull;
    }
    return (await repository.get<ITransaction>(
      query: Query(where: [
        Where('isExpense').isExactly(isExpense),
        Where('transactionType').isExactly(transactionType),
        Where('status').isExactly(PENDING),
        if (branchId != null) Where('branchId').isExactly(branchId),
      ]),
    ))
        .firstOrNull;
  }

  @override
  Future<Sar?> getSar({required int branchId}) async {
    return (await repository.get<Sar>(
      query: Query(orderBy: [
        const OrderBy('createdAt', ascending: false)
      ], where: [
        Where('branchId').isExactly(branchId),
      ]),
    ))
        .firstOrNull;
  }
}
