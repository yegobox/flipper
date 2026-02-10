// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/utils/platform.dart';
import 'package:flipper_web/core/utils/platform_utils.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:http/http.dart' as http;
import 'database_path.dart';
import 'lock_mechanism.dart';

/// Singleton manager for Ditto instances to prevent file lock conflicts
class DittoSingleton {
  static DittoSingleton? _instance;
  static Ditto? _ditto;
  static bool _isInitializing = false;
  static Completer<Ditto?>? _initCompleter;
  static String? _userId;

  // Lock mechanism abstraction
  static LockMechanism? _lockMechanism;
  static bool _lockAcquired = false;

  DittoSingleton._();

  static DittoSingleton get instance {
    print('📦 Accessing DittoSingleton instance');
    _instance ??= DittoSingleton._();
    return _instance!;
  }

  /// Get existing Ditto instance or null if not initialized
  Ditto? get ditto => _ditto;

  /// Check if Ditto is ready
  bool get isReady => _ditto != null && !_isInitializing;

  /// Get detailed initialization status
  Map<String, dynamic> getInitializationStatus() {
    return {
      'isInitialized': _ditto != null,
      'isInitializing': _isInitializing,
      'hasInstance': _ditto != null,
      'instanceIsNull': _ditto == null,
      'lockAcquired': _lockAcquired,
    };
  }

  /// Initialize Ditto with proper singleton handling and file locking
  Future<Ditto?> initialize({
    required String appId,
    required String userId,
  }) async {
    print(
      '🚀 [INIT START] Initializing Ditto for userId: $userId, appId: $appId',
    );
    if (appId.isEmpty) {
      print('❌ [INIT FAIL] Ditto initialization failed: appId is empty');
      return null;
    }

    // Detect user mismatch and force logout/reset to prevent silent user swaps
    if (_userId != null && userId != _userId) {
      print(
        '⚠️ [INIT] User mismatch detected ($userId != $_userId). Forcing logout and re-initialization.',
      );
      await logout();
      await dispose();
    }

    _userId = userId;
    print('✅ [INIT] UserId set to: $_userId');

    // Prevent multiple simultaneous initializations
    if (_isInitializing) {
      print('⏳ [INIT] Already initializing, waiting for result...');
      return _initCompleter?.future;
    }

    // Return existing instance if available and properly initialized
    if (_ditto != null && _lockAcquired) {
      print(
        '✅ [INIT] Using existing Ditto instance (hashCode: ${_ditto.hashCode}) with active lock',
      );
      return _ditto;
    }

    _isInitializing = true;
    _initCompleter = Completer<Ditto?>();
    print('🔄 [INIT] Set _isInitializing = true');

    try {
      // Get the persistence directory first
      print('📂 [INIT] Getting persistence directory...');
      final persistenceDirectory = await DatabasePath.getDatabaseDirectory(
        subDirectory: 'db2',
      );
      print('📂 [INIT] Persistence directory: $persistenceDirectory');

      if (persistenceDirectory.isEmpty) {
        print('❌ [INIT FAIL] persistenceDirectory is empty');
        _isInitializing = false;
        _initCompleter?.complete(null);
        _initCompleter = null;
        return null;
      }

      // Create and acquire lock file
      print('🔒 [INIT] Attempting to acquire lock...');
      final lockFilePath = '$persistenceDirectory/.ditto_lock';
      _lockMechanism = getLockMechanism();

      final lockAcquired = await _lockMechanism!.acquire(lockFilePath);
      print('🔒 [INIT] Lock acquisition result: $lockAcquired');
      if (!lockAcquired) {
        print(
          '❌ [INIT FAIL] Failed to acquire Ditto lock - another instance may be running',
        );
        _isInitializing = false;
        _initCompleter?.complete(null);
        _initCompleter = null;
        return null;
      }
      _lockAcquired = true;
      print('✅ [INIT] Lock acquired successfully');

      // Initialize Ditto
      print('🔧 [INIT] Calling Ditto.init()...');
      await Ditto.init();
      print('✅ [INIT] Ditto.init() completed');

      print('🔧 [INIT] Creating AuthenticationHandler...');
      final authHandler = AuthenticationHandler(
        authenticationRequired: (authenticator) =>
            _performAuthentication(authenticator, appId),
        authenticationExpiringSoon: (authenticator, secondsRemaining) =>
            _performAuthentication(authenticator, appId),
      );
      print('✅ [INIT] AuthenticationHandler created');

      print('🔧 [INIT] Creating OnlineWithAuthenticationIdentity...');
      final identity = OnlineWithAuthenticationIdentity(
        appID: appId,
        authenticationHandler: authHandler,
      );
      print('✅ [INIT] OnlineWithAuthenticationIdentity created');

      // isAndroid ? "ditto" :
      print('🔧 [INIT] Calling Ditto.open()...');
      _ditto = await Ditto.open(
        identity: identity,
        persistenceDirectory: persistenceDirectory,
      );
      print(
        '✅ [INIT] Ditto.open() completed, instance hashCode: ${_ditto.hashCode}',
      );

      try {
        print('🔧 [INIT] Setting DQL_STRICT_MODE to false...');
        await _ditto!.store.execute("ALTER SYSTEM SET DQL_STRICT_MODE = false");
        print('✅ [INIT] DQL_STRICT_MODE set successfully');
      } catch (e) {
        print(
          '⚠️ [INIT] Could not set DQL_STRICT_MODE: $e (this might be normal depending on Ditto version)',
        );
      }

      // Set DittoService instance BEFORE starting sync.
      // This ensures ProxyService.ditto.getUserAccess works even if sync setup fails.
      print(
        '📌 [INIT] About to call DittoService().setDitto(_ditto!) with instance: ${_ditto.hashCode}',
      );
      try {
        DittoService().setDitto(_ditto!);
        print('✅ [INIT] DittoService().setDitto() completed successfully');
        print(
          '✅ [INIT] DittoService.instance.dittoInstance is now: ${DittoService.instance.dittoInstance != null ? "SET (${DittoService.instance.dittoInstance!.hashCode})" : "NULL"}',
        );
      } catch (e, stack) {
        print('❌ [INIT ERROR] calling DittoService().setDitto(): $e');
        print('Stack: $stack');
      }

      try {
        print('🔧 [INIT] Configuring transports and starting sync...');
        // Configure transports manually for the web/cloud sync
        _ditto!.updateTransportConfig((config) {
          // Note: this will not enable peer-to-peer sync on the web platform
          config.setAllPeerToPeerEnabled(true);
        });

        // Start sync to connect to Ditto cloud
        final userName = platformUserName;
        final platform = getPlatformName();
        _ditto!.deviceName = '$userName-$platform-$userId';
        _ditto!.startSync();

        print("✅ [INIT] Sync started. is sync active: ${_ditto!.isSyncActive}");
        print("✅ [INIT] Auth status: ${_ditto!.auth.status}");
      } catch (e) {
        print('⚠️ [INIT] Error starting Ditto sync: $e');
      }

      print(
        '✅ [INIT COMPLETE] Ditto singleton initialized successfully with lock',
      );
      _initCompleter?.complete(_ditto);
      return _ditto;
    } catch (e) {
      print('❌ Ditto singleton initialization failed: $e');
      _ditto = null;
      _lockAcquired = false;
      await _releaseLock();
      if (!(_initCompleter?.isCompleted ?? true)) {
        _initCompleter?.completeError(e);
      }
      rethrow;
    } finally {
      _isInitializing = false;
      _initCompleter = null;
    }
  }

