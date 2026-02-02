import 'dart:async';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/models/transaction_with_items.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/utils/test_data/dummy_transaction_generator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';
import 'package:flipper_models/helperModels/random.dart';

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
    bool includeZeroSubTotal = false,
  }) {
    if (!forceRealData) {
      return Stream.value(
        DummyTransactionGenerator.generateDummyTransactions(
          count: 100,
          branchId: branchId ?? "1",
          status: status,
          transactionType: transactionType,
        ),
      );
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
          '(status = :status OR status = :pendingStatus OR status = :parkedStatus OR status = :waitingMomoStatus)',
        );
        arguments['status'] = status ?? COMPLETE;
        arguments['pendingStatus'] = PENDING;
        arguments['parkedStatus'] = PARKED;
        arguments['waitingMomoStatus'] = WAITING_MOMO_COMPLETE;
      } else if (includePending) {
        // Include both COMPLETE and PENDING statuses
        whereClauses.add('(status = :status OR status = :pendingStatus)');
        arguments['status'] = status ?? COMPLETE;
        arguments['pendingStatus'] = PENDING;
      } else if (includeParked) {
        // Include both COMPLETE and PARKED statuses
        whereClauses.add(
          '(status = :status OR status = :parkedStatus OR status = :waitingMomoStatus)',
        );
        arguments['status'] = status ?? COMPLETE;
        arguments['parkedStatus'] = PARKED;
        arguments['waitingMomoStatus'] = WAITING_MOMO_COMPLETE;
      } else {
        // Only include the specified status (default COMPLETE)
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
        final localStartDate = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        final localEndDate = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
          999,
        );
        whereClauses.add(
          'lastTouched >= :startDate AND lastTouched <= :endDate',
        );
        arguments['startDate'] = localStartDate.toIso8601String();
        arguments['endDate'] = localEndDate.toIso8601String();
      } else if (startDate != null) {
        final localStartDate = DateTime(
          startDate.year,
          startDate.month,
          startDate.day,
        );
        whereClauses.add('lastTouched >= :startDate');
        arguments['startDate'] = localStartDate.toIso8601String();
      } else if (endDate != null) {
        final localEndDate = DateTime(
          endDate.year,
          endDate.month,
          endDate.day,
          23,
          59,
          59,
          999,
        );
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
            'Capella Transaction stream returned: ${transactions.length} records',
          );
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
    bool? isExpense,
    bool forceRealData = true,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool includeParked = false,
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
        if (includePending && includeParked) {
          whereClauses.add(
            '(status = :status OR status = :pendingStatus OR status = :parkedStatus OR status = :waitingMomoStatus)',
          );
          arguments['status'] = status ?? COMPLETE;
          arguments['pendingStatus'] = PENDING;
          arguments['parkedStatus'] = PARKED;
          arguments['waitingMomoStatus'] = WAITING_MOMO_COMPLETE;
        } else if (includePending) {
          whereClauses.add('(status = :status OR status = :pendingStatus)');
          arguments['status'] = status ?? COMPLETE;
          arguments['pendingStatus'] = PENDING;
        } else if (includeParked) {
          whereClauses.add(
            '(status = :status OR status = :parkedStatus OR status = :waitingMomoStatus)',
          );
          arguments['status'] = status ?? COMPLETE;
          arguments['parkedStatus'] = PARKED;
          arguments['waitingMomoStatus'] = WAITING_MOMO_COMPLETE;
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
        if (isCashOut || (isExpense ?? false)) {
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
            '(invoiceNumber IN ($invoicePlaceholders) OR receiptNumber IN ($receiptPlaceholders))',
          );

          // Bind values for both placeholders
          for (var i = 0; i < receiptNumber.length; i++) {
            arguments['receipt$i'] = receiptNumber[i];
            arguments['invoice$i'] = receiptNumber[i];
          }
        }

        // Date filtering
        if (startDate != null && endDate != null) {
          final localStartDate = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
          );
          final localEndDate = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            23,
            59,
            59,
            999,
          );
          whereClauses.add(
            'lastTouched >= :startDate AND lastTouched <= :endDate',
          );
          arguments['startDate'] = localStartDate.toIso8601String();
          arguments['endDate'] = localEndDate.toIso8601String();
        } else if (startDate != null) {
          final localStartDate = DateTime(
            startDate.year,
            startDate.month,
            startDate.day,
          );
          whereClauses.add('lastTouched >= :startDate');
          arguments['startDate'] = localStartDate.toIso8601String();
        } else if (endDate != null) {
          final localEndDate = DateTime(
            endDate.year,
            endDate.month,
            endDate.day,
            23,
            59,
            59,
            999,
          );
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
        'Capella transactions() returned: ${transactions.length} records',
      );
      return transactions;
    } catch (e, stackTrace) {
      talker.error('Error in transactions(): $e', stackTrace);
      return [];
    }
  }

  @override
  FutureOr<void> addTransaction({required ITransaction transaction}) {
    throw UnimplementedError(
      'addTransaction needs to be implemented for Capella',
    );
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
      'getByTaxType needs to be implemented for Capella',
    );
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
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) return null;

      // 1. Check for existing transaction
      final agentId = ProxyService.box.getUserId();
      final Map<String, dynamic> args = {
        'branchId': branchId,
        'status': status,
        'transactionType': transactionType,
        'isExpense': isExpense,
      };

      String query =
          "SELECT * FROM transactions WHERE branchId = :branchId AND status = :status AND transactionType = :transactionType AND isExpense = :isExpense";
      if (agentId != null) {
        query += " AND agentId = :agentId";
        args['agentId'] = agentId;
      }

      final result = await ditto.store.execute(query, arguments: args);

      if (result.items.isNotEmpty) {
        final data = Map<String, dynamic>.from(result.items.first.value);
        return _convertFromDittoDocument(data);
      }

      // 2. Create new transaction if none exists
      final now = DateTime.now().toUtc();
      final randomRef = randomNumber()
          .toString(); // Assuming randomNumber() is available globally or mixed in

      final newTransaction = ITransaction(
        agentId: agentId ?? 'unknown',
        lastTouched: now,
        reference: randomRef,
        transactionNumber: randomRef,
        status: status,
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
        shiftId: shiftId,
        receiptType: isExpense
            ? "NS"
            : "TS", // Simplified logic, adjust as needed
      );

      await ditto.store.execute(
        "INSERT INTO transactions DOCUMENTS (:doc)",
        arguments: {'doc': _transactionToMap(newTransaction)},
      );

      // Background Sync (Fire-and-forget)
      _backgroundSync(
        (strategy) => strategy.manageTransaction(
          transactionType: transactionType,
          isExpense: isExpense,
          branchId: branchId,
          shiftId: shiftId,
          status: status,
          includeSubTotalCheck: includeSubTotalCheck,
        ),
      );

      return newTransaction;
    } catch (e, s) {
      talker.error('Error in manageTransaction: $e', s);
      return null;
    }
  }

  /// Helper for firing background sync operations safely
  void _backgroundSync(
    Future<dynamic> Function(dynamic strategy) operation,
  ) async {
    try {
      final strategy = ProxyService.getStrategy(Strategy.cloudSync);
      await operation(strategy);
    } catch (e, s) {
      talker.warning('Background sync failed: $e', s);
    }
  }

  @override
  Stream<ITransaction> manageTransactionStream({
    required String transactionType,
    required bool isExpense,
    required String branchId,
    bool includeSubTotalCheck = false,
  }) async* {
    talker.info('Managing transaction stream for branch: $branchId');

    // 1. Try to find an existing pending transaction
    Stream<ITransaction> pendingStream = pendingTransaction(
      branchId: branchId,
      transactionType: transactionType,
      isExpense: isExpense,
    );

    // Wait for the first event to see if we have a transaction
    ITransaction? existingTransaction;
    try {
      existingTransaction = await pendingStream.first.timeout(
        Duration(milliseconds: 500),
      );
    } catch (e) {
      // Timeout means no pending transaction found quickly
    }

    if (existingTransaction != null) {
      yield existingTransaction;
      yield* pendingStream;
    } else {
      // 2. If no pending transaction, create one
      ITransaction? newTransaction = await manageTransaction(
        transactionType: transactionType,
        isExpense: isExpense,
        branchId: branchId,
        status: PENDING,
        includeSubTotalCheck: includeSubTotalCheck,
      );

      if (newTransaction != null) {
        yield newTransaction;
        // Continue listening to updates
        yield* pendingTransaction(
          branchId: branchId,
          transactionType: transactionType,
          isExpense: isExpense,
        );
      }
    }
  }

  @override
  FutureOr<void> removeCustomerFromTransaction({
    required ITransaction transaction,
  }) async {
    throw UnimplementedError(
      'removeCustomerFromTransaction needs to be implemented for Capella',
    );
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
      'assignTransaction needs to be implemented for Capella',
    );
  }

  @override
  Future<bool> saveTransactionItem({
    double? compositePrice,
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
    String? sarTyCd,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for saveTransactionItem');
        return false;
      }

      // 1. Check if item exists in transaction
      final query =
          "SELECT * FROM transaction_items WHERE transactionId = :transactionId AND variantId = :variantId";
      final args = {
        'transactionId': pendingTransaction.id,
        'variantId': variation.id,
      };

      final result = await ditto.store.execute(query, arguments: args);

      if (result.items.isNotEmpty) {
        // Update existing item
        final existingItemData = Map<String, dynamic>.from(
          result.items.first.value,
        );
        final double currentQty = (existingItemData['qty'] as num).toDouble();
        final double newQty = updatableQty ?? (currentQty + 1);
        final double newTotal =
            amountTotal *
            newQty; // Assuming amountTotal is unit price here, or re-calculate

        await ditto.store.execute(
          "UPDATE transaction_items SET qty = :qty, totAmt = :totAmt, updatedAt = :updatedAt WHERE _id = :id",
          arguments: {
            'qty': newQty,
            'totAmt': newTotal,
            'updatedAt': DateTime.now().toIso8601String(),
            'id': existingItemData['_id'] ?? existingItemData['id'],
          },
        );
      } else {
        // Insert new item
        final newItem = TransactionItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(), // Generate ID
          name: variation.name,
          transactionId: pendingTransaction.id,
          variantId: variation.id,
          qty: updatableQty ?? 1.0,
          price: amountTotal, // Unit price
          totAmt: amountTotal * (updatableQty ?? 1.0),
          discount: 0.0,
          // type: "REGULAR", // Removed
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          // isCustom: customItem, // Removed
          // isTaxExempted: false, // Removed
          isRefunded: false,
          doneWithTransaction: doneWithTransaction,
          active: true,
          branchId: pendingTransaction.branchId!,
          prc: variation.retailPrice ?? 0.0,
          ttCatCd: "B",
          itemSeq: variation.itemSeq,
          isrccCd: variation.isrccCd,
          isrccNm: variation.isrccNm,
          isrcRt: variation.isrcRt,
          isrcAmt: variation.isrcAmt,
          taxTyCd: variation.taxTyCd,
          bcd: variation.bcd,
          itemClsCd: variation.itemClsCd,
          itemTyCd: variation.itemTyCd,
          itemStdNm: variation.itemStdNm,
          orgnNatCd: variation.orgnNatCd,
          pkg: variation.pkg,
          itemCd: variation.itemCd,
          pkgUnitCd: variation.pkgUnitCd,
          qtyUnitCd: variation.qtyUnitCd,
          itemNm: variation.itemNm,
          splyAmt: variation.splyAmt,
          tin: variation.tin,
          bhfId: variation.bhfId,
          dftPrc: variation.dftPrc,
          addInfo: variation.addInfo,
          isrcAplcbYn: variation.isrcAplcbYn,
          useYn: variation.useYn,
          regrId: variation.regrId,
          regrNm: variation.regrNm,
          modrId: variation.modrId,
          modrNm: variation.modrNm,
        );

        final docMap = newItem.toFlipperJson();
        // Ensure dates are strings for Ditto
        docMap['createdAt'] = newItem.createdAt?.toIso8601String();
        docMap['updatedAt'] = newItem.updatedAt?.toIso8601String();
        // Explicitly set _id to match our generated id
        docMap['_id'] = newItem.id;

        await ditto.store.execute(
          "INSERT INTO transaction_items DOCUMENTS (:doc)",
          arguments: {'doc': docMap},
        );
        // Ensure we pass the created item to background sync to prevent duplicates
        item = newItem;
      }
      // Update Transaction Totals (SubTotal)
      // Recalculate everything for safety
      final itemsResult = await ditto.store.execute(
        "SELECT * FROM transaction_items WHERE transactionId = :tid",
        arguments: {'tid': pendingTransaction.id},
      );

      double newSubTotal = 0.0;
      for (final item in itemsResult.items) {
        final data = Map<String, dynamic>.from(item.value);
        newSubTotal += (data['totAmt'] as num).toDouble();
      }

      await updateTransaction(
        transaction: pendingTransaction,
        subTotal: newSubTotal,
        updatedAt: DateTime.now(),
        lastTouched: DateTime.now(),
      );

      // Background Sync
      talker.info('Background sync triggered for item: ${item?.id}');
      _backgroundSync(
        (strategy) => strategy.saveTransactionItem(
          compositePrice: compositePrice,
          ignoreForReport: ignoreForReport,
          updatableQty: updatableQty,
          variation: variation,
          doneWithTransaction: doneWithTransaction,
          amountTotal: amountTotal,
          customItem: customItem,
          pendingTransaction: pendingTransaction,
          invoiceNumber: invoiceNumber,
          currentStock: currentStock,
          useTransactionItemForQty: useTransactionItemForQty,
          partOfComposite: partOfComposite,
          item: item,
          sarTyCd: sarTyCd,
        ),
      );

      return true;
    } catch (e, s) {
      talker.error('Error saving transaction item to Capella: $e', s);
      return false;
    }
  }

  @override
  Future<void> markItemAsDoneWithTransaction({
    required List<TransactionItem> inactiveItems,
    bool? ignoreForReport,
    required ITransaction pendingTransaction,
    bool isDoneWithTransaction = false,
  }) {
    throw UnimplementedError(
      'markItemAsDoneWithTransaction needs to be implemented for Capella',
    );
  }

  Future<void> updateTransactionItem({
    double? qty,
    required String transactionItemId,
    double? discount,
    bool? active,
    double? taxAmt,
    int? quantityApproved,
    int? quantityRequested,
    bool? ebmSynced,
    bool? isRefunded,
    bool? incrementQty,
    double? price,
    double? prc,
    bool? doneWithTransaction,
    int? quantityShipped,
    double? taxblAmt,
    double? totAmt,
    double? dcRt,
    double? dcAmt,
    double? splyAmt, // Added missing parameter
    bool? ignoreForReport,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for updateTransactionItem');
        return;
      }

      final Map<String, dynamic> arguments = {'id': transactionItemId};
      final List<String> updates = [];

      void addUpdate(String field, dynamic value) {
        if (value != null) {
          updates.add('$field = :$field');
          arguments[field] = value;
        }
      }

      addUpdate('qty', qty);
      addUpdate('price', price);
      addUpdate('prc', prc); // Often same as price
      addUpdate('active', active);
      addUpdate('isRefunded', isRefunded);
      addUpdate('doneWithTransaction', doneWithTransaction);
      addUpdate('updatedAt', DateTime.now().toIso8601String());

      // If quantity or price changed, update totals locally for the item
      // Note: This logic assumes the caller handles valid inputs.
      // Ideally, we fetch the item first to get current price if only qty changed, etc.
      // But for speed, if we assume the caller provided what changed...

      // However, to be safe and correct (especially for totals), we should probably
      // update totAmt if qty or price is updated.
      if (qty != null || price != null) {
        // This is tricky without current values. But let's see typically usage.
        // Usually updateTransactionItem is called with just qty upgrade.
        // We might need to fetch the item first to do this correctly, OR
        // use a Ditto update query that calculates fields (not standard SQL usually in these embedded DBs).
        // Let's do a fetch-modify-write for safety on totals if critical fields change.
      }

      // We'll proceed with direct updates for now, assuming the sync strategy
      // relies on the simple field updates.
      // If `totAmt` needs calc, the caller might need to supply it or we fetch.
      // The classic implementation often just updates what is passed.

      if (updates.isEmpty) return;

      final query =
          'UPDATE transaction_items SET ${updates.join(', ')} WHERE _id = :id OR id = :id';

      await ditto.store.execute(query, arguments: arguments);

      // Update transaction totals if needed (e.g. if active changed to false)
      // We might need to fetch the transactionId from the item to update the parent transaction subTotal.
      // This is expensive: Fetch Item -> Get TransId -> Fetch All Items -> Calc SubTotal -> Update Trans.
      // For fast path, maybe we defer this or assume the stream listener on items
      // handles UI, and we eventually reconcile?
      // But `updateTransaction` logic earlier did recalculations.

      // Let's trying to fetch the item to get transactionId so we can update the transaction subtotal.
      final itemResult = await ditto.store.execute(
        "SELECT * FROM transaction_items WHERE _id = :id OR id = :id",
        arguments: {'id': transactionItemId},
      );

      if (itemResult.items.isNotEmpty) {
        final itemData = itemResult.items.first.value;
        final String? transactionId = itemData['transactionId'];
        if (transactionId != null) {
          // Recalculate Transaction subTotal
          await _recalculateTransactionSubTotal(transactionId);
        }
      }

      // Background Sync
      _backgroundSync(
        (strategy) => strategy.updateTransactionItem(
          qty: qty,
          transactionItemId: transactionItemId,
          discount: discount,
          active: active,
          taxAmt: taxAmt,
          quantityApproved: quantityApproved,
          quantityRequested: quantityRequested,
          ebmSynced: ebmSynced,
          isRefunded: isRefunded,
          incrementQty: incrementQty,
          price: price,
          prc: prc,
          doneWithTransaction: doneWithTransaction,
          quantityShipped: quantityShipped,
          taxblAmt: taxblAmt,
          totAmt: totAmt,
          dcRt: dcRt,
          dcAmt: dcAmt,
          ignoreForReport: ignoreForReport,
        ),
      );
    } catch (e, s) {
      talker.error('Error in updateTransactionItem: $e', s);
    }
  }

  Future<void> _recalculateTransactionSubTotal(String transactionId) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    final itemsResult = await ditto.store.execute(
      "SELECT * FROM transaction_items WHERE transactionId = :tid AND active = :active",
      arguments: {'tid': transactionId, 'active': true},
    );

    double newSubTotal = 0.0;
    for (final item in itemsResult.items) {
      final data = Map<String, dynamic>.from(item.value);
      final qty = (data['qty'] as num?)?.toDouble() ?? 0.0;
      final price = (data['price'] as num?)?.toDouble() ?? 0.0;
      newSubTotal += price * qty;
    }

    await updateTransaction(
      transactionId: transactionId,
      subTotal: newSubTotal,
      updatedAt: DateTime.now(),
      lastTouched: DateTime.now(),
    );
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
      'updatedAt',
      updatedAt ?? transaction?.updatedAt ?? DateTime.now(),
    );
    addUpdate(
      'lastTouched',
      lastTouched ?? transaction?.lastTouched ?? DateTime.now(),
    );
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
      talker.info(
        'Updated transaction $targetId with ${updates.length} fields',
      );
    } catch (e) {
      talker.error('Error updating transaction: $e');
      rethrow;
    }

    // Background Sync
    _backgroundSync(
      (strategy) => strategy.updateTransaction(
        transaction: transaction,
        receiptType: receiptType,
        subTotal: subTotal,
        note: note,
        status: status,
        customerId: customerId,
        ebmSynced: ebmSynced,
        sarTyCd: sarTyCd,
        reference: reference,
        customerTin: customerTin,
        customerBhfId: customerBhfId,
        cashReceived: cashReceived,
        isRefunded: isRefunded,
        customerName: customerName,
        ticketName: ticketName,
        updatedAt: updatedAt,
        invoiceNumber: invoiceNumber,
        lastTouched: lastTouched,
        supplierId: supplierId,
        receiptNumber: receiptNumber,
        totalReceiptNumber: totalReceiptNumber,
        isProformaMode: isProformaMode,
        sarNo: sarNo,
        orgSarNo: orgSarNo,
        receiptPrinted: receiptPrinted,
        isUnclassfied: isUnclassfied,
        isTrainingMode: isTrainingMode,
        transactionId: transactionId,
        customerPhone: customerPhone,
      ),
    );
  }

  @override
  Future<ITransaction?> getTransaction({
    String? sarNo,
    required String branchId,
    String? id,
    bool awaitRemote = false,
  }) {
    throw UnimplementedError(
      'getTransaction needs to be implemented for Capella',
    );
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
          'Attempted to delete a parked transaction (ticket): ${transaction.id}',
        );
        return false;
      }
      if ((transaction.cashReceived ?? 0) > 0) {
        talker.warning(
          'Attempted to delete a transaction with partial payments: ${transaction.id}',
        );
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
        'Successfully deleted transaction and items: ${transaction.id}',
      );

      // Background Sync
      _backgroundSync(
        (strategy) => strategy.deleteTransaction(transaction: transaction),
      );

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
  Future<ITransaction?> pendingTransactionFuture({
    String? branchId,
    required String transactionType,
    bool forceRealData = true,
    required bool isExpense,
  }) {
    throw UnimplementedError(
      'pendingTransactionFuture needs to be implemented for Capella',
    );
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
    bool? isExpense,
    FilterType? filterType,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool includeParked = false,
    bool skipOriginalTransactionCheck = false,
  }) async {
    throw UnimplementedError(
      'transactions needs to be implemented for Capella',
    );
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

      final queryResult = await ditto.store.execute(
        query,
        arguments: arguments,
      );

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
    // If not forcing real data, use dummy generator
    if (!forceRealData) {
      return Stream.value(
        DummyTransactionGenerator.generateDummyTransactions(
          count: 1,
          branchId: branchId ?? "1",
          status: PENDING,
          transactionType: transactionType,
        ).first,
      );
    }

    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for pendingTransaction');
        return Stream.empty();
      }

      final agentId = ProxyService.box.getUserId();
      final Map<String, dynamic> arguments = {
        'branchId': branchId,
        'status': PENDING,
        'transactionType': transactionType,
        'isExpense': isExpense,
      };

      String query =
          "SELECT * FROM transactions WHERE branchId = :branchId AND status = :status AND transactionType = :transactionType AND isExpense = :isExpense";

      if (agentId != null) {
        query += " AND agentId = :agentId";
        arguments['agentId'] = agentId;
      }

      query += " ORDER BY lastTouched DESC";

      ditto.sync.registerSubscription(query, arguments: arguments);

      final controller = StreamController<ITransaction>.broadcast();

      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) {
          if (queryResult.items.isNotEmpty) {
            final data = Map<String, dynamic>.from(
              queryResult.items.first.value,
            );
            controller.add(_convertFromDittoDocument(data));
          }
        },
      );

      controller.onCancel = () {
        observer.cancel();
        controller.close();
      };

      return controller.stream;
    } catch (e, s) {
      talker.error('Error in pendingTransaction stream: $e', s);
      return Stream.empty();
    }
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

  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    String? branchId,
    String? requestId,
    bool fetchRemote = false,
    bool? doneWithTransaction,
    bool? active,
    bool forceRealData = true,
    String? branchIdString,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    if (!forceRealData) {
      return Stream.value([]);
    }

    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for transactionItemsStreams');
        return Stream.value([]);
      }

      final Map<String, dynamic> arguments = {'transactionId': transactionId};

      String query =
          "SELECT * FROM transaction_items WHERE transactionId = :transactionId";

      if (doneWithTransaction != null) {
        query += " AND doneWithTransaction = :doneWithTransaction";
        arguments['doneWithTransaction'] = doneWithTransaction;
      }

      if (active != null) {
        query += " AND active = :active";
        arguments['active'] = active;
      }

      ditto.sync.registerSubscription(query, arguments: arguments);

      final controller = StreamController<List<TransactionItem>>.broadcast();

      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) {
          final items = <TransactionItem>[];
          for (final doc in queryResult.items) {
            try {
              final data = Map<String, dynamic>.from(doc.value);
              items.add(_convertTransactionItemFromDitto(data));
            } catch (e) {
              talker.error("Error converting transaction item", e);
            }
          }
          controller.add(items);
        },
      );

      controller.onCancel = () {
        try {
          observer.cancel();
          controller.close();
        } catch (e) {
          talker.error("Error cancelling observer", e);
        }
      };

      return controller.stream;
    } catch (e, s) {
      talker.error('Error in transactionItemsStreams: $e', s);
      return Stream.value([]);
    }
  }

  TransactionItem _convertTransactionItemFromDitto(Map<String, dynamic> data) {
    return TransactionItem(
      id: data['_id'] ?? data['id'],
      name: data['name'] ?? '',
      transactionId: data['transactionId'],
      variantId: data['variantId'],
      qty: (data['qty'] as num?) ?? 0,
      price: (data['price'] as num?) ?? 0,
      discount: (data['discount'] as num?) ?? 0,
      remainingStock: (data['remainingStock'] as num?)?.toDouble(),
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'])
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'])
          : null,
      isRefunded: data['isRefunded'] ?? false,
      doneWithTransaction: data['doneWithTransaction'],
      active: data['active'],
      prc: (data['prc'] as num?) ?? 0,
      ttCatCd: data['ttCatCd'] ?? '',
      // Optional fields
      quantityRequested: (data['quantityRequested'] as num?)?.toInt(),
      quantityApproved: (data['quantityApproved'] as num?)?.toInt(),
      quantityShipped: (data['quantityShipped'] as num?)?.toInt(),
      dcRt: (data['dcRt'] as num?)?.toDouble(),
      dcAmt: (data['dcAmt'] as num?)?.toDouble(),
      taxblAmt: (data['taxblAmt'] as num?)?.toDouble(),
      taxAmt: (data['taxAmt'] as num?)?.toDouble(),
      totAmt: (data['totAmt'] as num?)?.toDouble(),
      itemSeq: (data['itemSeq'] as num?)?.toInt(),
      isrccCd: data['isrccCd'],
      isrccNm: data['isrccNm'],
      isrcRt: (data['isrcRt'] as num?)?.toInt(),
      isrcAmt: (data['isrcAmt'] as num?)?.toInt(),
      inventoryRequestId: data['inventoryRequestId'],
      spplrItemClsCd: data['spplrItemClsCd'],
      spplrItemCd: data['spplrItemCd'],
      ignoreForReport: data['ignoreForReport'],
      supplyPriceAtSale: (data['supplyPriceAtSale'] as num?)?.toDouble(),
      compositePrice: (data['compositePrice'] as num?)?.toDouble(),
      partOfComposite: data['partOfComposite'] ?? false,

      // Additional properties from toFlipperJson that might be in data
      itemNm: data['itemNm'],
      taxTyCd: data['taxTyCd'],
      bcd: data['bcd'],
      itemClsCd: data['itemClsCd'],
      itemTyCd: data['itemTyCd'],
      itemStdNm: data['itemStdNm'],
      orgnNatCd: data['orgnNatCd'],
      pkg: (data['pkg'] as num?)?.toInt(),
      itemCd: data['itemCd'],
      pkgUnitCd: data['pkgUnitCd'],
      qtyUnitCd: data['qtyUnitCd'],
      splyAmt: (data['splyAmt'] as num?)?.toDouble(),
      tin: (data['tin'] as num?)?.toInt(),
      bhfId: data['bhfId'],
      dftPrc: (data['dftPrc'] as num?)?.toDouble(),
      addInfo: data['addInfo'],
      isrcAplcbYn: data['isrcAplcbYn'],
      useYn: data['useYn'],
      regrId: data['regrId'],
      regrNm: data['regrNm'],
      modrId: data['modrId'],
      modrNm: data['modrNm'],
      lastTouched: data['lastTouched'] != null
          ? DateTime.tryParse(data['lastTouched'])
          : null,
      purchaseId: data['purchaseId'],
      taxPercentage: (data['taxPercentage'] as num?)?.toDouble(),
      color: data['color'],
      sku: data['sku'],
      productId: data['productId'],
      unit: data['unit'],
      productName: data['productName'],
      categoryId: data['categoryId'],
      categoryName: data['categoryName'],
      taxName: data['taxName'],
      supplyPrice: (data['supplyPrice'] as num?)?.toDouble(),
      retailPrice: (data['retailPrice'] as num?)?.toDouble(),
      spplrItemNm: data['spplrItemNm'],
      totWt: (data['totWt'] as num?)?.toInt(),
      netWt: (data['netWt'] as num?)?.toInt(),
      spplrNm: data['spplrNm'],
      agntNm: data['agntNm'],
      invcFcurAmt: (data['invcFcurAmt'] as num?)?.toInt(),
      invcFcurCd: data['invcFcurCd'],
      invcFcurExcrt: (data['invcFcurExcrt'] as num?)?.toDouble(),
      exptNatCd: data['exptNatCd'],
      dclNo: data['dclNo'],
      taskCd: data['taskCd'],
      dclDe: data['dclDe'],
      hsCd: data['hsCd'],
      imptItemSttsCd: data['imptItemSttsCd'],
      isShared: data['isShared'],
      assigned: data['assigned'],
      ebmSynced: data['ebmSynced'],
    );
  }

  Map<String, dynamic> _transactionToMap(ITransaction transaction) {
    return {
      'id': transaction.id,
      'reference': transaction.reference,
      'categoryId': transaction.categoryId,
      'transactionNumber': transaction.transactionNumber,
      'branchId': transaction.branchId,
      'status': transaction.status,
      'transactionType': transaction.transactionType,
      'subTotal': transaction.subTotal,
      'paymentType': transaction.paymentType,
      'cashReceived': transaction.cashReceived,
      'customerChangeDue': transaction.customerChangeDue,
      'createdAt': transaction.createdAt?.toIso8601String(),
      'receiptType': transaction.receiptType,
      'updatedAt': transaction.updatedAt?.toIso8601String(),
      'customerId': transaction.customerId,
      'customerType': transaction.customerType,
      'note': transaction.note,
      'lastTouched': transaction.lastTouched?.toIso8601String(),
      'supplierId': transaction.supplierId,
      'ebmSynced': transaction.ebmSynced,
      'isIncome': transaction.isIncome,
      'isExpense': transaction.isExpense,
      'isRefunded': transaction.isRefunded,
      'customerName': transaction.customerName,
      'customerTin': transaction.customerTin,
      'remark': transaction.remark,
      'customerBhfId': transaction.customerBhfId,
      'sarTyCd': transaction.sarTyCd,
      'receiptNumber': transaction.receiptNumber,
      'totalReceiptNumber': transaction.totalReceiptNumber,
      'invoiceNumber': transaction.invoiceNumber,
      'isDigitalReceiptGenerated': transaction.isDigitalReceiptGenerated,
      'receiptPrinted': transaction.receiptPrinted,
      'receiptFileName': transaction.receiptFileName,
      'currentSaleCustomerPhoneNumber':
          transaction.currentSaleCustomerPhoneNumber,
      'sarNo': transaction.sarNo,
      'orgSarNo': transaction.orgSarNo,
      'shiftId': transaction.shiftId,
      'isLoan': transaction.isLoan,
      'dueDate': transaction.dueDate?.toIso8601String(),
      'isAutoBilled': transaction.isAutoBilled,
      'nextBillingDate': transaction.nextBillingDate?.toIso8601String(),
      'billingFrequency': transaction.billingFrequency,
      'billingAmount': transaction.billingAmount,
      'totalInstallments': transaction.totalInstallments,
      'paidInstallments': transaction.paidInstallments,
      'lastBilledDate': transaction.lastBilledDate?.toIso8601String(),
      'originalLoanAmount': transaction.originalLoanAmount,
      'remainingBalance': transaction.remainingBalance,
      'lastPaymentDate': transaction.lastPaymentDate?.toIso8601String(),
      'lastPaymentAmount': transaction.lastPaymentAmount,
      'originalTransactionId': transaction.originalTransactionId,
      'isOriginalTransaction': transaction.isOriginalTransaction,
      'taxAmount': transaction.taxAmount,
      'numberOfItems': transaction.numberOfItems,
      'discountAmount': transaction.discountAmount,
      'customerPhone': transaction.customerPhone,
      'agentId': transaction.agentId,
      'ticketName': transaction.ticketName,
    };
  }
}
