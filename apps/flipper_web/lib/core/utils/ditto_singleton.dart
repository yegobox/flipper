// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/utils/platform_web.dart';
import 'package:http/http.dart' as http;
import 'database_path.dart';

/// Singleton manager for Ditto instances to prevent file lock conflicts
class DittoSingleton {
  static DittoSingleton? _instance;
  static Ditto? _ditto;
  static bool _isInitializing = false;
  static Completer<Ditto?>? _initCompleter;
  static int? _userId;
  static final StreamController<int> _userIdController =
      StreamController<int>.broadcast();

  DittoSingleton._();

  static DittoSingleton get instance {
    _instance ??= DittoSingleton._();
    return _instance!;
  }

  /// Get the current user ID or a future that completes with the next one
  Future<int> get userIdFuture async {
    if (_userId != null) return _userId!;
    return _userIdController.stream.first;
  }

  /// Set user ID to unlock authentication
  void setUserId(int userId) {
    if (_userId == userId) return;
    _userId = userId;
    _userIdController.add(userId);
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
    };
  }

  /// Initialize Ditto with proper singleton handling
  Future<Ditto?> initialize({
    required String appId,
    required String token,
    int? userId,
  }) async {
    // Detect user mismatch and force logout/reset to prevent silent user swaps
    // If a non-null userId is passed that differs from the currently stored _userId,
    // we perform a logout and set _ditto to null to force a fresh initialization.
    if (userId != null && _userId != null && userId != _userId) {
      print(
        '⚠️ User mismatch detected ($userId != $_userId). Forcing logout and re-initialization.',
      );
      await logout();
      _ditto = null;
    }

    if (userId != null) {
      setUserId(userId);
    }
    // Prevent multiple simultaneous initializations
    if (_isInitializing) {
      print(
        '⏳ Ditto initialization already in progress, waiting for result...',
      );
      return _initCompleter?.future;
    }

    // Return existing instance if available
    if (_ditto != null) {
      print('✅ Using existing Ditto instance');
      return _ditto;
    }

    _isInitializing = true;
    _initCompleter = Completer<Ditto?>();

    try {
      await Ditto.init();

      final authHandler = AuthenticationHandler(
        authenticationRequired: (authenticator) =>
            _performAuthentication(authenticator, appId),
        authenticationExpiringSoon: (authenticator, secondsRemaining) =>
            _performAuthentication(authenticator, appId),
      );

      final identity = OnlineWithAuthenticationIdentity(
        appID: appId,
        authenticationHandler: authHandler,
      );

      final persistenceDirectory = await DatabasePath.getDatabaseDirectory(
        subDirectory: 'db2',
      );
      print('📂 Using persistence directory: $persistenceDirectory');

      _ditto = await Ditto.open(
        identity: identity,
        persistenceDirectory: isAndroid ? "ditto" : persistenceDirectory,
      );
      print('✅ Ditto singleton initialized successfully');

      try {
        print('Setting DQL_STRICT_MODE to false');
        await _ditto!.store.execute("ALTER SYSTEM SET DQL_STRICT_MODE = false");
      } catch (e) {
        print(
          '⚠️ Could not set DQL_STRICT_MODE: $e (this might be normal depending on Ditto version)',
        );
      }
      print('Setting DQL_STRICT_MODE to false Done');
      try {
        // Configure transports manually for the web/cloud sync
        _ditto!.updateTransportConfig((config) {
          // Note: this will not enable peer-to-peer sync on the web platform
          config.setAllPeerToPeerEnabled(true);
        });
        print('Configuring transports manually for the web/cloud sync Done');

        // Start sync to connect to Ditto cloud
        _ditto!.startSync();

        print("is sync active: ${_ditto!.isSyncActive}");
        print("auth status: ${_ditto!.auth.status}");
      } catch (e) {
        print('⚠️ Error starting Ditto sync: $e');
      }

      print('✅ Ditto singleton initialized successfully');
      _initCompleter?.complete(_ditto);
      return _ditto;
    } catch (e) {
      print('❌ Ditto singleton initialization failed: $e');
      _ditto = null;
      if (!(_initCompleter?.isCompleted ?? true)) {
        _initCompleter?.completeError(e);
      }
      rethrow;
    } finally {
      _isInitializing = false;
      _initCompleter = null;
    }
  }

  /// Reset singleton (for testing or hot restart)
  static Future<void> reset() async {
    if (_instance != null) {
      await _instance!.dispose();
      _instance = null;
    }
  }

  /// Dispose Ditto instance properly
  Future<void> dispose() async {
    if (_ditto != null) {
      try {
        print('🛑 Stopping Ditto sync and disposing singleton...');
        _ditto!.stopSync();
        await Future.delayed(const Duration(milliseconds: 500));
        _ditto = null;
        print('✅ Ditto singleton disposed');
      } catch (e) {
        print('❌ Error disposing Ditto singleton: $e');
        _ditto = null;
      }
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

      // Wait for userId if not yet provided, with a 30-second timeout
      final activeUserId = await userIdFuture.timeout(
        const Duration(seconds: 120),
        onTimeout: () {
          throw TimeoutException(
            'Timed out waiting for userId during Ditto authentication. '
            'Ensure setUserId() is called before or shortly after initialization.',
          );
        },
      );

      const provider = "auth-provider-01";
      final userID = "$activeUserId@flipper.rw";

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
