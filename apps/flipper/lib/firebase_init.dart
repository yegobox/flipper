import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Starts the default Firebase app, or reuses the one that already exists.
///
/// On Android the google-services plugin creates `[DEFAULT]` natively from
/// `google-services.json` before Dart runs. `Firebase.initializeApp` then
/// compares our Dart options with that app and throws `core/duplicate-app`
/// when the API key, database URL or storage bucket differ. Every native
/// Firebase SDK (Crashlytics, Messaging) and every Dart plugin already runs on
/// that native app, so the right move is to use it, not to report a failure.
Future<FirebaseApp> initializeDefaultFirebaseApp(FirebaseOptions options) {
  return reuseExistingAppOnDuplicate(
    () => Firebase.initializeApp(options: options),
    Firebase.app,
  );
}

/// Runs [initialize] and, only when it fails with Firebase's `duplicate-app`
/// error, returns [existing] instead. Any other error is rethrown unchanged.
@visibleForTesting
Future<T> reuseExistingAppOnDuplicate<T>(
  Future<T> Function() initialize,
  T Function() existing,
) async {
  try {
    return await initialize();
  } on FirebaseException catch (e) {
    if (!isDuplicateAppError(e)) rethrow;
    debugPrint(
      '[Firebase] [DEFAULT] already exists with different options; '
      'reusing the native app (check google-services.json against '
      'firebase_options.dart).',
    );
    return existing();
  }
}

/// Whether [e] is firebase_core's "A Firebase App named ... already exists".
@visibleForTesting
bool isDuplicateAppError(FirebaseException e) =>
    e.plugin == 'core' && e.code == 'duplicate-app';
