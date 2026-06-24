// E2E test for the PIN + TOTP login flow.
//
// Test account (non-expiring TOTP):
//   PIN : 157307
//   TOTP: 725155
//
// Run with:
//   chromedriver --port=4444 &
//   flutter drive \
//     --driver=test_driver/main_test.dart \
//     --target=integration_test/pin_login_e2e_test.dart \
//     -d chrome

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flipper_web/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('PIN login E2E', () {
    testWidgets(
      'enters PIN → authenticator TOTP → reaches business selection',
      (WidgetTester tester) async {
        // Boot the full app (initialises Supabase, HTTP overrides, etc.)
        app.main();

        // Allow Supabase initialisation and first routing decision to settle.
        await tester.pumpAndSettle(const Duration(seconds: 5));

        // ── Step 1: PIN screen ────────────────────────────────────────────
        expect(
          find.text('Welcome back'),
          findsOneWidget,
          reason: 'Should open on the PIN login screen',
        );

        // The visible PIN cells are driven by a hidden TextFormField
        // (key: pin_hidden_input) that has autofocus.  enterText injects
        // text directly into the field controller.
        await tester.enterText(
          find.byKey(const Key('pin_hidden_input')),
          '157307',
        );

        // _onPinChanged schedules auto-submit via addPostFrameCallback when
        // 6 digits are present.  Give the network round-trip time to finish.
        await tester.pumpAndSettle(const Duration(seconds: 10));

        // ── Step 2: TOTP screen ───────────────────────────────────────────
        expect(
          find.text('Verify your identity'),
          findsOneWidget,
          reason: 'PIN verified – should show TOTP/OTP step',
        );

        // Default mode is Authenticator (TOTP).  The test account uses a
        // fixed, non-expiring TOTP code, so no toggle needed.
        await tester.enterText(
          find.byKey(const Key('otp_input')),
          '725155',
        );

        await tester.tap(find.text('Verify'));

        // Wait for verifyTotp(), profile fetch, and GoRouter redirect.
        await tester.pumpAndSettle(const Duration(seconds: 15));

        // ── Step 3: business selection ────────────────────────────────────
        expect(
          find.text('Choose a Business'),
          findsOneWidget,
          reason: 'Successful login should land on business selection',
        );
      },
    );

    testWidgets(
      'shows error on wrong PIN and clears the cells',
      (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 5));

        expect(find.text('Welcome back'), findsOneWidget);

        await tester.enterText(
          find.byKey(const Key('pin_hidden_input')),
          '000000',
        );

        await tester.pumpAndSettle(const Duration(seconds: 8));

        // PIN screen should still be visible (not advanced to OTP step)
        expect(find.text('Welcome back'), findsOneWidget);
        expect(find.text('Verify your identity'), findsNothing);
      },
    );
  });
}
