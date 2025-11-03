import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_web/core/secrets.dart' show AppSecrets;
import 'package:flipper_web/services/ditto_service.dart';
import 'ditto_singleton.dart';
// import 'platform.dart';

/// Clean up old Ditto directories to prevent accumulation
/// Note: Cleanup is disabled to ensure web compatibility
/// The unique directory approach already prevents conflicts

/// Initializes Supabase with the appropriate configuration based on the environment
Future<void> initializeSupabase() async {
  String supabaseUrl;
  String supabaseAnonKey;

  // if (kDebugMode) {
  //   if (isAndroid) {
  //     supabaseUrl = "http://10.0.2.2:54321";
  //   } else {
  //     supabaseUrl = AppSecrets.localSuperbaseUrl;
  //   }
  //   supabaseAnonKey = AppSecrets.localSupabaseAnonKey;
  // } else {
  supabaseUrl = AppSecrets.superbaseurl;
  supabaseAnonKey = AppSecrets.supabaseAnonKeyPublishable;
  // }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
}

/// Initializes Ditto with proper configuration for the Flipper app
Future<void> initializeDitto() async {
  try {
    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
    final token = kDebugMode
        ? AppSecrets.appTokenDebug
        : AppSecrets.appTokenProd;

    // Use consistent directory to preserve data
    final persistenceDir = kIsWeb ? "ditto_flipper_web" : "flipper_data_bridge";

    // Use singleton to prevent multiple instances
    final ditto = await DittoSingleton.instance.initialize(
      appId: appID,
      token: token,
      persistenceDir: persistenceDir,
    );

    if (ditto != null) {
      // Set device name
      final platformTag = kIsWeb ? "Web" : "Mobile";
      final deviceId = DateTime.now().millisecondsSinceEpoch % 10000;
      ditto.deviceName = "Flipper_${platformTag}_$deviceId";

      debugPrint('🚀 Ditto initialized successfully');
      debugPrint('📱 Device name: ${ditto.deviceName}');

      // Store in service
      DittoService.instance.setDitto(ditto);
      debugPrint('✅ DittoService instance set and ready');
    }
  } catch (e) {
    debugPrint('❌ Error initializing Ditto: $e');

    // If file lock error, wait and let singleton handle retry
    if (e.toString().contains('File already locked')) {
      debugPrint('🔄 File lock detected, waiting for cleanup...');
      await Future.delayed(const Duration(seconds: 3));
    }

    debugPrint('🔧 App will continue without Ditto functionality');
  }
}
