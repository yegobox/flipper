import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_folio_screen.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

final _stay = HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '103',
  transactionId: 't1',
  guestName: 'Uwase',
  checkInAt: DateTime.now().subtract(const Duration(hours: 2)),
  expectedCheckOutAt: DateTime.now().add(const Duration(days: 1)),
  nightlyRate: 55000,
  status: HotelStayStatus.inHouse,
);

TransactionItem _roomNight() => TransactionItem(
  name: 'Room 103 · 1 night',
  qty: 1,
  price: 55000,
  discount: 0,
  prc: 55000,
  ttCatCd: 'B',
  loggedByTenantId: 'c1',
);

class _FixedHotelNotifier extends HotelModeNotifier {
  _FixedHotelNotifier(this.initial);
  final HotelModeState initial;

  @override
  HotelModeState build() => initial;
}

Future<void> _pump(WidgetTester tester, List<TransactionItem> lines) async {
  tester.view.physicalSize = const Size(1440, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hotelFolioLinesProvider.overrideWith((ref, _) => Stream.value(lines)),
        hotelModeProvider.overrideWith(
          () => _FixedHotelNotifier(
            HotelModeState(
              screen: HotelScreen.folio,
              activeStay: _stay,
              activeClerk: Tenant(id: 'c1', userId: 'u1', name: 'Richie'),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: const Scaffold(body: HotelFolioScreen()),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets(
    'Cancel stay on a folio with charges asks first instead of doing nothing',
    (tester) async {
      await _pump(tester, [_roomNight()]);

      await tester.tap(find.widgetWithText(TextButton, 'Cancel stay'));
      await tester.pumpAndSettle();

      expect(find.text('Cancel the stay for Uwase?'), findsOneWidget);
      expect(find.textContaining('RWF 55,000 of charges'), findsOneWidget);

      await tester.tap(find.text('Keep stay'));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(find.text('Uwase'), findsOneWidget);
    },
  );
}
