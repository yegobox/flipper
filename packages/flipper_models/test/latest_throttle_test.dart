import 'package:flipper_models/sync/utils/latest_throttle.dart';
import 'package:flutter_test/flutter_test.dart';

/// The POS stock watcher decodes a page of stock and repaints the grid per
/// emission; a sync burst must cost a few of those, not one per changed row.
void main() {
  const window = Duration(milliseconds: 40);

  test('the first value goes through at once', () {
    final got = <int>[];
    final throttle = LatestThrottle<int>(window, got.add)..add(1);
    expect(got, [1]);
    throttle.close();
  });

  test('a burst collapses to its first and newest values', () async {
    final got = <int>[];
    final throttle = LatestThrottle<int>(window, got.add);
    for (var i = 1; i <= 20; i++) {
      throttle.add(i);
    }
    expect(got, [1]);

    await Future<void>.delayed(window * 2);
    expect(got, [1, 20]);

    // Quiet again: the next value is immediate.
    await Future<void>.delayed(window * 2);
    throttle.add(21);
    expect(got, [1, 20, 21]);
    throttle.close();
  });

  test('nothing is delivered after close', () async {
    final got = <int>[];
    LatestThrottle<int>(window, got.add)
      ..add(1)
      ..add(2)
      ..close()
      ..add(3);

    await Future<void>.delayed(window * 2);
    expect(got, [1]);
  });
}
