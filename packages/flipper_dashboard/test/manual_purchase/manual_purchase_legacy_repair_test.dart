import 'package:flipper_dashboard/manual_purchase/manual_purchase_legacy_repair.dart';
import 'package:flipper_models/sync/capella/manual_purchase_ditto.dart';
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

/// Lines, on-hand by stock id and the line flags, kept the way Ditto keeps
/// them: a move is a pair of counter increments, so replaying one (a second
/// offline device) adds up instead of being ignored.
class _FakeStore extends LegacyLineRepairStore {
  _FakeStore({
    required List<Variant> lines,
    required this.catalog,
    required this.onHandById,
  }) : _lines = {for (final l in lines) l.id: l};

  final Map<String, Variant> _lines;
  final List<Variant> catalog;
  final Map<String, double> onHandById;
  final repaired = <String>{};
  final targets = <String, String>{};
  bool isReady = true;
  String? failOnLine;

  @override
  bool get ready => isReady;

  @override
  Future<List<LegacyPurchaseLine>> legacyLines(String branchId) async => [
    for (final line in _lines.values)
      LegacyPurchaseLine(
        line: line,
        repaired: repaired.contains(line.id),
        targetVariantId: targets[line.id],
      ),
  ];

  @override
  Future<List<Variant>> branchVariants(String branchId) async => catalog;

  @override
  Future<double?> onHand(String stockId) async => onHandById[stockId];

  @override
  Future<void> retire(String lineId) async => repaired.add(lineId);

  @override
  Future<void> move({
    required Variant line,
    required Variant target,
    required double qty,
  }) async {
    if (line.id == failOnLine) throw StateError('boom');
    onHandById[line.stockId!] = (onHandById[line.stockId!] ?? 0) - qty;
    onHandById[target.stockId!] = (onHandById[target.stockId!] ?? 0) + qty;
    repaired.add(line.id);
    targets[line.id] = target.id;
  }
}

