import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_web/features/home/home_screen.dart';
import 'package:flipper_web/features/login/pin_screen.dart';

void main() {
  group('HomeScreen', () {
    // Helper to pump the widget with MaterialApp and a larger screen size
    Future<void> pumpHomeScreen(WidgetTester tester) async {
      // Set a wide enough screen size to avoid overflow in the header
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle(); // Wait for animations
    }

    testWidgets('renders all major components correctly', (
      WidgetTester tester,
    ) async {
      await pumpHomeScreen(tester);

      // Verify Header
      expect(find.text('Flipper'), findsOneWidget);
      expect(find.text('Pricing'), findsOneWidget);
      expect(find.text('Blog'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
      expect(find.text('Download'), findsOneWidget);
      expect(find.text('Help'), findsOneWidget);
      expect(find.text('21k'), findsOneWidget);

      // Verify Hero Section Title (RichText)
      final richTextFinder = find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText() == 'Safe home\nfor your business',
      );
      expect(richTextFinder, findsOneWidget);

      expect(
        find.text('Private by default. Works everywhere. Ready for business.'),
        findsOneWidget,
      );

      // Verify Buttons
      expect(find.widgetWithText(TextButton, 'Sign up'), findsNWidgets(2));
      expect(find.widgetWithText(TextButton, 'Login'), findsOneWidget);

      // Verify Photo Cards
      expect(find.byIcon(Icons.business_outlined), findsNWidgets(4));
    });

    testWidgets('navigates to PinScreen when header "Sign up" is tapped', (
      WidgetTester tester,
    ) async {
      await pumpHomeScreen(tester);

      await tester.tap(find.widgetWithText(TextButton, 'Sign up').first);
      await tester.pumpAndSettle();

      expect(find.byType(PinScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('navigates to PinScreen when hero "Sign up" is tapped', (
      WidgetTester tester,
    ) async {
      await pumpHomeScreen(tester);

      final heroSignUpButton = find.widgetWithText(TextButton, 'Sign up').last;
      await tester.ensureVisible(heroSignUpButton);
      await tester.pumpAndSettle();
      await tester.tap(heroSignUpButton);
      await tester.pumpAndSettle();

      expect(find.byType(PinScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('navigates to PinScreen when "Login" is tapped', (
      WidgetTester tester,
    ) async {
      await pumpHomeScreen(tester);

      final loginButton = find.widgetWithText(TextButton, 'Login');
      await tester.ensureVisible(loginButton);
      await tester.pumpAndSettle();
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      expect(find.byType(PinScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });
  });
}
