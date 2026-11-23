import 'package:flipper_accounting/production_journal_poster.dart';
import 'package:flipper_dashboard/features/production_output/services/production_output_service.dart';
import 'package:flipper_dashboard/features/production_output/services/production_stock_poster.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/sars.model.dart';

// flutter test test/features/production_output/services/production_output_service_test.dart --dart-define=FLUTTER_TEST_ENV=true
//
// Production output used to deduct the product being made (no recipe) or its
// sale-time components (composite) when an order started, and never added the
// finished goods. Now recording output adds plain goods to stock as `05`, a
// composite moves nothing, and starting moves no stock at all.

class _MockDb extends Mock implements DatabaseSyncInterface {}

/// Records each `saveStockItems` call; answers [resultCd] to all of them.
class _RecordingTaxApi extends Mock implements TaxApi {
  _RecordingTaxApi({this.resultCd = '000'});

  final String resultCd;
  final List<({String sarTyCd, bool isStockIn, String? sarNo, String remark})>
  ioCalls = [];
  final List<double?> masterQtys = [];

  @override
  Future<RwApiResponse> saveStockItems({
    required List<TransactionItem> items,
    bool updateMaster = true,
    required String tinNumber,
    required String bhFId,
    String? customerName,
    String? custTin,
    String? regTyCd = "A",
    required String sarTyCd,
    bool isStockIn = false,
    String? custBhfId,
    required double totalSupplyPrice,
    required double totalvat,
    required double totalAmount,
    required String remark,
    required DateTime ocrnDt,
    String? sarNo,
    required String URI,
    num? invoiceNumber,
    num? approvedQty,
    bool includeCustomerFields = false,
  }) async {
    ioCalls.add((
      sarTyCd: sarTyCd,
      isStockIn: isStockIn,
      sarNo: sarNo,
      remark: remark,
    ));
    return RwApiResponse(resultCd: resultCd, resultMsg: 'rejected');
  }

  @override
  Future<RwApiResponse> saveStockMaster({
    required Variant variant,
    required String URI,
    num? approvedQty,
    double? stockMasterQty,
  }) async {
    masterQtys.add(stockMasterQty);
    return RwApiResponse(resultCd: '000', resultMsg: 'ok');
  }
}

Ebm _ebmOn() => Ebm(
  bhfId: '00',
  tinNumber: 999909695,
  dvcSrlNo: 'dvc',
  taxServerUrl: 'https://tax.example/',
  businessId: 'biz1',
  branchId: 'b1',
  vatEnabled: true,
  mrc: 'mrc',
);

WorkOrder _order({String status = 'planned'}) => WorkOrder(
  id: 'wo1',
  branchId: 'b1',
  businessId: 'biz1',
  variantId: 'bread-v',
  variantName: 'Bread',
  plannedQuantity: 20,
  targetDate: DateTime(2026, 11, 23),
  status: status,
);

Variant _bread({String? itemTyCd = '2'}) => Variant(
  id: 'bread-v',
  name: 'Bread',
  branchId: 'b1',
  productId: 'bread-p',
  stockId: 'bread-s',
  itemTyCd: itemTyCd,
  itemCd: 'RW2NTU0000001',
  supplyPrice: 500,
  retailPrice: 800,
);

