import 'dart:convert';

import 'package:flipper_dashboard/utils/sale_stock_deduction.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/utils/combo_cost.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/FirebaseCrashlyticService.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/repository/storage.dart';

import 'test_helpers/mocks.dart';

/// In-memory [LocalStorage] for snapshot keys used during sale completion.
class _InMemoryBox extends MockBox {
  final Map<String, String> _strings = {};

  @override
  String? readString({required String key}) => _strings[key];

  @override
  Future<void> writeString({required String key, required String value}) async {
    _strings[key] = value;
  }

  @override
  void remove({required String key}) {
    _strings.remove(key);
  }
}

class _MockCapella extends Mock implements DatabaseSyncInterface {}

const _transactionId = 'txn-1';

ITransaction _transaction({int? invoiceNumber, double subTotal = 60}) {
  return ITransaction(
    id: _transactionId,
    branchId: 'b',
    agentId: 'agent-1',
    status: 'COMPLETE',
    transactionType: 'sale',
    paymentType: 'Cash',
    cashReceived: subTotal,
    customerChangeDue: 0,
    updatedAt: DateTime.utc(2026, 6, 12),
    isIncome: true,
    isExpense: false,
    invoiceNumber: invoiceNumber,
    subTotal: subTotal,
    taxAmount: 0,
  );
}

TransactionItem _saleLine({
  required String id,
  required String variantId,
  num qty = 1,
  int quantityShipped = 0,
  String itemTyCd = '2',
}) {
  return TransactionItem(
    id: id,
    name: 'Smoke 005',
    qty: qty,
    price: 60,
    discount: 0,
    prc: 60,
    ttCatCd: 'A',
    variantId: variantId,
    itemCd: 'RW2AMCT0000138',
    itemClsCd: '5020230602',
    itemNm: 'Smoke 005',
    itemTyCd: itemTyCd,
    supplyPrice: 25,
    quantityShipped: quantityShipped,
  );
}

