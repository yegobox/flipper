import 'package:flipper_dashboard/functions.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// [onWillPop] is shared by six screens, two of which call it from a
/// `PopScope(canPop: false)` callback. For those, the dialog must not navigate
/// on its own: popping the refusing route re-enters that callback and the
/// second showDialog lands inside the navigator's history flush
/// ('!_debugLocked' is not true), which both reopened the dialog and stranded
/// the operator on the screen they were trying to leave.
void main() {
  Future<void> pumpHost(
    WidgetTester tester, {
    required VoidCallback? onConfirmed,
    required VoidCallback onExitAttempt,
  }) async {
    await tester.pumpWidget(
      // The No branch reads willPopProvider off the element tree.
      ProviderScope(
        child: MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => TextButton(
              onPressed: () {
                onExitAttempt();
                onWillPop(
                  context: context,
                  navigationPurpose: NavigationPurpose.home,
                  message: 'Done shopping?',
                  onConfirmed: onConfirmed,
                );
              },
              child: const Text('leave'),
            ),
          ),
          ),
        ),
      ),
    );
  }

  testWidgets('with onConfirmed, Yes closes the dialog and hands back over',
      (tester) async {
    var confirmed = 0;
    var attempts = 0;

    await pumpHost(
      tester,
      onConfirmed: () => confirmed++,
      onExitAttempt: () => attempts++,
    );

    await tester.tap(find.text('leave'));
    await tester.pumpAndSettle();
    expect(find.text('Done shopping?'), findsOneWidget);

    await tester.tap(find.text('Yes'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(confirmed, 1, reason: 'the caller owns the exit');
    expect(find.text('Done shopping?'), findsNothing, reason: 'dialog closed');
    // The load-bearing assertion: the helper did not navigate, so nothing
    // re-entered the host's pop path and re-asked.
    expect(attempts, 1);
  });

  testWidgets('No closes the dialog without confirming', (tester) async {
    var confirmed = 0;

    await pumpHost(
      tester,
      onConfirmed: () => confirmed++,
      onExitAttempt: () {},
    );

    await tester.tap(find.text('leave'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No'));
    await tester.pumpAndSettle();

    expect(find.text('Done shopping?'), findsNothing);
    expect(confirmed, 0);
  });
}
