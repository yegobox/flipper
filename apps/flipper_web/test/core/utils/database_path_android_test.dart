import 'dart:io';

import 'package:flipper_web/core/utils/database_path_io.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  const root = '/data/data/rw.flipper/databases';

  test('the main store stays in the Android databases root', () {
    // Existing installs keep their data where it always was.
    expect(DatabasePath.androidDirectory(root, null), root);
    expect(DatabasePath.androidDirectory(root, 'db2'), root);
  });

  test('the QR-login store gets its own Android directory', () {
    final login = DatabasePath.androidDirectory(root, 'login_ditto/login-1');
    expect(login, p.join(root, 'login_ditto/login-1'));
    expect(login, isNot(DatabasePath.androidDirectory(root, 'db2')));
  });

  group('getDatabaseDirectory on Android', () {
    late Directory databases;

    setUp(() async {
      databases = await Directory.systemTemp.createTemp('android_databases');
      DatabasePath.debugAndroidDatabasesPath = () async => databases.path;
    });

    tearDown(() async {
      DatabasePath.debugAndroidDatabasesPath = null;
      await databases.delete(recursive: true);
    });

    test('keeps the main store in the databases root', () async {
      expect(
        await DatabasePath.getDatabaseDirectory(subDirectory: 'db2'),
        databases.path,
      );
    });

    test('gives the QR-login store its own directory', () async {
      final login = await DatabasePath.getDatabaseDirectory(
        subDirectory: 'login_ditto/login-1',
      );
      expect(login, p.join(databases.path, 'login_ditto/login-1'));
      expect(await Directory(login).exists(), isTrue);
    });
  });
}
