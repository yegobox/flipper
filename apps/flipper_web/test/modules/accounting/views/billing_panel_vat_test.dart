import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/data/services/vat_position_service.dart';
import 'package:flipper_web/modules/accounting/views/desktop/billing_views.dart';
import 'package:flipper_web/modules/accounting/widgets/v3_doc_panels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/fake_accounting_documents_repository.dart';
import '../../../helpers/fake_accounting_ledger_repository.dart';

const _bill = AccountingDocument(
  id: 'BILL-9',
  who: 'Kigali Wholesale',
  date: '1 Nov 2026',
  due: '30 Nov 2026',
  status: DocStatus.sent,
  lines: [DocLine(desc: 'Rice', qty: 2, price: 10000)],
);

/// Saves a new bill from the editor ("send") and returns the posted lines.
Future<List<JournalLine>> _recordBill(
  WidgetTester tester,
  BooksVatPosition? position,
) async {
  tester.view.physicalSize = const Size(1400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final ledger = FakeAccountingLedgerRepository();
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingBusinessIdProvider.overrideWithValue('biz'),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingUserNameProvider.overrideWithValue('Owner'),
        accountingUserRoleProvider.overrideWithValue('Admin'),
        accountingAccountsProvider.overrideWithValue(
          defaultChartOfAccountsSeed,
        ),
        accountingBillsProvider.overrideWithValue(const []),
        accountingSuppliersProvider.overrideWithValue(const []),
        accountingCustomersProvider.overrideWithValue(const []),
        accountingDocumentsRepositoryProvider.overrideWithValue(
          FakeAccountingDocumentsRepository(),
        ),
        accountingLedgerRepositoryProvider.overrideWithValue(ledger),
        booksVatPositionProvider.overrideWith((ref) async => position),
        billingUiProvider.overrideWith(
          (ref) => const BillingUiState(kind: DocKind.bill, editingNew: true),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: const Scaffold(body: AccountingBillingPanelHost()),
      ),
    ),
  );
  await tester.pumpAndSettle();

  tester
      .widget<DocEditorPanel>(find.byType(DocEditorPanel))
      .onSaved(_bill, 'send');
  await tester.pumpAndSettle();
  // Let the confirmation toast time out.
  await tester.pump(const Duration(seconds: 10));
  await tester.pumpAndSettle();

  expect(find.byType(DocEditorPanel), findsNothing);
  return ledger.entries.single.lines;
}

int _dr(List<JournalLine> lines, String ac) =>
    lines.where((l) => l.ac == ac).fold(0, (s, l) => s + l.dr);

void main() {
  group('Recording a bill from Books', () {
    testWidgets('not registered for VAT: the VAT is part of the stock cost', (
      tester,
    ) async {
      final lines = await _recordBill(
        tester,
        const BooksVatPosition(
          registered: false,
          hasEbmBranch: false,
          settingRegistered: false,
        ),
      );
      expect(_dr(lines, '1200'), 23600);
      expect(lines.where((l) => l.ac == '2100'), isEmpty);
    });

    testWidgets('registered: the VAT is reclaimable, on 2100', (tester) async {
      final lines = await _recordBill(
        tester,
        const BooksVatPosition(
          registered: true,
          hasEbmBranch: true,
          settingRegistered: false,
        ),
      );
      expect(_dr(lines, '1200'), 20000);
      expect(_dr(lines, '2100'), 3600);
    });

    testWidgets('position unknown: VAT still goes to 2100, as before', (
      tester,
    ) async {
      final lines = await _recordBill(tester, null);
      expect(_dr(lines, '2100'), 3600);
    });
  });
}
