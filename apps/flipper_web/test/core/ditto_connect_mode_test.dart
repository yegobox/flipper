import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(LocalMode.debugReset);

  test('with no store open the connect mode is never stale', () {
    // Nothing to reopen, whichever mode the device is in.
    for (final local in [false, true]) {
      LocalMode.debugSet(local);
      expect(DittoSingleton.instance.connectModeStale, isFalse);
    }
  });

  test(
    'an open store is stale only when local mode changed since it opened',
    () {
      for (final local in [false, true]) {
        LocalMode.debugSet(local);
        bool stale(bool? openedLocal) => DittoSingleton.isConnectModeStale(
          open: true,
          openedLocal: openedLocal,
        );
        expect(stale(local), isFalse);
        expect(stale(!local), isTrue);
        // Opened before the mode was known: nothing to compare.
        expect(stale(null), isFalse);
      }
    },
  );
}
