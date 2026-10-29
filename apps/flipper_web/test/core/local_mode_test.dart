// Run as CI does (melos test:flipper_web), with
// --dart-define=FLUTTER_TEST_ENV=true: DatabasePath then keeps the store, and
// so the marker, in a local `.db` directory.
import 'dart:io';

import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_web/core/local_mode/local_mode_marker.dart';
import 'package:flipper_web/core/utils/database_path.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  late File marker;

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

  test('no marker means full sync', () async {
    expect(await LocalMode.load(), isFalse);
    expect(await LocalMode.marker(), isNull);
  });

  test('concurrent loads all see an existing marker', () async {
    await writeLocalModeMarker({'businessId': 'biz-a'});
    LocalMode.debugReset();

    final results = await Future.wait([LocalMode.load(), LocalMode.load()]);

    expect(results, [true, true]);
    expect(LocalMode.isOn, isTrue);
  });

  test('an unreadable marker still means local mode, owner unknown', () async {
    await marker.writeAsString('{not json');

    expect(await readLocalModeMarker(), {kLocalModeMarkerUnreadable: true});
    expect(await LocalMode.load(), isTrue);
  });

  test('an empty marker still means local mode, owner unknown', () async {
    await marker.writeAsString('');

    expect(await readLocalModeMarker(), {kLocalModeMarkerUnreadable: true});
    expect(await LocalMode.load(), isTrue);
  });

  test('enable refuses a store whose owner is unknown', () async {
    await marker.writeAsString('{not json');

    await expectLater(
      LocalMode.enable(),
      throwsA(isA<LocalModeDeviceHeldException>()),
    );
    expect(await marker.readAsString(), '{not json');
  });

  test('recording the owner replaces an unreadable marker', () async {
    await marker.writeAsString('');
    await LocalMode.load();

    await LocalMode.recordServerState(businessId: 'biz-a');

    expect(await readLocalModeMarker(), {'businessId': 'biz-a'});
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

  test('enable, record the server state, then disable', () async {
    final flips = <bool>[];
    void listener() => flips.add(LocalMode.changes.value);
    LocalMode.changes.addListener(listener);
    addTearDown(() => LocalMode.changes.removeListener(listener));

    await LocalMode.enable();
    expect(LocalMode.isOn, isTrue);

    final at = DateTime.utc(2026, 10, 29);
    await LocalMode.recordServerState(businessId: 'biz-a', serverChangedAt: at);
    final recorded = await LocalMode.marker();
    expect(recorded?['businessId'], 'biz-a');
    expect(recorded?['serverChangedAt'], at.toIso8601String());
    expect(recorded?['enabledAt'], isNotNull);

    await LocalMode.disable();
    expect(LocalMode.isOn, isFalse);
    expect(await marker.exists(), isFalse);
    expect(flips, [true, false]);
  });

  test('enable refuses a store another business keeps offline', () async {
    await writeLocalModeMarker({'businessId': 'biz-a', 'enabledAt': 't0'});

    await expectLater(
      LocalMode.enable(),
      throwsA(isA<LocalModeDeviceHeldException>()),
    );
    await expectLater(
      LocalMode.enable(businessId: 'biz-b'),
      throwsA(isA<LocalModeDeviceHeldException>()),
    );
    expect(await readLocalModeMarker(), {
      'businessId': 'biz-a',
      'enabledAt': 't0',
    });
  });

  test('enable for the same business keeps going', () async {
    await writeLocalModeMarker({'businessId': 'biz-a'});

    await LocalMode.enable(businessId: 'biz-a');

    expect((await LocalMode.marker())?['businessId'], 'biz-a');
    expect(LocalMode.isOn, isTrue);
  });

  test('recordServerState does nothing in full sync', () async {
    await LocalMode.recordServerState(businessId: 'biz-a');
    expect(await marker.exists(), isFalse);
  });

  test(
    'a failed read leaves the mode unknown until a later read works',
    () async {
      await writeLocalModeMarker({'businessId': 'biz-a'});
      LocalMode.debugReset();
      LocalMode.debugReadMarker = () async =>
          throw const FileSystemException('store directory unavailable');

      expect(await LocalMode.load(), isFalse);
      expect(LocalMode.isLoaded, isFalse);

      // The directory resolves again: the next load reads the marker.
      LocalMode.debugReadMarker = readLocalModeMarker;
      expect(await LocalMode.load(), isTrue);
      expect(LocalMode.isLoaded, isTrue);
    },
  );

  test('a loaded mode is answered without reading the marker again', () async {
    await writeLocalModeMarker({'businessId': 'biz-a'});
    expect(await LocalMode.load(), isTrue);

    await marker.delete();

    expect(await LocalMode.load(), isTrue);
  });

  test('debugSet forces the mode', () {
    LocalMode.debugSet(true);
    expect(LocalMode.isOn, isTrue);
    expect(LocalMode.isLoaded, isTrue);
  });

  test('the held-store exception names itself', () {
    expect(
      const LocalModeDeviceHeldException().toString(),
      'LocalModeDeviceHeldException',
    );
  });

  test('allowCloud is visible only inside its body', () async {
    expect(LocalMode.cloudAllowedHere, isFalse);
    final inside = await LocalMode.allowCloud(() async {
      await Future<void>.delayed(Duration.zero);
      return LocalMode.cloudAllowedHere;
    });
    expect(inside, isTrue);
    expect(LocalMode.cloudAllowedHere, isFalse);
  });
}
