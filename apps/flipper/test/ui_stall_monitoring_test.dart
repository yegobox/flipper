import 'dart:io';

import 'package:flipper_rw/ui_stall_monitoring.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<String> sent;

  Future<void> send(String event, Map<String, Object?> _) async {
    sent.add(event);
  }

  setUp(() {
    sent = [];
    LocalMode.debugReset();
  });

  tearDown(LocalMode.debugReset);

  test('nothing is sent while the local-mode marker cannot be read', () async {
    LocalMode.debugReadMarker = () async =>
        throw const FileSystemException('store locked');

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
    await sendStallTelemetry('ui_stall', const {}, send: send);
    expect(sent, ['ui_stall']);
    expect(reads, 0);
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
