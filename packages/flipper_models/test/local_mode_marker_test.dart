import 'dart:io';

import 'package:flipper_models/services/local_mode_controller.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_web/core/local_mode/local_mode_marker.dart';
import 'package:flipper_web/core/utils/database_path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
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
}

void main() {
  late File marker;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = await Directory.systemTemp.createTemp('local_mode_marker');
    PathProviderPlatform.instance = _FakePaths(dir.path);
  });

  setUp(() async {
    final dir = await DatabasePath.getDatabaseDirectory(subDirectory: 'db2');
    await Directory(dir).create(recursive: true);
    marker = File(p.join(dir, '.flipper_local_mode'));
    if (await marker.exists()) await marker.delete();
    LocalMode.debugReset();
  });

  tearDown(() async {
    if (await marker.exists()) await marker.delete();
    LocalMode.debugReset();
  });

  test('concurrent loads all see an existing marker', () async {
    await writeLocalModeMarker({'businessId': 'biz-a'});
    LocalMode.debugReset();

    final results = await Future.wait([LocalMode.load(), LocalMode.load()]);

    expect(results, [true, true]);
    expect(LocalMode.isOn, isTrue);
  });

  test('an unreadable marker still means local mode', () async {
    await marker.writeAsString('{not json');

    expect(await readLocalModeMarker(), isNotNull);
    expect(await LocalMode.load(), isTrue);
  });

  test(
    'a marker write replaces the file whole and leaves no temp file',
    () async {
      await writeLocalModeMarker({'businessId': 'biz-a'});
      await writeLocalModeMarker({
        'businessId': 'biz-a',
        'serverChangedAt': 'x',
      });

      expect(await readLocalModeMarker(), {
        'businessId': 'biz-a',
        'serverChangedAt': 'x',
      });
      expect(await File('${marker.path}.tmp').exists(), isFalse);
    },
  );

  test('signup on a store held by another business changes nothing', () async {
    await writeLocalModeMarker({'businessId': 'biz-a', 'enabledAt': 't0'});
    await LocalMode.load();

    await expectLater(
      LocalModeController.enterForSignup(),
      throwsA(isA<LocalModeDeviceHeldException>()),
    );
    // The signup's catch path must not unlock the other business's store.
    await LocalModeController.abortSignup();

    expect(await readLocalModeMarker(), {
      'businessId': 'biz-a',
      'enabledAt': 't0',
    });
    expect(LocalMode.isOn, isTrue);
  });
}
