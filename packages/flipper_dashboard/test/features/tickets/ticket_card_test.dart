import 'package:flipper_dashboard/features/tickets/widgets/tickets_list.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

// flutter test test/features/tickets/ticket_card_test.dart
ITransaction _ticket({String status = PARKED, double subTotal = 5000}) =>
    ITransaction(
      id: 'ticket-9',
      reference: '9',
      branchId: 'branch-1',
      status: status,
      transactionType: 'sale',
      paymentType: 'CASH',
      cashReceived: 0,
      customerChangeDue: 0,
      updatedAt: DateTime.utc(2026, 10, 12, 13, 24),
      createdAt: DateTime.utc(2026, 10, 12, 13, 24),
      isIncome: true,
      isExpense: false,
      agentId: 'agent-test',
      subTotal: subTotal,
      customerName: 'Mura',
      customerPhone: '0783054874',
    );

class _Calls {
  int collect = 0;
  int delete = 0;
  int longPress = 0;
  int print = 0;
  final selections = <bool>[];
}

Future<_Calls> _pumpCard(
  WidgetTester tester, {
  required Size size,
  required bool compact,
  ITransaction? ticket,
  double paid = 0,
  ResumedTicketPlace resumedPlace = ResumedTicketPlace.queued,
  String? collectLabel,
  bool canManage = true,
  bool withPrint = true,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  final calls = _Calls();
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            TicketCard(
              ticket: ticket ?? _ticket(),
              isSelected: false,
              paidAmount: paid,
              compact: compact,
              showCollect: true,
              showResume: false,
              onCollect: () => calls.collect++,
              onTap: () {},
              onLongPress: () => calls.longPress++,
              onDelete: () => calls.delete++,
              onSelectionChanged: calls.selections.add,
              onSendToKitchen: () {},
              resumedPlace: resumedPlace,
              collectLabel: collectLabel,
              canManage: canManage,
              onPrint: withPrint ? () => calls.print++ : null,
            ),
          ],
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return calls;
}

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  group('compact (phone) TicketCard', () {
    testWidgets('no checkbox, full status text, full-width Collect', (
      tester,
    ) async {
      final calls = await _pumpCard(
        tester,
        size: const Size(360, 800),
        compact: true,
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(Checkbox), findsNothing);
      expect(find.text('Awaiting payment'), findsOneWidget);
      expect(find.text('Mura'), findsOneWidget);
      final primary = find.byKey(const ValueKey('ticket_primary_ticket-9'));
      expect(tester.getSize(primary).height, greaterThanOrEqualTo(48));
      // Takes the row: card width minus padding and the 48dp more button.
      expect(tester.getSize(primary).width, greaterThan(220));

      await tester.tap(primary);
      expect(calls.collect, 1);
    });

    testWidgets('long-press selects', (tester) async {
      final calls = await _pumpCard(
        tester,
        size: const Size(360, 800),
        compact: true,
      );
      await tester.longPress(find.text('Mura'));
      expect(calls.longPress, 1);
    });

    testWidgets('more sheet offers Select and Delete', (tester) async {
      final calls = await _pumpCard(
        tester,
        size: const Size(360, 800),
        compact: true,
      );
      await tester.tap(find.byKey(const ValueKey('ticket_more_ticket-9')));
      await tester.pumpAndSettle();

      await tester.tap(
        find.byKey(const ValueKey('ticket_more_select_ticket-9')),
      );
      await tester.pumpAndSettle();
      expect(calls.selections, [true]);

      await tester.tap(find.byKey(const ValueKey('ticket_more_ticket-9')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('ticket_more_delete_ticket-9')),
      );
      await tester.pumpAndSettle();
      expect(calls.delete, 1);
    });

    testWidgets('more sheet prints the ticket', (tester) async {
      final calls = await _pumpCard(
        tester,
        size: const Size(360, 800),
        compact: true,
      );
      await tester.tap(find.byKey(const ValueKey('ticket_more_ticket-9')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('ticket_more_print_ticket-9')),
      );
      await tester.pumpAndSettle();
      expect(calls.print, 1);
    });

    testWidgets('staff who cannot manage tickets can still print', (
      tester,
    ) async {
      final calls = await _pumpCard(
        tester,
        size: const Size(360, 800),
        compact: true,
        canManage: false,
      );
      await tester.tap(find.byKey(const ValueKey('ticket_more_ticket-9')));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey('ticket_more_select_ticket-9')),
        findsNothing,
      );
      expect(
        find.byKey(const ValueKey('ticket_more_delete_ticket-9')),
        findsNothing,
      );
      await tester.tap(
        find.byKey(const ValueKey('ticket_more_print_ticket-9')),
      );
      await tester.pumpAndSettle();
      expect(calls.print, 1);
    });

    testWidgets('no print and no manage access hides the more button', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        size: const Size(360, 800),
        compact: true,
        canManage: false,
        withPrint: false,
      );
      expect(find.byKey(const ValueKey('ticket_more_ticket-9')), findsNothing);
    });

    testWidgets('partial payment shows progress and "Paid x of y"', (
      tester,
    ) async {
      await _pumpCard(
        tester,
        size: const Size(360, 800),
        compact: true,
        paid: 2000,
      );
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.textContaining('Paid '), findsOneWidget);
      expect(find.text('Partial'), findsOneWidget);
    });

    testWidgets('unpaid ticket hides the progress bar', (tester) async {
      await _pumpCard(tester, size: const Size(360, 800), compact: true);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('fits a 320dp phone without overflow', (tester) async {
      await _pumpCard(
        tester,
        size: const Size(320, 640),
        compact: true,
        paid: 2000,
      );
      expect(tester.takeException(), isNull);
    });
  });

  testWidgets('wide TicketCard keeps the desktop layout', (tester) async {
    await _pumpCard(tester, size: const Size(1280, 800), compact: false);

    expect(find.byType(Checkbox), findsOneWidget);
    expect(find.text('TOTAL'), findsOneWidget);
    expect(find.text('PAID'), findsOneWidget);
    expect(find.text('REMAINING'), findsOneWidget);
    expect(find.byKey(const ValueKey('ticket_primary_ticket-9')), findsNothing);
  });

  testWidgets('wide TicketCard has a Print button', (tester) async {
    final calls = await _pumpCard(
      tester,
      size: const Size(1280, 800),
      compact: false,
    );
    await tester.tap(find.byKey(const ValueKey('ticket_print_ticket-9')));
    expect(calls.print, 1);
  });

  testWidgets('wide TicketCard hides Print when the ticket has no print', (
    tester,
  ) async {
    await _pumpCard(
      tester,
      size: const Size(1280, 800),
      compact: false,
      withPrint: false,
    );
    expect(find.byKey(const ValueKey('ticket_print_ticket-9')), findsNothing);
  });

  group('resumed ticket (PENDING) stays listed', () {
    for (final compact in [true, false]) {
      final layout = compact ? 'compact' : 'wide';

      testWidgets('$layout: open on another till offers Take over', (
        tester,
      ) async {
        final calls = await _pumpCard(
          tester,
          size: compact ? const Size(360, 800) : const Size(1280, 800),
          compact: compact,
          ticket: _ticket(status: PENDING),
          resumedPlace: ResumedTicketPlace.otherTill,
          collectLabel: 'Take over →',
        );

        expect(find.text('Open on another till'), findsOneWidget);
        expect(find.text('Collect →'), findsNothing);
        await tester.tap(find.text('Take over →'));
        expect(calls.collect, 1);
      });

      testWidgets('$layout: resumed here reads "In your cart"', (tester) async {
        final calls = await _pumpCard(
          tester,
          size: compact ? const Size(360, 800) : const Size(1280, 800),
          compact: compact,
          ticket: _ticket(status: PENDING),
          resumedPlace: ResumedTicketPlace.thisTill,
          collectLabel: 'Go to cart →',
        );

        expect(find.text('In your cart'), findsOneWidget);
        await tester.tap(find.text('Go to cart →'));
        expect(calls.collect, 1);
      });
    }
  });
}
