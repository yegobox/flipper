import 'dart:async';
import 'dart:isolate';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/supabase_realtime_utils.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';

class GlobalErrorHandler {
  static final LogService _logService = LogService();

  /// How many times an identical error is reported before it is suppressed.
  static const int _maxIdenticalReports = 3;

  /// A repeat is treated as a fresh problem again after this long.
  static const Duration _repeatWindow = Duration(minutes: 2);

  /// How often a suppressed error still gets a one-line heartbeat.
  static const int _suppressedHeartbeatEvery = 500;

  static final Map<String, _ErrorTally> _tallies = {};

  /// Some framework assertions latch and then fire ONCE PER FRAME for the rest
  /// of the session — both `_RenderTheater._addDeferredChild`
  /// ('!_skipMarkNeedsLayout') and `MouseTracker._deviceUpdatePhase`
  /// ('!_debugDuringDeviceUpdate') set a debug flag, call a callback, and clear
  /// it with no try/finally, so one throw inside leaves the flag stuck true.
  ///
  /// Reporting every repeat inserts a Log row per frame (which then syncs) and
  /// buries the FIRST error — the only one that identifies the actual cause.
  /// So: report the first few, then count quietly.
  static bool _shouldReport(Object error, StackTrace? stackTrace) {
    final signature = _signatureOf(error, stackTrace);
    final now = DateTime.now();
    final tally = _tallies[signature];

    if (tally == null || now.difference(tally.lastSeen) > _repeatWindow) {
      _tallies[signature] = _ErrorTally(count: 1, lastSeen: now);
      return true;
    }

    tally
      ..count += 1
      ..lastSeen = now;

    if (tally.count <= _maxIdenticalReports) return true;

    if (tally.count % _suppressedHeartbeatEvery == 0) {
      talker.warning(
        'Suppressed ${tally.count} identical errors (still happening): '
        '$signature',
      );
    }
    return false;
  }

  /// Exception text plus the top few frames — enough to tell two different
  /// errors apart without treating every occurrence as unique.
  ///
  /// More than one frame matters: for an assertion failure frame #0 is always
  /// `_AssertionError._doThrowNew`, so a single frame would lump unrelated
  /// asserts together and hide the second one entirely.
  static String _signatureOf(Object error, StackTrace? stackTrace) {
    final message = error.toString().split('\n').first;
    final frames = (stackTrace?.toString() ?? '')
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .take(3)
        .join(' ');
    return '$message | $frames';
  }

  /// Initialize global error handling
  static void initialize() {
    // Catch Flutter framework errors
    FlutterError.onError = (FlutterErrorDetails details) {
      if (!_shouldReport(details.exception, details.stack)) return;

      // Log to your service
      _logService.logException(
        details.exception,
        stackTrace: details.stack,
        type: 'flutter_error',
        extra: {
          'library': details.library,
          'context': details.context.toString(),
          'informationCollector':
              details.informationCollector?.call().toString(),
        },
      );

      // Also print to console in debug mode
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // Catch errors outside of Flutter framework (async errors, etc.)
    PlatformDispatcher.instance.onError = (error, stack) {
      if (isBenignSupabaseRealtimeError(error)) {
        logSupabaseRealtimeError(error, stackTrace: stack);
        return true;
      }
      if (!_shouldReport(error, stack)) return true;
      _logService.logException(
        error,
        stackTrace: stack,
        type: 'platform_error',
        extra: {
          'error_type': error.runtimeType.toString(),
        },
      );
      return true; // Handled
    };

    // Catch isolate errors
    Isolate.current.addErrorListener(
      RawReceivePort((pair) async {
        final List<dynamic> errorAndStacktrace = pair;
        final error = errorAndStacktrace.first;
        final stackTrace = errorAndStacktrace.last;

        await _logService.logException(
          error,
          stackTrace: StackTrace.fromString(stackTrace.toString()),
          type: 'isolate_error',
          extra: {
            'error_type': error.runtimeType.toString(),
          },
        );
      }).sendPort,
    );
  }

  /// Manual error logging method
  static Future<void> logError(
    Object error, {
    StackTrace? stackTrace,
    String? type,
    Map<String, dynamic>? context,
    Map<String, String>? tags,
    Map<String, dynamic>? extra,
  }) async {
    await _logService.logException(
      error,
      stackTrace: stackTrace,
      type: type ?? 'manual',
      tags: tags,
      extra: {
        if (context != null) ...context,
        if (extra != null) ...extra,
      },
    );
  }

  /// Fire-and-forget helper for catch blocks (safe before/after [initialize]).
  static void report(
    Object error,
    StackTrace? stackTrace, {
    String? type,
    Map<String, String>? tags,
    Map<String, dynamic>? extra,
  }) {
    unawaited(
      logError(
        error,
        stackTrace: stackTrace,
        type: type ?? 'caught',
        tags: tags,
        extra: extra,
      ),
    );
  }

  /// Log custom messages
  static Future<void> logMessage(
    String message, {
    String? type,
    Map<String, String>? tags,
    Map<String, dynamic>? extra,
  }) async {
    await _logService.logMessage(
      message,
      type: type ?? 'info',
      tags: tags,
      extra: extra,
    );
  }

  /// Enhanced runApp wrapper with error handling
  void runAppWithErrorHandling(Widget app) {
    // Initialize error handling first
    GlobalErrorHandler.initialize();

    // Run the app in a error zone
    runZonedGuarded<Future<void>>(
      () async {
        WidgetsFlutterBinding.ensureInitialized();

        // Any other initialization code here
        // e.g., Firebase, SharedPreferences, etc.

        runApp(app);
      },
      (error, stackTrace) {
        if (isBenignSupabaseRealtimeError(error)) {
          logSupabaseRealtimeError(error, stackTrace: stackTrace);
          return;
        }
        // This catches any errors not caught by Flutter
        GlobalErrorHandler.logError(
          error,
          stackTrace: stackTrace,
          type: 'zone_error',
          extra: {
            'error_type': error.runtimeType.toString(),
          },
        );
      },
    );
  }

  /// Test hook: forget what has been reported so far.
  @visibleForTesting
  static void resetReportTallies() => _tallies.clear();

  /// Test hook for the repeat-suppression decision.
  @visibleForTesting
  static bool debugShouldReport(Object error, StackTrace? stackTrace) =>
      _shouldReport(error, stackTrace);

  /// Example of how to use in your main.dart
/*
void main() {
  runAppWithErrorHandling(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: ErrorBoundary(
        child: MyHomePage(),
        errorBuilder: (error, stackTrace) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Custom Error UI'),
                  ElevatedButton(
                    onPressed: () {
                      // Restart app or navigate to safe screen
                    },
                    child: Text('Restart'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
*/
}

class _ErrorTally {
  _ErrorTally({required this.count, required this.lastSeen});

  int count;
  DateTime lastSeen;
}
