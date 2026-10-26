import 'package:flipper_dashboard/features/bar_mode/bar_credit.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_credit_collect_sheet.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_credit_floor_button.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_credit_tile.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_tab_bottom_sheet.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/customer.model.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

// flutter test test/features/bar_mode/bar_credit_test.dart

final _now = DateTime.now().toUtc();

ITransaction _loan({
  String id = 'loan-1',
  num subTotal = 3000,
  double paid = 0,
  DateTime? due,
}) => ITransaction(
  id: id,
  branchId: 'branch-1',
  status: 'parked',
  transactionType: 'Sale',
  paymentType: 'CREDIT',
  subTotal: subTotal.toDouble(),
  cashReceived: paid,
  customerChangeDue: 0,
  isIncome: true,
  isExpense: false,
  agentId: 't1',
  isLoan: true,
  customerName: 'Aline',
  remainingBalance: subTotal - paid,
  dueDate: due ?? _now.add(const Duration(days: 7)),
  note: 'Bar · T1 · Opened by Server',
  updatedAt: _now,
);

Widget _app(Widget child, {List overrides = const []}) => ProviderScope(
  overrides: [...overrides],
  child: MaterialApp(
    localizationsDelegates: FlipperLocalizationDelegates.delegates,
    supportedLocales: FlipperLocalizationDelegates.supportedLocales,
    home: Scaffold(body: child),
  ),
);

void _phone(WidgetTester tester) {
  tester.view.physicalSize = const Size(420, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('tab sheet', () {
    Future<void> pump(WidgetTester tester, {VoidCallback? onPutOnCredit}) {
      _phone(tester);
      final cashier = Tenant(id: 't1', name: 'Server');
      final line = TransactionItem(
        name: 'Beer',
        qty: 2,
        price: 1500,
        discount: 0,
        prc: 1500,
        ttCatCd: 'B',
        loggedByTenantId: 't1',
      );
      return tester.pumpWidget(
        _app(
          BarTabBottomSheet(
            tableName: 'T1',
            zoneName: 'Main Bar',
            lines: [line],
            grouped: {
              't1': [line],
            },
            staff: [cashier],
            cashier: cashier,
            isManager: true,
            total: 3000,
            lineCount: 1,
            serverCount: 1,
            myLines: 1,
            onClose: () {},
            onQtyDelta: (_, _) {},
            onSaveToTab: () {},
            onBackToTables: () {},
            onSettle: () {},
            onPutOnCredit: onPutOnCredit,
          ),
        ),
      );
    }

    testWidgets('offers Put on credit and runs it', (tester) async {
      var tapped = 0;
      await pump(tester, onPutOnCredit: () => tapped++);
      await tester.pumpAndSettle();

      final button = find.byKey(const ValueKey('bar_tab_sheet_credit'));
      await tester.ensureVisible(button);
      await tester.tap(button);
      expect(tapped, 1);
    });

    testWidgets('hides it when settling needs a manager PIN', (tester) async {
      await pump(tester);
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('bar_tab_sheet_credit')), findsNothing);
    });
  });

  group('settle tile', () {
    testWidgets('asks for a customer until one is chosen', (tester) async {
      await tester.pumpWidget(
        _app(BarCreditTile(selected: false, terms: null, onTap: () {})),
      );
      expect(find.text('The customer pays later'), findsOneWidget);
    });

    testWidgets('names the debtor once chosen', (tester) async {
      final terms = BarCreditTerms(
        customer: Customer(id: 'c1', custNm: 'Aline', branchId: 'branch-1'),
        dueDate: DateTime.utc(2026, 11, 9),
      );
      await tester.pumpWidget(
        _app(BarCreditTile(selected: true, terms: terms, onTap: () {})),
      );
      expect(find.textContaining('Aline · Due'), findsOneWidget);
    });
  });

  group('collect sheet', () {
    Future<void> pump(WidgetTester tester, ITransaction loan) async {
      _phone(tester);
      await tester.pumpWidget(
        _app(
          BarCreditCollectSheet(loan: loan),
          overrides: [
            barTabLinesProvider.overrideWith(
              (ref, id) => Stream.value(const <TransactionItem>[]),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('starts at the full balance', (tester) async {
      await pump(tester, _loan(paid: 1000));
      expect(find.text('2,000'), findsOneWidget);
      expect(find.text('Collect RWF 2,000'), findsOneWidget);
    });

    testWidgets('takes part of the balance', (tester) async {
      await pump(tester, _loan());
      await tester.enterText(
        find.byKey(const ValueKey('bar_credit_amount')),
        '1000',
      );
      await tester.pump();
      expect(find.text('Collect RWF 1,000'), findsOneWidget);
    });

    testWidgets('refuses more than is owed', (tester) async {
      await pump(tester, _loan());
      await tester.enterText(
        find.byKey(const ValueKey('bar_credit_amount')),
        '5000',
      );
      await tester.pump();
      expect(find.text('Aline owes only RWF 3,000'), findsOneWidget);
      final button = tester.widget<InkWell>(
        find.byKey(const ValueKey('bar_credit_collect')),
      );
      expect(button.onTap, isNull);
    });

    testWidgets('flags an overdue loan', (tester) async {
      await pump(tester, _loan(due: _now.subtract(const Duration(days: 2))));
      expect(find.textContaining('Overdue'), findsOneWidget);
    });
  });

  group('floor button', () {
    Future<void> pump(WidgetTester tester, List<ITransaction> loans) async {
      await tester.pumpWidget(
        _app(
          const Center(child: BarCreditFloorButton()),
          overrides: [
            barCreditTabsProvider.overrideWith((ref) => Stream.value(loans)),
          ],
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('stays visible while nobody owes anything', (tester) async {
      await pump(tester, const []);
      expect(
        find.byKey(const ValueKey('bar_credit_floor_button')),
        findsOneWidget,
      );
      expect(find.text('Credit'), findsOneWidget);
    });

    testWidgets('counts the unpaid bills', (tester) async {
      await pump(tester, [_loan(), _loan(id: 'loan-2')]);
      expect(find.text('Credit · 2'), findsOneWidget);
    });
  });
}
