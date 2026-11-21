import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/sync/utils/purchase_stock_rra.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/sars.model.dart';

// flutter test test/purchase_stock_rra_test.dart
//
// A purchased variant without a tax code used to be reported as B. A branch
// on EBM without VAT registration may send only D, so RRA rejected the stock-in.

class _MockDb extends Mock implements DatabaseSyncInterface {}

/// Records the items of each `saveStockItems` call; answers 000 to all.
class _RecordingTaxApi extends Mock implements TaxApi {
  final List<List<TransactionItem>> ioItems = [];

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
    ioItems.add(items);
    return RwApiResponse(resultCd: '000', resultMsg: 'ok');
  }

  @override
  Future<RwApiResponse> saveStockMaster({
    required Variant variant,
    required String URI,
    num? approvedQty,
    double? stockMasterQty,
  }) async => RwApiResponse(resultCd: '000', resultMsg: 'ok');
}

Ebm _ebm({required bool vatEnabled, bool? ebmEnabled}) => Ebm(
  bhfId: '00',
  tinNumber: 999909695,
  dvcSrlNo: 'dvc',
  taxServerUrl: 'https://tax.example/',
  businessId: 'biz1',
  branchId: 'b1',
  vatEnabled: vatEnabled,
  ebmEnabled: ebmEnabled,
  mrc: 'mrc',
);

PurchaseStockInLine _line(String? taxTyCd) => PurchaseStockInLine(
  variant: Variant(
    id: 'v1',
    name: 'Sugar',
    branchId: 'b1',
    taxTyCd: taxTyCd,
    itemCd: 'RW2AMCT0000138',
    supplyPrice: 900,
    retailPrice: 1200,
  ),
  qty: 5,
  onHandAfter: 12,
);

void main() {
  late _MockDb db;
  late _RecordingTaxApi tax;

  setUp(() {
    db = _MockDb();
    tax = _RecordingTaxApi();
  });

  Future<List<TransactionItem>> report(
    Ebm branchEbm,
    PurchaseStockInLine line,
  ) async {
    when(
      () => db.ebm(branchId: 'b1', fetchRemote: false),
    ).thenAnswer((_) async => branchEbm);
    final result = await reportPurchaseStockInToRra(
      branchId: 'b1',
      lines: [line],
      supplierName: 'Supplier',
      deps: PurchaseApprovalDeps(strategy: db, capella: db, tax: tax),
      businessId: 'biz1',
      resolveEbm: (_) async => branchEbm,
      nextBranchSar: (branchId) async => Sar(sarNo: 7, branchId: branchId),
    );
    expect(result.attempted, isTrue);
    expect(result.succeeded, isTrue);
    return tax.ioItems.single;
  }

  test('an uncoded line is D on an EBM branch without VAT', () async {
    final items = await report(
      _ebm(vatEnabled: false, ebmEnabled: true),
      _line(null),
    );
    expect(items.single.taxTyCd, 'D');
    expect(items.single.ttCatCd, 'D');
  });

  test('an uncoded line is still B on a VAT-registered branch', () async {
    final items = await report(_ebm(vatEnabled: true), _line(null));
    expect(items.single.taxTyCd, 'B');
  });

  test('an explicit code is kept', () async {
    final items = await report(
      _ebm(vatEnabled: false, ebmEnabled: true),
      _line('A'),
    );
    expect(items.single.taxTyCd, 'A');
  });
}
