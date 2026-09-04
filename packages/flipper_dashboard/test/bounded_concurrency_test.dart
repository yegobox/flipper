import 'package:flipper_dashboard/utils/bounded_concurrency.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('forEachBounded', () {
    test('visits every item exactly once', () async {
      final seen = <int>[];
      await forEachBounded(List.generate(100, (i) => i), (i) async {
        seen.add(i);
      });

      expect(seen.length, 100);
      expect(seen.toSet().length, 100);
    });

    test('never exceeds the window', () async {
      var inFlight = 0;
      var peak = 0;

      await forEachBounded(
        List.generate(100, (i) => i),
        (_) async {
          inFlight++;
          if (inFlight > peak) peak = inFlight;
          await Future<void>.delayed(const Duration(milliseconds: 1));
          inFlight--;
        },
        concurrency: 8,
      );

      expect(peak, lessThanOrEqualTo(8));
      expect(peak, greaterThan(1), reason: 'must actually run in parallel');
    });

    test('a 100-item run costs ~13 windows, not 100', () async {
      // The point of the whole exercise: per-line Ditto work on the Pay path
      // must not scale one round trip per line.
      var windows = 0;
      var completedInWindow = 0;

      await forEachBounded(
        List.generate(100, (i) => i),
        (_) async {
          if (completedInWindow == 0) windows++;
          completedInWindow++;
          await Future<void>.delayed(const Duration(milliseconds: 1));
          completedInWindow--;
        },
        concurrency: 8,
      );

      expect(windows, lessThanOrEqualTo(13));
    });

    test('propagates the first error like a sequential loop', () async {
      expect(
        () => forEachBounded(List.generate(20, (i) => i), (i) async {
          if (i == 3) throw StateError('boom');
        }),
        throwsStateError,
      );
    });

    test('does not start later windows after a failure', () async {
      final started = <int>[];

      await expectLater(
        forEachBounded(
          List.generate(40, (i) => i),
          (i) async {
            started.add(i);
            if (i == 0) throw StateError('boom');
          },
          concurrency: 8,
        ),
        throwsStateError,
      );

      // The failing window still runs to completion; nothing past it starts.
      expect(started.length, lessThanOrEqualTo(8));
    });

    test('empty and single-item inputs are handled', () async {
      var calls = 0;
      await forEachBounded(<int>[], (_) async => calls++);
      expect(calls, 0);

      await forEachBounded([1], (_) async => calls++);
      expect(calls, 1);
    });

    test('accepts a lazy iterable', () async {
      final seen = <int>[];
      await forEachBounded(
        List.generate(20, (i) => i).where((i) => i.isEven),
        (i) async => seen.add(i),
      );
      expect(seen.length, 10);
    });
  });
}
