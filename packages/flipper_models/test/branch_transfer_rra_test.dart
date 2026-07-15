import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/sync/utils/branch_transfer_rra.dart';
import 'package:flipper_models/sync/utils/rra_stock_reporting.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart' as services_locator;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/sars.model.dart';

/// Concrete [TaxApi] fake that records the order + args of the RRA calls the
/// branch-transfer reporter makes. Only [saveStockItems] / [saveStockMaster]
/// are exercised; everything else falls through to [Mock.noSuchMethod].
class RecordingTaxApi extends Mock implements TaxApi {
  final List<String> order = [];
  final List<Map<String, dynamic>> ioCalls = [];

  RwApiResponse ioResponse = RwApiResponse(resultCd: '000', resultMsg: 'ok');
  RwApiResponse masterResponse =
      RwApiResponse(resultCd: '000', resultMsg: 'ok');

  @override
  Future<RwApiResponse> saveStockItems(
      {required List<TransactionItem> items,
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
      bool includeCustomerFields = false}) async {
    order.add('io:$sarTyCd');
    ioCalls.add({
      'sarTyCd': sarTyCd,
      'bhFId': bhFId,
      'tinNumber': tinNumber,
      'custTin': custTin,
      'custBhfId': custBhfId,
      'sarNo': sarNo,
      'invoiceNumber': invoiceNumber,
      'isStockIn': isStockIn,
      'includeCustomerFields': includeCustomerFields,
      'URI': URI,
    });
    return ioResponse;
  }

  @override
  Future<RwApiResponse> saveStockMaster({
    required Variant variant,
    required String URI,
    num? approvedQty,
    double? stockMasterQty,
  }) async {
    order.add('master:${variant.id}');
    return masterResponse;
  }
}

class MockSyncStrategy extends Mock implements SyncStrategy {}

class MockDatabaseSync extends Mock implements DatabaseSyncInterface {}

Ebm _ebm({
  required String branchId,
  required String bhfId,
  String? taxServerUrl,
  int tin = 999909695,
  bool vatEnabled = true,
}) {
  return Ebm(
    bhfId: bhfId,
    tinNumber: tin,
    dvcSrlNo: 'dvc',
    taxServerUrl: taxServerUrl,
    businessId: 'biz1',
    branchId: branchId,
    vatEnabled: vatEnabled,
    mrc: 'mrc',
  );
}

Variant _variant({
  required String id,
  required String branchId,
  required Stock stock,
}) {
  return Variant(
    id: id,
    name: 'Tea',
    branchId: branchId,
    taxTyCd: 'B',
    itemCd: 'RW2AMCT0000138',
    itemClsCd: '5020230602',
    itemTyCd: '2',
    supplyPrice: 25,
    retailPrice: 60,
    stock: stock,
  );
}

BranchTransferApprovedLine _line() {
  final source = _variant(
    id: 'vSrc',
    branchId: 'branchA',
    stock: Stock(id: 'sSrc', branchId: 'branchA', currentStock: 7, rsdQty: 7),
  );
  final dest = _variant(
    id: 'vDst',
    branchId: 'branchB',
    stock: Stock(id: 'sDst', branchId: 'branchB', currentStock: 3, rsdQty: 3),
  );
  return BranchTransferApprovedLine(
    sourceVariant: source,
    destVariant: dest,
    approvedQty: 3,
    itemName: 'Tea',
  );
}

InventoryRequest _request() => InventoryRequest(
      mainBranchId: 'branchA',
      subBranchId: 'branchB',
      branchId: 'branchB',
    );

