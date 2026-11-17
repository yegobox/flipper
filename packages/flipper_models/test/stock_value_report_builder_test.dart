import 'package:flipper_models/providers/stock_value_report_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/variant.model.dart';

Variant _variant(
  String id, {
  String? name,
  double retail = 100,
  double supply = 0,
  String? categoryId,
  String? categoryName,
  String? itemTyCd,
}) => Variant(
  id: id,
  name: name ?? id,
  branchId: 'b1',
  stockId: 's_$id',
  retailPrice: retail,
  supplyPrice: supply,
  categoryId: categoryId,
  categoryName: categoryName,
  itemTyCd: itemTyCd,
);

Map<String, dynamic> _stock(
  double qty, {
  double lowStock = 0,
  bool alert = true,
  int? milli,
}) => {
  'currentStock': qty,
  'lowStock': lowStock,
  'showLowStockAlert': alert,
  if (milli != null) 'currentStockMilli': milli,
};

StockValueReportData _build(
  List<Variant> variants,
  Map<String, Map<String, dynamic>> stockByVariant, {
  Map<String, String> categoryNames = const {},
}) => buildStockValueReport(
  branchId: 'b1',
  variants: variants,
  stockById: {for (final e in stockByVariant.entries) 's_${e.key}': e.value},
  categoryNames: categoryNames,
);

StockValueProductLine _line(StockValueReportData r, String id) =>
    r.allProducts.singleWhere((l) => l.variantId == id);

