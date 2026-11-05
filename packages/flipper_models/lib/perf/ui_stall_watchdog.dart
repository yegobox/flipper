import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' show AppExitResponse;

import 'package:flipper_models/perf/windows_unbiased_ticks.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;

/// Reports a diagnostic event (`ui_stall`, `ui_hang_killed`, `search_timeout`)
/// to wherever the app sends them. Set once at startup.
typedef PerfEventReporter =
    void Function(String event, Map<String, Object?> properties);

/// One labelled piece of work, kept so a main-thread stall can say what ran
/// just before it.
class PerfOp {
  PerfOp(this.label, this.startedAt);

  final String label;
  final DateTime startedAt;

  /// Null while the op is still running.
  Duration? duration;

  String describe(DateTime now) {
    final d = duration;
    if (d == null) {
      return '$label(running ${now.difference(startedAt).inMilliseconds}ms)';
    }
    return '$label(${d.inMilliseconds}ms)';
  }
}

/// What the app was doing recently: the last [capacity] ops and the ones
/// still running.
///
/// A Windows till that freezes ("Not Responding") cannot be watched live, so
/// a stall report carries this trail instead — it names the query or observer
/// that was running when the main thread stopped.
class PerfOpTrail {
  PerfOpTrail({DateTime Function()? clock, this.capacity = 20})
    : _clock = clock ?? DateTime.now;

  static final PerfOpTrail instance = PerfOpTrail();

  final int capacity;
  final DateTime Function() _clock;
  final ListQueue<PerfOp> _recent = ListQueue<PerfOp>();
  final List<PerfOp> _running = <PerfOp>[];

  /// Critical ops still running, oldest first; the marker names the last.
  final List<PerfOp> _critical = <PerfOp>[];
  File? _marker;
  PerfEventReporter? _reporter;

  /// While a `critical` op runs, its label sits in [file]. A hang the user
  /// ends by killing the app leaves the file behind for the next start to
  /// report (see [takeLeftoverMarker]).
  void useMarkerFile(File? file) => _marker = file;

  void useReporter(PerfEventReporter? reporter) => _reporter = reporter;

  /// Sends [event] through the configured reporter; dropped when none is set
  /// (tests, or before startup wires one).
  void report(String event, Map<String, Object?> properties) {
    try {
      _reporter?.call(event, properties);
    } catch (_) {
      // Diagnostics must never break the till.
    }
  }

  Future<T> track<T>(
    String label,
    Future<T> Function() body, {
    bool critical = false,
  }) async {
    final op = PerfOp(label, _clock());
    _running.add(op);
    if (critical) {
      _critical.add(op);
      _writeMarker(op);
    }
    try {
      return await body();
    } finally {
      op.duration = _clock().difference(op.startedAt);
      _running.remove(op);
      _remember(op);
      // Not found after [markCleanExit]: the app was already quitting.
      if (_critical.remove(op)) {
        // An overlapping op that is still running takes the marker back, so
        // a kill now names it rather than the one that just finished.
        if (_critical.isEmpty) {
          _clearMarker();
        } else {
          _writeMarker(_critical.last);
        }
      }
    }
  }

  /// The app is quitting normally: the ops still running are cut off by the
  /// exit, not by a hang, so the next start must not report them.
  void markCleanExit() {
    _critical.clear();
    _clearMarker();
  }

  /// Records something that already happened and took [took].
  void note(String label, {Duration took = Duration.zero}) {
    _remember(PerfOp(label, _clock().subtract(took))..duration = took);
  }

  /// Ops still running, oldest first.
  List<String> running() {
    final now = _clock();
    return [for (final op in _running) op.describe(now)];
  }

  /// Finished ops, oldest first.
  List<String> recent() {
    final now = _clock();
    return [for (final op in _recent) op.describe(now)];
  }

  void _remember(PerfOp op) {
    _recent.addLast(op);
    while (_recent.length > capacity) {
      _recent.removeFirst();
    }
  }

  // Synchronous on purpose: an async write could land after the delete and
  // leave a marker that reports a hang that never happened.
  void _writeMarker(PerfOp op) {
    final file = _marker;
    if (file == null) return;
    try {
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(
        jsonEncode({
          'op': op.label,
          'startedAt': op.startedAt.toUtc().toIso8601String(),
        }),
      );
    } catch (_) {}
  }

  void _clearMarker() {
    final file = _marker;
    if (file == null) return;
    try {
      if (file.existsSync()) file.deleteSync();
    } catch (_) {}
  }

  /// The op a previous run was in when it died, or null after a clean exit.
  /// Deletes the marker so it is reported once.
  static Map<String, Object?>? takeLeftoverMarker(File file) {
    try {
      if (!file.existsSync()) return null;
      final raw = file.readAsStringSync();
      file.deleteSync();
      final decoded = jsonDecode(raw);
      if (decoded is Map) return Map<String, Object?>.from(decoded);
      return {'op': 'unknown'};
    } catch (_) {
      return {'op': 'unknown'};
    }
  }
}

