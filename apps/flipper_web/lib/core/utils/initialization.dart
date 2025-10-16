import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_web/core/secrets.dart' show AppSecrets;
import 'package:flipper_web/services/ditto_service.dart';
import 'platform.dart';

/// Clean up old Ditto directories to prevent accumulation
/// Note: Cleanup is disabled to ensure web compatibility
/// The unique directory approach already prevents conflicts

/// Initializes Supabase with the appropriate configuration based on the environment
Future<void> initializeSupabase() async {
  String supabaseUrl;
  String supabaseAnonKey;

  if (kDebugMode) {
    if (isAndroid) {
      supabaseUrl = "http://10.0.2.2:54321";
    } else {
      supabaseUrl = AppSecrets.localSuperbaseUrl;
    }
    supabaseAnonKey = AppSecrets.localSupabaseAnonKey;
  } else {
    supabaseUrl = AppSecrets.superbaseurl;
    supabaseAnonKey = AppSecrets.supabaseAnonKeyPublishable;
  }

  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
}

/// Initializes Ditto with proper configuration for the Flipper app
Future<void> initializeDitto() async {
  try {
    // Clean up old directories first (non-web platforms only)

    // Check if DittoService already has an active instance and dispose it
    if (DittoService.instance.isReady()) {
      debugPrint(
        '⚠️  Existing Ditto instance found, disposing before creating new one',
      );
      await DittoService.instance.dispose();
      // Wait a bit to ensure cleanup is complete
      await Future.delayed(const Duration(milliseconds: 500));
    }

    final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

    await Ditto.init();

    final identity = OnlinePlaygroundIdentity(
      appID: appID,
      token: kDebugMode ? AppSecrets.appTokenDebug : AppSecrets.appTokenProd,
      enableDittoCloudSync: true,
    );

    // Use consistent directory for desktop, unique for web/mobile
    final String persistenceDir;
    if (kIsWeb) {
      // Web needs unique directories to avoid conflicts
      final dirTimestamp = DateTime.now().millisecondsSinceEpoch;
      persistenceDir = "ditto_flipper_web_$dirTimestamp";
    } else {
      // Desktop/mobile use consistent directory to persist data
      persistenceDir = "flipper_data_bridge";
    }

    debugPrint('📁 Using Ditto directory: $persistenceDir');

    final ditto = await Ditto.open(
      identity: identity,
      persistenceDirectory: persistenceDir,
    );

    // Set device name for debugging with timestamp to ensure uniqueness
    final platformTag = kIsWeb ? "Web" : "Mobile";
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp % 100000) + (DateTime.now().microsecond % 1000);
    ditto.deviceName = "Flipper_${platformTag}_${random}_$timestamp";

    ditto.updateTransportConfig((config) {
      // Clear any existing configs first to prevent conflicts
      config.connect.webSocketUrls.clear();

      if (kIsWeb) {
        // For web, ensure P2P is completely disabled
        config.setAllPeerToPeerEnabled(false);
        // Add cloud sync URL
        config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
      } else {
        // Enable P2P for mobile/desktop
        config.setAllPeerToPeerEnabled(true);

        // Add cloud sync URL
        config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
      }
    });

    // Disable DQL strict mode for flexibility
    await ditto.store.execute("ALTER SYSTEM SET DQL_STRICT_MODE = false");

    ditto.startSync();

    // Log initialization info
    debugPrint('🚀 Ditto initialized successfully');
    debugPrint('📱 Device name: ${ditto.deviceName}');
    debugPrint('✅ Ditto is ready for use');
    if (kDebugMode) {
      debugPrint(
        'ℹ️  Note: mDNS NameConflict warnings are normal during development',
      );
      debugPrint(
        '   Multiple Ditto instances on the same network will compete for service names',
      );
    }

    // Store the initialized Ditto instance in the service
    DittoService.instance.setDitto(ditto);
    debugPrint('✅ DittoService instance set and ready');
  } catch (e, stackTrace) {
    debugPrint('❌ Error initializing Ditto: $e');
    debugPrint('Stack trace: $stackTrace');

    // If we get a file lock error, try to recover by waiting and retrying once
    if (e.toString().contains('File already locked') ||
        e.toString().contains('Multiple Ditto instances')) {
      debugPrint('🔄 File lock conflict detected, waiting and retrying...');

      // Wait longer for any existing instances to fully clean up
      await Future.delayed(const Duration(seconds: 2));

      try {
        // Retry the initialization
        final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

        final identity = OnlinePlaygroundIdentity(
          appID: appID,
          token: kDebugMode
              ? AppSecrets.appTokenDebug
              : AppSecrets.appTokenProd,
          enableDittoCloudSync: true,
        );

        // Use consistent directory for retry on desktop, unique for web
        final String retryPersistenceDir;
        if (kIsWeb) {
          final retryTimestamp = DateTime.now().millisecondsSinceEpoch;
          retryPersistenceDir = "ditto_flipper_web_retry_$retryTimestamp";
        } else {
          retryPersistenceDir = "flipper_data_bridge";
        }

        debugPrint('📁 Using retry Ditto directory: $retryPersistenceDir');

        final ditto = await Ditto.open(
          identity: identity,
          persistenceDirectory: retryPersistenceDir,
        );

        // Set device name with more randomness
        final platformTag = kIsWeb ? "Web" : "Mobile";
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final random =
            (timestamp % 100000) + (DateTime.now().microsecond % 1000);
        ditto.deviceName = "Flipper_${platformTag}_${random}_retry_$timestamp";

        ditto.updateTransportConfig((config) {
          config.connect.webSocketUrls.clear();

          if (kIsWeb) {
            config.setAllPeerToPeerEnabled(false);
            config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
          } else {
            config.setAllPeerToPeerEnabled(true);
            config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
          }
        });

        await ditto.store.execute("ALTER SYSTEM SET DQL_STRICT_MODE = false");
        ditto.startSync();

        debugPrint('✅ Ditto initialization retry successful');
        DittoService.instance.setDitto(ditto);
      } catch (retryError) {
        debugPrint('❌ Ditto initialization retry failed: $retryError');
        debugPrint('🔧 App will continue without Ditto functionality');
        // Don't rethrow - allow app to continue without Ditto
      }
    } else {
      debugPrint('🔧 App will continue without Ditto functionality');
      // Don't rethrow - allow app to continue without Ditto
    }
  }
}
