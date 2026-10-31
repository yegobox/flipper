import 'dart:async';
import 'dart:io';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flipper_models/sync/ditto_observer_registry.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

UiStallWatchdog? _watchdog;

/// Watches the till for main-thread stalls and reports what was running.
///
/// A frozen Windows till ("Not Responding") cannot be watched live, so each
/// stall goes to talker, to `<app support>/perf/perf.log` (support can ask
/// for the file) and to product analytics, which queues offline. A hang the
/// cashier ends by killing the app is reported on the next start.
Future<void> startUiStallMonitoring() async {
  if (kIsWeb || _watchdog != null) return;
  final dir = await getApplicationSupportDirectory();
  final perfDir = '${dir.path}${Platform.pathSeparator}perf';
  final log = PerfLogFile(File('$perfDir${Platform.pathSeparator}perf.log'));
  final marker = File('$perfDir${Platform.pathSeparator}inflight.json');
  final trail = PerfOpTrail.instance;

  trail.useReporter((event, properties) => _report(log, event, properties));
  final leftover = PerfOpTrail.takeLeftoverMarker(marker);
  if (leftover != null) trail.report('ui_hang_killed', leftover);
  trail.useMarkerFile(marker);

  _watchdog = UiStallWatchdog(
    onStall: (stall) => trail.report('ui_stall', stall.toProperties()),
    context: () => {'observers': dittoObserverStats.summary()},
  )..start();
}

void _report(PerfLogFile log, String event, Map<String, Object?> properties) {
  talker.warning('[perf] $event $properties');
  log.append('${DateTime.now().toUtc().toIso8601String()} $event $properties');
  // A local-mode till promised to stay off the cloud.
  if (LocalMode.isOn) return;
  try {
    unawaited(
      FlipperAnalytics.instance
          .track(event, properties: properties)
          .catchError((Object _) {}),
    );
  } catch (_) {
    // Analytics never initialised; the log file still has it.
  }
}