void main() {
  test('zero and negative stock are out of stock, not healthy', () {
    final r = _build(
      [_variant('none'), _variant('neg'), _variant('missing'), _variant('ok')],
      {'none': _stock(0), 'neg': _stock(-4), 'ok': _stock(3)},
    );

    expect(_line(r, 'none').status, StockValueLineStatus.out);
    expect(_line(r, 'neg').status, StockValueLineStatus.out);
    // No stock document at all reads as nothing on hand.
    expect(_line(r, 'missing').status, StockValueLineStatus.out);
    expect(_line(r, 'ok').status, StockValueLineStatus.ok);
    expect(r.outOfStockCount, 3);
    expect(r.healthyStockCount, 1);
  });

  test('a negative count adds no value instead of subtracting it', () {
    final r = _build(
      [_variant('neg'), _variant('ok')],
      {'neg': _stock(-10), 'ok': _stock(2)},
    );

    expect(_line(r, 'neg').lineValue, 0);
    expect(r.totalValue, 200);
  });

  test('services are left out: they have no stock to value', () {
    final r = _build(
      [_variant('svc', itemTyCd: '3'), _variant('good', itemTyCd: '2')],
      {'svc': _stock(0), 'good': _stock(1)},
    );

    expect(r.productsCount, 1);
    expect(r.allProducts.single.variantId, 'good');
  });

  test('the COUNTER wins over the lagging register', () {
    final r = _build([_variant('a')], {'a': _stock(10, milli: 4000)});

    expect(_line(r, 'a').currentStock, 4);
    expect(r.totalValue, 400);
  });

  test(
    'low, critical and out are exclusive; restock count keeps its meaning',
    () {
      final r = _build(
        [_variant('low'), _variant('crit'), _variant('zeroAlert')],
        {
          'low': _stock(4, lowStock: 5),
          'crit': _stock(2, lowStock: 5),
          'zeroAlert': _stock(0, lowStock: 5),
        },
      );

      expect(_line(r, 'low').status, StockValueLineStatus.low);
      expect(_line(r, 'crit').status, StockValueLineStatus.critical);
      expect(_line(r, 'zeroAlert').status, StockValueLineStatus.out);
      expect(r.lowCount, 1);
      expect(r.criticalCount, 1);
      expect(r.outOfStockCount, 1);
      // The dashboard tile counts every fired alert, the empty one included.
      expect(r.needsRestockCount, 3);
      expect(r.lowAndCriticalItems.first.severity, StockSeverity.critical);
    },
  );

  test('category ids are shown as names; unknown ids never leak', () {
    const uuid = 'cf3bbf6c-e8e3-40c0-bd2c-a0bf00000001';
    const other = '575cc7cb-56ab-4137-8026-1e0f30000002';
    final r = _build(
      [
        _variant('byId', categoryId: 'c1', categoryName: 'Old name'),
        _variant('idInName', categoryName: uuid),
        _variant('unknownId', categoryName: other),
        _variant('plain', categoryName: ' Drinks '),
        _variant('none'),
      ],
      {
        for (final id in ['byId', 'idInName', 'unknownId', 'plain', 'none'])
          id: _stock(1),
      },
      categoryNames: {'c1': 'Hardware', uuid: 'Plumbing'},
    );

    expect(_line(r, 'byId').categoryName, 'Hardware');
    expect(_line(r, 'idInName').categoryName, 'Plumbing');
    expect(_line(r, 'unknownId').categoryName, kStockValueOtherCategory);
    expect(_line(r, 'plain').categoryName, 'Drinks');
    expect(_line(r, 'none').categoryName, kStockValueOtherCategory);
    expect(
      r.valueByCategory.map((c) => c.categoryName),
      isNot(contains(other)),
    );
  });

  test('cost and margin only count lines whose cost is known', () {
    final r = _build(
      [
        _variant('costed', retail: 150, supply: 100),
        _variant('noCost', retail: 500),
      ],
      {'costed': _stock(2), 'noCost': _stock(1)},
    );

    expect(r.totalValue, 800);
    expect(r.totalCostValue, 200);
    expect(r.marginValue, 100);
  });

  test('rows come most valuable first, and the top item matches', () {
    final r = _build(
      [
        _variant('small', retail: 10),
        _variant('big', retail: 1000),
        _variant('mid', retail: 100),
      ],
      {'small': _stock(1), 'big': _stock(1), 'mid': _stock(1)},
    );

    expect(r.allProducts.map((l) => l.variantId), ['big', 'mid', 'small']);
    expect(r.topByLineValue?.name, 'big');
  });

  group('expiry', () {
    final now = DateTime.utc(2026, 11, 17, 12);
    Variant expiring(String id, DateTime? at, {double retail = 10}) {
      final v = _variant(id, retail: retail);
      v.expirationDate = at;
      return v;
    }

    StockValueReportData build(
      List<Variant> variants,
      Map<String, Map<String, dynamic>> stocks,
    ) => buildStockValueReport(
      branchId: 'b1',
      variants: variants,
      stockById: {for (final e in stocks.entries) 's_${e.key}': e.value},
      now: now,
    );

    test('a catalogue without dates does not track expiry', () {
      final r = build([_variant('a')], {'a': _stock(3)});

      expect(r.tracksExpiry, isFalse);
      expect(r.expiredCount, 0);
      expect(r.expiryAlerts, isEmpty);
      expect(_line(r, 'a').expiryState, StockExpiryState.none);
    });

    test('past dates are expired, the next 30 days are soon', () {
      final r = build(
        [
          expiring('past', now.subtract(const Duration(days: 2))),
          expiring(
            'edge',
            now.add(const Duration(days: kStockExpiringSoonDays)),
          ),
          expiring('later', now.add(const Duration(days: 31))),
          expiring('soon', now.add(const Duration(days: 3))),
          _variant('none'),
        ],
        {
          'past': _stock(4),
          'edge': _stock(1),
          'later': _stock(1),
          'soon': _stock(1),
          'none': _stock(1),
        },
      );

      expect(r.tracksExpiry, isTrue);
      expect(_line(r, 'past').expiryState, StockExpiryState.expired);
      expect(_line(r, 'soon').expiryState, StockExpiryState.soon);
      expect(_line(r, 'edge').expiryState, StockExpiryState.soon);
      expect(_line(r, 'later').expiryState, StockExpiryState.ok);
      expect(_line(r, 'none').expiryState, StockExpiryState.none);
      expect(r.expiredCount, 1);
      expect(r.expiredValue, 40); // 4 units x 10
      expect(r.expiringSoonCount, 2);
      // Expired first, then soonest.
      expect(r.expiryAlerts.map((l) => l.variantId), ['past', 'soon', 'edge']);
    });

    test('an expired date on an empty shelf needs no action', () {
      final r = build(
        [expiring('gone', now.subtract(const Duration(days: 9)))],
        {'gone': _stock(0)},
      );

      expect(r.tracksExpiry, isTrue);
      expect(_line(r, 'gone').expiryState, StockExpiryState.ok);
      expect(_line(r, 'gone').expiryDate, isNotNull);
      expect(r.expiredCount, 0);
      expect(r.expiryAlerts, isEmpty);
    });
  });
}
