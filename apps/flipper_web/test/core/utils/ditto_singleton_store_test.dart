// Opens real Ditto stores through DittoSingleton. `flutter test` has no Ditto
// native library, so the tests that open a store skip unless LIBDITTOFFI_PATH
// points at one, e.g. on macOS:
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test --dart-define=FLUTTER_TEST_ENV=true \
//     test/core/utils/ditto_singleton_store_test.dart
import 'dart:async';
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/core/flipper_web_host.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_web/core/utils/database_path.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';

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

/// In-memory preferences whose reads run [onRead] first. Initialize reads
/// them (the Ditto install suffix) after the store opens, so [onRead] runs,
/// and can hold or fail, an init with its store open.
class _GatedPrefs extends Fake
    with MockPlatformInterfaceMixin
    implements SharedPreferencesStorePlatform {
  Future<void> Function()? onRead;
  final values = <String, Object>{};

  @override
  bool get isMock => true;

  Future<Map<String, Object>> _read() async {
    await onRead?.call();
    return Map.of(values);
  }

  @override
  Future<Map<String, Object>> getAll() => _read();
  @override
  Future<Map<String, Object>> getAllWithParameters(
    GetAllParameters parameters,
  ) => _read();
  @override
  Future<bool> remove(String key) async => values.remove(key) != null;
  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    values[key] = value;
    return true;
  }
}

const _appId = 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeeee';

Future<void> _until(bool Function() done) async {
  final deadline = DateTime.now().add(const Duration(seconds: 20));
  while (!done()) {
    if (DateTime.now().isAfter(deadline)) fail('timed out waiting');
    await Future<void>.delayed(const Duration(milliseconds: 5));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;
  final needsDitto = hasDitto
      ? null
      : 'set LIBDITTOFFI_PATH to run against a real Ditto store';

  final singleton = DittoSingleton.instance;
  late Directory home;
  late String storeDir;
  late _GatedPrefs prefs;

  setUpAll(() async {
    home = await Directory.systemTemp.createTemp('ditto_singleton_store');
    PathProviderPlatform.instance = _FakePaths(home.path);
  });

  tearDownAll(() async {
    await home.delete(recursive: true);
  });

  setUp(() async {
    // Local mode: the store never reaches the cloud or the auth server.
    LocalMode.debugSet(true);
    flipperWebIsHostApp = true;
    prefs = _GatedPrefs();
    SharedPreferencesStorePlatform.instance = prefs;
    SharedPreferences.resetStatic();
    storeDir = await DatabasePath.getDatabaseDirectory(subDirectory: 'db2');
  });

  tearDown(() async {
    prefs.onRead = null;
    // reset() closes the store only through a live instance, and the last
    // reset dropped it, so close here.
    await singleton.dispose();
    await DittoSingleton.reset();
    flipperWebIsHostApp = false;
    SharedPreferences.resetStatic();
    LocalMode.debugReset();
  });

  test('a lock held by another process opens nothing', () async {
    // A directory where the lock file goes makes the lock unobtainable.
    final path = p.join(storeDir, '.ditto_lock');
    if (await File(path).exists()) await File(path).delete();
    final lock = Directory(path);
    await lock.create(recursive: true);
    try {
      expect(await singleton.initialize(appId: _appId, userId: 'u1'), isNull);
      expect(singleton.ditto, isNull);
      expect(singleton.getInitializationStatus()['lockAcquired'], isFalse);
    } finally {
      await lock.delete(recursive: true);
    }
  });

  test(
    'an open store is reused, then dispose closes it so it can reopen',
    skip: needsDitto,
    () async {
      final ditto = await singleton.initialize(appId: _appId, userId: 'u1');
      expect(ditto, isNotNull);
      expect(singleton.getInitializationStatus()['lockAcquired'], isTrue);
      expect(
        await singleton.initialize(appId: _appId, userId: 'u1'),
        same(ditto),
      );

      await singleton.dispose();
      expect(singleton.ditto, isNull);
      expect(singleton.getInitializationStatus()['lockAcquired'], isFalse);
      expect(DittoService.instance.dittoInstance, isNull);

      // The directory and its lock were freed: the same store opens again.
      final again = await singleton.initialize(appId: _appId, userId: 'u1');
      expect(again, isNotNull);
      expect(again, isNot(same(ditto)));
    },
  );

  test(
    'an init that fails after the open closes the store it opened',
    skip: needsDitto,
    () async {
      // A cloud store this time. Its sync never starts: the init fails first.
      LocalMode.debugSet(false);
      late final Ditto opened;
      late final Future<Ditto?> joined;
      prefs.onRead = () async {
        opened = singleton.ditto!;
        // A caller that joins the running init sees its failure too.
        joined = singleton.initialize(appId: _appId, userId: 'u1');
        // The service already holds the store when the init fails.
        DittoService.instance.setDitto(opened);
        throw StateError('prefs unavailable');
      };

      await expectLater(
        singleton.initialize(appId: _appId, userId: 'u1'),
        throwsStateError,
      );
      await expectLater(joined, throwsStateError);
      expect(singleton.ditto, isNull);
      expect(DittoService.instance.dittoInstance, isNull);

      // The failed init released the directory: the store opens again.
      LocalMode.debugSet(true);
      prefs.onRead = null;
      SharedPreferences.resetStatic();
      final again = await singleton.initialize(appId: _appId, userId: 'u1');
      expect(again, isNotNull);
      expect(again, isNot(same(opened)));
    },
  );

  test(
    "a stale init for another user is disposed before the new store opens",
    skip: needsDitto,
    () async {
      final release = Completer<void>();
      prefs.onRead = () => release.future;
      final first = singleton.initialize(appId: _appId, userId: 'u1');
      await _until(() => singleton.ditto != null);
      final stale = singleton.ditto!;

      // Logout clears the user while u1's init still runs; u2 then finds a
      // stale init holding an open store.
      await singleton.logout();
      final second = singleton.initialize(appId: _appId, userId: 'u2');
      await _until(() => singleton.ditto != null && singleton.ditto != stale);
      release.complete();

      expect(await first, isNull);
      final fresh = await second;
      expect(fresh, isNotNull);
      expect(fresh, isNot(same(stale)));
      expect(singleton.ditto, same(fresh));
    },
  );
}
