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

/// Sends one diagnostic event to product analytics.
typedef StallEventSender = Future<void> Function(
    String event, Map<String, Object?> properties);

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

  trail.useReporter((event, properties) {
    talker.warning('[perf] $event $properties');
    unawaited(
      log.append(
          '${DateTime.now().toUtc().toIso8601String()} $event $properties'),
    );
    unawaited(sendStallTelemetry(event, properties));
  });
  final leftover = PerfOpTrail.takeLeftoverMarker(marker);
  if (leftover != null) trail.report('ui_hang_killed', leftover);
  trail.useMarkerFile(marker);
  // A normal quit mid-search is not a hang. The binding keeps the listener.
  clearMarkerOnExitRequest(trail);

  _watchdog = UiStallWatchdog(
    onStall: (stall) => trail.report('ui_stall', stall.toProperties()),
    context: () => {'observers': dittoObserverStats.summary()},
  )..start();
}

/// Sends [event] to analytics only once Local Mode is known to be off.
///
/// A local-mode till promised to stay off the cloud, and until its marker
/// has been read [LocalMode.isOn] is just a default `false`. A failed read
/// is retried here; if it fails again the event stays in the log only.
@visibleForTesting
Future<void> sendStallTelemetry(
  String event,
  Map<String, Object?> properties, {
  StallEventSender? send,
}) async {
  try {
    if (!LocalMode.isLoaded) await LocalMode.load();
    if (!LocalMode.isLoaded || LocalMode.isOn) return;
    await (send ?? _sendToAnalytics)(event, properties);
  } catch (_) {
    // Analytics never initialised or offline; the log file still has it.
  }
}

Future<void> _sendToAnalytics(String event, Map<String, Object?> properties) =>
    FlipperAnalytics.instance.track(event, properties: properties);
