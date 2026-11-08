import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_billing_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

// flutter test test/features/hotel_mode/hotel_billing_screen_test.dart

ITransaction _loan() => ITransaction(
  id: 'loan-1',
  agentId: 'c1',
  branchId: 'b1',
  status: PARKED,
  transactionType: 'sale',
  paymentType: 'CREDIT',
  cashReceived: 20000,
  customerChangeDue: 0,
  updatedAt: DateTime(2026, 1, 12),
  isIncome: true,
  isExpense: false,
  isLoan: true,
  subTotal: 100000,
  remainingBalance: 80000,
  ticketName: 'Aline Uwase',
  customerName: 'Aline Uwase',
  note: 'Hotel · Room 101 · 2026-01-10 → 2026-01-12',
  dueDate: DateTime(2026, 2, 1),
);

HotelStay _gone({bool heldAdvance = false}) => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '101',
  transactionId: 't1',
  guestName: 'Bosco',
  checkInAt: DateTime(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime(2026, 1, 12, 11),
  checkedOutAt: DateTime(2026, 1, 12, 10),
  status: HotelStayStatus.checkedOut,
  nightlyRate: 50000,
  advances: [
    if (heldAdvance)
      HotelAdvance(
        id: 'a1',
        amount: 20000,
        paymentMethod: 'Cash',
        paidAt: DateTime(2026, 1, 5),
      ),
  ],
);

Future<void> _pump(
  WidgetTester tester, {
  List<ITransaction> loans = const [],
  List<HotelStay> stays = const [],
}) async {
  final view = tester.view;
  view.physicalSize = const Size(1400, 1000);
  view.devicePixelRatio = 1;
  addTearDown(view.resetPhysicalSize);
  addTearDown(view.resetDevicePixelRatio);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        barCreditTabsProvider.overrideWith((ref) => Stream.value(loans)),
        barTablesProvider.overrideWith((ref) => Stream.value(const [])),
        hotelCheckedOutStaysProvider.overrideWith((ref) async => stays),
        hotelStaysProvider.overrideWith((ref) => Stream.value(const [])),
        hotelRoomsProvider.overrideWith((ref) => Stream.value(const [])),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: const Scaffold(body: HotelBillingScreen()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('empty: says nobody owes and nobody left', (tester) async {
    await _pump(tester);
    expect(find.text('Nobody owes money.'), findsOneWidget);
    expect(
      find.text('No guests checked out in the last 30 days.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('lists what is owed and who left, with print', (tester) async {
    await _pump(tester, loans: [_loan()], stays: [_gone()]);
    expect(find.text('Aline Uwase'), findsOneWidget);
    expect(find.text('RWF 80,000'), findsOneWidget);
    expect(find.byKey(const ValueKey('hotel-collect-loan-1')), findsOneWidget);
    expect(find.text('Room 101 · Bosco'), findsOneWidget);
    expect(find.byKey(const ValueKey('hotel-folio-print')), findsOneWidget);
    // Advances already settled: nothing to heal.
    expect(find.byKey(const ValueKey('hotel-apply-advance-s1')), findsNothing);
  });

  testWidgets('a checkout whose advance was not applied can be healed', (
    tester,
  ) async {
    await _pump(tester, stays: [_gone(heldAdvance: true)]);
    expect(
      find.byKey(const ValueKey('hotel-apply-advance-s1')),
      findsOneWidget,
    );
  });

  testWidgets("Bar's collect toasts reach the desk", (tester) async {
    await _pump(tester);
    final container = ProviderScope.containerOf(
      tester.element(find.byType(HotelBillingScreen)),
    );
    container.read(barModeProvider.notifier).showToast('Aline paid 5,000');
    await tester.pump();
    expect(container.read(hotelModeProvider).toastMessage, 'Aline paid 5,000');
    expect(container.read(barModeProvider).toastMessage, isNull);
  });
}
