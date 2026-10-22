import 'package:flipper_dashboard/maestro_semantics.dart';
import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_dashboard/utils/mpos_helpers.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_payment_section.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/digital_payment_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/repository/storage.dart';

/// The preference box, reduced to what the payment section touches.
class _FakeBox extends Fake implements LocalStorage {
  final values = <String, String>{};

  @override
  String? currentSaleCustomerPhoneNumber() => null;

  @override
  Future<void> writeString({required String key, required String value}) async {
    values[key] = value;
  }
}

final _sale = ITransaction(
  id: 'txn-1',
  branchId: 'branch-1',
  status: PENDING,
  transactionType: 'sale',
  paymentType: 'CASH',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.utc(2026, 10, 12),
  isIncome: true,
  isExpense: false,
  agentId: 'agent-test',
  subTotal: 1500,
);

late _FakeBox _box;

/// Checkout's own payment setup on entry, run where checkout runs it.
class _CheckoutEntry with TransactionComputationMixin {}

WidgetRef? _ref;

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  List<Payment>? initialPayments,
  Locale? locale,
  double totalPayable = 1500,
  String? splitOwner,
}) async {
  // Narrow phone: all five chips must fit on one row.
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      isDigitalPaymentEnabledProvider.overrideWith((ref) async => false),
      transactionByIdProvider.overrideWith((ref, id) => Stream.value(_sale)),
      if (initialPayments != null)
        paymentMethodsProvider.overrideWith(
          () => PaymentMethodsNotifier(initialPayments),
        ),
      if (splitOwner != null)
        mposSplitOwnerProvider.overrideWith((ref) => splitOwner),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                MposPaymentSection(
                  transactionId: 'txn-1',
                  totalPayable: totalPayable,
                ),
                Consumer(
                  builder: (context, ref, _) {
                    _ref = ref;
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  setUp(() async {
    await getIt.reset();
    _box = _FakeBox();
    getIt.registerSingleton<LocalStorage>(_box);
  });

  testWidgets('five payment chips fit on a 360dp phone', (tester) async {
    await _pump(tester);

    for (final id in [
      MaestroIds.mposPaymentCash,
      MaestroIds.mposPaymentMomo,
      MaestroIds.mposPaymentBank,
      MaestroIds.mposPaymentCard,
      MaestroIds.mposPaymentCredit,
    ]) {
      expect(find.bySemanticsIdentifier(id), findsOneWidget, reason: id);
    }
    expect(tester.takeException(), isNull);
  });

  testWidgets('long translations stay on one chip row (sw)', (tester) async {
    await _pump(tester, locale: const Locale('sw'));

    expect(find.text('Fedha taslimu'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Bank records BANK CHECK for the full total', (tester) async {
    final container = await _pump(tester);

    await tester.tap(find.text('Bank'));
    await tester.pumpAndSettle();

    final payments = container.read(paymentMethodsProvider);
    expect(payments, hasLength(1));
    expect(payments.first.method, 'BANK CHECK');
    expect(payments.first.amount, 1500);
    expect(_box.values['paymentType'], 'BANK CHECK');
    expect(
      find.textContaining('Confirm the money has arrived'),
      findsOneWidget,
    );
  });

  testWidgets('Card records DEBIT&CREDIT CARD for the full total', (
    tester,
  ) async {
    final container = await _pump(tester);

    await tester.tap(find.text('Card'));
    await tester.pumpAndSettle();

    final payments = container.read(paymentMethodsProvider);
    expect(payments, hasLength(1));
    expect(payments.first.method, 'DEBIT&CREDIT CARD');
    expect(payments.first.amount, 1500);
    expect(_box.values['paymentType'], 'DEBIT&CREDIT CARD');
    expect(find.textContaining('POS terminal'), findsOneWidget);
  });

  testWidgets('a resumed card sale reopens on the Card chip, not Credit', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      initialPayments: [Payment(amount: 1500, method: 'DEBIT&CREDIT CARD')],
    );

    expect(find.textContaining('POS terminal'), findsOneWidget);
    expect(
      container.read(paymentMethodsProvider).first.method,
      'DEBIT&CREDIT CARD',
    );
  });

  group('split payment', () {
    List<(String, double)> lines(ProviderContainer c) => [
      for (final p in c.read(paymentMethodsProvider)) (p.method, p.amount),
    ];

    Finder rowField(int i) => find.descendant(
      of: find.byKey(ValueKey('mposSplitRow$i')),
      matching: find.byType(TextField),
    );

    testWidgets('typing the MoMo part leaves the rest on cash', (tester) async {
      // Checkout pre-fills cash with the bill, as on the till.
      final container = await _pump(
        tester,
        initialPayments: [Payment(amount: 1500, method: 'CASH')],
      );

      await tester.tap(find.byKey(const Key('mposSplitPayment')));
      await tester.pumpAndSettle();
      expect(lines(container), [('CASH', 1500.0), ('MOBILE MONEY', 0.0)]);
      // A MoMo row at zero asks no phone for anything yet.
      expect(
        find.byKey(const Key(MaestroIds.mposPaymentMomoPhone)),
        findsNothing,
      );

      await tester.enterText(rowField(1), '600');
      await tester.pumpAndSettle();
      expect(lines(container), [('CASH', 900.0), ('MOBILE MONEY', 600.0)]);
      expect(find.text('900'), findsOneWidget);
      // Now MoMo carries money, the payer's phone is asked for.
      expect(
        find.byKey(const Key(MaestroIds.mposPaymentMomoPhone)),
        findsWidgets,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('splitting a MoMo sale puts the bill on cash first', (
      tester,
    ) async {
      final container = await _pump(tester);
      await tester.tap(find.text('MoMo'));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('mposSplitPayment')));
      await tester.pumpAndSettle();
      expect(lines(container), [('MOBILE MONEY', 0.0), ('CASH', 1500.0)]);
    });

    testWidgets('removing a row goes back to the chips', (tester) async {
      final container = await _pump(tester);
      await tester.tap(find.byKey(const Key('mposSplitPayment')));
      await tester.pumpAndSettle();
      await tester.enterText(rowField(1), '600');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.close_rounded).last);
      await tester.pumpAndSettle();

      expect(container.read(paymentMethodsProvider), hasLength(1));
      expect(
        find.bySemanticsIdentifier(MaestroIds.mposPaymentCash),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('coming back to checkout keeps the split as it was', (
      tester,
    ) async {
      // Back (or Save Ticket) left Cash 1,000 + MoMo 600 on the 1,600 bill.
      final container = await _pump(
        tester,
        totalPayable: 1600,
        splitOwner: 'txn-1',
        initialPayments: [
          Payment(amount: 1000, method: 'CASH'),
          Payment(amount: 600, method: 'MOBILE MONEY'),
        ],
      );

      // Checkout re-entry sets up payment after reading what was paid.
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      _CheckoutEntry().standardizedPaymentInitialization(
        ref: _ref!,
        transaction: _sale,
        total: 1600,
        overrideAlreadyPaid: 0,
      );
      await tester.pumpAndSettle();

      expect(lines(container), [('CASH', 1000.0), ('MOBILE MONEY', 600.0)]);
      expect(find.text('1000'), findsOneWidget);
      expect(find.text('600'), findsOneWidget);
      expect(find.textContaining('Change'), findsNothing);
      final pay = mposCheckoutTender(
        container.read(paymentMethodsProvider),
        1600,
      );
      expect((pay.change, pay.due, pay.tenderOk), (null, null, true));
      expect(tester.takeException(), isNull);
    });

    testWidgets('a split left from another sale starts this one on cash', (
      tester,
    ) async {
      final container = await _pump(
        tester,
        totalPayable: 1600,
        splitOwner: 'txn-other',
        initialPayments: [
          Payment(amount: 1000, method: 'CASH'),
          Payment(amount: 600, method: 'MOBILE MONEY'),
        ],
      );

      expect(lines(container), [('CASH', 1600.0)]);
      expect(
        find.bySemanticsIdentifier(MaestroIds.mposPaymentCash),
        findsOneWidget,
      );
      expect(find.byKey(const Key('mposSplitRow0')), findsNothing);
    });

    testWidgets('Charge dropping the cash row brings back the MoMo chip', (
      tester,
    ) async {
      final container = await _pump(
        tester,
        totalPayable: 1600,
        splitOwner: 'txn-1',
        initialPayments: [
          Payment(amount: 0, method: 'CASH'),
          Payment(amount: 1600, method: 'MOBILE MONEY'),
        ],
      );
      final notifier = container.read(paymentMethodsProvider.notifier);
      final putBack = mposSaveSplitForCharge(
        payments: container.read(paymentMethodsProvider),
        owed: 1600,
        readLines: () => container.read(paymentMethodsProvider),
        writeLines: notifier.setPaymentMethods,
      );
      await tester.pumpAndSettle();

      expect(lines(container), [('MOBILE MONEY', 1600.0)]);
      // The chips follow the one line left: MoMo, so the phone stays.
      expect(
        find.byKey(const Key(MaestroIds.mposPaymentMomoPhone)),
        findsWidgets,
      );
      expect(
        find.byKey(const Key(MaestroIds.mposPaymentCashAmount)),
        findsNothing,
      );

      // The MoMo part is declined: the cashier's split comes back.
      putBack!();
      await tester.pumpAndSettle();
      expect(lines(container), [('CASH', 0.0), ('MOBILE MONEY', 1600.0)]);
      expect(find.byKey(const Key('mposSplitRow1')), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a row cannot pick a method another row already uses', (
      tester,
    ) async {
      await _pump(tester);
      await tester.tap(find.byKey(const Key('mposSplitPayment')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('MoMo').last);
      await tester.pumpAndSettle();
      // The open menu offers MoMo, Bank, Card, Credit, but not Cash.
      expect(find.text('Cash'), findsOneWidget);
    });
  });
}
