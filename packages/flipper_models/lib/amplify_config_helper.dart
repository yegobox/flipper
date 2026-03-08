import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_rw/amplifyconfiguration.dart';

class AmplifyConfigHelper {
  static bool _isConfigured = false;
  static bool _isConfiguring = false;

  static Future<void> configureAmplify({bool block = true}) async {
    if (_isConfigured) {
      return; // Already configured
    }

    if (_isConfiguring) {
      safePrint(
        'ℹ️ [AmplifyConfigHelper] Configuration already in progress...',
      );
      return;
    }

    _isConfiguring = true;
    final configFuture = () async {
      try {
        safePrint('🚀 [AmplifyConfigHelper] Adding plugins...');
        // Add Auth and Storage plugins
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

        // Configure Amplify with your amplifyconfiguration.dart
        // Make sure you have amplifyconfiguration.dart in your project
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
        // On iOS simulators, Keychain issues can cause Amplify to fail.
        if (AppSecrets.isTestEnvironment()) {
          safePrint('⚠️ Skipping Amplify rethrow in test/debug environment');
        } else {
          rethrow;
        }
      } finally {
        _isConfiguring = false;
      }
    }();

    if (block) {
      await configFuture;
    }
  }

  static bool get isConfigured => _isConfigured;
}