/// One Primus line (5 on hand) and the one product it was bought for.
_FakeStore _primus({double line = 5, double product = 12}) => _FakeStore(
  lines: [_line()],
  catalog: [_product('v1')],
  onHandById: {'s-line-1': line, 's-v1': product},
);

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

  group('planLegacyLineRepair on a repaired line', () {
    test('settled at zero: nothing to do', () {
      final plan = planLegacyLineRepair(
        line: _line(),
        onHand: 0,
        catalog: [_product('v1')],
        repaired: true,
        repairedTargetId: 'v1',
      );
      expect(plan.action, LegacyLineRepairAction.none);
    });

    test('off zero: back to the product it was given, not a new match', () {
      final plan = planLegacyLineRepair(
        line: _line(itemCd: 'X'),
        onHand: -5,
        catalog: [
          _product('v1'),
          _product('v2', name: 'Other', itemCd: 'X'),
        ],
        repaired: true,
        repairedTargetId: 'v1',
      );
      expect(plan.action, LegacyLineRepairAction.rebalance);
      expect(plan.target!.id, 'v1');
    });
  });

  group('repairLegacyManualPurchaseLines', () {
    test('moves what is left onto the product and retires the line', () async {
      final store = _primus();

      final result = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );

      expect(result.merged, 1);
      expect(store.onHandById, {'s-line-1': 0, 's-v1': 17});
      expect(store.targets, {'line-1': 'v1'});
    });

    test('a second run finds nothing to do', () async {
      final store = _primus();
      await repairLegacyManualPurchaseLines(branchId: 'b1', store: store);

      final again = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );

      expect(again.changedCatalog, isFalse);
      expect(store.onHandById['s-v1'], 17);
    });

    test('two devices moving the same line converge on one move', () async {
      final store = _primus();
      // Both devices saw the line at '02' with 5 on hand before either
      // device's move synced: two moves of 5, merged additively.
      await store.move(line: _line(), target: _product('v1'), qty: 5);
      await store.move(line: _line(), target: _product('v1'), qty: 5);
      expect(store.onHandById, {'s-line-1': -5, 's-v1': 22});

      final result = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );

      expect(result.rebalanced, 1);
      expect(store.onHandById, {'s-line-1': 0, 's-v1': 17});
    });

    test('sold-out lines are retired, unmatched stock is left alone', () async {
      final store = _FakeStore(
        lines: [
          _line(id: 'empty', stockId: 's-empty'),
          _line(id: 'orphan', name: 'Mystery crate', stockId: 's-orphan'),
        ],
        catalog: [_product('v1')],
        onHandById: {'s-empty': 0, 's-orphan': 4, 's-v1': 1},
      );

      final result = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );

      expect(result.retired, 1);
      expect(result.review, ['Mystery crate']);
      expect(store.repaired, {'empty'});
      expect(store.onHandById, {'s-empty': 0, 's-orphan': 4, 's-v1': 1});
    });

    test('Ditto not open yet: reports it did not run', () async {
      final store = _primus()..isReady = false;

      final result = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );

      expect(result.ran, isFalse);
      expect(store.onHandById['s-v1'], 12);
    });

    test('a failing line is counted and the rest still run', () async {
      final store = _FakeStore(
        lines: [
          _line(),
          _line(id: 'line-2', name: 'Mutzig', stockId: 's-line-2'),
        ],
        catalog: [
          _product('v1'),
          _product('v2', name: 'Mutzig'),
        ],
        onHandById: {'s-line-1': 5, 's-line-2': 3, 's-v1': 0, 's-v2': 0},
      )..failOnLine = 'line-1';

      final result = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );

      expect(result.failed, 1);
      expect(result.merged, 1);
      expect(store.onHandById['s-v2'], 3);
      expect(result.complete, isFalse);
    });

    test(
      'a line whose stock has not synced yet waits for a later run',
      () async {
        final store = _primus()..onHandById.remove('s-line-1');

        final result = await repairLegacyManualPurchaseLines(
          branchId: 'b1',
          store: store,
        );

        expect(result.deferred, 1);
        expect(result.complete, isFalse);
        expect(store.repaired, isEmpty);

        // The stock arrives: the next run moves it instead of having retired
        // the line with it.
        store.onHandById['s-line-1'] = 5;
        final later = await repairLegacyManualPurchaseLines(
          branchId: 'b1',
          store: store,
        );
        expect(later.merged, 1);
        expect(later.complete, isTrue);
        expect(store.onHandById, {'s-line-1': 0, 's-v1': 17});
      },
    );
  });

  group('legacyLineBalancesDrifted', () {
    test('a complete run settles; a synced second move drifts', () async {
      final store = _FakeStore(
        lines: [
          _line(),
          _line(id: 'empty', name: 'Mutzig', stockId: 's-empty'),
        ],
        catalog: [_product('v1')],
        onHandById: {'s-line-1': 5, 's-empty': 0, 's-v1': 12},
      );
      final run = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );
      // Only lines whose stock went to a product can drift.
      expect(run.settledStockIds, ['s-line-1']);
      expect(
        await legacyLineBalancesDrifted(run.settledStockIds, store: store),
        isFalse,
      );

      // Another device's move of the same 5 syncs in after this session's
      // run: the re-check catches it and the next run moves it back.
      await store.move(line: _line(), target: _product('v1'), qty: 5);
      expect(
        await legacyLineBalancesDrifted(run.settledStockIds, store: store),
        isTrue,
      );
      final again = await repairLegacyManualPurchaseLines(
        branchId: 'b1',
        store: store,
      );
      expect(again.rebalanced, 1);
      expect(again.settledStockIds, ['s-line-1']);
      expect(store.onHandById, {'s-line-1': 0, 's-empty': 0, 's-v1': 17});
    });

    test('both devices correcting the same balance still converge', () async {
      final store = _primus(line: -5, product: 22);
      store.repaired.add('line-1');
      store.targets['line-1'] = 'v1';

      // Each replica moves the -5 back before seeing the other's correction.
      await store.move(line: _line(), target: _product('v1'), qty: -5);
      await store.move(line: _line(), target: _product('v1'), qty: -5);
      expect(store.onHandById, {'s-line-1': 5, 's-v1': 12});
      expect(
        await legacyLineBalancesDrifted(['s-line-1'], store: store),
        isTrue,
      );

      await repairLegacyManualPurchaseLines(branchId: 'b1', store: store);
      expect(store.onHandById, {'s-line-1': 0, 's-v1': 17});
    });
  });
}
