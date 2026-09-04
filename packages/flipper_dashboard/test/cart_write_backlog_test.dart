import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Adds are serialised behind one persist lock, so a big cart's backlog drains
/// steadily rather than all at once. A flat deadline refused Pay on a 60-line
/// cart with a dozen writes still in flight and landing normally.
void main() {
  late ProviderContainer container;

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  OptimisticCart cart() => container.read(optimisticCartProvider.notifier);

  test('returns immediately when nothing is queued', () async {
    expect(await awaitQueuedCartWritesWhileProgressing(cart()), isTrue);
  });

  test('waits out a backlog that drains past the old flat 15s deadline',
      () async {
    // The reported failure: 60 lines, 12 writes still in flight at 15s, all
    // landing normally, and Pay refused. Nothing here stalls, so nothing here
    // may be refused — no matter how long the queue takes.
    final notifier = cart();
    for (var i = 0; i < 12; i++) {
      notifier.noteAddInFlight('v$i');
    }
    expect(notifier.queuedAddCount, 12);

    for (var i = 0; i < 12; i++) {
      Future<void>.delayed(
        Duration(milliseconds: 1500 * (i + 1)),
        () => notifier.noteAddSettled('v$i'),
      );
    }

    final sw = Stopwatch()..start();
    expect(await awaitQueuedCartWritesWhileProgressing(notifier), isTrue);
    expect(notifier.queuedAddCount, 0);
    expect(
      sw.elapsedMilliseconds,
      greaterThan(15000),
      reason: 'must have waited past the deadline that caused the regression',
    );
  }, timeout: const Timeout(Duration(seconds: 90)));

  test('gives up when the backlog stops moving', () async {
    final notifier = cart();
    notifier.noteAddInFlight('stuck');
    notifier.noteAddInFlight('lands');
    // One lands, then nothing ever moves again.
    Future<void>.delayed(
      const Duration(milliseconds: 200),
      () => notifier.noteAddSettled('lands'),
    );

    expect(await awaitQueuedCartWritesWhileProgressing(notifier), isFalse);
    expect(notifier.queuedAddCount, 1);
  }, timeout: const Timeout(Duration(seconds: 30)));

  test('counts every queued add, including repeats of one variant', () {
    final notifier = cart();
    notifier.noteAddInFlight('v1');
    notifier.noteAddInFlight('v1');
    notifier.noteAddInFlight('v2');
    expect(notifier.queuedAddCount, 3);

    notifier.noteAddSettled('v1');
    expect(notifier.queuedAddCount, 2);
  });
}
