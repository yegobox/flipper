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

  test('opting in refuses a store whose owner is unknown', () async {
    await marker.writeAsString('{not json');
    await LocalMode.load();

    final result = await LocalModeController.optInToSync();

    expect(result, CloudSyncOptIn.notOwner);
    expect(await marker.readAsString(), '{not json');
    expect(LocalMode.isOn, isTrue);
  });
}
