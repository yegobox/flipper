import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  group('PinScreen', () {
    testWidgets('renders correctly before PIN verification', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: PinScreen())),
      );
      await tester.pump();

      expect(find.text('Welcome back'), findsOneWidget);
      expect(find.text('PIN'), findsOneWidget);
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.byType(FlipperGradientButton), findsOneWidget);
      expect(find.text('SMS'), findsNothing);
      expect(find.text('Authenticator'), findsNothing);
    });

    group('after PIN verification', () {
      testWidgets('renders OTP toggle and defaults to Authenticator', (
        tester,
      ) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: PinScreen(isPinVerified: true)),
          ),
        );
        await tester.pump();

        expect(find.text('Verify your identity'), findsOneWidget);
        expect(find.text('SMS'), findsOneWidget);
        expect(find.text('Authenticator'), findsOneWidget);
        expect(find.text('Authenticator Code'), findsOneWidget);
        expect(find.text('SMS Code'), findsNothing);
      });

      testWidgets('toggles to SMS and updates UI', (tester) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: PinScreen(isPinVerified: true)),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('SMS'));
        await tester.pumpAndSettle();

        expect(find.text('SMS Code'), findsOneWidget);
        expect(find.text('Authenticator Code'), findsNothing);
      });

      testWidgets('toggles back to Authenticator and updates UI', (
        tester,
      ) async {
        await tester.pumpWidget(
          const ProviderScope(
            child: MaterialApp(home: PinScreen(isPinVerified: true)),
          ),
        );
        await tester.pump();

        await tester.tap(find.text('SMS'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Authenticator'));
        await tester.pumpAndSettle();

        expect(find.text('Authenticator Code'), findsOneWidget);
        expect(find.text('SMS Code'), findsNothing);
      });
    });
  });
}
