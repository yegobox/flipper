import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:talker/talker.dart';

/// Prefer explicit `id` (UUID) over Ditto's auto-generated `_id`.
String? _dittoDocumentId(Map<String, dynamic> data) {
  final id = data['id']?.toString();
  if (id != null && id.isNotEmpty) return id;
  return data['_id']?.toString();
}

/// Parent sale link — camelCase and snake_case both appear in Ditto payloads.
String? _dittoTransactionIdLink(Map<String, dynamic> data) {
  final camel = data['transactionId']?.toString().trim();
  if (camel != null && camel.isNotEmpty) return camel;
  final snake = data['transaction_id']?.toString().trim();
  if (snake != null && snake.isNotEmpty) return snake;
  return null;
}

mixin CapellaTransactionItemMixin implements TransactionItemInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;
  @override
  Future<void> addTransactionItem({
    ITransaction? transaction,
    required bool partOfComposite,
    required DateTime lastTouched,
    required double discount,
    double? compositePrice,
    bool? doneWithTransaction,
    required double quantity,
    required double currentStock,
    Variant? variation,
    required double amountTotal,
    required String name,
    TransactionItem? item,
    required bool ignoreForReport,
  }) async {
    if (transaction == null) {
      throw ArgumentError('Transaction cannot be null.');
    }
    if (item == null && variation == null) {
      throw ArgumentError('Either `item` or `variation` must be provided.');
    }

    final capella = ProxyService.getStrategy(Strategy.capella);

    if (item != null) {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for addTransactionItem');
        return;
      }
      final docMap = await TransactionItemDittoAdapter.instance
          .toDittoDocument(item);
      await ditto.store.execute(
        "INSERT INTO transaction_items DOCUMENTS (:doc)",
        arguments: {'doc': docMap},
      );
      final lineTotal =
          item.totAmt?.toDouble() ??
          (item.price.toDouble() * item.qty.toDouble());
      await (capella as dynamic)._dittoAdjustTransactionSubtotalByDelta(
        transactionId: transaction.id,
        delta: lineTotal,
      );
      return;
    }

    final v = variation!;
    final ok = await (capella as dynamic).saveTransactionItem(
      compositePrice: compositePrice,
      ignoreForReport: ignoreForReport,
      updatableQty: quantity,
      variation: v,
      doneWithTransaction: doneWithTransaction ?? false,
      amountTotal: amountTotal,
      customItem: false,
      pendingTransaction: transaction,
      invoiceNumber: null,
      currentStock: currentStock,
      useTransactionItemForQty: true,
      partOfComposite: partOfComposite,
      item: null,
      sarTyCd: null,
      updatePendingTransactionSubtotal: true,
    ) as bool;
    if (!ok) {
      throw StateError('saveTransactionItem failed in addTransactionItem');
    }
  }

  @override
  Future<TransactionItem?> getTransactionItem({
    required String variantId,
    String? transactionId,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) return null;

      final conditions = <String>['variantId = :variantId'];
      final arguments = <String, dynamic>{'variantId': variantId};
      if (transactionId != null && transactionId.isNotEmpty) {
        conditions.add(
          '(transactionId = :transactionId OR transaction_id = :transactionId)',
        );
        arguments['transactionId'] = transactionId;
      }
      conditions.add('active = :active');
      arguments['active'] = true;

      final query =
          'SELECT * FROM transaction_items WHERE ${conditions.join(' AND ')} ORDER BY updatedAt DESC LIMIT 1';
      final result = await ditto.store.execute(query, arguments: arguments);
      if (result.items.isEmpty) return null;

      final doc = Map<String, dynamic>.from(result.items.first.value);
      return TransactionItemDittoAdapter.instance.fromDittoDocument(doc);
    } catch (e, s) {
      talker.error('Capella getTransactionItem: $e', s);
      return null;
    }
  }

  @override
  Future<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    String? branchId,
    String? variantId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
    bool forceRealData = true,
    List<String>? itemIds,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:9');
        return [];
      }

      String query = 'SELECT * FROM transaction_items';
      final arguments = <String, dynamic>{};
      final conditions = <String>[];

      if (transactionId != null) {
        conditions.add(
          '(transactionId = :transactionId OR transaction_id = :transactionId)',
        );
        arguments['transactionId'] = transactionId;
      }
      if (requestId != null) {
        conditions.add('inventoryRequestId = :requestId');
        arguments['requestId'] = requestId;
      }
      if (branchId != null) {
        conditions.add('(branchId = :branchId OR branch_id = :branchId)');
        arguments['branchId'] = branchId;
      }
      if (variantId != null) {
        conditions.add('variantId = :variantId');
        arguments['variantId'] = variantId;
      }
      if (id != null) {
        conditions.add('id = :id');
        arguments['id'] = id;
      }
      if (active != null) {
        conditions.add('active = :active');
        arguments['active'] = active;
      }
      if (doneWithTransaction != null) {
        conditions.add('doneWithTransaction = :doneWithTransaction');
        arguments['doneWithTransaction'] = doneWithTransaction;
      }

      if (conditions.isNotEmpty) {
        query += ' WHERE ' + conditions.join(' AND ');
      }

      // Simple one-time fetch - no subscriptions needed here
      // (subscriptions are managed globally, not per-query)
      final result = await ditto.store.execute(query, arguments: arguments);

      return result.items.map((doc) {
        final data = Map<String, dynamic>.from(doc.value);
        return _convertFromDittoDocument(data);
      }).toList();
    } catch (e) {
      talker.error('Error getting transaction items: $e');
      return [];
    }
  }

  /// Fetches transaction items for MULTIPLE transaction IDs in a single query.
  /// Use this for bulk operations (e.g. export tax calculation) to avoid N+1 queries.
  @override
  Future<Map<String, List<TransactionItem>>> transactionItemsForIds(
    List<String> transactionIds,
  ) async {
    if (transactionIds.isEmpty) return {};
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized for transactionItemsForIds');
        return {};
      }

      // Dual-key OR join (parity with data-connector): snake_case has appeared on synced rows.
      final orParts = <String>[];
      final arguments = <String, dynamic>{};
      for (var i = 0; i < transactionIds.length; i++) {
        orParts.add('(transactionId = :t$i OR transaction_id = :t$i)');
        arguments['t$i'] = transactionIds[i];
      }
      final query =
          'SELECT * FROM transaction_items WHERE (${orParts.join(' OR ')})';

      final result = await ditto.store.execute(query, arguments: arguments);

      // Group by transactionId
      final grouped = <String, List<TransactionItem>>{};
      for (final doc in result.items) {
        final data = Map<String, dynamic>.from(doc.value);
        final tid = _dittoTransactionIdLink(data);
        if (tid == null) continue;
        final item = _convertFromDittoDocument(data);
        grouped.putIfAbsent(tid, () => []).add(item);
      }
      return grouped;
    } catch (e) {
      talker.error('Error in transactionItemsForIds: $e');
      return {};
    }
  }

  bool _reportItemBranchMatches(TransactionItem item, String branchId) {
    final rowBranch = item.branchId?.toString().trim();
    if (rowBranch == null || rowBranch.isEmpty) return true;
    return rowBranch == branchId;
  }

  List<TransactionItem> _parseTransactionItemQuery(dynamic queryResult) {
    final items = <TransactionItem>[];
    for (final doc in queryResult.items) {
      try {
        final data = Map<String, dynamic>.from(doc.value);
        items.add(_convertFromDittoDocument(data));
      } catch (e) {
        talker.error('Error converting transaction item row: $e');
      }
    }
    return items;
  }

  /// Ditto Playground–verified window: branchId + createdAt inclusive day.
  Future<List<TransactionItem>> _fetchTransactionItemsPlaygroundScope({
    required DateTime localStartDate,
    required DateTime localEndDate,
    required String branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return [];
    final query =
        'SELECT * FROM transaction_items WHERE branchId = :branchId AND '
        'createdAt >= :startDate AND createdAt <= :endDate '
        'ORDER BY createdAt DESC';
    final result = await ditto.store.execute(
      query,
      arguments: {
        'branchId': branchId,
        'startDate': localStartDate.toIso8601String(),
        'endDate': localEndDate.toIso8601String(),
      },
    );
    return _parseTransactionItemQuery(result)
        .where((i) => _reportItemBranchMatches(i, branchId))
        .toList();
  }

  /// One-shot fetch using the same DQL scope as [transactionItemsStreams] (pre–May-26 report path).
  Future<List<TransactionItem>> _fetchTransactionItemsLegacyStreamScope({
    required DateTime localStartDate,
    required DateTime endDate,
    required String branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return [];
    final query =
        'SELECT * FROM transaction_items WHERE '
        '(branchId = :branchId OR branch_id = :branchId) AND '
        'createdAt >= :startDate AND createdAt <= :endDate '
        'ORDER BY createdAt DESC';
    final result = await ditto.store.execute(
      query,
      arguments: {
        'branchId': branchId,
        'startDate': localStartDate.toIso8601String(),
        // Matches [transactionItemsStreams]: end of selected day + 1 day bound.
        'endDate': endDate.add(const Duration(days: 1)).toIso8601String(),
      },
    );
    return _parseTransactionItemQuery(result)
        .where((i) => _reportItemBranchMatches(i, branchId))
        .toList();
  }

  /// Inclusive report-day window (Ditto playground / transaction paging parity).
  Future<List<TransactionItem>> _fetchTransactionItemsInclusiveDayScope({
    required DateTime localStartDate,
    required DateTime localEndDate,
    required String branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return [];
    final dateClause =
        '((createdAt >= :startDate AND createdAt <= :endDate) OR '
        '(created_at >= :startDate AND created_at <= :endDate) OR '
        '(lastTouched >= :startDate AND lastTouched <= :endDate) OR '
        '(last_touched >= :startDate AND last_touched <= :endDate))';
    final query =
        'SELECT * FROM transaction_items WHERE '
        '(branchId = :branchId OR branch_id = :branchId) AND $dateClause '
        'ORDER BY createdAt DESC';
    final result = await ditto.store.execute(
      query,
      arguments: {
        'branchId': branchId,
        'startDate': localStartDate.toIso8601String(),
        'endDate': localEndDate.toIso8601String(),
      },
    );
    return _parseTransactionItemQuery(result)
        .where((i) => _reportItemBranchMatches(i, branchId))
        .toList();
  }

  /// All PLU rows for Transaction Reports in [startDate]…[endDate] (branch-scoped).
  /// Restores pre-regression stream loading; callers filter to sale ids as needed.
  Future<List<TransactionItem>> fetchTransactionItemsReportScope({
    required DateTime startDate,
    required DateTime endDate,
    required String branchId,
  }) async {
    try {
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

      var lines = await _fetchTransactionItemsPlaygroundScope(
        localStartDate: localStartDate,
        localEndDate: localEndDate,
        branchId: branchId,
      );
      if (lines.isNotEmpty) return lines;

      lines = await _fetchTransactionItemsLegacyStreamScope(
        localStartDate: localStartDate,
        endDate: endDate,
        branchId: branchId,
      );
      if (lines.isNotEmpty) return lines;

      lines = await _fetchTransactionItemsInclusiveDayScope(
        localStartDate: localStartDate,
        localEndDate: localEndDate,
        branchId: branchId,
      );
      if (lines.isNotEmpty) return lines;

      // Last resort: bulk link by parent sale id (export / legacy payloads).
      return [];
    } catch (e, s) {
      talker.error('fetchTransactionItemsReportScope: $e', s);
      return [];
    }
  }

  /// @deprecated Prefer [fetchTransactionItemsReportScope].
  Future<List<TransactionItem>> transactionItemsInReportDateRange({
    required DateTime startDate,
    required DateTime endDate,
    required String branchId,
  }) =>
      fetchTransactionItemsReportScope(
        startDate: startDate,
        endDate: endDate,
        branchId: branchId,
      );

  num? _dittoOptNum(dynamic v) {
    if (v == null) return null;
    if (v is num) return v;
    return num.tryParse(v.toString());
  }

  String? _dittoOptString(dynamic v) {
    if (v == null) return null;
    final s = v.toString().trim();
    return s.isEmpty ? null : s;
  }

  String? _dittoFirstString(Map<String, dynamic> data, List<String> keys) {
    for (final k in keys) {
      final s = _dittoOptString(data[k]);
      if (s != null) return s;
    }
    return null;
  }

  /// Convert Ditto document to TransactionItem model
  TransactionItem _convertFromDittoDocument(Map<String, dynamic> data) {
    DateTime? lastTouched;
    if (data['lastTouched'] != null) {
      if (data['lastTouched'] is String) {
        lastTouched = DateTime.parse(data['lastTouched']);
      } else {
        lastTouched = data['lastTouched'];
      }
    }

    return TransactionItem(
      id: _dittoDocumentId(data),
      name: data['name'] ?? '',
      transactionId: _dittoTransactionIdLink(data),
      variantId: data['variantId'],
      qty: _dittoOptNum(data['qty']) ?? 0,
      price: _dittoOptNum(data['price']) ?? 0,
      discount: _dittoOptNum(data['discount']) ?? 0,
      taxAmt: _dittoOptNum(data['taxAmt']),
      remainingStock: _dittoOptNum(data['remainingStock']),
      active: data['active'] ?? true,
      doneWithTransaction: data['doneWithTransaction'] ?? false,
      lastTouched: lastTouched,
      branchId: _dittoFirstString(data, ['branchId', 'branch_id']),
      taxTyCd: data['taxTyCd'],
      bcd: _dittoFirstString(data, ['bcd', 'barcode', 'Barcode', 'barCode']),
      sku: _dittoOptString(data['sku']),
      itemClsCd: data['itemClsCd'],
      itemTyCd: data['itemTyCd'],
      itemStdNm: data['itemStdNm'],
      orgnNatCd: data['orgnNatCd'],
      pkgUnitCd: data['pkgUnitCd'],
      qtyUnitCd: data['qtyUnitCd'],
      totAmt: _dittoOptNum(data['totAmt']),
      prc: _dittoOptNum(data['prc']) ?? 0,
      splyAmt: _dittoOptNum(data['splyAmt']),
      tin: data['tin'],
      bhfId: data['bhfId'],
      dftPrc: _dittoOptNum(data['dftPrc']) ?? 0,
      addInfo: data['addInfo'],
      isrccCd: data['isrccCd'],
      isrccNm: data['isrccNm'],
      isrcRt: _dittoOptNum(data['isrcRt'])?.toInt() ?? 0,
      isrcAmt: _dittoOptNum(data['isrcAmt'])?.toInt() ?? 0,
      taxblAmt: _dittoOptNum(data['taxblAmt']),
      dcRt: _dittoOptNum(data['dcRt']) ?? 0,
      dcAmt: _dittoOptNum(data['dcAmt']) ?? 0,
      isrcAplcbYn: data['isrccAplcbYn'],
      useYn: data['useYn'],
      regrId: data['regrId'],
      regrNm: data['regrNm'],
      modrId: data['modrId'],
      modrNm: data['modrNm'],
      itemSeq: data['itemSeq'],
      itemCd: data['itemCd'],
      itemNm: data['itemNm'],
      pkg: data['pkg'],
      ebmSynced: data['ebmSynced'],
      isRefunded: data['isRefunded'],
      ttCatCd: data['ttCatCd'],
      taxPercentage: _dittoOptNum(data['taxPercentage']),
      supplyPriceAtSale: _dittoOptNum(data['supplyPriceAtSale']),
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'].toString())
          : null,
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'].toString())
          : null,
    );
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    String? branchId,
    DateTime? startDate,
    String? branchIdString,
    DateTime? endDate,
    bool? doneWithTransaction,
    bool? active,
    String? requestId,
    bool fetchRemote = false,
    bool forceRealData = true,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized:10');
      return Stream.value([]);
    }

    String baseQuery = 'SELECT * FROM transaction_items';
    final arguments = <String, dynamic>{};
    final conditions = <String>[];

    if (transactionId != null) {
      conditions.add(
        '(transactionId = :transactionId OR transaction_id = :transactionId)',
      );
      arguments['transactionId'] = transactionId;
    }
    if (branchId != null) {
      conditions.add('(branchId = :branchId OR branch_id = :branchId)');
      arguments['branchId'] = branchId;
    }
    if (active != null) {
      conditions.add('active = :active');
      arguments['active'] = active;
    }
    if (doneWithTransaction != null) {
      conditions.add('doneWithTransaction = :doneWithTransaction');
      arguments['doneWithTransaction'] = doneWithTransaction;
    }
    if (requestId != null) {
      conditions.add('inventoryRequestId = :requestId');
      arguments['requestId'] = requestId;
    }

    // Handle date filtering
    if (startDate != null || endDate != null) {
      if (startDate != null && endDate != null) {
        conditions.add('createdAt >= :startDate');
        conditions.add('createdAt <= :endDate');
        arguments['startDate'] = startDate.toIso8601String();
        arguments['endDate'] = endDate
            .add(const Duration(days: 1))
            .toIso8601String();
      } else if (startDate != null) {
        conditions.add('createdAt >= :startDate');
        arguments['startDate'] = startDate.toIso8601String();
      } else if (endDate != null) {
        conditions.add('createdAt <= :endDate');
        arguments['endDate'] = endDate
            .add(const Duration(days: 1))
            .toIso8601String();
      }
    }

    if (conditions.isNotEmpty) {
      baseQuery += ' WHERE ' + conditions.join(' AND ');
    }
    // Ditto 5: sync subscriptions reject ORDER BY; use unordered query for replication only.
    final subscriptionQuery = baseQuery;
    final query = '$baseQuery ORDER BY createdAt DESC';

    /// A workaround to first register to whole data instead of subset
    /// this is because after test on new device, it can't pull data using complex query
    /// there is open issue on ditto https://support.ditto.live/hc/en-us/requests/2648?page=1
    ///
    /// NOTE: Broad subscription DISABLED - causes duplicate query warnings
    /// The specific subscription below is sufficient for most cases

    // Register subscription to sync data (unordered; Ditto 5 rejects ORDER BY on subscriptions)
    talker.debug('Registering specific subscription: $subscriptionQuery');
    final preparedTi = prepareDqlSyncSubscription(subscriptionQuery, arguments);
    final specificSubscription = ditto.sync.registerSubscription(
      preparedTi.dql,
      arguments: preparedTi.arguments,
    );

    final controller = StreamController<List<TransactionItem>>.broadcast();
    dynamic observer;

    observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) {
        if (controller.isClosed) return;

        final items = <TransactionItem>[];
        for (final doc in queryResult.items) {
          try {
            final data = Map<String, dynamic>.from(doc.value);
            items.add(_convertFromDittoDocument(data));
          } catch (e) {
            talker.error('Error converting transaction item: $e');
          }
        }
        controller.add(items);
      },
    );

    // Seed the stream immediately — the observer only fires on *changes*, so
    // without this initial fetch the stream would emit 0 items until the next
    // Ditto mutation event.
    ditto.store
        .execute(query, arguments: arguments)
        .then((result) {
          if (controller.isClosed) return;
          final items = <TransactionItem>[];
          for (final doc in result.items) {
            try {
              final data = Map<String, dynamic>.from(doc.value);
              items.add(_convertFromDittoDocument(data));
            } catch (e) {
              talker.error('Error converting transaction item (initial): $e');
            }
          }
          talker.debug(
            'transactionItemsStreams initial seed: ${items.length} items',
          );
          if (!controller.isClosed) controller.add(items);
        })
        .catchError((e) {
          talker.error('Error seeding transaction items stream: $e');
        });

    controller.onCancel = () async {
      talker.debug('Cleaning up transactionItemsStreams subscriptions');
      await observer?.cancel();
      specificSubscription.cancel();
      await controller.close();
      talker.debug('Cleanup completed for transactionItemsStreams');
    };

    return controller.stream;
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
    required bool ignoreForReport,
    bool skipParentSaleSubtotalRecalc = false,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:12');
        return;
      }

      final updates = <String, dynamic>{};
      if (qty != null)
        updates['qty'] = incrementQty == true ? 'qty + $qty' : qty;
      if (discount != null) updates['discount'] = discount;
      if (active != null) updates['active'] = active;
      if (taxAmt != null) updates['taxAmt'] = taxAmt;
      if (ebmSynced != null) updates['ebmSynced'] = ebmSynced;
      if (isRefunded != null) updates['isRefunded'] = isRefunded;
      if (price != null) updates['price'] = price;
      if (prc != null) updates['prc'] = prc;
      if (doneWithTransaction != null)
        updates['doneWithTransaction'] = doneWithTransaction;
      if (taxblAmt != null) updates['taxblAmt'] = taxblAmt;
      if (totAmt != null) updates['totAmt'] = totAmt;
      if (dcRt != null) updates['dcRt'] = dcRt;
      if (dcAmt != null) updates['dcAmt'] = dcAmt;

      if (updates.isEmpty) return;

      updates['updatedAt'] = DateTime.now().toIso8601String();

      final setClause = updates.keys
          .map(
            (key) => key == 'qty' && incrementQty == true
                ? '$key = $key + :qty'
                : '$key = :$key',
          )
          .join(', ');

      final query =
          'UPDATE transaction_items SET $setClause WHERE _id = :id OR id = :id';
      final arguments = Map<String, dynamic>.from(updates);
      arguments['id'] = transactionItemId;
      if (incrementQty == true && qty != null) {
        arguments['qty'] = qty;
      }

      await ditto.store.execute(query, arguments: arguments);
    } catch (e) {
      talker.error('Error updating transaction item: $e');
    }
  }
}
