import 'dart:convert';

import 'package:flipper_dashboard/features/hotel_mode/hotel_folio_pdf.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_quotation_pdf.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_advance_sheet.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/branch_document_settings.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

// flutter test test/features/hotel_mode/hotel_advance_widgets_test.dart

HotelStay _stay({List<HotelAdvance> advances = const []}) => HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '101',
  transactionId: 't1',
  guestName: 'Aline Uwase',
  checkInAt: DateTime(2026, 1, 10, 14),
  expectedCheckOutAt: DateTime(2026, 1, 12, 11),
  nightlyRate: 50000,
  advances: advances,
);

HotelAdvance _advance(
  String id,
  double amount, {
  HotelAdvanceStatus status = HotelAdvanceStatus.held,
}) => HotelAdvance(
  id: id,
  amount: amount,
  paymentMethod: 'MOBILE MONEY',
  paidAt: DateTime(2026, 1, 5),
  status: status,
);

TransactionItem _line(String name, num qty, num price) => TransactionItem(
  name: name,
  qty: qty,
  price: price,
  discount: 0,
  prc: price,
  ttCatCd: 'TT',
);

Widget _host(Widget child) => MaterialApp(
  localizationsDelegates: FlipperLocalizationDelegates.delegates,
  supportedLocales: FlipperLocalizationDelegates.supportedLocales,
  home: Scaffold(body: SingleChildScrollView(child: child)),
);

