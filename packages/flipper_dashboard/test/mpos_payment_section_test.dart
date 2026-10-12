import 'package:flipper_dashboard/maestro_semantics.dart';
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

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  List<Payment>? initialPayments,
  Locale? locale,
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
        home: const Scaffold(
          body: SingleChildScrollView(
            child: MposPaymentSection(
              transactionId: 'txn-1',
              totalPayable: 1500,
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
}
