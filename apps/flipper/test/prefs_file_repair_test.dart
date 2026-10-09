import 'dart:io';

import 'package:flipper_rw/prefs_file_repair.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory dir;
  late File prefs;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('prefs_repair_');
    prefs = File('${dir.path}/$sharedPreferencesFileName');
    debugPrefsFileRepairPlatformOverride = true;
  });

  tearDown(() {
    debugPrefsFileRepairPlatformOverride = null;
    dir.deleteSync(recursive: true);
  });

  List<String> corruptBackups() => dir
      .listSync()
      .map((e) => e.uri.pathSegments.last)
      .where((n) => n.startsWith('$sharedPreferencesFileName.corrupt-'))
      .toList();

  test('moves a NUL-filled prefs file aside', () async {
    prefs.writeAsBytesSync(List<int>.filled(512, 0));

    await repairCorruptSharedPreferencesFile(supportDir: dir);

    expect(prefs.existsSync(), isFalse);
    expect(corruptBackups(), hasLength(1));
  });

  test('moves a prefs file that decodes to a non-map aside', () async {
    prefs.writeAsStringSync('[1,2]');

    await repairCorruptSharedPreferencesFile(supportDir: dir);

    expect(prefs.existsSync(), isFalse);
    expect(corruptBackups(), hasLength(1));
  });

  test('moves a prefs file that is not UTF-8 aside', () async {
    prefs.writeAsBytesSync([0xff, 0xfe, 0x7b]);

    await repairCorruptSharedPreferencesFile(supportDir: dir);

    expect(prefs.existsSync(), isFalse);
    expect(corruptBackups(), hasLength(1));
  });

  test('leaves a valid prefs file alone', () async {
    prefs.writeAsStringSync('{"flipper_web_api_user_id":"42"}');

    await repairCorruptSharedPreferencesFile(supportDir: dir);

    expect(prefs.readAsStringSync(), '{"flipper_web_api_user_id":"42"}');
    expect(corruptBackups(), isEmpty);
  });

  test('missing or empty prefs file is a no-op', () async {
    await repairCorruptSharedPreferencesFile(supportDir: dir);
    expect(dir.listSync(), isEmpty);

    prefs.writeAsStringSync('');
    await repairCorruptSharedPreferencesFile(supportDir: dir);
    expect(prefs.existsSync(), isTrue);
    expect(corruptBackups(), isEmpty);
  });

  test('skips platforms that do not keep prefs in a JSON file', () async {
    debugPrefsFileRepairPlatformOverride = false;
    prefs.writeAsBytesSync(List<int>.filled(16, 0));

    await repairCorruptSharedPreferencesFile(supportDir: dir);

    expect(prefs.existsSync(), isTrue);
  });
}
