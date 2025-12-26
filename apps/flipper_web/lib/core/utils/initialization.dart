import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_web/core/secrets.dart' show AppSecrets;
// import 'package:flipper_web/services/ditto_service.dart';
// import 'ditto_singleton.dart';
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
/// DEPRECATED: Initialization is now handled in AppService.appInit
// Future<void> initializeDitto({int? userId}) async {
//   debugPrint('🔵 initializeDitto() called - DEPRECATED');
// }
