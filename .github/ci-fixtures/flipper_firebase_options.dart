// CI FIXTURE — NOT REAL CREDENTIALS. Safe to read; safe to commit.
//
// `apps/flipper/lib/firebase_options.dart` is gitignored and written from an
// Actions secret in release.yml. PR-time jobs must not do that: they run
// PR-authored code, and fork pull requests are denied secrets entirely.
//
// Without this file, `dart analyze` on apps/flipper reports URI_DOES_NOT_EXIST
// for the import and UNDEFINED_IDENTIFIER for DefaultFirebaseOptions, which
// made the analyzer baseline differ between a developer's machine (where the
// real file exists) and CI (where it does not).
//
// This is NOT generated from the real file. The committed source references
// exactly one member — DefaultFirebaseOptions.currentPlatform — so that is all
// this provides. Every value is a placeholder; nothing here can reach a real
// Firebase project.
//
// Named flipper_firebase_options.dart, not firebase_options.dart, because
// .gitignore line 63 ignores that filename ANYWHERE in the tree -- a fixture
// called firebase_options.dart is silently untracked and CI would still fail
// with the error this file exists to prevent.
//
// See .github/ci-fixtures/README.md.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

class DefaultFirebaseOptions {
  /// The only member the committed source uses.
  ///
  /// Platform-independent on purpose: CI never initialises Firebase, it only
  /// needs the symbol to resolve so analysis and compilation succeed.
  static const FirebaseOptions currentPlatform = FirebaseOptions(
    apiKey: 'ci-fixture-apiKey',
    appId: '1:000000000000:web:0000000000000000000000',
    messagingSenderId: '000000000000',
    projectId: 'ci-fixture-project',
    authDomain: 'ci-fixture.invalid',
    storageBucket: 'ci-fixture.invalid',
  );
}