void main() {
  group('buildRraSaveStockItemsRequest — branch-transfer IN (04)', () {
    final item = TransactionItem(
      id: 'l1',
      name: 'Tea',
      qty: 3,
      price: 60,
      discount: 0,
      prc: 60,
      ttCatCd: 'B',
      itemCd: 'RW2AMCT0000138',
      itemClsCd: '5020230602',
      itemNm: 'Tea',
      itemTyCd: '2',
      supplyPrice: 25,
    );

    Map<String, dynamic> build({required bool includeCustomerFields}) {
      final line = mapRraStockIoItemToJson(item, bhfId: '01', itemSeq: 1);
      return buildRraSaveStockItemsRequest(
        items: [item],
        itemList: [line],
        tinNumber: '999909695',
        bhfId: '01',
        sarTyCd: StockInOutType.stockMovementIn,
        regTyCd: 'M',
        ocrnDt: '20260715',
        totalSupplyPrice: 75,
        totalvat: 0,
        totalAmount: 180,
        remark: 'Stock received from branch 00',
        sarNo: '200',
        orgSarNo: 100,
        saleCustomerName: 'Head Office',
        saleCustTin: '999909695',
        saleCustBhfId: '00',
        includeCustomerFields: includeCustomerFields,
      );
    }

    test('emits cust* on 04 when includeCustomerFields is set', () {
      final body = build(includeCustomerFields: true);
      expect(body['sarTyCd'], StockInOutType.stockMovementIn);
      expect(body['custNm'], 'Head Office');
      expect(body['custTin'], '999909695');
      expect(body['custBhfId'], '00');
    });

    test('omits cust* on 04 by default (other incoming paths unchanged)', () {
      final body = build(includeCustomerFields: false);
      expect(body.containsKey('custNm'), isFalse);
      expect(body.containsKey('custTin'), isFalse);
      expect(body.containsKey('custBhfId'), isFalse);
    });

    test('orgSarNo carries the linked source SAR', () {
      final body = build(includeCustomerFields: true);
      expect(body['orgSarNo'], 100);
      expect(body['sarNo'], '200');
    });
  });

  group('reportBranchTransferToRra', () {
    late RecordingTaxApi tax;
    late MockSyncStrategy strategy;
    late MockDatabaseSync db;

    setUp(() async {
      await services_locator.getIt.reset();
      tax = RecordingTaxApi();
      strategy = MockSyncStrategy();
      db = MockDatabaseSync();

      services_locator.getIt.registerSingleton<TaxApi>(tax);
      services_locator.getIt.registerSingleton<SyncStrategy>(
        strategy,
        instanceName: 'strategy',
      );
      when(() => strategy.current).thenReturn(db);
    });

    tearDown(() async {
      await services_locator.getIt.reset();
    });

    test('skips when no vat-enabled business EBM resolves (no tax calls)',
        () async {
      final result = await reportBranchTransferToRra(
        request: _request(),
        lines: [_line()],
        businessId: 'biz1',
        resolveEbm: (_) async => null,
        nextBranchSar: (branchId) async =>
            Sar(sarNo: 1, branchId: branchId),
      );

      expect(result.attempted, isFalse);
      expect(tax.order, isEmpty);
    });

    test('skips + flags when a branch bhfId cannot be resolved', () async {
      when(() => db.ebm(branchId: 'branchA'))
          .thenAnswer((_) async => _ebm(branchId: 'branchA', bhfId: '00'));
      when(() => db.ebm(branchId: 'branchB')).thenAnswer((_) async => null);

      final result = await reportBranchTransferToRra(
        request: _request(),
        lines: [_line()],
        businessId: 'biz1',
        resolveEbm: (_) async => _ebm(
          branchId: 'branchA',
          bhfId: '00',
          taxServerUrl: 'https://tax.example/',
        ),
        nextBranchSar: (branchId) async =>
            Sar(sarNo: 1, branchId: branchId),
      );

      expect(result.attempted, isFalse);
      expect(result.succeeded, isFalse);
      expect(tax.order, isEmpty);
    });

    test('posts OUT(13) → IN(04) → masters, links orgSarNo, cust* per side',
        () async {
      when(() => db.ebm(branchId: 'branchA'))
          .thenAnswer((_) async => _ebm(branchId: 'branchA', bhfId: '00'));
      when(() => db.ebm(branchId: 'branchB'))
          .thenAnswer((_) async => _ebm(branchId: 'branchB', bhfId: '01'));
      when(() => db.updateStock(
            stockId: any(named: 'stockId'),
            ebmSynced: any(named: 'ebmSynced'),
          )).thenAnswer((_) async {});

      final result = await reportBranchTransferToRra(
        request: _request(),
        lines: [_line()],
        businessId: 'biz1',
        resolveEbm: (_) async => _ebm(
          branchId: 'branchA',
          bhfId: '00',
          taxServerUrl: 'https://tax.example/',
        ),
        // Distinct SARs per branch so the OUT→IN link is unambiguous.
        nextBranchSar: (branchId) async =>
            Sar(sarNo: branchId == 'branchA' ? 100 : 200, branchId: branchId),
      );

      expect(result.attempted, isTrue);
      expect(result.succeeded, isTrue);

      // Call order: source OUT, then dest IN, then both masters.
      expect(tax.order, ['io:13', 'io:04', 'master:vSrc', 'master:vDst']);

      final out = tax.ioCalls[0];
      expect(out['sarTyCd'], StockInOutType.stockMovementOut);
      expect(out['bhFId'], '00');
      expect(out['custBhfId'], '01'); // counterparty = destination
      expect(out['isStockIn'], isFalse);
      expect(out['includeCustomerFields'], isFalse);
      expect(out['sarNo'], '100');
      expect(out['invoiceNumber'], 100);
      expect(out['URI'], 'https://tax.example/');

      final incoming = tax.ioCalls[1];
      expect(incoming['sarTyCd'], StockInOutType.stockMovementIn);
      expect(incoming['bhFId'], '01');
      expect(incoming['custBhfId'], '00'); // counterparty = source
      expect(incoming['isStockIn'], isTrue);
      expect(incoming['includeCustomerFields'], isTrue);
      expect(incoming['sarNo'], '200');
      // orgSarNo on IN links back to A's OUT sarNo.
      expect(incoming['invoiceNumber'], 100);
      expect(incoming['invoiceNumber'], out['invoiceNumber']);

      // Local stocks flagged ebmSynced once masters return 000.
      verify(() => db.updateStock(stockId: 'sSrc', ebmSynced: true)).called(1);
      verify(() => db.updateStock(stockId: 'sDst', ebmSynced: true)).called(1);
    });

    test('OUT failure aborts before IN / masters', () async {
      when(() => db.ebm(branchId: 'branchA'))
          .thenAnswer((_) async => _ebm(branchId: 'branchA', bhfId: '00'));
      when(() => db.ebm(branchId: 'branchB'))
          .thenAnswer((_) async => _ebm(branchId: 'branchB', bhfId: '01'));
      tax.ioResponse = RwApiResponse(resultCd: '894', resultMsg: 'rejected');

      final result = await reportBranchTransferToRra(
        request: _request(),
        lines: [_line()],
        businessId: 'biz1',
        resolveEbm: (_) async => _ebm(
          branchId: 'branchA',
          bhfId: '00',
          taxServerUrl: 'https://tax.example/',
        ),
        nextBranchSar: (branchId) async =>
            Sar(sarNo: branchId == 'branchA' ? 100 : 200, branchId: branchId),
      );

      expect(result.attempted, isTrue);
      expect(result.succeeded, isFalse);
      expect(result.message, 'rejected');
      // Only the OUT call happened.
      expect(tax.order, ['io:13']);
    });
  });
}
