import 'dart:async';

import 'package:flipper_auth/core/providers.dart';
import 'package:flipper_auth/core/services/auth_service.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_auth/features/auth/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService authService;

  Widget buildSubject() {
    return ProviderScope(
      overrides: [
        authServiceProvider.overrideWithValue(authService),
      ],
      child: MaterialApp(
        routes: {
          '/': (_) => const SignUpScreen(),
          '/home': (_) => const Scaffold(body: Text('Home screen')),
        },
      ),
    );
  }

  Future<void> tapSignUp(WidgetTester tester) async {
    final button = find.byType(FlipperGradientButton);
    await tester.ensureVisible(button);
    await tester.pump();
    await tester.tap(button);
  }

  setUp(() {
    authService = MockAuthService();
  });

  group('SignUpScreen', () {
    testWidgets('renders the signup form fields and sign in link',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      expect(find.text('Create account'), findsOneWidget);
      expect(find.text('Full name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Confirm password'), findsOneWidget);
      expect(find.text('Already have an account? Sign in'), findsOneWidget);
    });

    testWidgets('shows validation errors and does not submit invalid input',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      await tapSignUp(tester);
      await tester.pump();

      expect(find.text('Please enter your name'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
      expect(find.text('Please confirm your password'), findsOneWidget);
      verifyNever(
        () => authService.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      );
    });

    testWidgets('requires a six character password and matching confirmation',
        (tester) async {
      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your full name'),
        'Alice Owner',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'alice@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'short',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm your password'),
        'different',
      );

      await tapSignUp(tester);
      await tester.pump();

      expect(
          find.text('Password must be at least 6 characters'), findsOneWidget);
      expect(find.text('Passwords do not match'), findsOneWidget);
      verifyNever(
        () => authService.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      );
    });

    testWidgets('submits trimmed email and navigates home on success',
        (tester) async {
      when(
        () => authService.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) async => AuthResponse());

      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your full name'),
        'Alice Owner',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        '  alice@example.com  ',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'secret1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm your password'),
        'secret1',
      );

      await tapSignUp(tester);
      await tester.pumpAndSettle();

      verify(
        () => authService.signUp(
          email: 'alice@example.com',
          password: 'secret1',
          name: 'Alice Owner',
        ),
      ).called(1);
      expect(find.text('Home screen'), findsOneWidget);
    });

    testWidgets('disables the signup button while signup is in progress',
        (tester) async {
      final completer = Completer<AuthResponse>();
      when(
        () => authService.signUp(
          email: any(named: 'email'),
          password: any(named: 'password'),
          name: any(named: 'name'),
        ),
      ).thenAnswer((_) => completer.future);

      await tester.pumpWidget(buildSubject());

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your full name'),
        'Alice Owner',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your email'),
        'alice@example.com',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Enter your password'),
        'secret1',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Confirm your password'),
        'secret1',
      );

      await tapSignUp(tester);
      await tester.pump();

      final button =
          tester.widget<FlipperGradientButton>(find.byType(FlipperGradientButton));
      expect(button.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      completer.complete(AuthResponse());
      await tester.pumpAndSettle();
    });
  });
}