void main() {
  late _MockCapella mockCapella;
  late _InMemoryBox box;
  late MockSyncStrategy mockStrategy;
  late MockTaxApi mockTaxApi;

  const stockId = 'stock-1';
  const variantId = 'var-1';

  setUpAll(() {
    registerFallbackValue(
      TransactionItem(
        name: 'fallback',
        qty: 1,
        price: 1,
        discount: 0,
        prc: 1,
        ttCatCd: 'A',
      ),
    );
    registerFallbackValue(Variant(name: 'V', branchId: 'b', stockId: stockId));
    registerFallbackValue(_transaction());
  });

  setUp(() async {
    await getIt.reset();

    mockCapella = _MockCapella();
    box = _InMemoryBox();
    mockStrategy = MockSyncStrategy();
    mockTaxApi = MockTaxApi();

    getIt.registerSingleton<LocalStorage>(box);
    getIt.registerSingleton<TaxApi>(mockTaxApi);
    getIt.registerSingleton<Crash>(CrashlitycsTalkerObserverUnsupported());
    getIt.registerSingleton<SyncStrategy>(
      mockStrategy,
      instanceName: 'strategy',
    );

    when(
      () => mockStrategy.getStrategy(Strategy.capella),
    ).thenReturn(mockCapella);

    when(() => mockCapella.batchGetVariantsByIds(any())).thenAnswer(
      (_) async => {
        variantId: Variant(
          name: 'V',
          branchId: 'b',
          stockId: stockId,
          id: variantId,
        ),
      },
    );

    when(() => mockCapella.batchDeductStocks(any())).thenAnswer((_) async {});
    when(() => mockCapella.batchUpdateStocks(any())).thenAnswer((_) async {});

    when(
      () => mockCapella.updateTransactionItem(
        transactionItemId: any(named: 'transactionItemId'),
        quantityShipped: any(named: 'quantityShipped'),
        ignoreForReport: any(named: 'ignoreForReport'),
        skipParentSaleSubtotalRecalc: any(
          named: 'skipParentSaleSubtotalRecalc',
        ),
      ),
    ).thenAnswer((_) async {});

    when(
      () => mockTaxApi.syncStockAfterSuccessfulSaveSales(
        receiptType: any(named: 'receiptType'),
        items: any(named: 'items'),
        transaction: any(named: 'transaction'),
        highestInvcNo: any(named: 'highestInvcNo'),
        sarTyCd: any(named: 'sarTyCd'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> _stubStock(double current) async {
    when(() => mockCapella.batchGetStocksByIds(any())).thenAnswer(
      (_) async => {
        stockId: Stock(id: stockId, branchId: 'b', currentStock: current),
      },
    );
    when(() => mockCapella.getStockById(id: stockId)).thenAnswer(
      (_) async => Stock(id: stockId, branchId: 'b', currentStock: current),
    );
  }

  group('applyDeferredSaleStockDeduction — perf-refactor regression', () {
    test(
      'deducts when quantityShipped matches but on-hand is still pre-sale',
      () async {
        await _stubStock(11);
        final item = _saleLine(
          id: 'line-1',
          variantId: variantId,
          quantityShipped: 1,
        );
        await box.writeString(
          key: rraSaleStockSnapshotBoxKey(_transactionId),
          value: jsonEncode({stockId: 11}),
        );

        await applyDeferredSaleStockDeduction(
          transactionItems: [item],
          allowSellingBelowStock: false,
          isProformaOrTraining: false,
          transactionId: _transactionId,
        );

        final captured =
            verify(
                  () => mockCapella.batchDeductStocks(captureAny()),
                ).captured.single
                as Map<String, double>;

        expect(captured[stockId], 1);
        verifyNever(() => mockCapella.batchUpdateStocks(any()));
      },
    );

    test('skips deduct when stock already reflects post-sale qty', () async {
      await _stubStock(10);
      final item = _saleLine(
        id: 'line-1',
        variantId: variantId,
        quantityShipped: 1,
      );
      await box.writeString(
        key: rraSaleStockSnapshotBoxKey(_transactionId),
        value: jsonEncode({stockId: 11}),
      );

      await applyDeferredSaleStockDeduction(
        transactionItems: [item],
        allowSellingBelowStock: false,
        isProformaOrTraining: false,
        transactionId: _transactionId,
      );

      verifyNever(() => mockCapella.batchDeductStocks(any()));
      verifyNever(() => mockCapella.batchUpdateStocks(any()));
    });
  });

  group('service lines keep no stock', () {
    test('a service is never deducted, even with padded itemTyCd', () async {
      // Same predicate as the POS tile (isServiceItemType): a tile that sold
      // the service must not have the sale take stock for it.
      await _stubStock(11);
      final item = _saleLine(
        id: 'line-svc',
        variantId: variantId,
        quantityShipped: 0,
        itemTyCd: ' 3 ',
      );

      await applyDeferredSaleStockDeduction(
        transactionItems: [item],
        allowSellingBelowStock: true,
        isProformaOrTraining: false,
        transactionId: _transactionId,
      );

      verifyNever(() => mockCapella.batchGetVariantsByIds(any()));
      verifyNever(() => mockCapella.batchDeductStocks(any()));
      verifyNever(() => mockCapella.batchUpdateStocks(any()));
    });
  });

  group('runPostSaleStockDeductionAndRraSync', () {
    test(
      'reports sale stock-out (11) to RRA when invoice is present',
      () async {
        await _stubStock(10);
        final item = _saleLine(id: 'line-1', variantId: variantId);
        final transaction = _transaction(invoiceNumber: 4518);
        await box.writeString(
          key: rraSaleStockSnapshotBoxKey(_transactionId),
          value: jsonEncode({stockId: 11}),
        );

        await runPostSaleStockDeductionAndRraSync(
          transactionItems: [item],
          allowSellingBelowStock: false,
          isProformaOrTraining: false,
          transactionId: _transactionId,
          transaction: transaction,
          receiptType: 'NS',
          sarTyCd: StockInOutType.sale,
        );

        verify(
          () => mockTaxApi.syncStockAfterSuccessfulSaveSales(
            receiptType: 'NS',
            items: [item],
            transaction: transaction,
            highestInvcNo: 4518,
            sarTyCd: StockInOutType.sale,
          ),
        ).called(1);
      },
    );

    test('does not call RRA sync without invoice number', () async {
      await _stubStock(11);
      final item = _saleLine(id: 'line-1', variantId: variantId);
      final transaction = _transaction();

      await runPostSaleStockDeductionAndRraSync(
        transactionItems: [item],
        allowSellingBelowStock: false,
        isProformaOrTraining: false,
        transactionId: _transactionId,
        transaction: transaction,
        receiptType: 'NS',
        sarTyCd: StockInOutType.sale,
      );

      verifyNever(
        () => mockTaxApi.syncStockAfterSuccessfulSaveSales(
          receiptType: any(named: 'receiptType'),
          items: any(named: 'items'),
          transaction: any(named: 'transaction'),
          highestInvcNo: any(named: 'highestInvcNo'),
          sarTyCd: any(named: 'sarTyCd'),
        ),
      );
    });
  });

  group('sale stock-out contract (documents invariants)', () {
    test('pre-RRa deduct + post-sale master uses post-deduction on-hand', () {
      const preSaleOnHand = 11.0;
      const soldQty = 1.0;
      final postSaleOnHand = preSaleOnHand - soldQty;

      expect(
        saleLineAlreadyStockDeducted(
          item: _saleLine(id: 'l1', variantId: variantId, quantityShipped: 1),
          variantsByVariantId: {
            variantId: Variant(name: 'V', branchId: 'b', stockId: stockId),
          },
          stocksByStockId: {
            stockId: Stock(
              id: stockId,
              branchId: 'b',
              currentStock: preSaleOnHand,
            ),
          },
          preSaleStockByStockId: {stockId: preSaleOnHand},
        ),
        isFalse,
        reason: 'saveStockMaster must not run while stock is still pre-sale',
      );

      expect(
        saleLineAlreadyStockDeducted(
          item: _saleLine(id: 'l1', variantId: variantId, quantityShipped: 1),
          variantsByVariantId: {
            variantId: Variant(name: 'V', branchId: 'b', stockId: stockId),
          },
          stocksByStockId: {
            stockId: Stock(
              id: stockId,
              branchId: 'b',
              currentStock: postSaleOnHand,
            ),
          },
          preSaleStockByStockId: {stockId: preSaleOnHand},
        ),
        isTrue,
      );

      expect(postSaleOnHand, 10);
    });

    test('NS sale stock I/O payload uses outgoing sale code', () {
      final item = _saleLine(id: 'l1', variantId: variantId);
      final line = mapRraStockIoItemToJson(item, bhfId: '00', itemSeq: 1);
      final body = buildRraSaveStockItemsRequest(
        items: [item],
        itemList: [line],
        tinNumber: '999909695',
        bhfId: '00',
        sarTyCd: resolveRraStockIoSarTyCd(receiptType: 'NS'),
        regTyCd: 'A',
        ocrnDt: '20260612',
        totalSupplyPrice: 60,
        totalvat: 0,
        totalAmount: 60,
        remark: 'Stock out for sale',
        sarNo: '4518',
        orgSarNo: 4518,
      );

      expect(body['sarTyCd'], StockInOutType.sale);
      expect(body['remark'], 'Stock out for sale');
      expect(body['orgSarNo'], 4518);
    });
  });

  // A combo sold as made books its components' cost as COGS (splyAmt), and
  // its own supply price follows.
  group('combo costs', () {
    late List<(String, double, double)> lineCosts;
    late Map<String, double> variantCosts;
    late ComboCostWriter writer;

    TransactionItem comboLine() => TransactionItem(
      id: 'combo-line',
      name: 'Lunch',
      qty: 2,
      price: 3000,
      discount: 0,
      prc: 3000,
      ttCatCd: 'A',
      variantId: 'combo-v',
      productId: 'combo-p',
      branchId: 'b',
      itemTyCd: '3',
      supplyPrice: 0,
    );

    Variant component(String id, double? supply) => Variant(
      id: id,
      name: id,
      branchId: 'b',
      stockId: '$id-s',
      itemTyCd: '2',
      supplyPrice: supply,
    );

    void stubCombo({double? breadCost = 250}) {
      when(() => box.getBusinessId()).thenReturn('biz');
      when(() => box.getBranchId()).thenReturn('b');
      when(
        () => mockCapella.getProduct(
          id: 'combo-p',
          branchId: 'b',
          businessId: 'biz',
        ),
      ).thenAnswer(
        (_) async => Product(
          id: 'combo-p',
          name: 'Lunch',
          color: '#000',
          businessId: 'biz',
          branchId: 'b',
          isComposite: true,
        ),
      );
      when(
        () => mockCapella.composites(productId: 'combo-p', localOnly: true),
      ).thenAnswer(
        (_) async => [
          Composite(productId: 'combo-p', variantId: 'soda', qty: 2),
          Composite(productId: 'combo-p', variantId: 'bread'),
        ],
      );
      when(() => mockCapella.batchGetVariantsByIds(any())).thenAnswer(
        (_) async => {
          'soda': component('soda', 300),
          'bread': component('bread', breadCost),
        },
      );
      when(
        () => mockCapella.batchGetStocksByIds(any()),
      ).thenAnswer((_) async => {});
      when(
        () => mockCapella.getStockById(id: any(named: 'id')),
      ).thenAnswer((_) async => null);
    }

    setUp(() {
      lineCosts = [];
      variantCosts = {};
      writer = ComboCostWriter(
        variantSupplyPrice: (id, cost) async => variantCosts[id] = cost,
        lineSupplyCost: (id, unit, qty) async => lineCosts.add((id, unit, qty)),
      );
    });

    Future<void> sell({ComboCostWriter? costs}) =>
        applyDeferredSaleStockDeduction(
          transactionItems: [comboLine()],
          allowSellingBelowStock: true,
          isProformaOrTraining: false,
          transactionId: _transactionId,
          comboCosts: () => costs,
        );

    test('a combo line books what its components cost', () async {
      stubCombo();

      await sell(costs: writer);

      // One lunch = 2 soda × 300 + 1 bread × 250 = 850; 2 sold.
      expect(lineCosts, [('combo-line', 850.0, 2.0)]);
      expect(variantCosts, {'combo-v': 850.0});
    });

    test('a component with no cost keeps the cost the combo has', () async {
      stubCombo(breadCost: null);

      await sell(costs: writer);

      expect(lineCosts, isEmpty);
      expect(variantCosts, isEmpty);
    });

    test('with Ditto not open, nothing is written', () async {
      stubCombo();

      await sell();

      expect(lineCosts, isEmpty);
      expect(variantCosts, isEmpty);
    });

    test('a failed cost write never fails the sale', () async {
      stubCombo();

      await sell(
        costs: ComboCostWriter(
          variantSupplyPrice: (_, __) async => throw StateError('ditto'),
          lineSupplyCost: (_, __, ___) async => throw StateError('ditto'),
        ),
      );

      // The components' stock still moves.
      verify(
        () => mockCapella.batchGetStocksByIds(any()),
      ).called(greaterThan(0));
    });
  });
}
