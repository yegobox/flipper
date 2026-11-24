import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show AppExitResponse, AppLifecycleState;

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

    test('a marker left by a killed run stays until it is cleared', () {
      final marker = File('${tmp.path}/inflight.json')
        ..writeAsStringSync(jsonEncode({'op': 'pos_search'}));

      // Reading alone keeps it: the report may not be written yet.
      expect(PerfOpTrail.readLeftoverMarker(marker), {'op': 'pos_search'});
      expect(marker.existsSync(), isTrue);

      PerfOpTrail.clearLeftoverMarker(marker);
      expect(marker.existsSync(), isFalse);
      expect(PerfOpTrail.readLeftoverMarker(marker), isNull);
      // Clearing a missing marker is harmless.
      PerfOpTrail.clearLeftoverMarker(marker);
    });

    test('a critical op already running when the marker is set is written '
        'at once', () async {
      final marker = File('${tmp.path}/inflight.json');
      final held = Completer<void>();
      final search = trail.track(
        'pos_search',
        () => held.future,
        critical: true,
      );

      trail.useMarkerFile(marker);
      expect(jsonDecode(marker.readAsStringSync())['op'], 'pos_search');

      held.complete();
      await search;
      expect(marker.existsSync(), isFalse);
    });

    test('an unreadable marker still counts as a killed run', () {
      final marker = File('${tmp.path}/inflight.json')
        ..writeAsStringSync('not json');
      expect(PerfOpTrail.readLeftoverMarker(marker), {'op': 'unknown'});

      final list = File('${tmp.path}/list.json')..writeAsStringSync('[1]');
      expect(PerfOpTrail.readLeftoverMarker(list), {'op': 'unknown'});
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

    test('a failed clock read keeps the last good value', () {
      // Uptime well past zero, as on a real till: falling back to 0 would
      // read as a jump of ~1000s.
      var ticks = 10000000000;
      final clocked = UiStallWatchdog(
        onStall: stalls.add,
        trail: trail,
        elapsed: awakeClock(unbiasedTicks: () => ticks),
      )..start();
      addTearDown(clocked.stop);

      ticks += 2500000;
      clocked.check();
      final good = ticks;
      ticks = 0; // QueryUnbiasedInterruptTime failed
      clocked.check();
      ticks = good + 2500000;
      clocked.check();
      ticks += 2500000;
      clocked.check();

      expect(stalls, isEmpty);
    });

    test('time spent paused is never reported, even past the threshold', () {
      watchdog.start();
      watchdog.pause();
      expect(watchdog.isPaused, isTrue);
      expect(watchdog.isRunning, isFalse);

      // Seven hours in the background (Android froze the app).
      elapsed += const Duration(hours: 7);
      // A tick that was already queued when the app paused.
      watchdog.check();
      watchdog.resume();
      expect(watchdog.isRunning, isTrue);

      elapsed += const Duration(milliseconds: 250);
      watchdog.check();
      expect(stalls, isEmpty);

      // Resuming twice does not restart the clock.
      watchdog.resume();
      elapsed += const Duration(milliseconds: 3250);
      watchdog.check();
      expect(stalls.single.lag, const Duration(seconds: 3));
    });

    test('a foreground stall after a resume is still reported', () {
      watchdog
        ..start()
        ..pause();
      elapsed += const Duration(minutes: 5);
      watchdog.resume();

      elapsed += const Duration(milliseconds: 2250);
      watchdog.check();
      expect(stalls.single.lag, const Duration(seconds: 2));
    });

    test('a watchdog paused before it starts waits for both', () {
      watchdog
        ..pause()
        ..start();
      expect(watchdog.isRunning, isFalse);
      watchdog.resume();
      expect(watchdog.isRunning, isTrue);

      // Stopped while paused: resuming does not bring it back.
      watchdog
        ..pause()
        ..stop()
        ..resume();
      expect(watchdog.isRunning, isFalse);
    });

    test('only the background stops the watch; a minimised Windows till is '
        'still watched', () {
      for (final windows in [true, false]) {
        expect(
          watchesUiIn(AppLifecycleState.resumed, isWindows: windows),
          isTrue,
        );
        expect(
          watchesUiIn(AppLifecycleState.inactive, isWindows: windows),
          isTrue,
        );
        expect(
          watchesUiIn(AppLifecycleState.paused, isWindows: windows),
          isFalse,
        );
        expect(
          watchesUiIn(AppLifecycleState.detached, isWindows: windows),
          isFalse,
        );
      }
      expect(watchesUiIn(AppLifecycleState.hidden, isWindows: true), isTrue);
      expect(watchesUiIn(AppLifecycleState.hidden, isWindows: false), isFalse);
      expect(watchesUiIn(AppLifecycleState.hidden), Platform.isWindows);
    });

    testWidgets('the lifecycle pauses the watchdog in the background and a '
        'resumed app measures from the resume', (tester) async {
      final binding = tester.binding;
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      watchdog.start();
      final listener = pauseWatchdogInBackground(watchdog, isWindows: false);
      addTearDown(listener.dispose);
      expect(watchdog.isRunning, isTrue);

      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      expect(watchdog.isRunning, isTrue);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      expect(watchdog.isPaused, isTrue);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      expect(watchdog.isPaused, isTrue);

      elapsed += const Duration(hours: 7, minutes: 24);

      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      expect(watchdog.isRunning, isTrue);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);

      elapsed += const Duration(milliseconds: 250);
      watchdog.check();
      expect(stalls, isEmpty);

      // Back in the foreground, a real freeze is reported.
      elapsed += const Duration(milliseconds: 4250);
      watchdog.check();
      expect(stalls.single.lag, const Duration(seconds: 4));
      // testWidgets checks for pending timers before tearDown runs.
      watchdog.stop();
    });

    testWidgets('a minimised Windows till keeps reporting stalls', (
      tester,
    ) async {
      final binding = tester.binding;
      binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      watchdog.start();
      final listener = pauseWatchdogInBackground(watchdog, isWindows: true);
      addTearDown(listener.dispose);

      binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      expect(watchdog.isRunning, isTrue);

      elapsed += const Duration(milliseconds: 5250);
      watchdog.check();
      expect(stalls.single.lag, const Duration(seconds: 5));
      watchdog.stop();
    });

    testWidgets('an app wired up while in the background starts paused', (
      tester,
    ) async {
      // Disposes of the listener first, then leaves the binding in the
      // foreground for the tests after this one.
      addTearDown(
        () => tester.binding.handleAppLifecycleStateChanged(
          AppLifecycleState.resumed,
        ),
      );
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.hidden);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
      watchdog.start();
      final listener = pauseWatchdogInBackground(watchdog, isWindows: false);
      addTearDown(listener.dispose);
      expect(watchdog.isPaused, isTrue);
      expect(watchdog.isRunning, isFalse);
    });

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
