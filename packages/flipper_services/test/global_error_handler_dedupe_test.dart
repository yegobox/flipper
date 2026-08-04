import 'package:flipper_services/GlobalLogError.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/global_error_handler_dedupe_test.dart
//
// Latched framework assertions (MouseTracker's '!_debugDuringDeviceUpdate' and
// _RenderTheater's '!_skipMarkNeedsLayout') fire once per frame for the rest of
// the session. Unsuppressed, each repeat became a Log row — flooding the DB and
// burying the first error, which is the only one that names the real cause.
void main() {
  setUp(GlobalErrorHandler.resetReportTallies);

  final stack = StackTrace.fromString(
    '#0      _AssertionError._doThrowNew\n'
    '#1      MouseTracker._deviceUpdatePhase',
  );

  test('reports the first few identical errors, then suppresses', () {
    final decisions = [
      for (var i = 0; i < 6; i++)
        GlobalErrorHandler.debugShouldReport('same failure', stack),
    ];

    expect(decisions, [true, true, true, false, false, false]);
  });

  test('different errors are tracked separately', () {
    for (var i = 0; i < 6; i++) {
      GlobalErrorHandler.debugShouldReport('failure A', stack);
    }

    expect(
      GlobalErrorHandler.debugShouldReport('failure A', stack),
      isFalse,
      reason: 'A is already suppressed',
    );
    expect(
      GlobalErrorHandler.debugShouldReport('failure B', stack),
      isTrue,
      reason: 'an unrelated error must still surface',
    );
  });

  test('the same message from a different frame is its own signature', () {
    final otherStack = StackTrace.fromString(
      '#0      _AssertionError._doThrowNew\n'
      '#1      _RenderTheater._addDeferredChild',
    );

    for (var i = 0; i < 6; i++) {
      GlobalErrorHandler.debugShouldReport('Failed assertion', stack);
    }

    expect(
      GlobalErrorHandler.debugShouldReport('Failed assertion', otherStack),
      isTrue,
    );
  });

  test('a null stack trace does not blow up the signature', () {
    expect(GlobalErrorHandler.debugShouldReport('no stack', null), isTrue);
    expect(GlobalErrorHandler.debugShouldReport('no stack', null), isTrue);
  });
}
