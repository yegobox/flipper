
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('PinScreen', () {
    testWidgets('renders correctly before PIN verification', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: PinScreen()),
        ),
      );

      expect(find.text('Enter PIN'), findsOneWidget);
      expect(find.byKey(const Key('pinOrOtpInput')), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Submit'), findsOneWidget);
      expect(find.byType(SegmentedButton<OtpType>), findsNothing);
    });

    group('after PIN verification', () {
      testWidgets('renders OTP/TOTP toggle and defaults to SMS', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: PinScreen(isPinVerified: true),
            ),
          ),
        );

        expect(find.text('Enter SMS OTP'), findsOneWidget);
        expect(find.byType(SegmentedButton<OtpType>), findsOneWidget);
        expect(find.text('SMS'), findsOneWidget);
        expect(find.text('Authenticator'), findsOneWidget);

        final segmentedButton = tester.widget<SegmentedButton<OtpType>>(
          find.byType(SegmentedButton<OtpType>),
        );
        expect(segmentedButton.selected, {OtpType.sms});
      });

      testWidgets('toggles to Authenticator and updates UI', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: PinScreen(isPinVerified: true),
            ),
          ),
        );

        await tester.tap(find.text('Authenticator'));
        await tester.pumpAndSettle();

        expect(find.text('Enter Authenticator Code'), findsOneWidget);
        final segmentedButton = tester.widget<SegmentedButton<OtpType>>(
          find.byType(SegmentedButton<OtpType>),
        );
        expect(segmentedButton.selected, {OtpType.authenticator});
      });

      testWidgets('toggles back to SMS and updates UI', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(
              home: PinScreen(isPinVerified: true),
            ),
          ),
        );

        // Go to Authenticator first
        await tester.tap(find.text('Authenticator'));
        await tester.pumpAndSettle();

        // Then go back to SMS
        await tester.tap(find.text('SMS'));
        await tester.pumpAndSettle();

        expect(find.text('Enter SMS OTP'), findsOneWidget);
        final segmentedButton = tester.widget<SegmentedButton<OtpType>>(
          find.byType(SegmentedButton<OtpType>),
        );
        expect(segmentedButton.selected, {OtpType.sms});
      });
    });
  });
}
