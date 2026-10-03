import 'package:flipper_dashboard/features/import_purchase/purchases_mobile_screen.dart';
import 'package:flipper_dashboard/import_purchase_viewmodel.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MockBox extends Mock implements LocalStorage {
  @override
  String defaultCurrency() => 'RWF';

  @override
  String? getBranchId() => 'b1';
}

/// Serves a fixed list; filtering mirrors the real view model's state change
/// without the RRA / Ditto round trip.
class _FakeViewModel extends ImportPurchaseViewModel {
  _FakeViewModel(super.ref, List<Purchase> purchases) {
    state = state.copyWith(purchases: purchases);
  }

  @override
  Future<void> loadList() async {}

  @override
  void setPurchaseStatusFilter(String filter) {
    state = state.copyWith(purchaseStatusFilter: filter);
  }
}

Variant _line(String name, String status, double qty, double price) => Variant(
  name: name,
  itemNm: name,
  branchId: 'b1',
  pchsSttsCd: status,
  qty: qty,
  prc: price,
  totAmt: qty * price,
);

Purchase _purchase({
  required String supplier,
  required int invoice,
  required String pmtTyCd,
  required String regTyCd,
  required List<Variant> lines,
}) {
  final total = lines.fold<double>(0, (s, l) => s + (l.totAmt ?? 0));
  return Purchase(
    spplrTin: '',
    spplrNm: supplier,
    spplrBhfId: '00',
    spplrInvcNo: invoice,
    rcptTyCd: 'P',
    pmtTyCd: pmtTyCd,
    cfmDt: '',
    salesDt: '',
    totItemCnt: lines.length,
    taxblAmtA: 0,
    taxblAmtB: total,
    taxblAmtC: 0,
    taxblAmtD: 0,
    taxRtA: 0,
    taxRtB: 18,
    taxRtC: 0,
    taxRtD: 0,
    taxAmtA: 0,
    taxAmtB: 0,
    taxAmtC: 0,
    taxAmtD: 0,
    totTaxblAmt: total,
    totTaxAmt: 0,
    totAmt: total,
    regTyCd: regTyCd,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    variants: lines,
  );
}

final _purchases = [
  _purchase(
    supplier: 'Kigali Wholesale Distributors Ltd',
    invoice: 4521,
    pmtTyCd: '02',
    regTyCd: 'M',
    lines: [_line('Rice 25kg', '01', 4, 29500)],
  ),
  _purchase(
    supplier: 'DAPA Analytics Ltd',
    invoice: 666,
    pmtTyCd: '01',
    regTyCd: 'A',
    lines: [_line('Toner', '01', 2, 50000), _line('Paper', '01', 10, 4000)],
  ),
  _purchase(
    supplier: 'KAPP',
    invoice: 77,
    pmtTyCd: '01',
    regTyCd: 'A',
    lines: [_line('Soap', '02', 5, 1000)],
  ),
];

Future<void> _pump(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        importPurchaseViewModelProvider.overrideWith(
          (ref) => _FakeViewModel(ref, _purchases),
        ),
      ],
      child: const MaterialApp(home: PurchasesMobileScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<LocalStorage>(_MockBox());
  });

  for (final size in const [Size(320, 640), Size(390, 844)]) {
    testWidgets('waiting list lays out at ${size.width.toInt()}pt', (
      tester,
    ) async {
      await _pump(tester, size);
      expect(find.text('Record purchase'), findsOneWidget);
      // Waiting is the default filter: the approved KAPP invoice is hidden.
      expect(find.text('Kigali Wholesale Distributors Ltd'), findsOneWidget);
      expect(find.text('DAPA Analytics Ltd'), findsOneWidget);
      expect(find.text('KAPP'), findsNothing);
      expect(find.text('On credit'), findsOneWidget);
      expect(find.text('Recorded'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('approved chip shows approved purchases', (tester) async {
    await _pump(tester, const Size(390, 844));
    await tester.tap(find.widgetWithText(ChoiceChip, 'Approved'));
    await tester.pumpAndSettle();
    expect(find.text('KAPP'), findsOneWidget);
    expect(find.text('DAPA Analytics Ltd'), findsNothing);
  });

  testWidgets('RRA invoice detail asks to match items before accepting', (
    tester,
  ) async {
    await _pump(tester, const Size(390, 844));
    await tester.tap(find.text('DAPA Analytics Ltd'));
    await tester.pumpAndSettle();
    expect(find.text('Toner'), findsOneWidget);
    expect(find.text('Match to my item'), findsNWidgets(2));
    expect(find.text('Accept (2 to match)'), findsOneWidget);
    expect(find.text('Decline'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('recorded purchase needs no matching', (tester) async {
    await _pump(tester, const Size(390, 844));
    await tester.tap(find.text('Kigali Wholesale Distributors Ltd'));
    await tester.pumpAndSettle();
    expect(find.text('Match to my item'), findsNothing);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Credit'), findsOneWidget);
  });
}
