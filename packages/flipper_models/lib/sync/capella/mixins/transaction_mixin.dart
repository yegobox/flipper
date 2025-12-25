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
      if (includePending) {
        // Include both COMPLETE and PENDING statuses
        whereClauses.add('(status = :status OR status = :pendingStatus)');
        arguments['status'] = status ?? COMPLETE;
        arguments['pendingStatus'] = PENDING;
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
      branchId: parseInt(data['branchId']),
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
    int? branchId,
    bool isExpense = false,
    bool forceRealData = true,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool skipOriginalTransactionCheck = false,
    List<String>? receiptNumber,
    String? customerId,
  }) async {
    if (!forceRealData) {
      return DummyTransactionGenerator.generateDummyTransactions(
        count: 100,
        branchId: branchId ?? 1,
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

    /// because transaction is involved in account reporting
    /// and in other ways to facilitate that everything in flipper has attached transaction
    /// we want to make it unclassified i.e neither it is income or expense
    /// this help us having wrong computation on dashboard of what is income or expenses.
    bool isUnclassfied = false,
    bool? isTrainingMode,
    String? transactionId,
    String? customerPhone,
  }) {
    throw UnimplementedError(
        'updateTransaction needs to be implemented for Capella');
  }

  @override
  Future<ITransaction?> getTransaction(
      {String? sarNo,
      required int branchId,
      String? id,
      bool awaitRemote = false}) {
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
    throw UnimplementedError(
        'transactions needs to be implemented for Capella');
  }

  @override
  Future<Sar> getSar({required int branchId}) async {
    throw UnimplementedError('getSar needs to be implemented for Capella');
  }
}
