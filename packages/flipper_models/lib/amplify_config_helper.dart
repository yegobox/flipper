import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flipper_rw/amplifyconfiguration.dart';

class AmplifyConfigHelper {
  static bool _isConfigured = false;

  static Future<void> configureAmplify() async {
    if (_isConfigured) {
      return; // Already configured
    }

    try {
      // Add Auth and Storage plugins
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyStorageS3(),
      ]);

      // Configure Amplify with your amplifyconfiguration.dart
      // Make sure you have amplifyconfiguration.dart in your project
      await Amplify.configure(amplifyconfig);

      _isConfigured = true;
      safePrint('Amplify configured successfully');
    } on AmplifyAlreadyConfiguredException {
      _isConfigured = true;
      safePrint('Amplify was already configured');
    } catch (e) {
      safePrint('Error configuring Amplify: $e');
      rethrow;
    }
  }

  static bool get isConfigured => _isConfigured;
}
