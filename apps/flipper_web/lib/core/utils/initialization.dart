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
Future<void> initializeDitto({int? userId}) async {
  debugPrint('🔵 initializeDitto() called');

  final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
  final token = kDebugMode ? AppSecrets.appTokenDebug : AppSecrets.appTokenProd;

  debugPrint('🔵 Calling DittoSingleton.instance.initialize...');

  // Use singleton to prevent multiple instances
  final ditto = await DittoSingleton.instance.initialize(
    appId: appID,
    token: token,
    userId: userId,
  );

  debugPrint(
    '🔵 DittoSingleton.initialize returned: ${ditto != null ? "non-null" : "NULL"}',
  );

  // Check detailed status from singleton
  final status = DittoSingleton.instance.getInitializationStatus();
  debugPrint('🔧 DittoSingleton status: $status');

  if (ditto == null) {
    debugPrint('❌ Ditto initialization returned null!');
    throw Exception('Failed to initialize Sync DB - returned null instance');
  }

  // Set device name
  final platformTag = kIsWeb ? "Web" : "Mobile";
  final deviceId = DateTime.now().millisecondsSinceEpoch % 10000;
  ditto.deviceName = "Flipper_${platformTag}_$deviceId";

  debugPrint('🚀 Sync DB initialized successfully');
  debugPrint('📱 Device name: ${ditto.deviceName}');

  // Store in service
  debugPrint('🔵 Calling DittoService.instance.setDitto...');
  DittoService.instance.setDitto(ditto);
  debugPrint('✅ Sync DB instance set and ready');

  // Wait a bit to ensure the service has properly processed the Ditto instance
  await Future.delayed(const Duration(milliseconds: 100));

  // Verify it was set
  final verifyDitto = DittoService.instance.dittoInstance;
  debugPrint(
    '🔍 Verification: DittoService.instance.dittoInstance is ${verifyDitto != null ? "non-null" : "NULL"}',
  );

  // Also verify with the enhanced readiness check
  final isActuallyReady = DittoService.instance.isActuallyReady();
  debugPrint('🔍 Enhanced verification: isActuallyReady = $isActuallyReady');
}