/// Clears [trail]'s marker when the desktop app is asked to quit (last window
/// closed, Cmd+Q, Alt+F4), so a normal close mid-search is not reported as a
/// killed hang on the next start. A hung app cannot answer the request, so a
/// kill from "Not Responding" still leaves the marker. Phones send no exit
/// request; there the window is only as long as the critical op itself.
///
/// Always lets the exit go ahead. Dispose the listener to stop.
AppLifecycleListener clearMarkerOnExitRequest(PerfOpTrail trail) {
  return AppLifecycleListener(
    onExitRequested: () async {
      trail.markCleanExit();
      return AppExitResponse.exit;
    },
  );
}

/// A main-thread stall the watchdog saw, with what was running around it.
class UiStall {
  const UiStall({
    required this.lag,
    required this.running,
    required this.recent,
    this.context = const {},
  });

  final Duration lag;
  final List<String> running;
  final List<String> recent;
  final Map<String, Object?> context;

  /// The last [recentLimit] ops are enough to see what led up to the stall
  /// and keep the event small.
  Map<String, Object?> toProperties({int recentLimit = 8}) {
    final tail = recent.length > recentLimit
        ? recent.sublist(recent.length - recentLimit)
        : recent;
    return {
      'lag_ms': lag.inMilliseconds,
      'running': running.join(', '),
      'recent': tail.join(', '),
      ...context,
    };
  }
}

/// Notices when the main isolate stops processing events.
///
/// A periodic timer should fire every [tick]; when it fires late by
/// [threshold] or more, the main thread was blocked for that long — Windows
/// shows "Not Responding" from about 5s. It can only report once the thread
/// is free again; a stall that ends in a kill is caught by the
/// [PerfOpTrail] marker instead.
class UiStallWatchdog {
  UiStallWatchdog({
    required this.onStall,
    PerfOpTrail? trail,
    this.tick = const Duration(milliseconds: 250),
    this.threshold = const Duration(seconds: 2),
    Map<String, Object?> Function()? context,
    Duration Function()? elapsed,
  }) : _trail = trail ?? PerfOpTrail.instance,
       _context = context,
       _elapsed = elapsed ?? awakeClock();

  final void Function(UiStall stall) onStall;
  final Duration tick;
  final Duration threshold;
  final PerfOpTrail _trail;
  final Map<String, Object?> Function()? _context;
  final Duration Function() _elapsed;
  Timer? _timer;
  Duration _last = Duration.zero;

  bool get isRunning => _timer != null;

  void start() {
    if (_timer != null) return;
    _last = _elapsed();
    _timer = Timer.periodic(tick, (_) => check());
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  /// One timer tick: how late it is compared with the previous one.
  void check() {
    final now = _elapsed();
    final lag = now - _last - tick;
    _last = now;
    if (lag < threshold) return;
    Map<String, Object?> context = const {};
    try {
      context = _context?.call() ?? const {};
    } catch (_) {}
    try {
      onStall(
        UiStall(
          lag: lag,
          running: _trail.running(),
          recent: _trail.recent(),
          context: context,
        ),
      );
    } catch (_) {
      // Diagnostics must never break the till.
    }
  }
}

/// Time since the clock was made, not counting time the OS spent asleep.
///
/// A sleeping till is not a stalled one. `Stopwatch` already stands still
/// during sleep on macOS, Linux and phones, but on Windows it reads
/// QueryPerformanceCounter, which keeps counting, so waking a till would look
/// like a stall as long as the sleep. Windows reads the unbiased interrupt
/// time instead, which leaves sleep out.
///
/// [unbiasedTicks] (100ns units) replaces the Windows source in tests.
Duration Function() awakeClock({int Function()? unbiasedTicks}) {
  final read =
      unbiasedTicks ?? (Platform.isWindows ? windowsUnbiasedTicks() : null);
  if (read == null) {
    final stopwatch = Stopwatch()..start();
    return () => stopwatch.elapsed;
  }
  final start = read();
  return () => Duration(microseconds: (read() - start) ~/ 10);
}

/// Append-only text log that rolls to `<name>.1` past [maxBytes], so support
/// can ask a till for the file without it growing forever.
///
/// Writes are async and run one after another: the watchdog reports from the
/// main isolate, and a slow disk must not lengthen the stall it is reporting.
class PerfLogFile {
  PerfLogFile(this.file, {this.maxBytes = 1024 * 1024});

  final File file;
  final int maxBytes;
  Future<void> _tail = Future<void>.value();

  /// Queues [line]; the future completes once it is written (or dropped).
  Future<void> append(String line) => _tail = _tail.then((_) => _write(line));

  Future<void> _write(String line) async {
    try {
      await file.parent.create(recursive: true);
      if (await file.exists() && await file.length() > maxBytes) {
        await file.rename('${file.path}.1');
      }
      await file.writeAsString('$line\n', mode: FileMode.append, flush: true);
    } catch (_) {}
  }
}
