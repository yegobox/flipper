// Run as CI does (melos test:supabase_models):
//   flutter test --dart-define=FLUTTER_TEST_ENV=true test/repository_before_open_test.dart
import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository.dart';

void main() {
  group('Repository before it opens', () {
    test('waitUntilReady gives up after its timeout', () async {
      expect(Repository.isReady, isFalse);

      await expectLater(
        Repository.waitUntilReady(timeout: const Duration(milliseconds: 10)),
        throwsA(isA<TimeoutException>()),
      );
    });

    test('pausing and resuming cloud sync need no open repository', () {
      // Local-mode signup and opt-in can run before the repository opens.
      expect(Repository.pauseCloudSync, returnsNormally);
      expect(Repository.resumeCloudSync, returnsNormally);
    });
  });
}