void main() {
  setUpAll(() => registerFallbackValue(DateTime(2026)));

  group('postProductionOutput', () {
    late _MockDb db;
    late _RecordingTaxApi tax;
    late List<int> sarsHandedOut;

    setUp(() {
      db = _MockDb();
      tax = _RecordingTaxApi();
      sarsHandedOut = [];
      when(
        () => db.getVariant(id: 'bread-v'),
      ).thenAnswer((_) async => _bread());
      when(
        () => db.getProduct(id: 'bread-p', branchId: 'b1', businessId: 'biz1'),
      ).thenAnswer(
        (_) async => Product(
          id: 'bread-p',
          name: 'Bread',
          color: '#000',
          businessId: 'biz1',
          branchId: 'b1',
        ),
      );
      when(() => db.getStockById(id: 'bread-s')).thenAnswer(
        (_) async => Stock(id: 'bread-s', branchId: 'b1', currentStock: 13),
      );
      when(
        () => db.updateStock(
          stockId: any(named: 'stockId'),
          currentStock: any(named: 'currentStock'),
          appending: any(named: 'appending'),
          lastTouched: any(named: 'lastTouched'),
          ebmSynced: any(named: 'ebmSynced'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});
      when(
        () => db.ebm(branchId: 'b1', fetchRemote: false),
      ).thenAnswer((_) async => _ebmOn());
    });

    Future<ProductionStockResult> post(double qty) => postProductionOutput(
      workOrder: _order(status: 'in_progress'),
      qty: qty,
      deps: PurchaseApprovalDeps(strategy: db, capella: db, tax: tax),
      resolveEbm: (_) async => _ebmOn(),
      nextBranchSar: (branchId) async {
        sarsHandedOut.add(41 + sarsHandedOut.length);
        return Sar(sarNo: sarsHandedOut.last, branchId: branchId);
      },
    );

    test('adds the finished goods and reports incoming processing', () async {
      final result = await post(10);

      expect(result.stocked, isTrue);
      expect(result.rraMessage, isNull);
      // No recipe: Books moves each unit into stock at the bread's own cost.
      expect(result.absorbUnitCost, 500);
      verify(
        () => db.updateStock(
          stockId: 'bread-s',
          currentStock: 10,
          appending: true,
          lastTouched: any(named: 'lastTouched'),
          ebmSynced: false,
        ),
      ).called(1);
      final io = tax.ioCalls.single;
      expect(io.sarTyCd, '05');
      expect(io.isStockIn, isTrue);
      expect(io.sarNo, '41');
      expect(io.remark, 'Production output: Bread');
      expect(tax.masterQtys, [13]);
    });

    test('a combo made in production uses up its components', () async {
      when(
        () => db.getProduct(id: 'bread-p', branchId: 'b1', businessId: 'biz1'),
      ).thenAnswer(
        (_) async => Product(
          id: 'bread-p',
          name: 'Bread',
          color: '#000',
          businessId: 'biz1',
          branchId: 'b1',
          isComposite: true,
        ),
      );
      when(() => db.composites(productId: 'bread-p')).thenAnswer(
        (_) async => [
          Composite(productId: 'bread-p', variantId: 'flour', qty: 0.5),
          Composite(productId: 'bread-p', variantId: 'sugar', qty: 20),
          Composite(productId: 'bread-p', variantId: 'oven'),
        ],
      );
      Variant ingredient(String id, {String itemTyCd = '1'}) => Variant(
        id: id,
        name: id,
        branchId: 'b1',
        stockId: '$id-s',
        itemTyCd: itemTyCd,
        itemCd: 'RW1NTU$id',
        supplyPrice: 100,
        retailPrice: 100,
      );
      when(() => db.batchGetVariantsByIds(any())).thenAnswer(
        (_) async => {
          'flour': ingredient('flour'),
          'sugar': ingredient('sugar'),
          // A service component holds no stock and is skipped.
          'oven': ingredient('oven', itemTyCd: '3'),
        },
      );
      Map<String, double>? deducted;
      when(() => db.batchDeductStocks(any())).thenAnswer((inv) async {
        deducted = Map.of(inv.positionalArguments.first as Map<String, double>);
      });
      when(() => db.batchGetStocksByIds(any())).thenAnswer(
        (_) async => {
          'flour-s': Stock(id: 'flour-s', branchId: 'b1', currentStock: 15),
          'sugar-s': Stock(id: 'sugar-s', branchId: 'b1', currentStock: -4),
        },
      );

      final costs = <String, double>{};
      final result = await postProductionOutput(
        workOrder: _order(status: 'in_progress'),
        qty: 10,
        deps: PurchaseApprovalDeps(strategy: db, capella: db, tax: tax),
        resolveEbm: (_) async => _ebmOn(),
        nextBranchSar: (branchId) async {
          sarsHandedOut.add(41 + sarsHandedOut.length);
          return Sar(sarNo: sarsHandedOut.last, branchId: branchId);
        },
        writeSupplyPrice: (id, cost) async => costs[id] = cost,
      );

      expect(result.stocked, isTrue);
      expect(deducted, {'flour-s': 5.0, 'sugar-s': 200.0});
      // A loaf costs 0.5×100 + 20×100 + 1×100 = 2150. 3 loaves were already
      // held at 500, so the average after making 10 is (3×500 + 10×2150) / 13.
      expect(costs.keys, ['bread-v']);
      expect(costs['bread-v'], closeTo((3 * 500 + 10 * 2150) / 13, 0.001));
      // A recipe's components already move within stock: nothing to absorb.
      expect(result.absorbUnitCost, isNull);
      expect(tax.ioCalls.map((c) => (c.sarTyCd, c.isStockIn, c.sarNo)), [
        ('14', false, '41'),
        ('05', true, '42'),
      ]);
      expect(tax.ioCalls.first.remark, 'Used in production: Bread');
      // On-hand after use (never negative), then the bread itself.
      expect(tax.masterQtys, [15, 0, 13]);
    });

    test('a combo sold as made (a service) moves nothing here', () async {
      when(
        () => db.getVariant(id: 'bread-v'),
      ).thenAnswer((_) async => _bread(itemTyCd: '3'));

      final result = await post(10);

      expect(result.stocked, isFalse);
      verifyNever(() => db.composites(productId: any(named: 'productId')));
      expect(tax.ioCalls, isEmpty);
    });

    test('a service holds no stock', () async {
      when(
        () => db.getVariant(id: 'bread-v'),
      ).thenAnswer((_) async => _bread(itemTyCd: '3'));

      expect((await post(10)).stocked, isFalse);
      expect(tax.ioCalls, isEmpty);
    });

    test('no quantity, no movement', () async {
      expect((await post(0)).stocked, isFalse);
      verifyNever(() => db.getVariant(id: any(named: 'id')));
    });

    test('a missing product fails loudly', () async {
      when(() => db.getVariant(id: 'bread-v')).thenAnswer((_) async => null);

      expect(() => post(10), throwsStateError);
    });

    test('an RRA rejection keeps the stock and returns a message', () async {
      tax = _RecordingTaxApi(resultCd: '999');

      final result = await post(10);

      expect(result.stocked, isTrue);
      expect(result.rraMessage, isNotNull);
    });

    test('a branch off EBM is stocked without RRA', () async {
      when(
        () => db.ebm(branchId: 'b1', fetchRemote: false),
      ).thenAnswer((_) async => null);

      final result = await post(10);

      expect(result.stocked, isTrue);
      expect(result.rraMessage, isNull);
      expect(tax.ioCalls, isEmpty);
    });
  });

  group('ProductionOutputService → Books', () {
    late _MockDb db;
    setUp(() {
      db = _MockDb();
      when(
        () => db.recordActualOutput(
          workOrderId: any(named: 'workOrderId'),
          branchId: any(named: 'branchId'),
          actualQuantity: any(named: 'actualQuantity'),
          userId: any(named: 'userId'),
          varianceReason: any(named: 'varianceReason'),
          notes: any(named: 'notes'),
        ),
      ).thenAnswer(
        (_) async => ActualOutput(
          id: 'out-9',
          workOrderId: 'wo1',
          branchId: 'b1',
          actualQuantity: 10,
          userId: 'u1',
        ),
      );
    });

    ProductionOutputService service({
      double? absorb,
      required Future<void> Function(String, ProductionOutputRecord) books,
    }) => ProductionOutputService(
      deps: () => PurchaseApprovalDeps(
        strategy: db,
        capella: db,
        tax: _RecordingTaxApi(),
        branchId: 'b1',
        businessId: 'biz1',
        userId: 'u1',
      ),
      postStock: ({required workOrder, required qty, required deps}) async =>
          ProductionStockResult(stocked: true, absorbUnitCost: absorb),
      postToBooks: books,
    );

    test('a batch made without a recipe is posted at its cost', () async {
      final posted = <(String, ProductionOutputRecord)>[];
      await service(
        absorb: 150,
        books: (biz, record) async => posted.add((biz, record)),
      ).recordActualOutput(workOrder: _order(), actualQuantity: 10);

      final (biz, record) = posted.single;
      expect(biz, 'biz1');
      expect(record.outputId, 'out-9');
      expect(record.productName, 'Bread');
      expect(record.value, 1500);
    });

    test('nothing to absorb posts nothing', () async {
      var calls = 0;
      await service(
        books: (_, _) async => calls++,
      ).recordActualOutput(workOrder: _order(), actualQuantity: 10);
      expect(calls, 0);
    });

    test('a Books failure never undoes the recorded output', () async {
      final recorded = await service(
        absorb: 150,
        books: (_, _) async => throw StateError('ledger offline'),
      ).recordActualOutput(workOrder: _order(), actualQuantity: 10);
      expect(recorded.output?.id, 'out-9');
    });
  });

  group('ProductionOutputService', () {
    late _MockDb db;
    late List<double> posted;
    late ProductionOutputService service;

    setUp(() {
      db = _MockDb();
      posted = [];
      when(
        () => db.updateWorkOrder(
          workOrderId: any(named: 'workOrderId'),
          status: any(named: 'status'),
        ),
      ).thenAnswer((_) async {});
      service = ProductionOutputService(
        deps: () => PurchaseApprovalDeps(
          strategy: db,
          capella: db,
          tax: _RecordingTaxApi(),
          branchId: 'b1',
          businessId: 'biz1',
          userId: 'u1',
        ),
        postStock: ({required workOrder, required qty, required deps}) async {
          posted.add(qty);
          return const ProductionStockResult(
            stocked: true,
            rraMessage: 'tax server down',
          );
        },
      );
    });

    test('starting a planned order only changes its status', () async {
      await service.startWorkOrder(_order());

      verify(
        () => db.updateWorkOrder(workOrderId: 'wo1', status: 'in_progress'),
      ).called(1);
      expect(posted, isEmpty);
      verifyNever(() => db.getVariant(id: any(named: 'id')));
    });

    test('starting an order already under way is a no-op', () async {
      await service.startWorkOrder(_order(status: 'in_progress'));
      await service.startWorkOrder(_order(status: 'completed'));

      verifyNever(
        () => db.updateWorkOrder(
          workOrderId: any(named: 'workOrderId'),
          status: any(named: 'status'),
        ),
      );
    });

    test('recording output saves it, then stocks the quantity', () async {
      when(
        () => db.recordActualOutput(
          workOrderId: 'wo1',
          branchId: 'b1',
          actualQuantity: 12,
          userId: 'u1',
          varianceReason: null,
          notes: null,
        ),
      ).thenAnswer(
        (_) async => ActualOutput(
          workOrderId: 'wo1',
          branchId: 'b1',
          actualQuantity: 12,
          userId: 'u1',
        ),
      );

      final recorded = await service.recordActualOutput(
        workOrder: _order(status: 'in_progress'),
        actualQuantity: 12,
      );

      expect(recorded.output?.actualQuantity, 12);
      expect(recorded.rraMessage, 'tax server down');
      expect(posted, [12]);
    });

    test('an output that was not saved stocks nothing', () async {
      when(
        () => db.recordActualOutput(
          workOrderId: any(named: 'workOrderId'),
          branchId: any(named: 'branchId'),
          actualQuantity: any(named: 'actualQuantity'),
          userId: any(named: 'userId'),
          varianceReason: any(named: 'varianceReason'),
          notes: any(named: 'notes'),
        ),
      ).thenAnswer((_) async => null);

      final recorded = await service.recordActualOutput(
        workOrder: _order(),
        actualQuantity: 12,
      );

      expect(recorded.output, isNull);
      expect(posted, isEmpty);
    });
  });
}
