import 'dart:async';
import 'dart:io';

import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/perf/perf_track.dart';
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
  // First, before any await: Books may start a ledger refresh meanwhile.
  // The trail holds it until the marker file is handed over below.
  installPerfTrackHook(PerfOpTrail.instance);
  final dir = await getApplicationSupportDirectory();
  final perfDir = '${dir.path}${Platform.pathSeparator}perf';
  final log = PerfLogFile(File('$perfDir${Platform.pathSeparator}perf.log'));
  final marker = File('$perfDir${Platform.pathSeparator}inflight.json');
  final trail = PerfOpTrail.instance;

  trail.useReporter((event, properties) {
    talker.warning('[perf] $event $properties');
    unawaited(log.append(_logLine(event, properties)));
    unawaited(sendStallTelemetry(event, properties));
  });
  // Before the marker is handed to the trail, so a new op cannot overwrite
  // the old one while it is being reported.
  await reportKilledHang(marker, log);
  trail.useMarkerFile(marker);
  // A normal quit mid-search is not a hang. The binding keeps the listener.
  clearMarkerOnExitRequest(trail);

  _watchdog = UiStallWatchdog(
    onStall: (stall) => trail.report('ui_stall', stall.toProperties()),
    context: () => {'observers': dittoObserverStats.summary()},
  )..start();
}

/// Points [PerfTrack] at [trail], so shared packages (Books' ledger) time
/// their heavy work there. The work is critical: a kill during it leaves the
/// in-flight marker, so the next start reports it as `ui_hang_killed`.
@visibleForTesting
void installPerfTrackHook(PerfOpTrail trail) {
  PerfTrack.track = <T>(String label, Future<T> Function() body) =>
      trail.track<T>(label, body, critical: true);
}

/// Reports the op a killed previous run left in [marker] as `ui_hang_killed`.
///
/// The marker is deleted only after the log line is written: if the app dies
/// in between, the next start reports it again instead of losing it.
@visibleForTesting
Future<void> reportKilledHang(
  File marker,
  PerfLogFile log, {
  StallEventSender? send,
}) async {
  final leftover = PerfOpTrail.readLeftoverMarker(marker);
  if (leftover == null) return;
  talker.warning('[perf] ui_hang_killed $leftover');
  unawaited(sendStallTelemetry('ui_hang_killed', leftover, send: send));
  await log.append(_logLine('ui_hang_killed', leftover));
  PerfOpTrail.clearLeftoverMarker(marker);
}

String _logLine(String event, Map<String, Object?> properties) =>
    '${DateTime.now().toUtc().toIso8601String()} $event $properties';

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
