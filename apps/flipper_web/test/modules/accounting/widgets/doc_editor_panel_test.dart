import 'dart:async';

import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/accounting_v3_providers.dart';
import 'package:flipper_web/modules/accounting/data/default_chart_of_accounts_seed.dart';
import 'package:flipper_web/modules/accounting/widgets/v3_doc_panels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _acme = AccountingContact(
  id: 'c1',
  name: 'Acme Ltd',
  contact: '',
  phone: '',
  email: '',
  tin: '',
  since: '',
  terms: '',
  balance: 0,
);

AccountingDocument _doc() => const AccountingDocument(
  id: 'BILL-1',
  who: 'Acme Ltd',
  date: '19 Nov 2026',
  due: '19 Dec 2026',
  status: DocStatus.draft,
  lines: [DocLine(desc: 'Flour', qty: 2, price: 5000)],
);

typedef _Saved = ({AccountingDocument doc, String mode});

Future<void> _pump(
  WidgetTester tester, {
  required DocKind kind,
  AccountingDocument? doc,
  required Future<void> Function(AccountingDocument, String) onSaved,
  ValueNotifier<Locale>? locale,
}) async {
  tester.view.physicalSize = const Size(1600, 1100);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final lang = locale ?? ValueNotifier(const Locale('en'));
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountingAccountsProvider.overrideWithValue(
          defaultChartOfAccountsSeed,
        ),
        accountingCurrencyProvider.overrideWithValue('RWF'),
        accountingSuppliersProvider.overrideWithValue(const [_acme]),
        accountingCustomersProvider.overrideWithValue(const [_acme]),
      ],
      child: ValueListenableBuilder<Locale>(
        valueListenable: lang,
        builder: (_, l, _) => MaterialApp(
          locale: l,
          localizationsDelegates: FlipperLocalizationDelegates.delegates,
          supportedLocales: FlipperLocalizationDelegates.supportedLocales,
          home: Scaffold(
            body: DocEditorPanel(
              kind: kind,
              doc: doc,
              newId: 'BILL-NEW',
              onClose: () {},
              onSaved: onSaved,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a slow save keeps the buttons off, so a bill is recorded '
      'once', (tester) async {
    final saved = <_Saved>[];
    final done = Completer<void>();
    await _pump(
      tester,
      kind: DocKind.bill,
      doc: _doc().copyWithStatus(DocStatus.sent),
      onSaved: (doc, mode) {
        saved.add((doc: doc, mode: mode));
        return done.future;
      },
    );

    await tester.tap(find.text('Record bill'));
    await tester.pump();
    await tester.tap(find.text('Record bill'));
    await tester.tap(find.text('Save draft'));
    await tester.pump();
    expect(saved, hasLength(1));
    expect(saved.single.mode, 'send');

    done.complete();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save draft'));
    await tester.pumpAndSettle();
    expect(saved.map((s) => s.mode), ['send', 'draft']);
  });

  testWidgets('an invoice is saved and sent from the send menu', (
    tester,
  ) async {
    final modes = <String>[];
    await _pump(
      tester,
      kind: DocKind.invoice,
      doc: _doc(),
      onSaved: (doc, mode) async => modes.add(mode),
    );
    await tester.tap(find.text('Save & send'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Email').last);
    await tester.pumpAndSettle();
    expect(modes, ['send']);
  });

  testWidgets('the party picker is kept across line edits and redrawn for a '
      'new language', (tester) async {
    final locale = ValueNotifier(const Locale('en'));
    addTearDown(locale.dispose);
    await _pump(
      tester,
      kind: DocKind.bill,
      locale: locale,
      onSaved: (_, _) async {},
    );
    DropdownButtonFormField<String> picker() =>
        tester.widget<DropdownButtonFormField<String>>(
          find.byType(DropdownButtonFormField<String>),
        );
    final first = picker();
    expect(find.text('Select supplier…'), findsOneWidget);

    // Typing in a line rebuilds the panel; the picker is not rebuilt.
    await tester.enterText(find.byType(TextField).first, 'Flour');
    await tester.pump();
    expect(identical(picker(), first), isTrue);

    locale.value = const Locale('fr');
    await tester.pumpAndSettle();
    expect(identical(picker(), first), isFalse);
    expect(find.text('Choisir un fournisseur…'), findsOneWidget);

    // Picking a supplier redraws it with the choice.
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Acme Ltd').last);
    await tester.pumpAndSettle();
    expect(find.text('Choisir un fournisseur…'), findsNothing);
  });
}

extension on AccountingDocument {
  AccountingDocument copyWithStatus(DocStatus s) => AccountingDocument(
    id: id,
    who: who,
    date: date,
    due: due,
    status: s,
    lines: lines,
  );
}
