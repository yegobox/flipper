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
  _FakeViewModel(
    super.ref,
    List<Purchase> purchases, {
    List<Variant>? imports,
  }) {
    state = state.copyWith(
      purchases: purchases,
      importItems: imports ?? const [],
    );
  }

  final approvedImports = <({String id, double? retail, double? supply})>[];
  int approveAllCalls = 0;
  final failedRows = <String>{};

  @override
  bool canRetryRow(String id) => failedRows.contains(id);

  /// What a reload does: fresh item objects from the server.
  void reloadImports(List<Variant> fresh) {
    state = state.copyWith(importItems: fresh);
  }

  @override
  Future<void> loadList() async {}

  @override
  void setPurchaseStatusFilter(String filter) {
    state = state.copyWith(purchaseStatusFilter: filter);
  }

  @override
  void toggleImportPurchase(bool isImport) {
    state = state.copyWith(isImport: isImport);
  }

  @override
  Future<void> approveImport({
    required Variant variant,
    String? targetVariantId,
    double? retailPrice,
    double? supplyPrice,
    String? itemNm,
  }) async {
    approvedImports.add((
      id: variant.id,
      retail: retailPrice,
      supply: supplyPrice,
    ));
  }

  @override
  Future<void> approveAllImports({
    required List<Variant> variants,
    required Map<String, List<Variant>> variantMap,
  }) async {
    approveAllCalls++;
  }
}

Variant _import(String name, {double? supply, double? retail}) => Variant(
  name: name,
  itemNm: name,
  branchId: 'b1',
  imptItemSttsCd: '2',
  qty: 25600,
  qtyUnitCd: 'BE',
  hsCd: '69010000000',
  spplrNm: 'GOODWILL (TANZANIA) CERAMIC CO.,LTD MKURANGA-TANZANIA',
  orgnNatCd: 'TZ',
  supplyPrice: supply,
  retailPrice: retail,
);

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

late _FakeViewModel _vm;

Future<void> _pump(
  WidgetTester tester,
  Size size, {
  List<Variant> imports = const [],
}) async {
  tester.view.physicalSize = size * 3;
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        importPurchaseViewModelProvider.overrideWith(
          (ref) => _vm = _FakeViewModel(ref, _purchases, imports: imports),
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

  group('imports', () {
    List<Variant> fresh() => [
      _import('PORCELAIN FLOOR TILE')..id = 'imp-1',
      _import('EAC BROWN SUGAR EX MALAWI', supply: 200, retail: 300)
        ..id = 'imp-2',
    ];
    late List<Variant> items;
    setUp(() => items = fresh());

    Future<void> openImports(WidgetTester tester, Size size) async {
      await _pump(tester, size, imports: items);
      await tester.tap(find.text('Imports').last);
      await tester.pumpAndSettle();
    }

    for (final size in const [Size(320, 640), Size(390, 844)]) {
      testWidgets('lays out without overflow at ${size.width.toInt()}pt', (
        tester,
      ) async {
        await openImports(tester, size);
        expect(find.text('PORCELAIN FLOOR TILE'), findsOneWidget);
        expect(find.text('Set prices before approving'), findsOneWidget);
        expect(find.text('Approve all 2 waiting'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }

    testWidgets('approve all refuses items without prices', (tester) async {
      await openImports(tester, const Size(390, 844));
      await tester.tap(find.text('Approve all 2 waiting'));
      await tester.pumpAndSettle();
      expect(_vm.approveAllCalls, 0);
      expect(
        find.textContaining('need a supply and retail price'),
        findsOneWidget,
      );
    });

    testWidgets('pricing an item in its sheet and approving it', (
      tester,
    ) async {
      await openImports(tester, const Size(390, 844));
      await tester.tap(find.text('PORCELAIN FLOOR TILE'));
      await tester.pumpAndSettle();

      // Approve without prices is blocked in the sheet.
      await tester.tap(find.widgetWithText(FilledButton, 'Approve'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Enter both prices'), findsOneWidget);

      final fields = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(1), '250');
      await tester.enterText(fields.at(2), '500');
      await tester.tap(find.widgetWithText(FilledButton, 'Approve'));
      await tester.pumpAndSettle();

      expect(_vm.approvedImports, hasLength(1));
      expect(_vm.approvedImports.single.supply, 250);
      expect(_vm.approvedImports.single.retail, 500);
    });

    testWidgets('saved prices survive a reload', (tester) async {
      await openImports(tester, const Size(390, 844));
      await tester.tap(find.text('PORCELAIN FLOOR TILE'));
      await tester.pumpAndSettle();
      final fields = find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      );
      await tester.enterText(fields.at(1), '250');
      await tester.enterText(fields.at(2), '500');
      await tester.tap(find.text('Save for later'));
      await tester.pumpAndSettle();

      _vm.reloadImports(fresh());
      await tester.pumpAndSettle();
      expect(find.text('Set prices before approving'), findsNothing);
      expect(find.text('Cost 250 · sells at 500'), findsOneWidget);
    });

    testWidgets('a failed item can be retried or approved anew', (
      tester,
    ) async {
      await openImports(tester, const Size(390, 844));
      _vm.failedRows.add(items.first.id);
      await tester.tap(find.text('PORCELAIN FLOOR TILE'));
      await tester.pumpAndSettle();
      expect(find.text('Retry with previous values'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Approve'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
    });
  });
}
