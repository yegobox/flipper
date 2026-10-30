import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_web/services/ditto_mixins/ditto_core_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/sync_mixin.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class _SyncProbe extends DittoCore with SyncMixin {}

void main() {
  late List<String?> logs;
  late DebugPrintCallback previousDebugPrint;

  setUp(() {
    logs = [];
    previousDebugPrint = debugPrint;
    debugPrint = (message, {wrapWidth}) => logs.add(message);
  });

  tearDown(() {
    debugPrint = previousDebugPrint;
    LocalMode.debugReset();
  });

  test('startSync stops at local mode, before any permission prompt', () {
    LocalMode.debugSet(true);

    _SyncProbe().startSync();

    expect(logs, ['Ditto sync skipped: local mode']);
  });

  test('startSync goes past the guard when local mode is off', () {
    LocalMode.debugSet(false);

    _SyncProbe().startSync();

    expect(logs, isNot(contains('Ditto sync skipped: local mode')));
  });
}
