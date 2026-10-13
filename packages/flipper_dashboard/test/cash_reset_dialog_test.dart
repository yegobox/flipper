import 'package:flipper_dashboard/features/admin/widgets/cash_reset_dialog.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/cash_movement_reset_client.dart';
import 'package:flipper_models/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _FakeClient extends CashMovementResetClient {
  _FakeClient() : super(baseUrl: () async => 'https://unused.test/');

  final previews = <Set<CashMovementKind>>[];
  final resets = <(Set<CashMovementKind>, String)>[];
  int transactions = 3;

  CashResetSummary _summary({required bool deleted}) => CashResetSummary(
    businessName: 'Kigali Shop',
    dryRun: !deleted,
    deleted: deleted,
    transactions: transactions,
    journalEntries: 1,
    totalAmount: 1750,
    byKind: const {
      CashMovementKind.cashOut: CashResetKindTotals(count: 2, amount: 1250),
      CashMovementKind.cashIn: CashResetKindTotals(count: 1, amount: 500),
    },
  );

  @override
  Future<CashResetSummary> preview(Set<CashMovementKind> kinds) async {
    previews.add(kinds);
    return _summary(deleted: false);
  }

  @override
  Future<CashResetSummary> reset(
    Set<CashMovementKind> kinds, {
    required String confirm,
  }) async {
    resets.add((kinds, confirm));
    return _summary(deleted: true);
  }
}

void main() {
  Widget host(_FakeClient fake, {CashResetAdminCheck? verifyAdmin}) =>
      ProviderScope(
        overrides: [
          cashMovementResetClientProvider.overrideWithValue(fake),
          defaultCurrencyProvider.overrideWithValue('RWF'),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates:
              FlipperAppLocalizations.localizationsDelegates,
          supportedLocales: FlipperAppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () =>
                      showCashResetDialog(context, verifyAdmin: verifyAdmin),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      );

  FilledButton button(WidgetTester tester, String key) =>
      tester.widget<FilledButton>(find.byKey(ValueKey(key)));

  testWidgets('previews, gates on the business name, then deletes', (
    tester,
  ) async {
    final fake = _FakeClient();
    await tester.pumpWidget(host(fake));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Only Cash Out.
    await tester.tap(find.byKey(const ValueKey('cash-reset-cash_in')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cash-reset-preview')));
    await tester.pumpAndSettle();

    expect(fake.previews.single, {CashMovementKind.cashOut});
    expect(find.textContaining('Cash out: 2'), findsOneWidget);
    expect(find.textContaining('Cash in:'), findsNothing);
    expect(button(tester, 'cash-reset-delete').onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('cash-reset-confirm')),
      'Kigali',
    );
    await tester.pump();
    expect(button(tester, 'cash-reset-delete').onPressed, isNull);

    await tester.enterText(
      find.byKey(const ValueKey('cash-reset-confirm')),
      'kigali shop',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cash-reset-delete')));
    await tester.pumpAndSettle();

    expect(fake.resets.single.$1, {CashMovementKind.cashOut});
    expect(fake.resets.single.$2, 'kigali shop');
    expect(find.byType(CashResetDialog), findsNothing);
    expect(find.text('Deleted 3 records.'), findsOneWidget);
  });

  testWidgets('a refused admin PIN deletes nothing', (tester) async {
    final fake = _FakeClient();
    await tester.pumpWidget(host(fake, verifyAdmin: (_) async => false));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cash-reset-preview')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('cash-reset-confirm')),
      'Kigali Shop',
    );
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('cash-reset-delete')));
    await tester.pumpAndSettle();

    expect(fake.resets, isEmpty);
    expect(find.byType(CashResetDialog), findsOneWidget);
  });

  testWidgets('nothing to delete offers only Close', (tester) async {
    final fake = _FakeClient()..transactions = 0;
    await tester.pumpWidget(host(fake));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cash-reset-preview')));
    await tester.pumpAndSettle();

    expect(find.text('There is nothing to delete.'), findsOneWidget);
    expect(find.byKey(const ValueKey('cash-reset-delete')), findsNothing);
    expect(find.text('Close'), findsOneWidget);
  });
}
