import 'dart:async';

import 'package:flipper_dashboard/utils/frame_sync.dart';
import 'package:flutter_test/flutter_test.dart';

/// Completing a sale must never be gated on the window being visible.
/// `WidgetsBinding.endOfFrame` only completes when a frame is actually
/// produced, and a backgrounded window produces none — which left the Pay
/// button spinning on a sale that had completed, printed and cleared.
void main() {
  test('returns when the frame arrives', () async {
    final frame = Completer<void>();
    final waited = awaitFrameOrSkip(
      frame.future,
      timeout: const Duration(seconds: 5),
    );

    frame.complete();
    await waited; // must not throw or hang
  });

  test('gives up when no frame is ever produced', () async {
    // The backgrounded-window case: this future never completes.
    final neverPainted = Completer<void>();
    final sw = Stopwatch()..start();

    await awaitFrameOrSkip(
      neverPainted.future,
      timeout: const Duration(milliseconds: 100),
    );

    expect(sw.elapsedMilliseconds, lessThan(3000));
    expect(neverPainted.isCompleted, isFalse);
  });

  test('does not swallow a real error from the frame future', () async {
    final failing = Future<void>.error(StateError('engine gone'));
    await expectLater(
      awaitFrameOrSkip(failing, timeout: const Duration(seconds: 5)),
      throwsStateError,
    );
  });
}
