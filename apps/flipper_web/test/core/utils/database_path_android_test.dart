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
}
