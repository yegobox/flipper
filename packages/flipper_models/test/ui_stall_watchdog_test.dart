import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show AppExitResponse;

import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tmp;
  late DateTime now;
  late PerfOpTrail trail;

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('ui_stall_');
    now = DateTime.utc(2026, 10, 31, 12);
    trail = PerfOpTrail(clock: () => now, capacity: 3);
  });

  tearDown(() => tmp.deleteSync(recursive: true));

  group('PerfOpTrail', () {
    test(
      'lists running ops, then remembers them with their duration',
      () async {
        final gate = Completer<void>();
        final done = trail.track('pos_search', () => gate.future);
        now = now.add(const Duration(milliseconds: 40));

        expect(trail.running(), ['pos_search(running 40ms)']);
        expect(trail.recent(), isEmpty);

        now = now.add(const Duration(milliseconds: 60));
        gate.complete();
        await done;

        expect(trail.running(), isEmpty);
        expect(trail.recent(), ['pos_search(100ms)']);
      },
    );

    test('keeps only the newest ops', () {
      for (final label in ['a', 'b', 'c', 'd']) {
        trail.note(label, took: const Duration(milliseconds: 5));
      }
      expect(trail.recent(), ['b(5ms)', 'c(5ms)', 'd(5ms)']);
    });

    test('a failing op is still recorded and its error passes through', () {
      expect(
        trail.track<void>('boom', () async => throw StateError('x')),
        throwsStateError,
      );
    });

    test('a critical op holds the marker until the last one ends', () async {
      final marker = File('${tmp.path}/perf/inflight.json');
      trail.useMarkerFile(marker);
      final first = Completer<void>();
      final second = Completer<void>();

      final a = trail.track('a', () => first.future, critical: true);
      final b = trail.track('b', () => second.future, critical: true);
      expect(jsonDecode(marker.readAsStringSync())['op'], 'b');

      first.complete();
      await a;
      expect(marker.existsSync(), isTrue);

      second.complete();
      await b;
      expect(marker.existsSync(), isFalse);
    });

    test('when the newer critical op ends first, the older one takes the '
        'marker back', () async {
      final marker = File('${tmp.path}/perf/inflight.json');
      trail.useMarkerFile(marker);
      final older = Completer<void>();
      final newer = Completer<void>();

      final a = trail.track('pos_search', () => older.future, critical: true);
      final b = trail.track('autoadd', () => newer.future, critical: true);
      expect(jsonDecode(marker.readAsStringSync())['op'], 'autoadd');

      newer.complete();
      await b;
      expect(jsonDecode(marker.readAsStringSync())['op'], 'pos_search');

      older.complete();
      await a;
      expect(marker.existsSync(), isFalse);
    });

    test('a clean exit drops the marker, and ops ending after it do not '
        'write it back', () async {
      final marker = File('${tmp.path}/perf/inflight.json');
      trail.useMarkerFile(marker);
      final first = Completer<void>();
      final second = Completer<void>();
      final a = trail.track('a', () => first.future, critical: true);
      final b = trail.track('b', () => second.future, critical: true);

      trail.markCleanExit();
      expect(marker.existsSync(), isFalse);

      second.complete();
      await b;
      expect(marker.existsSync(), isFalse);
      first.complete();
      await a;
      expect(marker.existsSync(), isFalse);

      // A critical op started afterwards (the exit was cancelled) still counts.
      final later = Completer<void>();
      final c = trail.track('c', () => later.future, critical: true);
      expect(marker.existsSync(), isTrue);
      later.complete();
      await c;
      expect(marker.existsSync(), isFalse);
    });

    testWidgets('a quit request clears the marker and lets the app exit', (
      tester,
    ) async {
      final marker = File('${tmp.path}/perf/inflight.json');
      trail.useMarkerFile(marker);
      final gate = Completer<void>();
      final op = trail.track('pos_search', () => gate.future, critical: true);
      expect(marker.existsSync(), isTrue);

      final listener = clearMarkerOnExitRequest(trail);
      addTearDown(listener.dispose);
      final response = await tester.binding.handleRequestAppExit();

      expect(response, AppExitResponse.exit);
      expect(marker.existsSync(), isFalse);
      gate.complete();
      await op;
      expect(marker.existsSync(), isFalse);
    });

    test('a plain op never touches the marker', () async {
      final marker = File('${tmp.path}/inflight.json');
      trail.useMarkerFile(marker);
      await trail.track('quiet', () async {
        expect(marker.existsSync(), isFalse);
      });
    });

    test('a marker left by a killed run is reported once', () {
      final marker = File('${tmp.path}/inflight.json')
        ..writeAsStringSync(jsonEncode({'op': 'pos_search'}));

      expect(PerfOpTrail.takeLeftoverMarker(marker), {'op': 'pos_search'});
      expect(marker.existsSync(), isFalse);
      expect(PerfOpTrail.takeLeftoverMarker(marker), isNull);
    });

    test('an unreadable marker still counts as a killed run', () {
      final marker = File('${tmp.path}/inflight.json')
        ..writeAsStringSync('not json');
      expect(PerfOpTrail.takeLeftoverMarker(marker), {'op': 'unknown'});

      final list = File('${tmp.path}/list.json')..writeAsStringSync('[1]');
      expect(PerfOpTrail.takeLeftoverMarker(list), {'op': 'unknown'});
    });

    test('reports go to the reporter, and a failing one is swallowed', () {
      final events = <String>[];
      trail.report('dropped', const {});
      trail.useReporter((event, _) => events.add(event));
      trail.report('ui_stall', const {});
      expect(events, ['ui_stall']);

      trail.useReporter((_, __) => throw StateError('offline'));
      trail.report('ui_stall', const {});
    });
  });

  group('UiStallWatchdog', () {
    late Duration elapsed;
    late List<UiStall> stalls;
    late UiStallWatchdog watchdog;

    setUp(() {
      elapsed = Duration.zero;
      stalls = [];
      watchdog = UiStallWatchdog(
        onStall: stalls.add,
        trail: trail,
        elapsed: () => elapsed,
        context: () => {'observers': 'transactions=2'},
      );
    });

    tearDown(() => watchdog.stop());

    test('an on-time tick is not a stall', () {
      watchdog.start();
      elapsed += const Duration(milliseconds: 300);
      watchdog.check();
      expect(stalls, isEmpty);
    });

    test('a tick late by the threshold reports the stall and the trail', () {
      trail.note('variants:page', took: const Duration(seconds: 3));
      watchdog.start();
      expect(watchdog.isRunning, isTrue);

      elapsed += const Duration(milliseconds: 3250);
      watchdog.check();

      expect(stalls.single.lag, const Duration(seconds: 3));
      expect(stalls.single.toProperties(), {
        'lag_ms': 3000,
        'running': '',
        'recent': 'variants:page(3000ms)',
        'observers': 'transactions=2',
      });

      // The next tick measures from the late one, not from the start.
      elapsed += const Duration(milliseconds: 250);
      watchdog.check();
      expect(stalls, hasLength(1));
    });

    test('a broken context or callback never escapes', () {
      final quiet = UiStallWatchdog(
        onStall: (_) => throw StateError('x'),
        trail: trail,
        elapsed: () => elapsed,
        context: () => throw StateError('y'),
      );
      elapsed += const Duration(seconds: 5);
      quiet.check();
    });

    test('start is idempotent and stop ends the timer', () {
      watchdog
        ..start()
        ..start();
      watchdog.stop();
      expect(watchdog.isRunning, isFalse);
    });

    test(
      'a till that slept is not a stall when the clock leaves sleep out',
      () {
        // Unbiased interrupt time in 100ns units: it stands still while the
        // machine sleeps, so one hour asleep reads as a single on-time tick.
        var ticks = 5000000;
        final slept = UiStallWatchdog(
          onStall: stalls.add,
          trail: trail,
          elapsed: awakeClock(unbiasedTicks: () => ticks),
        )..start();
        addTearDown(slept.stop);

        ticks += 2500000; // 250ms awake
        slept.check();
        expect(stalls, isEmpty);

        ticks += 32500000; // 3.25s awake, main thread blocked
        slept.check();
        expect(stalls.single.lag, const Duration(seconds: 3));
      },
    );

    test('the default clock and trail need no setup', () {
      final real = UiStallWatchdog(onStall: (_) {})..start();
      real.check();
      real.stop();
    });
  });

  test('UiStall keeps only the last ops it was given', () {
    final stall = UiStall(
      lag: const Duration(seconds: 2),
      running: const ['pos_search(running 2000ms)'],
      recent: [for (var i = 0; i < 10; i++) 'op$i'],
    );
    expect(stall.toProperties(recentLimit: 2)['recent'], 'op8, op9');
    expect(stall.toProperties()['running'], 'pos_search(running 2000ms)');
  });

  group('PerfLogFile', () {
    test('appends lines in order and rolls past the size cap', () async {
      final file = File('${tmp.path}/logs/perf.log');
      final log = PerfLogFile(file, maxBytes: 15);

      unawaited(log.append('first line'));
      await log.append('second');
      expect(file.readAsStringSync(), 'first line\nsecond\n');

      await log.append('third');
      expect(File('${file.path}.1').readAsStringSync(), contains('second'));
      expect(file.readAsStringSync(), 'third\n');
    });

    test('append returns before touching the disk', () async {
      final file = File('${tmp.path}/logs/perf.log');
      final written = PerfLogFile(file).append('stall');
      // A synchronous write would already have made the file.
      expect(file.existsSync(), isFalse);
      await written;
      expect(file.readAsStringSync(), 'stall\n');
    });

    test('a file that cannot be written is ignored', () async {
      final blocker = File('${tmp.path}/blocker')..writeAsStringSync('x');
      final log = PerfLogFile(File('${blocker.path}/perf.log'));
      await log.append('lost');
      // The queue keeps going after a failed write.
      await log.append('also lost');
    });
  });
}
