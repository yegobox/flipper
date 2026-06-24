import 'package:flipper_dashboard/widgets/checkout_error_recovery.dart';
import 'package:flipper_dashboard/widgets/checkout_error_recovery_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

void main() {
  group('checkoutErrorKindFrom', () {
    test('maps no branch StateError', () {
      expect(
        checkoutErrorKindFrom(
          StateError(
            'No default branch selected. Please select a branch first.',
          ),
        ),
        CheckoutErrorKind.noBranch,
      );
    });

    test('maps unknown errors to generic', () {
      expect(
        checkoutErrorKindFrom(Exception('network')),
        CheckoutErrorKind.generic,
      );
    });

    test('diagnostic code for no branch', () {
      expect(
        checkoutErrorDiagnosticCode(
          StateError('No default branch selected'),
        ),
        'no_default_branch',
      );
    });
  });

  group('CheckoutErrorRecoveryScreen widget', () {
    Future<void> noopRecovered() async {}

    Widget buildScreen({required Object error}) {
      return ProviderScope(
        child: MaterialApp(
          home: CheckoutErrorRecoveryScreen(
            error: error,
            onRecovered: noopRecovered,
          ),
        ),
      );
    }

    testWidgets('shows branded no-branch recovery UI', (tester) async {
      await tester.pumpWidget(
        buildScreen(
          error: StateError(
            'No default branch selected. Please select a branch first.',
          ),
        ),
      );
      await tester.pump();

      expect(find.text('No branch selected yet'), findsOneWidget);
      expect(find.text('ACTION NEEDED'), findsOneWidget);
      expect(find.text('Select a branch'), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
      expect(find.textContaining('no_default_branch'), findsOneWidget);
      expect(find.text('Failed to Load Checkout'), findsNothing);
      expect(find.text('Checkout'), findsOneWidget);
    });

    testWidgets('shows generic headline for other errors', (tester) async {
      await tester.pumpWidget(
        buildScreen(error: Exception('Ditto timeout')),
      );
      await tester.pump();

      expect(find.text('Couldn\'t load checkout'), findsOneWidget);
      expect(find.text('CHECKOUT UNAVAILABLE'), findsOneWidget);
      expect(find.text('Select a branch'), findsNothing);
      expect(find.textContaining('Still stuck'), findsOneWidget);
      expect(find.textContaining('Get help'), findsOneWidget);
    });

    testWidgets('opens branch picker sheet with title', (tester) async {
      await tester.pumpWidget(
        buildScreen(error: StateError('No default branch selected')),
      );
      await tester.pump();

      await tester.tap(find.text('Select a branch'));
      await tester.pumpAndSettle();

      expect(find.text('Where is this sale taking place?'), findsOneWidget);
      expect(find.text('Choose a branch'), findsOneWidget);
      expect(find.text('Set as default branch for this device'), findsOneWidget);
    });

    testWidgets('invokes onRecovered when Try again is tapped', (tester) async {
      var recovered = 0;
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: CheckoutErrorRecoveryScreen(
              error: StateError('No default branch selected'),
              onRecovered: () async {
                recovered++;
              },
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Try again'));
      await tester.pump();

      expect(recovered, 1);
    });

    testWidgets('Try again shows toast when branch still missing', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildScreen(error: StateError('No default branch selected')),
      );
      await tester.pump();

      await tester.tap(find.text('Try again'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(
        find.textContaining('Still no branch selected'),
        findsOneWidget,
      );
    });
  });
}
