import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_ui/dialogs/AdminPinDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  setUpAll(() => GoogleFonts.config.allowRuntimeFetching = false);

  Future<Future<bool?>> open(
    WidgetTester tester, {
    required AdminPinMode mode,
    String? expectedPin,
    Future<void> Function(String pin)? onSavePin,
  }) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    late Future<bool?> result;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: FlipperLocalizationDelegates.delegates,
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () {
              result = showAdminPinDialog(
                context: context,
                mode: mode,
                expectedPin: expectedPin,
                onSavePin: onSavePin,
              );
            },
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return result;
  }

  Future<void> enter(WidgetTester tester, String pin) async {
    for (final digit in pin.split('')) {
      await tester.tap(find.byKey(ValueKey('admin_pin_key_$digit')));
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  testWidgets('set mode saves automatically once the PIN is confirmed',
      (tester) async {
    String? saved;
    final result = await open(
      tester,
      mode: AdminPinMode.set,
      onSavePin: (pin) async => saved = pin,
    );

    expect(find.text('Set up admin PIN'), findsOneWidget);
    expect(find.text('Step 1 of 2'), findsOneWidget);
    expect(find.textContaining('Demo'), findsNothing);

    await enter(tester, '1234');
    expect(find.text('Confirm your PIN'), findsOneWidget);
    expect(find.text('Step 2 of 2'), findsOneWidget);

    await enter(tester, '1234');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(saved, '1234');
    expect(await result, isTrue);
  });

  testWidgets('set mode mismatch returns to step 1 without saving',
      (tester) async {
    var saveCalls = 0;
    await open(
      tester,
      mode: AdminPinMode.set,
      onSavePin: (_) async => saveCalls++,
    );

    await enter(tester, '1234');
    await enter(tester, '9999');

    expect(saveCalls, 0);
    expect(find.text('Set up admin PIN'), findsOneWidget);
    expect(find.text("PINs didn't match. Try again."), findsOneWidget);
  });

  testWidgets('verify mode accepts the correct PIN', (tester) async {
    final result =
        await open(tester, mode: AdminPinMode.verify, expectedPin: '4321');
    await enter(tester, '4321');
    expect(await result, isTrue);
  });

  testWidgets('verify mode locks out after 5 wrong attempts', (tester) async {
    await open(tester, mode: AdminPinMode.verify, expectedPin: '4321');

    await enter(tester, '0000');
    expect(find.text('Incorrect PIN. 4 attempts left.'), findsOneWidget);
    for (var i = 0; i < 4; i++) {
      await enter(tester, '0000');
    }
    expect(find.textContaining('Too many attempts'), findsOneWidget);

    // Keypad is disabled while locked — even the correct PIN is ignored.
    await enter(tester, '4321');
    expect(find.byType(Dialog), findsOneWidget);

    await tester.pump(const Duration(seconds: 31));
    await tester.pumpAndSettle();
    expect(find.textContaining('Too many attempts'), findsNothing);
  });

  testWidgets('hardware keyboard enters digits and Escape cancels',
      (tester) async {
    final result =
        await open(tester, mode: AdminPinMode.verify, expectedPin: '4321');

    await tester.sendKeyEvent(LogicalKeyboardKey.digit4);
    await tester.sendKeyEvent(LogicalKeyboardKey.numpad3);
    await tester.pump();
    expect(
      find.bySemanticsLabel('PIN, 2 of 4 digits entered'),
      findsOneWidget,
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(await result, isFalse);
  });

  testWidgets('hardware keyboard can complete verification', (tester) async {
    final result =
        await open(tester, mode: AdminPinMode.verify, expectedPin: '4321');
    for (final key in [
      LogicalKeyboardKey.digit4,
      LogicalKeyboardKey.digit3,
      LogicalKeyboardKey.digit2,
      LogicalKeyboardKey.digit1,
    ]) {
      await tester.sendKeyEvent(key);
    }
    await tester.pumpAndSettle();
    expect(await result, isTrue);
  });
}
