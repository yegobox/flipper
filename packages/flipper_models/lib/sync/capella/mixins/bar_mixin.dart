import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/models/bar_branch_settings.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/interfaces/bar_interface.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';
import 'package:talker/talker.dart';
import 'package:uuid/uuid.dart';

TransactionItem? _barFindLine(List<TransactionItem> lines, String lineId) {
  for (final line in lines) {
    if (line.id == lineId) return line;
  }
  return null;
}

/// Keys of Ditto sync subscriptions already registered for bar collections.
/// Store queries/observers only read locally; without these subscriptions a
/// fresh device never replicates bar documents from the mesh/cloud.
final Set<String> _barSyncSubscriptionKeys = <String>{};

mixin CapellaBarMixin implements BarInterface {
  DittoService get dittoService;
  Talker get talker;

  static const _barBranchSettingsSql =
      'SELECT * FROM bar_branch_settings WHERE branchId = :branchId LIMIT 1';
  static const _barTablesSql =
      'SELECT * FROM bar_tables WHERE branchId = :branchId ORDER BY ordinal ASC';
  static const _barTabsSql =
      "SELECT * FROM transactions WHERE branchId = :branchId AND status = :status AND tableId IS NOT NULL";

  void _ensureBarSyncSubscription(
    dynamic ditto,
    String key,
    String sql,
    Map<String, dynamic>? args,
  ) {
    if (_barSyncSubscriptionKeys.contains(key)) return;
    try {
      final prepared = prepareDqlSyncSubscription(sql, args);
      ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );
      _barSyncSubscriptionKeys.add(key);
      talker.debug('bar: registered sync subscription $key');
    } catch (e, s) {
      talker.warning('bar: sync subscription failed ($key): $e\n$s');
    }
  }

  void _ensureBarSettingsSync(dynamic ditto, String branchId) {
    // Collection-wide first: fresh devices can fail to pull with filtered
    // subscriptions (known Ditto issue, see customer_mixin). The collection
    // holds one small doc per branch, so this is cheap.
    _ensureBarSyncSubscription(
      ditto,
      'bar_branch_settings|all',
      'SELECT * FROM bar_branch_settings',
      null,
    );
    _ensureBarSyncSubscription(
      ditto,
      'bar_branch_settings|$branchId',
      _barBranchSettingsSql,
      {'branchId': branchId},
    );
  }

  void _ensureBarTablesSync(dynamic ditto, String branchId) {
    _ensureBarSyncSubscription(ditto, 'bar_tables|$branchId', _barTablesSql, {
      'branchId': branchId,
    });
  }

  void _ensureBarTabsSync(dynamic ditto, String branchId) {
    _ensureBarSyncSubscription(
      ditto,
      'bar_tabs|$branchId',
      'SELECT * FROM transactions WHERE branchId = :branchId',
      {'branchId': branchId},
    );
    _ensureBarSyncSubscription(
      ditto,
      'bar_tab_lines|$branchId',
      'SELECT * FROM transaction_items WHERE branchId = :branchId',
      {'branchId': branchId},
    );
  }

  List<BarTable> _tablesFromResult(dynamic queryResult) {
    final list = <BarTable>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        list.add(
          BarTable.fromJson(
            Map<String, dynamic>.from(item.value as Map<dynamic, dynamic>),
          ),
        );
      } catch (e) {
        talker.error('bar_tables map error: $e');
      }
    }
    return list;
  }

  Future<List<ITransaction>> _tabsFromResult(dynamic queryResult) async {
    final list = <ITransaction>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        final data = Map<String, dynamic>.from(item.value as Map);
        final txn = await ITransactionDittoAdapter.instance.fromDittoDocument(
          data,
        );
        if (txn != null) list.add(txn);
      } catch (e) {
        talker.error('bar tab map error: $e');
      }
    }
    return list;
  }

  BarBranchSettings? _branchSettingsFromResult(dynamic queryResult) {
    try {
      final items = queryResult.items as Iterable<dynamic>;
      if (items.isEmpty) return null;
      final raw = Map<String, dynamic>.from(items.first.value as Map);
      return BarBranchSettings.fromJson(raw);
    } catch (e) {
      talker.error('bar_branch_settings map error: $e');
      return null;
    }
  }

  @override
  Future<BarBranchSettings?> barBranchSettings({
    required String branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;
    _ensureBarSettingsSync(ditto, branchId);
    final result = await ditto.store.execute(
      _barBranchSettingsSql,
      arguments: {'branchId': branchId},
    );
    return _branchSettingsFromResult(result);
  }

  @override
  Stream<BarBranchSettings?> barBranchSettingsStream({
    required String branchId,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return Stream.value(null);
    _ensureBarSettingsSync(ditto, branchId);

    final controller = StreamController<BarBranchSettings?>();
    final args = {'branchId': branchId};
    dynamic observer;

    unawaited(() async {
      try {
        final initial = await ditto.store.execute(
          _barBranchSettingsSql,
          arguments: args,
        );
        if (controller.isClosed) return;
        controller.add(_branchSettingsFromResult(initial));
        if (controller.isClosed) return;
        observer = ditto.store.registerObserver(
          _barBranchSettingsSql,
          arguments: args,
          onChange: (r) {
            if (!controller.isClosed) {
              controller.add(_branchSettingsFromResult(r));
            }
          },
        );
      } catch (e, s) {
        talker.error('barBranchSettingsStream: $e\n$s');
        if (!controller.isClosed) controller.add(null);
      }
    }());

    controller.onCancel = () async {
      try {
        await observer?.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> saveBarBranchSettings(BarBranchSettings settings) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) throw StateError('Ditto not initialized');
    final doc = settings.copyWith(updatedAt: DateTime.now().toUtc()).toJson();
    await ditto.store.execute(
      'INSERT INTO bar_branch_settings DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );
  }

  @override
  Future<List<BarTable>> barTables({required String branchId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return [];
    _ensureBarTablesSync(ditto, branchId);
    final result = await ditto.store.execute(
      _barTablesSql,
      arguments: {'branchId': branchId},
    );
    return _tablesFromResult(result);
  }

  @override
  Stream<List<BarTable>> barTablesStream({required String branchId}) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      return Stream.value(<BarTable>[]);
    }
    _ensureBarTablesSync(ditto, branchId);

    final controller = StreamController<List<BarTable>>();
    final args = {'branchId': branchId};
    dynamic observer;

    unawaited(() async {
      try {
        final initial = await ditto.store.execute(
          _barTablesSql,
          arguments: args,
        );
        if (!controller.isClosed) {
          controller.add(_tablesFromResult(initial));
        }
        observer = ditto.store.registerObserver(
          _barTablesSql,
          arguments: args,
          onChange: (r) {
            if (!controller.isClosed) {
              controller.add(_tablesFromResult(r));
            }
          },
        );
      } catch (e, s) {
        talker.error('barTablesStream: $e\n$s');
        if (!controller.isClosed) controller.add([]);
      }
    }());

    controller.onCancel = () async {
      try {
        await observer?.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Future<void> saveBarTable(BarTable table) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) throw StateError('Ditto not initialized');
    await ditto.store.execute(
      'INSERT INTO bar_tables DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': table.toJson()},
    );
  }

  @override
  Future<void> deleteBarTable({
    required String id,
    required String branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    await ditto.store.execute(
      'DELETE FROM bar_tables WHERE (_id = :id OR id = :id) AND branchId = :branchId',
      arguments: {'id': id, 'branchId': branchId},
    );
  }

  @override
  Future<void> seedDefaultFloorPlan({required String branchId}) async {
    final existing = await barTables(branchId: branchId);
    if (existing.isNotEmpty) return;
    for (final table in defaultBarFloorPlan(branchId: branchId)) {
      await saveBarTable(table);
    }
  }

  @override
  Stream<List<ITransaction>> barTabsStream({required String branchId}) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return Stream.value(<ITransaction>[]);
    _ensureBarTabsSync(ditto, branchId);

    final controller = StreamController<List<ITransaction>>();
    final args = {'branchId': branchId, 'status': PARKED};
    dynamic observer;

    unawaited(() async {
      try {
        final initial = await ditto.store.execute(_barTabsSql, arguments: args);
        if (!controller.isClosed) {
          controller.add(await _tabsFromResult(initial));
        }
        observer = ditto.store.registerObserver(
          _barTabsSql,
          arguments: args,
          onChange: (r) async {
            if (!controller.isClosed) {
              controller.add(await _tabsFromResult(r));
            }
          },
        );
      } catch (e, s) {
        talker.error('barTabsStream: $e\n$s');
        if (!controller.isClosed) controller.add([]);
      }
    }());

    controller.onCancel = () async {
      try {
        await observer?.cancel();
      } catch (_) {}
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Future<ITransaction?> barTabForTable({
    required String branchId,
    required String tableId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM transactions WHERE branchId = :branchId AND tableId = :tableId AND status = :status LIMIT 1',
      arguments: {'branchId': branchId, 'tableId': tableId, 'status': PARKED},
    );
    if (result.items.isEmpty) return null;
    final data = Map<String, dynamic>.from(result.items.first.value);
    return await ITransactionDittoAdapter.instance.fromDittoDocument(data);
  }

  Future<List<TransactionItem>> _linesFromResult(dynamic queryResult) async {
    final lines = <TransactionItem>[];
    for (final item in queryResult.items as Iterable<dynamic>) {
      try {
        final data = Map<String, dynamic>.from(item.value as Map);
        final line = barTransactionLineFromDitto(data);
        if (line != null) lines.add(line);
      } catch (e) {
        talker.error('barTabLines map: $e');
      }
    }
    return lines;
  }

  @override
  Future<List<TransactionItem>> barTabLines({
    required String transactionId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return [];
    final result = await ditto.store.execute(
      'SELECT * FROM transaction_items WHERE transactionId = :transactionId',
      arguments: {'transactionId': transactionId},
    );
    return _linesFromResult(result);
  }

  @override
  Future<ITransaction> openBarTab({
    required String branchId,
    required BarTable table,
    required String cashierTenantId,
    required String cashierName,
  }) async {
    final existing = await barTabForTable(
      branchId: branchId,
      tableId: table.id,
    );
    if (existing != null) return existing;

    final ditto = dittoService.dittoInstance;
    if (ditto == null) throw StateError('Ditto not initialized');

    final now = DateTime.now().toUtc();
    final ref = const Uuid().v4().substring(0, 8);
    final txn = ITransaction(
      branchId: branchId,
      status: PARKED,
      transactionType: SALE,
      subTotal: 0,
      cashReceived: 0,
      customerChangeDue: 0,
      paymentType: ProxyService.box.paymentType() ?? 'Cash',
      isIncome: true,
      isExpense: false,
      agentId: cashierTenantId,
      cashierName: cashierName,
      ticketName: table.name,
      tableId: table.id,
      note: 'Opened by $cashierName',
      createdAt: now,
      updatedAt: now,
      lastTouched: now,
      reference: ref,
      transactionNumber: ref,
    );

    final doc = await ITransactionDittoAdapter.instance.toDittoDocument(txn);
    await ditto.store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc)',
      arguments: {'doc': doc},
    );
    return txn;
  }

  Future<void> _adjustSubtotal(String transactionId, double delta) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    final txn = await barTabForTableById(transactionId);
    if (txn == null) return;
    final newSub = (txn.subTotal ?? 0) + delta;
    final nowIso = DateTime.now().toUtc().toIso8601String();
    await ditto.store.execute(
      'UPDATE transactions SET subTotal = :subTotal, updatedAt = :updatedAt, lastTouched = :lastTouched WHERE _id = :id OR id = :id',
      arguments: {
        'id': transactionId,
        'subTotal': newSub,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
  }

  Future<ITransaction?> barTabForTableById(String transactionId) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return null;
    final result = await ditto.store.execute(
      'SELECT * FROM transactions WHERE _id = :id OR id = :id LIMIT 1',
      arguments: {'id': transactionId},
    );
    if (result.items.isEmpty) return null;
    return await ITransactionDittoAdapter.instance.fromDittoDocument(
      Map<String, dynamic>.from(result.items.first.value),
    );
  }

  @override
  Future<void> addLineToBarTab({
    required String transactionId,
    required String branchId,
    required String variantId,
    required String productName,
    required num defaultPrice,
    required num stock,
    required String cashierTenantId,
    required String cashierName,
    String? color,
    String? sku,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) throw StateError('Ditto not initialized');

    final lines = await barTabLines(transactionId: transactionId);
    TransactionItem? mergeTarget;
    for (final line in lines) {
      if (barLineMatchesMerge(
        line: line,
        variantId: variantId,
        cashierTenantId: cashierTenantId,
        defaultPrice: defaultPrice,
      )) {
        mergeTarget = line;
        break;
      }
    }

    if (mergeTarget != null) {
      final newQty = mergeTarget.qty + 1;
      if (newQty > stock) return;
      await setBarTabLineQty(
        lineId: mergeTarget.id,
        transactionId: transactionId,
        qty: newQty,
        stockCap: stock,
      );
      return;
    }

    final variant = await ProxyService.getStrategy(
      Strategy.capella,
    ).getVariant(id: variantId);
    final taxTyCd = variant?.taxTyCd ?? 'B';
    final taxPct = (variant?.taxPercentage ?? 18.0).toDouble();
    final dcRt = (variant?.dcRt ?? 0).toDouble();
    final pricing = SaleLinePricing.compute(
      unitPrice: defaultPrice.toDouble(),
      qty: 1,
      dcRt: dcRt,
      taxTyCd: taxTyCd,
      taxPercentage: taxPct,
    );

    final itemCd = barRraItemCd(
      variant: variant,
      sku: sku ?? variant?.sku,
      variantId: variantId,
    );
    if (itemCd == null) {
      throw StateError(
        'Cannot add "$productName" to bar tab: no RRA itemCd on variant. '
        'Register the product with RRA first.',
      );
    }

    final line = TransactionItem(
      name: productName,
      itemNm: variant?.itemNm ?? productName,
      variantId: variantId,
      transactionId: transactionId,
      branchId: branchId,
      qty: 1,
      price: defaultPrice,
      prc: variant?.retailPrice ?? defaultPrice,
      discount: pricing.discount,
      dcRt: pricing.dcRt,
      dcAmt: pricing.dcAmt,
      taxblAmt: pricing.taxblAmt,
      taxAmt: pricing.taxAmt,
      totAmt: pricing.totAmt,
      ttCatCd: barRraTtCatCdForItem(variant: variant),
      itemTyCd: variant?.itemTyCd ?? '2',
      itemCd: itemCd,
      taxTyCd: taxTyCd,
      taxPercentage: taxPct,
      qtyUnitCd: variant?.qtyUnitCd,
      pkgUnitCd: variant?.pkgUnitCd,
      itemClsCd: variant?.itemClsCd,
      bhfId: variant?.bhfId,
      regrNm: variant?.regrNm ?? 'Registrar',
      orgnNatCd: variant?.orgnNatCd ?? 'RW',
      itemSeq: variant?.itemSeq,
      bcd: variant?.bcd,
      color: color,
      sku: sku ?? variant?.sku,
      loggedByTenantId: cashierTenantId,
      loggedByName: cashierName,
    );

    final doc = await TransactionItemDittoAdapter.instance.toDittoDocument(
      line,
    );
    await ditto.store.execute(
      'INSERT INTO transaction_items DOCUMENTS (:doc)',
      arguments: {'doc': doc},
    );
    await _adjustSubtotal(
      transactionId,
      line.price.toDouble() * line.qty.toDouble(),
    );
  }

  @override
  Future<void> setBarTabLineQty({
    required String lineId,
    required String transactionId,
    required num qty,
    required num stockCap,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    final lines = await barTabLines(transactionId: transactionId);
    final line = _barFindLine(lines, lineId);
    if (line == null) return;

    final oldTotal = line.price.toDouble() * line.qty.toDouble();
    final clamped = qty.clamp(0, stockCap);

    if (clamped <= 0) {
      await deleteBarTabLine(lineId: lineId, transactionId: transactionId);
      await _adjustSubtotal(transactionId, -oldTotal);
      return;
    }

    final nowIso = DateTime.now().toUtc().toIso8601String();
    await ditto.store.execute(
      'UPDATE transaction_items SET qty = :qty, updatedAt = :updatedAt, lastTouched = :lastTouched WHERE _id = :id OR id = :id',
      arguments: {
        'id': lineId,
        'qty': clamped,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
    final newTotal = line.price.toDouble() * clamped.toDouble();
    await _adjustSubtotal(transactionId, newTotal - oldTotal);
  }

  @override
  Future<void> setBarTabLinePrice({
    required String lineId,
    required String transactionId,
    required num price,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    final lines = await barTabLines(transactionId: transactionId);
    final line = _barFindLine(lines, lineId);
    if (line == null) return;

    final oldTotal = line.price.toDouble() * line.qty.toDouble();
    final newTotal = price.toDouble() * line.qty.toDouble();
    final nowIso = DateTime.now().toUtc().toIso8601String();

    await ditto.store.execute(
      'UPDATE transaction_items SET price = :price, prc = :price, updatedAt = :updatedAt, lastTouched = :lastTouched WHERE _id = :id OR id = :id',
      arguments: {
        'id': lineId,
        'price': price,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
    await _adjustSubtotal(transactionId, newTotal - oldTotal);
  }

  @override
  Future<void> deleteBarTabLine({
    required String lineId,
    required String transactionId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    final lines = await barTabLines(transactionId: transactionId);
    final line = _barFindLine(lines, lineId);
    if (line == null) return;

    final lineTotal = line.price.toDouble() * line.qty.toDouble();
    await ditto.store.execute(
      'DELETE FROM transaction_items WHERE _id = :id OR id = :id',
      arguments: {'id': lineId},
    );
    await _adjustSubtotal(transactionId, -lineTotal);
  }

  @override
  Future<void> refreshBarTabSubTotal({required String transactionId}) async {
    final lines = await barTabLines(transactionId: transactionId);
    final total = barTabTotal(lines);
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;
    final nowIso = DateTime.now().toUtc().toIso8601String();
    await ditto.store.execute(
      'UPDATE transactions SET subTotal = :subTotal, updatedAt = :updatedAt, lastTouched = :lastTouched WHERE _id = :id OR id = :id',
      arguments: {
        'id': transactionId,
        'subTotal': total,
        'updatedAt': nowIso,
        'lastTouched': nowIso,
      },
    );
  }

  @override
  Future<ITransaction> settleBarTab({
    required ITransaction transaction,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) throw StateError('Ditto not initialized');

    final nowIso = DateTime.now().toUtc().toIso8601String();
    final updated = transaction.copyWith(
      status: COMPLETE,
      paymentType: paymentType,
      cashReceived: cashReceived,
      customerChangeDue: customerChangeDue,
      tableId: null,
      updatedAt: DateTime.parse(nowIso),
      lastTouched: DateTime.parse(nowIso),
    );

    final doc = await ITransactionDittoAdapter.instance.toDittoDocument(
      updated,
    );
    await ditto.store.execute(
      'INSERT INTO transactions DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc},
    );

    return updated;
  }
}