/// Opens [open] from a button and records what it returned.
Future<List<T?>> _open<T>(
  WidgetTester tester,
  Future<T?> Function(BuildContext) open,
) async {
  final results = <T?>[];
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      home: Builder(
        builder: (context) => Scaffold(
          body: TextButton(
            onPressed: () async => results.add(await open(context)),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return results;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // Desk-sized: the dialogs, not the phone sheets.
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.physicalSize = const Size(1400, 1000);
    view.devicePixelRatio = 1;
  });
  tearDown(() {
    final view =
        TestWidgetsFlutterBinding.instance.platformDispatcher.views.first;
    view.resetPhysicalSize();
    view.resetDevicePixelRatio();
  });

  group('folio totals', () {
    testWidgets('without an advance nothing extra is shown', (tester) async {
      await tester.pumpWidget(
        _host(
          HotelFolioTotals(lines: [_line('Room 101 · 2 nights', 2, 50000)]),
        ),
      );
      expect(find.text('Advance paid'), findsNothing);
      expect(find.text('Balance due'), findsNothing);
    });

    testWidgets('an advance shows what is left to pay', (tester) async {
      await tester.pumpWidget(
        _host(
          HotelFolioTotals(
            lines: [_line('Room 101 · 2 nights', 2, 50000)],
            advance: 30000,
          ),
        ),
      );
      expect(find.text('Advance paid'), findsOneWidget);
      expect(find.text('−RWF 30,000'), findsOneWidget);
      expect(find.text('Balance due'), findsOneWidget);
      expect(find.text('RWF 70,000'), findsOneWidget);
    });

    testWidgets('an advance above the folio shows the refund', (tester) async {
      await tester.pumpWidget(
        _host(
          HotelFolioTotals(
            lines: [_line('Room 101 · 1 night', 1, 50000)],
            advance: 60000,
          ),
        ),
      );
      expect(find.text('To refund'), findsOneWidget);
      expect(find.text('RWF 10,000'), findsOneWidget);
    });
  });

  group('folio header', () {
    testWidgets('lists every advance and offers to change departure', (
      tester,
    ) async {
      var tapped = 0;
      await tester.pumpWidget(
        _host(
          HotelFolioHeaderCard(
            stay: _stay(
              advances: [
                _advance('a1', 20000),
                _advance('a2', 5000, status: HotelAdvanceStatus.refunded),
              ],
            ),
            onChangeDeparture: () => tapped++,
          ),
        ),
      );
      expect(find.text('Advances'), findsOneWidget);
      expect(find.textContaining('Held'), findsOneWidget);
      expect(find.textContaining('Refunded'), findsOneWidget);
      expect(find.text('RWF 20,000'), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('hotel-change-departure')));
      expect(tapped, 1);
    });

    testWidgets('without the callback the departure is plain text', (
      tester,
    ) async {
      await tester.pumpWidget(_host(HotelFolioHeaderCard(stay: _stay())));
      expect(
        find.byKey(const ValueKey('hotel-change-departure')),
        findsNothing,
      );
      expect(find.text('Advances'), findsNothing);
    });
  });

  group('checkout dialog', () {
    testWidgets('charges only the balance after an advance', (tester) async {
      final results = await _open<HotelCheckOutResult>(
        tester,
        (context) =>
            HotelCheckOutDialog.show(context, total: 100000, advance: 30000),
      );
      expect(find.text('Balance due'), findsOneWidget);
      // The tender starts at what is due, not the folio.
      expect(find.widgetWithText(TextField, '70000'), findsOneWidget);
      // No credit rail unless asked for.
      expect(find.text('Credit'), findsNothing);

      await tester.tap(find.text('Settle & release room'));
      await tester.pumpAndSettle();
      expect(results.single!.paymentType, 'Cash');
      expect(results.single!.cashReceived, 70000);
      expect(results.single!.changeDue, 0);
    });

    testWidgets('a non-cash rail settles exactly the balance', (tester) async {
      final results = await _open<HotelCheckOutResult>(
        tester,
        (context) =>
            HotelCheckOutDialog.show(context, total: 100000, advance: 30000),
      );
      await tester.tap(find.text('Card'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settle & release room'));
      await tester.pumpAndSettle();
      expect(results.single!.paymentType, 'DEBIT&CREDIT CARD');
      expect(results.single!.cashReceived, 70000);
    });

    testWidgets('credit puts the balance on the guest\'s account', (
      tester,
    ) async {
      final results = await _open<HotelCheckOutResult>(
        tester,
        (context) => HotelCheckOutDialog.show(
          context,
          total: 100000,
          advance: 30000,
          allowCredit: true,
        ),
      );
      await tester.tap(find.text('Credit'));
      await tester.pumpAndSettle();
      // No tender to type for credit.
      expect(find.byType(TextField), findsNothing);
      await tester.tap(find.text('Put on credit'));
      await tester.pumpAndSettle();
      expect(results.single!.paymentType, HotelCheckOutDialog.creditTender);
      expect(results.single!.cashReceived, 0);
    });

    testWidgets('nothing owed means no credit rail', (tester) async {
      await _open<HotelCheckOutResult>(
        tester,
        (context) => HotelCheckOutDialog.show(
          context,
          total: 100000,
          advance: 100000,
          allowCredit: true,
        ),
      );
      expect(find.text('Credit'), findsNothing);
      expect(find.widgetWithText(TextField, '0'), findsOneWidget);
    });

    testWidgets('without an advance it behaves as before', (tester) async {
      final results = await _open<HotelCheckOutResult>(
        tester,
        (context) => HotelCheckOutDialog.show(context, total: 120000),
      );
      expect(find.text('Advance paid'), findsNothing);
      expect(find.widgetWithText(TextField, '120000'), findsOneWidget);
      await tester.enterText(find.byType(TextField), '150000');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Settle & release room'));
      await tester.pumpAndSettle();
      expect(results.single!.cashReceived, 150000);
      expect(results.single!.changeDue, 30000);
    });
  });

  group('advance sheet', () {
    testWidgets('returns the amount and method', (tester) async {
      final results = await _open<HotelAdvanceDraft>(
        tester,
        (context) => HotelAdvanceSheet.show(context, guestName: 'Aline'),
      );
      expect(find.textContaining('Aline'), findsOneWidget);

      await tester.enterText(
        find.byKey(const ValueKey('hotel-advance-amount')),
        '25000',
      );
      await tester.tap(
        find.byKey(const ValueKey('hotel-advance-method-MOBILE MONEY')),
      );
      await tester.pumpAndSettle();
      expect(find.text('Record RWF 25,000'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('hotel-advance-save')));
      await tester.pumpAndSettle();

      expect(results.single!.amount, 25000);
      expect(results.single!.paymentMethod, 'MOBILE MONEY');
    });

    testWidgets('cannot save nothing', (tester) async {
      final results = await _open<HotelAdvanceDraft>(
        tester,
        (context) => HotelAdvanceSheet.show(context, guestName: 'Aline'),
      );
      await tester.tap(find.byKey(const ValueKey('hotel-advance-save')));
      await tester.pumpAndSettle();
      expect(results, isEmpty);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(results.single, isNull);
    });
  });

  group('folio document', () {
    test('names itself from the folio', () {
      expect(hotelFolioDocumentKind(null), HotelFolioDocumentKind.proforma);
      ITransaction folio({String status = PARKED, bool? isLoan}) =>
          ITransaction(
            id: 't1',
            agentId: 'c1',
            branchId: 'b1',
            status: status,
            transactionType: 'sale',
            paymentType: 'Cash',
            cashReceived: 0,
            customerChangeDue: 0,
            updatedAt: DateTime(2026),
            isIncome: true,
            isExpense: false,
            isLoan: isLoan,
          );
      expect(hotelFolioDocumentKind(folio()), HotelFolioDocumentKind.proforma);
      expect(
        hotelFolioDocumentKind(folio(status: COMPLETE)),
        HotelFolioDocumentKind.invoice,
      );
      expect(
        hotelFolioDocumentKind(folio(isLoan: true)),
        HotelFolioDocumentKind.credit,
      );
    });

    for (final kind in ['open', 'settled', 'credit']) {
      test('renders a PDF for a $kind folio with advances', () async {
        final bytes = await HotelFolioPdf.build(
          stay: _stay(
            advances: [
              _advance('a1', 20000),
              _advance('a2', 5000, status: HotelAdvanceStatus.refunded),
            ],
          ),
          lines: [
            _line('Room 101 · 2 nights', 2, 50000),
            _line('Beer', 3, 1500),
          ],
          folio: kind == 'open'
              ? null
              : ITransaction(
                  id: 't1',
                  agentId: 'c1',
                  branchId: 'b1',
                  status: kind == 'settled' ? COMPLETE : PARKED,
                  transactionType: 'sale',
                  paymentType: 'Cash',
                  cashReceived: 0,
                  customerChangeDue: 0,
                  updatedAt: DateTime(2026),
                  isIncome: true,
                  isExpense: false,
                  isLoan: kind == 'credit',
                  remainingBalance: 84500,
                  receiptNumber: 42,
                ),
          currency: 'RWF',
          generatedAt: DateTime(2026, 1, 12, 11),
        );
        expect(bytes.length, greaterThan(1000));
        // A PDF, not an empty buffer.
        expect(String.fromCharCodes(bytes.take(4)), '%PDF');
      });
    }

    for (final placement in DocumentStampPlacement.values) {
      test('an invoice billed to a company, stamped ${placement.name}', () async {
        final bytes = await HotelFolioPdf.build(
          // RWF 120,000 against a RWF 100,000 stay: 20,000 went back.
          stay: _stay(
            advances: [
              _advance('a1', 120000, status: HotelAdvanceStatus.applied),
            ],
          ),
          lines: [_line('Room 101 · 2 nights', 2, 50000)],
          folio: ITransaction(
            id: 't1',
            agentId: 'c1',
            branchId: 'b1',
            status: COMPLETE,
            transactionType: 'sale',
            paymentType: 'Cash',
            cashReceived: 100000,
            customerChangeDue: 0,
            updatedAt: DateTime(2026),
            isIncome: true,
            isExpense: false,
            customerName: 'Acme Ltd',
            receiptNumber: 42,
          ),
          currency: 'RWF',
          stamp: DocumentStamp(
            // A 1x1 PNG.
            bytes: base64Decode(
              'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQ'
              'DwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
            ),
            placement: placement,
          ),
        );
        expect(String.fromCharCodes(bytes.take(4)), '%PDF');
      });
    }

    test('a folio still syncing down is not printed', () {
      final open = _stay();
      final gone = _stay().copyWith(status: HotelStayStatus.checkedOut);
      ITransaction folio(double subTotal) => ITransaction(
        id: 't1',
        agentId: 'c1',
        branchId: 'b1',
        status: COMPLETE,
        transactionType: 'sale',
        paymentType: 'Cash',
        cashReceived: 0,
        customerChangeDue: 0,
        updatedAt: DateTime(2026),
        isIncome: true,
        isExpense: false,
        subTotal: subTotal,
      );
      final room = [_line('Room 101 · 2 nights', 2, 50000)];

      // Checked out, but the folio has not arrived: not a pro-forma.
      expect(
        hotelFolioStillSyncing(stay: gone, folio: null, lines: const []),
        isTrue,
      );
      // Billed, but its lines have not arrived: not an invoice for nothing.
      expect(
        hotelFolioStillSyncing(stay: gone, folio: folio(100000), lines: []),
        isTrue,
      );
      // Complete, an open stay's pro-forma, or a genuinely empty folio.
      expect(
        hotelFolioStillSyncing(stay: gone, folio: folio(100000), lines: room),
        isFalse,
      );
      expect(
        hotelFolioStillSyncing(stay: open, folio: null, lines: const []),
        isFalse,
      );
      expect(
        hotelFolioStillSyncing(stay: gone, folio: folio(0), lines: const []),
        isFalse,
      );
    });

    test('an advance above the folio renders the refund line', () async {
      final bytes = await HotelFolioPdf.build(
        stay: _stay(advances: [_advance('a1', 200000)]),
        lines: [_line('Room 101 · 1 night', 1, 50000)],
        folio: null,
        currency: 'RWF',
      );
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
    });
  });
}
