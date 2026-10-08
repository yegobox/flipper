import 'package:flipper_dashboard/manual_purchase/manual_purchase_legacy_repair.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

/// A legacy manual purchase line: approved to '02' by a pre-#710 build.
Variant _line({
  String id = 'line-1',
  String name = 'Primus 72cl',
  String? itemCd,
  String? bcd,
  String stockId = 's-line-1',
}) => Variant(
  id: id,
  name: name,
  itemNm: name,
  branchId: 'b1',
  itemCd: itemCd,
  bcd: bcd,
  purchaseId: 'p1',
  pchsSttsCd: '02',
  stockId: stockId,
);

Variant _product(
  String id, {
  String name = 'Primus 72cl',
  String? itemCd,
  String? bcd,
  String branchId = 'b1',
  String? purchaseId,
  String? pchsSttsCd,
}) => Variant(
  id: id,
  name: name,
  itemNm: name,
  branchId: branchId,
  productId: 'prod-$id',
  itemCd: itemCd,
  bcd: bcd,
  purchaseId: purchaseId,
  pchsSttsCd: pchsSttsCd,
  stockId: 's-$id',
);

LegacyLineRepairPlan _plan(
  Variant line,
  List<Variant> catalog, {
  double onHand = 5,
}) => planLegacyLineRepair(line: line, onHand: onHand, catalog: catalog);

class _FakeStore extends LegacyLineRepairStore {
  _FakeStore({required this.lines, required this.catalog});

  final List<Variant> lines;
  final List<Variant> catalog;
  final retired = <String, String?>{};

  @override
  Future<List<Variant>> legacyLines(String branchId) async =>
      lines.where((l) => !retired.containsKey(l.id)).toList();

  @override
  Future<List<Variant>> branchVariants(String branchId) async => catalog;

  @override
  Future<void> retire({required String lineId, String? targetVariantId}) async {
    retired[lineId] = targetVariantId;
  }
}

/// Stocks by id, with the two updateStock modes the repair uses.
class _FakeCapella extends Fake implements DatabaseSyncInterface {
  _FakeCapella(this.onHand);

  final Map<String, double> onHand;

  @override
  Future<Stock?> getStockById({required String id}) async {
    final qty = onHand[id];
    return qty == null
        ? null
        : Stock(id: id, branchId: 'b1', currentStock: qty);
  }

  @override
  Future<void> updateStock({
    required String stockId,
    double? qty,
    double? rsdQty,
    double? initialStock,
    bool? ebmSynced,
    double? currentStock,
    double? value,
    bool appending = false,
    DateTime? lastTouched,
  }) async {
    if (currentStock == null) return;
    onHand[stockId] = appending
        ? (onHand[stockId] ?? 0) + currentStock
        : currentStock;
  }
}

void main() {
  group('planLegacyLineRepair', () {
    test('nothing on hand is only retired', () {
      final plan = _plan(_line(), [_product('v1')], onHand: 0);
      expect(plan.action, LegacyLineRepairAction.retire);
      expect(plan.target, isNull);
    });

    test('item code beats barcode beats name', () {
      final byCode = _product('code', name: 'Other', itemCd: 'RW1NTBA0001');
      final byBarcode = _product('bar', name: 'Other 2', bcd: '6001');
      final byName = _product('name');
      final line = _line(itemCd: 'RW1NTBA0001', bcd: '6001');

      expect(_plan(line, [byName, byBarcode, byCode]).target, byCode);
      expect(
        _plan(_line(bcd: '6001'), [byName, byBarcode, byCode]).target,
        byBarcode,
      );
      expect(_plan(_line(), [byName, byBarcode, byCode]).target, byName);
    });

    test('names match case- and space-insensitively', () {
      final plan = _plan(_line(name: '  primus 72CL '), [_product('v1')]);
      expect(plan.action, LegacyLineRepairAction.merge);
      expect(plan.target!.id, 'v1');
    });

    test('two products with the same name are left for review', () {
      final plan = _plan(_line(), [_product('v1'), _product('v2')]);
      expect(plan.action, LegacyLineRepairAction.review);
    });

    test('an ambiguous code falls through to a unique name', () {
      final plan = _plan(_line(itemCd: 'X'), [
        _product('a', name: 'A', itemCd: 'X'),
        _product('b', name: 'B', itemCd: 'X'),
        _product('c'),
      ]);
      expect(plan.target!.id, 'c');
    });

    test('never another purchase line, a hidden row or another branch', () {
      final plan = _plan(_line(), [
        _line(id: 'line-2'),
        _product('rec', purchaseId: 'p2', pchsSttsCd: '03'),
        _product('waiting', pchsSttsCd: '01'),
        _product('elsewhere', branchId: 'b2'),
        Variant(id: 'no-product', name: 'Primus 72cl', branchId: 'b1'),
      ]);
      expect(plan.action, LegacyLineRepairAction.review);
    });

    test('the line never matches itself', () {
      final line = _line();
      final self = _line()..productId = 'prod-self';
      expect(_plan(line, [self]).action, LegacyLineRepairAction.review);
    });
  });

  group('repairLegacyManualPurchaseLines', () {
    test('moves what is left onto the product and retires the line', () async {
      final store = _FakeStore(lines: [_line()], catalog: [_product('v1')]);
      final capella = _FakeCapella({'s-line-1': 5, 's-v1': 12});

      final result = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        capella: capella,
        store: store,
      );

      expect(result.merged, 1);
      expect(capella.onHand['s-v1'], 17);
      expect(capella.onHand['s-line-1'], 0);
      expect(store.retired, {'line-1': 'v1'});
    });

    test('a second run finds nothing to do', () async {
      final store = _FakeStore(lines: [_line()], catalog: [_product('v1')]);
      final capella = _FakeCapella({'s-line-1': 5, 's-v1': 12});

      await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        capella: capella,
        store: store,
      );
      final again = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        capella: capella,
        store: store,
      );

      expect(again.merged + again.retired, 0);
      expect(capella.onHand['s-v1'], 17);
    });

    test('sold-out lines are retired, unmatched stock is left alone', () async {
      final store = _FakeStore(
        lines: [
          _line(id: 'empty', stockId: 's-empty'),
          _line(id: 'orphan', name: 'Mystery crate', stockId: 's-orphan'),
        ],
        catalog: [_product('v1')],
      );
      final capella = _FakeCapella({'s-empty': 0, 's-orphan': 4, 's-v1': 1});

      final result = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        capella: capella,
        store: store,
      );

      expect(result.retired, 1);
      expect(result.review, ['Mystery crate']);
      expect(store.retired, {'empty': null});
      expect(capella.onHand['s-orphan'], 4);
      expect(capella.onHand['s-v1'], 1);
    });
  });
}
