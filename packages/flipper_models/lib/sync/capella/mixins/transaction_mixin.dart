import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/models/transaction_with_items.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/utils/test_data/dummy_transaction_generator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaTransactionMixin implements TransactionInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    String? branchId,
    bool isCashOut = false,
    String? id,
    required bool removeAdjustmentTransactions,
    FilterType? filterType,
    bool includePending = false,
    DateTime? startDate,
    DateTime? endDate,
    bool forceRealData = true,
    bool includeParked = false,
    required bool skipOriginalTransactionCheck,
  }) {
    if (!forceRealData) {
      return Stream.value(DummyTransactionGenerator.generateDummyTransactions(
        count: 100,
        branchId: branchId ?? "1",
        status: status,
        transactionType: transactionType,
      ));
    }

    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:13');
        return Stream.value([]);
      }

      ditto.sync.registerSubscription(
        "SELECT * FROM transactions WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM transactions WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );

      // Build SQL WHERE clause conditions
      final List<String> whereClauses = [];
      final Map<String, dynamic> arguments = {};

      // Add agentId filter
      final agentId = ProxyService.box.getUserId()!;
      whereClauses.add('agentId = :agentId');
      arguments['agentId'] = agentId;
      if (includePending && includeParked) {
        whereClauses.add(
            '(status = :status OR status = :pendingStatus OR status = :parkedStatus)');
        arguments['status'] = status ?? COMPLETE;
        arguments['pendingStatus'] = PENDING;
        arguments['parkedStatus'] = PARKED;
      } else if (includePending) {
        // Include both COMPLETE and PENDING statuses
        whereClauses.add('(status = :status OR status = :pendingStatus)');
        arguments['status'] = status ?? COMPLETE;
        arguments['pendingStatus'] = PENDING;
      } else if (includeParked) {
        // Include both COMPLETE and PARKED statuses
        whereClauses.add('(status = :status OR status = :parkedStatus)');
        arguments['status'] = status ?? COMPLETE;
        arguments['parkedStatus'] = PARKED;
      } else {
        // Only include the specified status (default COMPLETE)
        whereClauses.add('status = :status');
        arguments['status'] = status ?? COMPLETE;
      }

      // SubTotal filter
      whereClauses.add('subTotal > 0');

      // Original transaction check
      if (!skipOriginalTransactionCheck) {
        whereClauses.add('isOriginalTransaction = :isOriginal');
        arguments['isOriginal'] = true;
      }

      // ID filter
      if (id != null) {
        whereClauses.add('_id = :id');
        arguments['id'] = id;
      }

      // Branch ID filter
      if (branchId != null) {
        whereClauses.add('branchId = :branchId');
        arguments['branchId'] = branchId;
      }

      // Cash out / expense filter
      if (isCashOut) {
        whereClauses.add('isExpense = :isExpense');
        arguments['isExpense'] = true;
      }

      // Remove adjustment transactions
      if (removeAdjustmentTransactions) {
        whereClauses.add('transactionType != :adjustmentType');
        arguments['adjustmentType'] = 'Adjustment';
      }

      // Transaction type filter
      if (transactionType != null) {
        whereClauses.add('transactionType = :transactionType');
        arguments['transactionType'] = transactionType;
      }

      // Filter type handling (maps to 'type' field in database)
      if (filterType != null) {
        whereClauses.add('type = :filterType');
        arguments['filterType'] = filterType.name;
      }

      // Date filtering
      if (startDate != null && endDate != null) {
        final localStartDate =
            DateTime(startDate.year, startDate.month, startDate.day);
        final localEndDate =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
        whereClauses
            .add('lastTouched >= :startDate AND lastTouched <= :endDate');
        arguments['startDate'] = localStartDate.toIso8601String();
        arguments['endDate'] = localEndDate.toIso8601String();
      } else if (startDate != null) {
        final localStartDate =
            DateTime(startDate.year, startDate.month, startDate.day);
        whereClauses.add('lastTouched >= :startDate');
        arguments['startDate'] = localStartDate.toIso8601String();
      } else if (endDate != null) {
        final localEndDate =
            DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
        whereClauses.add('lastTouched <= :endDate');
        arguments['endDate'] = localEndDate.toIso8601String();
      }

      final whereClause = whereClauses.join(' AND ');
      final query =
          'SELECT * FROM transactions WHERE $whereClause ORDER BY lastTouched DESC';

      talker.info('Capella Ditto Query: $query');
      talker.info('Capella Ditto Arguments: $arguments');

      final controller = StreamController<List<ITransaction>>.broadcast();
      dynamic observer;

      observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) {
          if (controller.isClosed) return;

          final transactions = <ITransaction>[];
          for (final item in queryResult.items) {
            try {
              final transactionData = Map<String, dynamic>.from(item.value);
              final transaction = _convertFromDittoDocument(transactionData);
              transactions.add(transaction);
            } catch (e) {
              talker.error('Error converting transaction: $e');
            }
          }

          talker.info(
              'Capella Transaction stream returned: ${transactions.length} records');
          controller.add(transactions);
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error in transactionsStream: $e');
      return Stream.value([]);
    }
  }

  /// Convert Ditto document to ITransaction model
  ITransaction _convertFromDittoDocument(Map<String, dynamic> data) {
    DateTime? parseDateTime(dynamic value) {
      if (value == null) return null;
      if (value is String) return DateTime.parse(value);
      if (value is DateTime) return value;
      return null;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return null;
    }

    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == 'true';
      return null;
    }

    return ITransaction(
      agentId: ProxyService.box.getUserId()!,
      id: data['_id'] ?? data['id'],
      reference: data['reference'],
      categoryId: data['categoryId'],
      transactionNumber: data['transactionNumber'],
      branchId: data['branchId'],
      status: data['status'],
      transactionType: data['transactionType'],
      subTotal: parseDouble(data['subTotal']),
      paymentType: data['paymentType'],
      cashReceived: parseDouble(data['cashReceived']),
      customerChangeDue: parseDouble(data['customerChangeDue']),
      createdAt: parseDateTime(data['createdAt']),
      receiptType: data['receiptType'],
      updatedAt: parseDateTime(data['updatedAt']),
      customerId: data['customerId'],
      customerType: data['customerType'],
      note: data['note'],
      lastTouched: parseDateTime(data['lastTouched']),
      supplierId: parseInt(data['supplierId']),
      ebmSynced: parseBool(data['ebmSynced']),
      isIncome: parseBool(data['isIncome']),
      isExpense: parseBool(data['isExpense']),
      isRefunded: parseBool(data['isRefunded']),
      customerName: data['customerName'],
      customerTin: data['customerTin'],
      remark: data['remark'],
      customerBhfId: data['customerBhfId'],
      sarTyCd: data['sarTyCd'],
      receiptNumber: parseInt(data['receiptNumber']),
      totalReceiptNumber: parseInt(data['totalReceiptNumber']),
      invoiceNumber: parseInt(data['invoiceNumber']),
      isDigitalReceiptGenerated: parseBool(data['isDigitalReceiptGenerated']),
      receiptPrinted: parseBool(data['receiptPrinted']),
      receiptFileName: data['receiptFileName'],
      currentSaleCustomerPhoneNumber: data['currentSaleCustomerPhoneNumber'],
      sarNo: data['sarNo'],
      orgSarNo: data['orgSarNo'],
      shiftId: data['shiftId'],
      isLoan: parseBool(data['isLoan']),
      dueDate: parseDateTime(data['dueDate']),
      isAutoBilled: parseBool(data['isAutoBilled']),
      nextBillingDate: parseDateTime(data['nextBillingDate']),
      billingFrequency: data['billingFrequency'],
      billingAmount: parseDouble(data['billingAmount'])?.toDouble(),
      totalInstallments: parseInt(data['totalInstallments']),
      paidInstallments: parseInt(data['paidInstallments']),
      lastBilledDate: parseDateTime(data['lastBilledDate']),
      originalLoanAmount: parseDouble(data['originalLoanAmount'])?.toDouble(),
      remainingBalance: parseDouble(data['remainingBalance'])?.toDouble(),
      lastPaymentDate: parseDateTime(data['lastPaymentDate']),
      lastPaymentAmount: parseDouble(data['lastPaymentAmount'])?.toDouble(),
      originalTransactionId: data['originalTransactionId'],
      isOriginalTransaction: parseBool(data['isOriginalTransaction']),
      taxAmount: parseDouble(data['taxAmount'])?.toDouble(),
      numberOfItems: parseInt(data['numberOfItems']),
      discountAmount: parseDouble(data['discountAmount'])?.toDouble(),
      customerPhone: data['customerPhone'],
      ticketName: data['ticketName'],
    );
  }

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
    String? branchId,
    bool isExpense = false,
    bool forceRealData = true,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool skipOriginalTransactionCheck = false,
    List<String>? receiptNumber,
    String? customerId,
    String? agentId,
  }) async {
    if (!forceRealData) {
      return DummyTransactionGenerator.generateDummyTransactions(
        count: 100,
        branchId: branchId ?? "1",
        status: status,
        transactionType: transactionType,
      );
    }

    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:14');
        return [];
      }

      ditto.sync.registerSubscription(
        "SELECT * FROM transactions WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );
      ditto.store.registerObserver(
        "SELECT * FROM transactions WHERE branchId = :branchId",
        arguments: {'branchId': branchId},
      );

      // Build SQL WHERE clause conditions
      final List<String> whereClauses = [];
      final Map<String, dynamic> arguments = {};

      // ID filter (highest priority)
      if (id != null) {
        whereClauses.add('_id = :id');
        arguments['id'] = id;
      } else {
        // Status filter - conditional based on includePending
        if (includePending) {
          whereClauses.add('(status = :status OR status = :pendingStatus)');
          arguments['status'] = status ?? COMPLETE;
          arguments['pendingStatus'] = PENDING;
        } else {
          whereClauses.add('status = :status');
          arguments['status'] = status ?? COMPLETE;
        }

        // SubTotal filter
        if (!includeZeroSubTotal) {
          whereClauses.add('subTotal > 0');
        }

        // Original transaction check
        if (!skipOriginalTransactionCheck) {
          whereClauses.add('isOriginalTransaction = :isOriginal');
          arguments['isOriginal'] = true;
        }

        // Branch ID filter
        if (branchId != null) {
          whereClauses.add('branchId = :branchId');
          arguments['branchId'] = branchId;
        }

        // Cash out / expense filter
        if (isCashOut || isExpense) {
          whereClauses.add('isExpense = :isExpense');
          arguments['isExpense'] = true;
        }

        // Transaction type filter
        if (transactionType != null) {
          whereClauses.add('transactionType = :transactionType');
          arguments['transactionType'] = transactionType;
        }

        // Filter type handling
        if (filterType != null) {
          whereClauses.add('type = :filterType');
          arguments['filterType'] = filterType.name;
        }

        // Customer ID filter
        if (customerId != null) {
          whereClauses.add('customerId = :customerId');
          arguments['customerId'] = customerId;
        }

        // Agent ID filter
        if (agentId != null) {
          whereClauses.add('agentId = :agentId');
          arguments['agentId'] = agentId;
        }

        // Receipt number filter - check both invoiceNumber OR receiptNumber
        if (receiptNumber != null && receiptNumber.isNotEmpty) {
          final receiptPlaceholders = receiptNumber
              .asMap()
              .entries
              .map((e) => ':receipt${e.key}')
              .join(', ');
          final invoicePlaceholders = receiptNumber
              .asMap()
              .entries
              .map((e) => ':invoice${e.key}')
              .join(', ');

          // Match either invoiceNumber OR receiptNumber
          whereClauses.add(
              '(invoiceNumber IN ($invoicePlaceholders) OR receiptNumber IN ($receiptPlaceholders))');

          // Bind values for both placeholders
          for (var i = 0; i < receiptNumber.length; i++) {
            arguments['receipt$i'] = receiptNumber[i];
            arguments['invoice$i'] = receiptNumber[i];
          }
        }

        // Date filtering
        if (startDate != null && endDate != null) {
          final localStartDate =
              DateTime(startDate.year, startDate.month, startDate.day);
          final localEndDate = DateTime(
              endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
          whereClauses
              .add('lastTouched >= :startDate AND lastTouched <= :endDate');
          arguments['startDate'] = localStartDate.toIso8601String();
          arguments['endDate'] = localEndDate.toIso8601String();
        } else if (startDate != null) {
          final localStartDate =
              DateTime(startDate.year, startDate.month, startDate.day);
          whereClauses.add('lastTouched >= :startDate');
          arguments['startDate'] = localStartDate.toIso8601String();
        } else if (endDate != null) {
          final localEndDate = DateTime(
              endDate.year, endDate.month, endDate.day, 23, 59, 59, 999);
          whereClauses.add('lastTouched <= :endDate');
          arguments['endDate'] = localEndDate.toIso8601String();
        }
      }

      final whereClause = whereClauses.join(' AND ');
      final query =
          'SELECT * FROM transactions WHERE $whereClause ORDER BY lastTouched DESC';

      talker.info('Capella Ditto Query (transactions): $query');
      talker.info('Capella Ditto Arguments: $arguments');

      // Execute the query
      final queryResult = await ditto.store.execute(
        query,
        arguments: arguments,
      );

      // Convert results to ITransaction list
      final transactions = <ITransaction>[];
      for (final item in queryResult.items) {
        try {
          final transactionData = Map<String, dynamic>.from(item.value);
          final transaction = _convertFromDittoDocument(transactionData);
          transactions.add(transaction);
        } catch (e) {
          talker.error('Error converting transaction: $e');
        }
      }

      talker.info(
          'Capella transactions() returned: ${transactions.length} records');
      return transactions;
    } catch (e, stackTrace) {
      talker.error('Error in transactions(): $e', stackTrace);
      return [];
    }
  }

  @override
  FutureOr<void> addTransaction({required ITransaction transaction}) {
    throw UnimplementedError(
        'addTransaction needs to be implemented for Capella');
  }

  @override
  Future<List<Configurations>> taxes({required String branchId}) async {
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
    required String branchId,
    String? shiftId,
    String status = PENDING,
    bool includeSubTotalCheck = false,
  }) async {
    throw UnimplementedError(
        'manageTransaction needs to be implemented for Capella');
  }

  @override
  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required String branchId,
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
  Future<ITransaction> assignTransaction({
    required Variant variant,
    required ITransaction pendingTransaction,
    Purchase? purchase,
    double? updatableQty,
    int? invoiceNumber,
    required bool doneWithTransaction,
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
      int? invoiceNumber,
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
  Future<void> updateTransaction({
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
    bool? receiptPrinted,
    bool isUnclassfied = false,
    bool? isTrainingMode,
    String? transactionId,
    String? customerPhone,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for updateTransaction');
      return;
    }

    final targetId = transaction?.id ?? transactionId;
    if (targetId == null) {
      talker.error('No transaction ID provided for update');
      return;
    }

    final Map<String, dynamic> arguments = {'id': targetId};
    final List<String> updates = [];

    void addUpdate(String field, dynamic value) {
      if (value != null) {
        updates.add('$field = :$field');
        if (value is DateTime) {
          arguments[field] = value.toIso8601String();
        } else {
          arguments[field] = value;
        }
      }
    }

    addUpdate('status', status ?? transaction?.status);
    addUpdate('subTotal', subTotal ?? transaction?.subTotal);
    addUpdate(
        'updatedAt', updatedAt ?? transaction?.updatedAt ?? DateTime.now());
    addUpdate('lastTouched',
        lastTouched ?? transaction?.lastTouched ?? DateTime.now());
    addUpdate('cashReceived', cashReceived ?? transaction?.cashReceived);
    addUpdate('customerPhone', customerPhone ?? transaction?.customerPhone);
    addUpdate('note', note ?? transaction?.note);
    addUpdate('customerId', customerId ?? transaction?.customerId);
    addUpdate('ticketName', ticketName ?? transaction?.ticketName);

    // Crucial for resumption: update agentId if transaction object is provided
    if (transaction != null) {
      addUpdate('agentId', transaction.agentId);
      addUpdate('isLoan', transaction.isLoan);
      addUpdate('remainingBalance', transaction.remainingBalance);
    }

    if (receiptType != null) addUpdate('receiptType', receiptType);
    if (ebmSynced != null) addUpdate('ebmSynced', ebmSynced);
    if (sarTyCd != null) addUpdate('sarTyCd', sarTyCd);
    if (reference != null) addUpdate('reference', reference);
    if (customerTin != null) addUpdate('customerTin', customerTin);
    if (customerBhfId != null) addUpdate('customerBhfId', customerBhfId);
    if (isRefunded != null) addUpdate('isRefunded', isRefunded);
    if (customerName != null) addUpdate('customerName', customerName);
    if (invoiceNumber != null) addUpdate('invoiceNumber', invoiceNumber);
    if (supplierId != null) addUpdate('supplierId', supplierId);
    if (receiptNumber != null) addUpdate('receiptNumber', receiptNumber);
    if (totalReceiptNumber != null)
      addUpdate('totalReceiptNumber', totalReceiptNumber);
    if (isProformaMode != null) addUpdate('isProformaMode', isProformaMode);
    if (sarNo != null) addUpdate('sarNo', sarNo);
    if (orgSarNo != null) addUpdate('orgSarNo', orgSarNo);
    if (receiptPrinted != null) addUpdate('receiptPrinted', receiptPrinted);
    if (isUnclassfied) addUpdate('isUnclassfied', isUnclassfied);
    if (isTrainingMode != null) addUpdate('isTrainingMode', isTrainingMode);

    if (updates.isEmpty) return;

    final query =
        'UPDATE transactions SET ${updates.join(', ')} WHERE _id = :id OR id = :id';

    try {
      await ditto.store.execute(query, arguments: arguments);
      talker
          .info('Updated transaction $targetId with ${updates.length} fields');
    } catch (e) {
      talker.error('Error updating transaction: $e');
      rethrow;
    }
  }

  @override
  Future<ITransaction?> getTransaction(
      {String? sarNo,
      required String branchId,
      String? id,
      bool awaitRemote = false}) {
    throw UnimplementedError(
        'getTransaction needs to be implemented for Capella');
  }

  @override
  Future<bool> deleteTransaction({required ITransaction transaction}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for deleteTransaction');
        return false;
      }

      // Prevent deleting tickets or transactions with partial payments
      if (transaction.ticketName != null &&
          transaction.ticketName!.isNotEmpty) {
        talker.warning(
            'Attempted to delete a parked transaction (ticket): ${transaction.id}');
        return false;
      }
      if ((transaction.cashReceived ?? 0) > 0) {
        talker.warning(
            'Attempted to delete a transaction with partial payments: ${transaction.id}');
        return false;
      }

      // Delete the transaction
      await ditto.store.execute(
        'DELETE FROM transactions WHERE _id = :id OR id = :id',
        arguments: {'id': transaction.id},
      );

      // Delete related items
      await ditto.store.execute(
        'DELETE FROM transaction_items WHERE transactionId = :id',
        arguments: {'id': transaction.id},
      );

      talker.info(
          'Successfully deleted transaction and items: ${transaction.id}');
      return true;
    } catch (e) {
      talker.error('Error deleting transaction: $e');
      return false;
    }
  }

  @override
  Future<bool> migrateToNewDateTime({required String branchId}) async {
    // TODO: implement migrateToNewDateTime
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> pendingTransactionFuture(
      {String? branchId,
      required String transactionType,
      bool forceRealData = true,
      required bool isExpense}) {
    throw UnimplementedError(
        'pendingTransactionFuture needs to be implemented for Capella');
  }

  @override
  Future<List<TransactionWithItems>> transactionsAndItems({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    String? branchId,
    bool isCashOut = false,
    bool fetchRemote = false,
    String? id,
    bool isExpense = false,
    FilterType? filterType,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool skipOriginalTransactionCheck = false,
  }) async {
    throw UnimplementedError(
        'transactions needs to be implemented for Capella');
  }

  @override
  Future<Sar> getSar({required String branchId}) async {
    throw UnimplementedError('getSar needs to be implemented for Capella');
  }

  @override
  Future<double?> getTotalPaidForTransaction({
    required String transactionId,
    required String branchId,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for getTotalPaidForTransaction');
        throw Exception('Ditto not initialized for getTotalPaidForTransaction');
      }

      final query =
          'SELECT * FROM transaction_payment_records WHERE transactionId = :transactionId';
      final arguments = {'transactionId': transactionId};

      final queryResult =
          await ditto.store.execute(query, arguments: arguments);

      if (queryResult.items.isEmpty) {
        return 0.0;
      }

      double total = 0.0;
      for (final item in queryResult.items) {
        final data = Map<String, dynamic>.from(item.value);
        final amount = data['amount'];
        if (amount != null) {
          if (amount is num) {
            total += amount.toDouble();
          } else if (amount is String) {
            total += double.tryParse(amount) ?? 0.0;
          }
        }
      }

      talker.info('Total paid for transaction $transactionId: $total');
      return total;
    } catch (e, s) {
      talker.error('Error getting total paid for transaction: $e', s);
      throw Exception('Failed to get total paid: $e');
    }
  }

  @override
  FutureOr<void> deletePaymentRecords({required String transactionId}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for deletePaymentRecords');
        return;
      }

      await ditto.store.execute(
        'DELETE FROM transaction_payment_records WHERE transactionId = :transactionId',
        arguments: {'transactionId': transactionId},
      );

      talker.info('Deleted payment records for transaction $transactionId');
    } catch (e, s) {
      talker.error('Error deleting payment records: $e', s);
    }
  }

  @override
  Stream<ITransaction> pendingTransaction({
    String? branchId,
    required String transactionType,
    required bool isExpense,
    bool forceRealData = true,
  }) {
    throw UnimplementedError(
        'pendingTransaction needs to be implemented for Capella');
  }

  @override
  Future<void> mergeTransactions({
    required ITransaction from,
    required ITransaction to,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for mergeTransactions');
      return;
    }

    if (from.id == to.id) return;

    try {
      // Move items
      await ditto.store.execute(
        'UPDATE transaction_items SET transactionId = :toId WHERE transactionId = :fromId',
        arguments: {'toId': to.id, 'fromId': from.id},
      );

      // Move payment records
      await ditto.store.execute(
        'UPDATE transaction_payment_records SET transactionId = :toId WHERE transactionId = :fromId',
        arguments: {'toId': to.id, 'fromId': from.id},
      );

      // Recalculate subTotal and cashReceived for 'to'
      final totalPaid = await getTotalPaidForTransaction(
        transactionId: to.id,
        branchId: to.branchId!,
      );

      // Get items for toId to calculate subTotal
      final itemsQueryResult = await ditto.store.execute(
        'SELECT * FROM transaction_items WHERE transactionId = :toId',
        arguments: {'toId': to.id},
      );

      double newSubTotal = 0.0;
      for (final item in itemsQueryResult.items) {
        final data = Map<String, dynamic>.from(item.value);
        final price = data['price'] ?? 0.0;
        final qty = data['qty'] ?? 0.0;
        newSubTotal += (data['totAmt'] ?? (price * qty)) ?? 0.0;
      }

      await updateTransaction(
        transaction: to,
        subTotal: newSubTotal,
        cashReceived: totalPaid,
        updatedAt: DateTime.now(),
        lastTouched: DateTime.now(),
      );

      // Delete 'from'
      await deleteTransaction(transaction: from);
      talker.info('Merged transaction ${from.id} into ${to.id}');
    } catch (e, s) {
      talker.error('Error in Capella mergeTransactions: $e', s);
    }
  }
}
