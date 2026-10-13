import 'package:flipper_dashboard/widgets/mpos/mpos_branch_transfer.dart';
import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _session = (businessId: 'biz-1', branchId: 'b1');

Branch _branch(String id) =>
    Branch(id: id, name: 'Branch $id', businessId: 'biz-1', isDefault: false);

ITransaction _sale() => ITransaction(
  id: 'txn-1',
  branchId: 'b1',
  status: PENDING,
  transactionType: 'sale',
  paymentType: 'CASH',
  cashReceived: 0,
  customerChangeDue: 0,
  updatedAt: DateTime.now().toUtc(),
  isIncome: true,
  isExpense: false,
  agentId: 'agent-test',
  subTotal: 0,
);

Future<bool> _gate(
  List<Branch> branches, {
  SettlingTillTicket? settling,
}) async {
  final container = ProviderContainer(
    overrides: [
      checkoutTransferSessionProvider.overrideWithValue(_session),
      effectiveSettlingTillTicketProvider.overrideWithValue(settling),
      branchesProvider(
        businessId: 'biz-1',
      ).overrideWith((ref) async => branches),
    ],
  );
  addTearDown(container.dispose);
  // Hold the input open: with a settling ticket the gate never watches it.
  container.listen(branchesProvider(businessId: 'biz-1'), (_, __) {});
  container.listen(canOfferBranchTransferProvider, (_, __) {});
  await container.read(branchesProvider(businessId: 'biz-1').future);
  return container.read(canOfferBranchTransferProvider);
}

Widget _app(Widget child) => ProviderScope(
  child: MaterialApp(
    locale: const Locale('en'),
    localizationsDelegates: FlipperAppLocalizations.localizationsDelegates,
    supportedLocales: FlipperAppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  ),
);

void main() {
  group('canOfferBranchTransferProvider', () {
    test('false for a single-branch business', () async {
      expect(await _gate([_branch('b1')]), isFalse);
    });

    test('true when the business has more than one branch', () async {
      expect(await _gate([_branch('b1'), _branch('b2')]), isTrue);
    });

    test('false while collecting a till ticket', () async {
      final settling = SettlingTillTicket(
        transactionId: 'txn-9',
        displayRef: 'TXN9',
        creatorName: 'Waiter',
        createdAt: DateTime.now(),
      );
      expect(
        await _gate([_branch('b1'), _branch('b2')], settling: settling),
        isFalse,
      );
    });

    test('false while branches are still loading', () {
      final container = ProviderContainer(
        overrides: [
          checkoutTransferSessionProvider.overrideWithValue(_session),
          effectiveSettlingTillTicketProvider.overrideWithValue(null),
          branchesProvider(
            businessId: 'biz-1',
          ).overrideWith((ref) => Future.delayed(const Duration(days: 1))),
        ],
      );
      addTearDown(container.dispose);
      expect(container.read(canOfferBranchTransferProvider), isFalse);
    });
  });

  testWidgets('MposTransferModeBar reports taps without touching the '
      'desktop mode provider', (tester) async {
    CheckoutCartMode? reported;
    late WidgetRef capturedRef;
    await tester.pumpWidget(
      _app(
        Consumer(
          builder: (context, ref, _) {
            capturedRef = ref;
            return MposTransferModeBar(
              mode: CheckoutCartMode.sale,
              onModeChanged: (m) => reported = m,
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Transfer'));
    await tester.pump();
    expect(reported, CheckoutCartMode.transfer);
    expect(capturedRef.read(checkoutCartModeProvider), CheckoutCartMode.sale);
  });

  testWidgets('MposBranchTransferFooter enables Transfer once a destination '
      'is picked', (tester) async {
    late WidgetRef capturedRef;
    await tester.pumpWidget(
      _app(
        Consumer(
          builder: (context, ref, _) {
            capturedRef = ref;
            return MposBranchTransferFooter(_sale(), 'b1', 2);
          },
        ),
      ),
    );

    FilledButton transferButton() =>
        tester.widget<FilledButton>(find.byType(FilledButton));
    expect(transferButton().onPressed, isNull);

    capturedRef.read(transferDestinationBranchProvider.notifier).state =
        _branch('b2');
    await tester.pump();
    expect(transferButton().onPressed, isNotNull);
    expect(find.text('Transfer to Branch b2'), findsOneWidget);
  });
}