  /// Release the lock file and close the handle
  Future<void> _releaseLock() async {
    if (_lockMechanism != null) {
      await _lockMechanism!.release();
      _lockAcquired = false;
      print('🔓 Released Ditto lock');
    }
  }

  /// Reset singleton (for testing or hot restart)
  static Future<void> reset() async {
    print('🔄 Resetting DittoSingleton...');
    if (_instance != null) {
      await _instance!.dispose();
      _instance = null;
    }
    // Also reset static variables to ensure clean state
    _ditto = null;
    _isInitializing = false;
    _initCompleter = null;
    _userId = null;
    _lockMechanism = null;
    _lockAcquired = false;
    print('✅ DittoSingleton reset complete');
  }

  /// Dispose Ditto instance properly and release lock
  Future<void> dispose() async {
    if (_ditto != null) {
      try {
        print('🛑 Stopping Ditto sync and disposing singleton...');
        _ditto!.stopSync();
        try {
          // Explicitly close the Ditto instance to release internal locks
          _ditto!.close();
        } catch (e) {
          print('⚠️ Error closing Ditto instance: $e');
        }
        await Future.delayed(const Duration(milliseconds: 500));
        _ditto = null;
        await _releaseLock();
        print('✅ Ditto singleton disposed and lock released');
      } catch (e) {
        print('❌ Error disposing Ditto singleton: $e');
        _ditto = null;
        await _releaseLock();
      }
    } else {
      await _releaseLock();
    }
  }

  /// Logout and stop sync
  Future<void> logout() async {
    if (_ditto != null) {
      try {
        print('🛑 Logging out from Ditto...');
        _ditto!.stopSync();
        _ditto!.auth.logout();
        // Reset userId state
        _userId = null;
        print('✅ Ditto logout complete');
      } catch (e) {
        print('❌ Error during Ditto logout: $e');
      }
    }
  }

  /// Internal helper to perform authentication with timeout and error handling
  Future<void> _performAuthentication(
    Authenticator authenticator,
    String appId,
  ) async {
    try {
      print('🔐 Starting Ditto authentication for appId: $appId');

      if (_userId == null) {
        throw StateError(
          'Ditto authentication failed: User ID is null. '
          'Ensure initialize() is called with a valid userId.',
        );
      }

      const provider = "auth-provider-01";
      final userID = "$_userId@flipper.rw";

      print('🔑 Generating JWT for user: $userID');
      final token = await YBAuthIdentity.generateJWT(
        userID,
        true,
        appId: appId,
      );

      print('🚀 Logging in to Ditto with token');
      await authenticator.login(token: token, provider: provider);
      print('✅ Ditto authentication successful for user: $userID');
    } catch (e, stackTrace) {
      print('❌ Ditto authentication failed: $e');
      print('Stack trace: $stackTrace');
      // We catch the error here to prevent the sync worker from crashing,
      // but the failure is logged for debugging.
    }
  }
}

class YBAuthIdentity {
  static Future<String> generateJWT(
    String userID,
    bool isUserRegistered, {
    required String appId,
  }) async {
    // Make API call to auth endpoint to get a valid JWT
    // Using the local auth service endpoint that matches the Kotlin implementation
    final url = Uri.parse(
      '${AppSecrets.apihubProdDomain}/v2/api/auth/ditto/login',
    );

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'userId': userID, 'appId': appId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['token'] as String;
    } else {
      throw Exception(
        'Failed to authenticate: ${response.statusCode} - ${response.body}',
      );
    }
  }
}
