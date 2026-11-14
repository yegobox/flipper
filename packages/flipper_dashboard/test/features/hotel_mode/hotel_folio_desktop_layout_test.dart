import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_folio_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_folio_widgets.dart';
import 'package:flipper_dashboard/widgets/mpos/mpos_customer_sheet.dart';
import 'package:flipper_design_system/flipper_design_system.dart'
    show CustomAppBar;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/models/hotel_stay.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final _stay = HotelStay(
  id: 's1',
  branchId: 'b1',
  roomId: 'r1',
  roomName: '102',
  transactionId: 't1',
  guestName: 'Marina',
  checkInAt: DateTime.now().subtract(const Duration(hours: 2)),
  expectedCheckOutAt: DateTime.now().add(const Duration(days: 2)),
  nightlyRate: 35000,
  status: HotelStayStatus.inHouse,
);

TransactionItem _roomNights() => TransactionItem(
  name: 'Room 102 · 2 nights',
  qty: 2,
  price: 35000,
  discount: 0,
  prc: 35000,
  ttCatCd: 'B',
  loggedByTenantId: 'c1',
);

class _RecordingHotelNotifier extends HotelModeNotifier {
  _RecordingHotelNotifier(this.initial);
  final HotelModeState initial;
  int backCalls = 0;

  @override
  HotelModeState build() => initial;

  @override
  void backToRooms() => backCalls++;
}

class _FakeCustomers extends CustomersNotifier {
  @override
  AsyncValue<List<Customer>> build() => const AsyncValue.data(<Customer>[]);
}

void _size(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

Future<_RecordingHotelNotifier> _pumpFolio(
  WidgetTester tester, {
  required Size size,
  List<TransactionItem>? lines,
}) async {
  _size(tester, size);
  final notifier = _RecordingHotelNotifier(
    HotelModeState(
      screen: HotelScreen.folio,
      activeStay: _stay,
      activeClerk: Tenant(id: 'c1', userId: 'u1', name: 'Richie'),
    ),
  );
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        hotelFolioLinesProvider.overrideWith(
          (ref, _) => Stream.value(lines ?? [_roomNights()]),
        ),
        hotelModeProvider.overrideWith(() => notifier),
      ],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: const Scaffold(body: HotelFolioScreen()),
      ),
    ),
  );
  await tester.pump();
  return notifier;
}

/// A button that opens [open] so the dialog gets a real navigator.
Future<void> _pumpLauncher(
  WidgetTester tester, {
  required Size size,
  required Future<Object?> Function(BuildContext context) open,
  void Function(Object? result)? onResult,
}) async {
  _size(tester, size);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [customersProvider.overrideWith(_FakeCustomers.new)],
      child: MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                // Not `onResult?.call(await open(context))`: a null-aware
                // call skips its arguments, so the dialog never opened.
                final result = await open(context);
                onResult?.call(result);
              },
              child: const Text('open'),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
}

