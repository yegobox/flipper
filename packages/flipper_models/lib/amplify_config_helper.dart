import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_rw/amplifyconfiguration.dart';

class AmplifyConfigHelper {
  static bool _isConfigured = false;
  static Future<void>? _inFlight;

  /// Bounded background retries. Cognito configuration fails for transient
  /// reasons on real devices (Keystore not ready straight after boot, no
  /// network yet), and a single startup attempt used to leave Amplify
  /// permanently unconfigured for the whole session — every product image and
  /// every S3 call silently dead until the app was restarted.
  static const _retryDelays = <Duration>[
    Duration(seconds: 10),
    Duration(seconds: 30),
    Duration(minutes: 2),
    Duration(minutes: 5),
  ];
  static bool _retryScheduled = false;

  /// Configures Amplify, coalescing concurrent callers onto one attempt.
  ///
  /// This never throws: Amplify backs product images and Cognito auth, neither
  /// of which is needed to open a till, so a failure here must not be able to
  /// stop the app from starting. Call sites already guard on
  /// [Amplify.isConfigured]; the background retry closes the gap for them.
  static Future<void> configureAmplify({bool block = true}) async {
    if (_isConfigured) return;

    final attempt = _inFlight ??= _configureOnce().whenComplete(() {
      _inFlight = null;
    });

    if (block) {
      await attempt;
    }
  }

  static Future<void> _configureOnce() async {
    try {
      safePrint('🚀 [AmplifyConfigHelper] Adding plugins...');
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyStorageS3(),
      ]).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          safePrint('⚠️ [AmplifyConfigHelper] addPlugins timed out');
          throw TimeoutException('Amplify.addPlugins timed out');
        },
      );
      safePrint('✅ [AmplifyConfigHelper] Plugins added');

      safePrint('🚀 [AmplifyConfigHelper] Calling Amplify.configure...');
      await Amplify.configure(amplifyconfig).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          safePrint('⚠️ [AmplifyConfigHelper] Amplify.configure timed out');
          throw TimeoutException('Amplify.configure timed out');
        },
      );

      _isConfigured = true;
      safePrint('✅ [AmplifyConfigHelper] Amplify configured successfully');
    } on AmplifyAlreadyConfiguredException {
      _isConfigured = true;
      safePrint('ℹ️ [AmplifyConfigHelper] Amplify was already configured');
    } catch (e, s) {
      safePrint('❌ [AmplifyConfigHelper] Error configuring Amplify: $e');
      safePrint('❌ [AmplifyConfigHelper] Stack trace: $s');
      safePrint(
        '⚠️ Continuing without Amplify; storage and Cognito features are '
        'unavailable until a retry succeeds',
      );
      if (!AppSecrets.isTestEnvironment()) {
        _scheduleRetry();
      }
    }
  }

  static void _scheduleRetry() {
    if (_retryScheduled || _isConfigured) return;
    _retryScheduled = true;
    unawaited(() async {
      for (final delay in _retryDelays) {
        await Future<void>.delayed(delay);
        if (_isConfigured) break;
        safePrint('🔁 [AmplifyConfigHelper] Retrying configuration...');
        // `_configureOnce` re-arms nothing: `_retryScheduled` stays true for
        // the life of this loop so retries cannot fan out.
        await (_inFlight ??= _configureOnce().whenComplete(() {
          _inFlight = null;
        }));
        if (_isConfigured) break;
      }
      _retryScheduled = false;
    }());
  }

  static bool get isConfigured => _isConfigured;
}
