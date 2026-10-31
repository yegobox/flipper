import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

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
  int _criticalRunning = 0;
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
      _criticalRunning++;
      _writeMarker(op);
    }
    try {
      return await body();
    } finally {
      op.duration = _clock().difference(op.startedAt);
      _running.remove(op);
      _remember(op);
      if (critical && --_criticalRunning == 0) _clearMarker();
    }
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
       _elapsed = elapsed ?? _monotonic();

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

Duration Function() _monotonic() {
  final stopwatch = Stopwatch()..start();
  return () => stopwatch.elapsed;
}

/// Append-only text log that rolls to `<name>.1` past [maxBytes], so support
/// can ask a till for the file without it growing forever.
class PerfLogFile {
  PerfLogFile(this.file, {this.maxBytes = 1024 * 1024});

  final File file;
  final int maxBytes;

  void append(String line) {
    try {
      file.parent.createSync(recursive: true);
      if (file.existsSync() && file.lengthSync() > maxBytes) {
        file.renameSync('${file.path}.1');
      }
      file.writeAsStringSync('$line\n', mode: FileMode.append, flush: true);
    } catch (_) {}
  }
}