void main() {
  const desk = Size(1600, 900);
  const phone = Size(400, 860);

  testWidgets('desk folio: CustomAppBar, charges table and summary panel', (
    tester,
  ) async {
    await _pumpFolio(tester, size: desk);

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text('Room 102'), findsOneWidget);
    expect(find.byType(HotelFolioLineHeader), findsOneWidget);

    final summary = find.byKey(const ValueKey('hotel-folio-summary'));
    expect(summary, findsOneWidget);
    expect(tester.getSize(summary).width, 360);
    expect(
      find.descendant(
        of: summary,
        matching: find.byKey(const ValueKey('hotel-folio-check-out')),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: summary, matching: find.text('Cancel stay')),
      findsOneWidget,
    );

    // Capped and centred: a wide monitor does not stretch the folio.
    final card = tester.getRect(
      find.byKey(const ValueKey('hotel-folio-charges-card')),
    );
    expect(tester.getRect(summary).right - card.left, lessThanOrEqualTo(1280));
    expect(card.left, greaterThan(100));
  });

  testWidgets('the app bar back arrow returns to the rooms', (tester) async {
    final notifier = await _pumpFolio(tester, size: desk);

    await tester.tap(
      find.descendant(
        of: find.byType(CustomAppBar),
        matching: find.byIcon(Icons.arrow_back),
      ),
    );
    await tester.pump();

    expect(notifier.backCalls, 1);
  });

  testWidgets('phone folio keeps one column with the CustomAppBar on top', (
    tester,
  ) async {
    await _pumpFolio(tester, size: phone);

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.byKey(const ValueKey('hotel-folio-summary')), findsNothing);
    expect(find.byType(HotelFolioLineHeader), findsNothing);
    expect(find.byKey(const ValueKey('hotel-folio-check-out')), findsOneWidget);
  });

  testWidgets('a pane too narrow for both desk columns keeps one column', (
    tester,
  ) async {
    // Past the 600 phone breakpoint but under the desk's minimum: two
    // columns would leave the charges about 160 wide and clip each row.
    await _pumpFolio(tester, size: const Size(800, 900));

    expect(tester.takeException(), isNull);
    expect(find.byKey(const ValueKey('hotel-folio-summary')), findsNothing);
    expect(find.byKey(const ValueKey('hotel-folio-check-out')), findsOneWidget);
  });

  testWidgets('desk check-out: 480 wide, full-size tender labels, Enter '
      'settles', (tester) async {
    Object? result;
    await _pumpLauncher(
      tester,
      size: desk,
      open: (context) =>
          HotelCheckOutDialog.show(context, total: 70000, allowCredit: true),
      onResult: (r) => result = r,
    );

    final dialog = find.byKey(const ValueKey('hotel-check-out-desk'));
    expect(dialog, findsOneWidget);
    expect(tester.getSize(dialog).width, 480);
    for (final label in ['Cash', 'Mobile money', 'Card', 'Credit']) {
      expect(
        find.descendant(of: dialog, matching: find.text(label)),
        findsOneWidget,
        reason: label,
      );
    }
    // Labels are never shrunk to fit.
    expect(
      find.descendant(of: dialog, matching: find.byType(FittedBox)),
      findsNothing,
    );

    await tester.enterText(
      find.byKey(const ValueKey('hotel-check-out-cash')),
      '80000',
    );
    await tester.pump();
    expect(find.text('RWF 10,000'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(dialog, findsNothing);
    final settled = result! as HotelCheckOutResult;
    expect(settled.paymentType, 'Cash');
    expect(settled.cashReceived, 80000);
    expect(settled.changeDue, 10000);
  });

  testWidgets('desk check-out: short cash keeps the dialog open on Enter', (
    tester,
  ) async {
    await _pumpLauncher(
      tester,
      size: desk,
      open: (context) => HotelCheckOutDialog.show(context, total: 70000),
    );

    await tester.enterText(
      find.byKey(const ValueKey('hotel-check-out-cash')),
      '5000',
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('hotel-check-out-desk')), findsOneWidget);
  });

  testWidgets('customer picker is a centred dialog on a desk', (tester) async {
    await _pumpLauncher(
      tester,
      size: desk,
      open: (context) => MposCustomerSheet.pick(context),
    );

    expect(find.byType(Dialog), findsOneWidget);
    final body = find.byType(MposCustomerSheetBody);
    expect(
      tester.getSize(body).width,
      lessThanOrEqualTo(MposCustomerSheet.dialogMaxWidth),
    );
    final rect = tester.getRect(body);
    expect(rect.center.dx, closeTo(desk.width / 2, 1));
  });

  testWidgets('customer dialog scrolls when the keyboard leaves it short', (
    tester,
  ) async {
    // A short, wide touch screen: 800x400 with a 250 keyboard leaves the
    // dialog about 100 high, less than the fields alone.
    tester.view.viewInsets = const FakeViewPadding(bottom: 250);
    await _pumpLauncher(
      tester,
      size: const Size(800, 400),
      open: (context) => MposCustomerSheet.pick(context),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(Dialog), findsOneWidget);
    final form = find.descendant(
      of: find.byType(MposCustomerSheetBody),
      matching: find.byType(SingleChildScrollView),
    );
    expect(form, findsOneWidget);
    await tester.dragUntilVisible(
      find.byKey(const ValueKey('mposCustomerNameField')),
      form,
      const Offset(0, -40),
    );
  });

  testWidgets('customer picker stays a bottom sheet on a phone', (
    tester,
  ) async {
    await _pumpLauncher(
      tester,
      size: phone,
      open: (context) => MposCustomerSheet.pick(context),
    );

    expect(find.byType(Dialog), findsNothing);
    final rect = tester.getRect(find.byType(MposCustomerSheetBody));
    expect(rect.width, phone.width);
    expect(rect.bottom, phone.height);
  });
}
