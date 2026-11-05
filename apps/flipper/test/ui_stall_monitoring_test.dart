import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flipper_models/perf/ui_stall_watchdog.dart';
import 'package:flipper_rw/ui_stall_monitoring.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter_test/flutter_test.dart';

/// A log whose writes finish only when the test says so.
class _HeldLog extends PerfLogFile {
  _HeldLog(super.file);

  final lines = <String>[];
  final written = Completer<void>();

  @override
  Future<void> append(String line) {
    lines.add(line);
    return written.future;
  }
}

void main() {
  late List<String> sent;
  late List<Map<String, Object?>> sentProperties;

  Future<void> send(String event, Map<String, Object?> properties) async {
    sent.add(event);
    sentProperties.add(properties);
  }

  setUp(() {
    sent = [];
    sentProperties = [];
    LocalMode.debugReset();
  });

  tearDown(LocalMode.debugReset);

  test('nothing is sent while the local-mode marker cannot be read', () async {
    LocalMode.debugReadMarker =
        () async => throw const FileSystemException('store locked');

    await sendStallTelemetry('ui_stall', const {'lag_ms': 3000}, send: send);

    // isOn is still its default false here, which must not count as "off".
    expect(LocalMode.isOn, isFalse);
    expect(LocalMode.isLoaded, isFalse);
    expect(sent, isEmpty);
  });

  test('an unread marker is read first, then obeyed', () async {
    LocalMode.debugReadMarker = () async => {'businessId': 'b1'};
    await sendStallTelemetry('ui_stall', const {}, send: send);
    expect(LocalMode.isOn, isTrue);
    expect(sent, isEmpty);

    LocalMode.debugReset();
    LocalMode.debugReadMarker = () async => null;
    await sendStallTelemetry('ui_hang_killed', const {}, send: send);
    expect(sent, ['ui_hang_killed']);
  });

  test('a loaded mode decides without reading again', () async {
    var reads = 0;
    LocalMode.debugSet(true);
    LocalMode.debugReadMarker = () async {
      reads++;
      return null;
    };
    await sendStallTelemetry('ui_stall', const {}, send: send);
    expect(sent, isEmpty);

    LocalMode.debugSet(false);
    await sendStallTelemetry('ui_stall', const {'lag_ms': 3000}, send: send);
    expect(sent, ['ui_stall']);
    expect(sentProperties, [
      {'lag_ms': 3000},
    ]);
    expect(reads, 0);
  });

  test('a killed hang keeps its marker until the log line is written',
      () async {
    LocalMode.debugSet(false);
    final dir = Directory.systemTemp.createTempSync('ui_hang_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final marker = File('${dir.path}/inflight.json')
      ..writeAsStringSync(jsonEncode({'op': 'pos_search'}));
    final log = _HeldLog(File('${dir.path}/perf.log'));

    final reporting = reportKilledHang(marker, log, send: send);
    await Future<void>.delayed(Duration.zero);

    // Dying here must leave the marker for the next start to report.
    expect(log.lines.single, contains('ui_hang_killed {op: pos_search}'));
    expect(marker.existsSync(), isTrue);

    log.written.complete();
    await reporting;
    expect(marker.existsSync(), isFalse);
    expect(sent, ['ui_hang_killed']);
    expect(sentProperties, [
      {'op': 'pos_search'},
    ]);

    // Nothing left: the next start reports nothing.
    await reportKilledHang(marker, log, send: send);
    expect(log.lines, hasLength(1));
  });

  test('a failing sender never escapes', () async {
    LocalMode.debugSet(false);
    await sendStallTelemetry(
      'ui_stall',
      const {},
      send: (_, __) async => throw StateError('analytics not ready'),
    );
  });
}
