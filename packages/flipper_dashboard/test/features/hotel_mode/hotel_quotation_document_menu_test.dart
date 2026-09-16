import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_quotations_screen.dart';
import 'package:flipper_models/models/hotel_quotation.dart';
import 'package:flipper_models/models/hotel_room.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

HotelQuotation _quote({
  String id = 'q1',
  String reference = 'Q-4F2A19',
  String? guestEmail,
  DateTime? createdAt,
}) => HotelQuotation(
  id: id,
  branchId: 'b1',
  reference: reference,
  guestName: 'Aline Uwase',
  guestEmail: guestEmail,
  roomId: 'r1',
  roomName: '204',
  roomType: 'Double',
  checkInAt: DateTime.now().add(const Duration(days: 1)),
  checkOutAt: DateTime.now().add(const Duration(days: 3)),
  nightlyRate: 45000,
  validUntil: DateTime.now().add(const Duration(days: 7)),
  createdAt: createdAt,
);

class _FixedHotelNotifier extends HotelModeNotifier {
  _FixedHotelNotifier(this.initial);
  final HotelModeState initial;

  @override
  HotelModeState build() => initial;
}

Future<void> _pump(
  WidgetTester tester, {
  required List<HotelQuotation> quotes,
  double width = 1440,
}) async {
  tester.view.physicalSize = Size(width, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hotelStaffProvider.overrideWith((ref) async => <Tenant>[]),
        hotelRoomsProvider.overrideWith(
          (ref) => Stream.value(const <HotelRoom>[]),
        ),
        hotelStaysProvider.overrideWith(
          (ref) => Stream.value(const <HotelStay>[]),
        ),
        hotelQuotationsProvider.overrideWith((ref) => Stream.value(quotes)),
        hotelModeProvider.overrideWith(
          () => _FixedHotelNotifier(
            HotelModeState(
              screen: HotelScreen.quotes,
              activeClerk: Tenant(id: 'c1', userId: 'u1', name: 'Richie'),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(size: Size(width, 1000)),
            child: SizedBox(
              width: width,
              height: 1000,
              child: const HotelQuotationsScreen(),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  group('quotation document menu', () {
    // Regression: the menu anchored off the itemBuilder's context, whose
    // nearest render object is the ListView's RenderSliverList, not a
    // RenderBox. The hard cast threw, so tapping Document did nothing at all —
    // no menu, no error the clerk could see.
    testWidgets('opens when Document is tapped inside the list', (
      tester,
    ) async {
      await _pump(tester, quotes: [_quote()]);

      expect(find.text('Document'), findsOneWidget);

      await tester.tap(find.text('Document'));
      await tester.pumpAndSettle();

      // Both go through the shared PdfPresentationService, so Download PDF
      // is the desktop save dialog and Print is the system print dialog.
      expect(find.text('Download PDF'), findsOneWidget);
      expect(find.text('Print'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('names the recipient when the quotation has an email', (
      tester,
    ) async {
      await _pump(tester, quotes: [_quote(guestEmail: 'aline@example.com')]);

      await tester.tap(find.text('Document'));
      await tester.pumpAndSettle();

      expect(find.text('Send to aline@example.com'), findsOneWidget);
    });

    testWidgets('offers to collect an address when there is none', (
      tester,
    ) async {
      await _pump(tester, quotes: [_quote()]);

      await tester.tap(find.text('Document'));
      await tester.pumpAndSettle();

      expect(find.text('Send to guest…'), findsOneWidget);
    });

    testWidgets('each card opens its own menu, not the first card\'s', (
      tester,
    ) async {
      await _pump(
        tester,
        // Explicit timestamps: hotelSortedQuotationsProvider orders newest
        // first, and two quotes built a microsecond apart sort unpredictably.
        quotes: [
          _quote(
            id: 'q1',
            reference: 'Q-AAA111',
            guestEmail: 'a@example.com',
            createdAt: DateTime.now(),
          ),
          _quote(
            id: 'q2',
            reference: 'Q-BBB222',
            guestEmail: 'b@example.com',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          ),
        ],
      );

      // q1 is newest, so it renders first and q2 is the last card.

      await tester.tap(find.text('Document').last);
      await tester.pumpAndSettle();

      expect(find.text('Send to b@example.com'), findsOneWidget);
      expect(find.text('Send to a@example.com'), findsNothing);
    });
  });

  group('send dialog', () {
    testWidgets('shows what is about to be sent before asking for an address', (
      tester,
    ) async {
      await _pump(tester, quotes: [_quote(reference: 'Q-AAD63C')]);

      await tester.tap(find.text('Document'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send to guest…'));
      await tester.pumpAndSettle();

      expect(find.text('Email this quotation'), findsOneWidget);
      // The clerk can confirm they are on the right card without cancelling.
      expect(find.text('Q-AAD63C'), findsWidgets);
      expect(find.text('Aline Uwase'), findsWidgets);
      expect(find.text('Guest email'), findsOneWidget);
      expect(find.text('Send quotation'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('refuses an address that cannot receive mail', (tester) async {
      await _pump(tester, quotes: [_quote()]);

      await tester.tap(find.text('Document'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send to guest…'));
      await tester.pumpAndSettle();

      // A phone number typed into the email box is the mistake to catch.
      await tester.enterText(find.byType(TextField).last, '0788360058');
      await tester.tap(find.text('Send quotation'));
      await tester.pumpAndSettle();

      expect(find.text('That email does not look right'), findsOneWidget);
      // Still open — the clerk gets to correct it.
      expect(find.text('Email this quotation'), findsOneWidget);
    });

    testWidgets('closes on cancel without sending', (tester) async {
      await _pump(tester, quotes: [_quote()]);

      await tester.tap(find.text('Document'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Send to guest…'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Email this quotation'), findsNothing);
      expect(tester.takeException(), isNull);
    });
  });
}
