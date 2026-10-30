// Local mode opens the Ditto store with no cloud connection, and opting in to
// full sync reopens the SAME store with the server connection. This proves the
// store survives that switch with its documents intact. `flutter test` has no
// Ditto native library, so this skips unless LIBDITTOFFI_PATH points at one:
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/local_mode_ditto_store_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  _FakePaths(this.dir);
  final String dir;
  @override
  Future<String?> getApplicationDocumentsPath() async => dir;
  @override
  Future<String?> getApplicationSupportPath() async => dir;
  @override
  Future<String?> getTemporaryPath() async => dir;
}

void main() {
  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;
  const appId = 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee';

  test(
    'a store opened local-only reopens with the server connect, docs intact',
    skip: hasDitto
        ? false
        : 'set LIBDITTOFFI_PATH to run against a real Ditto store',
    () async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final dir = await Directory.systemTemp.createTemp('ditto_local_mode');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();

      final local = await Ditto.open(
        DittoConfig(
          databaseID: appId,
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      await local.store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
      await local.store.execute(
        'INSERT INTO transactions DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {
          'doc': {'_id': 't1', 'id': 't1', 'subTotal': 1500},
        },
      );
      expect(local.sync.isActive, isFalse);
      await local.close();

      final cloud = await Ditto.open(
        DittoConfig(
          databaseID: appId,
          connect: DittoConfigConnectServer(
            url: 'https://$appId.cloud.ditto.live',
          ),
          persistenceDirectory: dir.path,
        ),
      );
      final result = await cloud.store.execute(
        'SELECT * FROM transactions WHERE _id = :id',
        arguments: {'id': 't1'},
      );
      expect(result.items, hasLength(1));
      expect(result.items.single.value['subTotal'], 1500);
      await cloud.close();
      await dir.delete(recursive: true);
    },
  );
}
