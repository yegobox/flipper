// ignore_for_file: avoid_print
import 'dart:async';
import 'dart:convert';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/helperModels/sale_device_id.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/utils/platform.dart';
import 'package:flipper_web/core/utils/platform_utils.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:http/http.dart' as http;
import 'database_path.dart';
import 'lock_mechanism.dart';

/// Singleton manager for Ditto instances to prevent file lock conflicts
class DittoSingleton {
  static DittoSingleton? _instance;
  static Ditto? _ditto;
  static bool _isInitializing = false;
  static Completer<Ditto?>? _initCompleter;
  /// userId for the in-flight [initialize] call (may differ from [_userId] briefly).
  static String? _initTargetUserId;
  /// Bumped when an in-flight init is aborted so stale work discards its result.
  static int _initGeneration = 0;
  static String? _userId;

  // Lock mechanism abstraction
  static LockMechanism? _lockMechanism;
  static bool _lockAcquired = false;

  /// Join concurrent JWT/login calls (expiration handler + explicit login).
  static Future<bool>? _dittoAuthInFlight;

  /// QR/desktop login auth+sync started with [unawaited]; [dispose] awaits this.
  static Future<void>? _qrLoginSyncInFlight;

  DittoSingleton._();

  static DittoSingleton get instance {
    print('📦 Accessing DittoSingleton instance');
    _instance ??= DittoSingleton._();
    return _instance!;
  }

  /// Get existing Ditto instance or null if not initialized
  Ditto? get ditto => _ditto;

  /// Last [userId] passed to [initialize] (raw id, not including `@flipper.rw`).
  /// Used to avoid skipping re-init when the auth guard is stale.
  static String? get persistenceUserId => _userId;

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

  /// Whether cloud auth completed for [ditto] (Books needs this before replication).
  static bool isAuthenticated(Ditto? ditto) {
    if (ditto == null) return false;
    try {
      return ditto.auth.status.isAuthenticated;
    } catch (_) {
      return false;
    }
  }

  /// Initialize Ditto with proper singleton handling and file locking.
  ///
  /// When [deferSyncStart] is true (PIN login fast path), opens the local store
  /// without cloud auth/sync — call [ensureAuthenticatedAndSyncing] later.
  Future<Ditto?> initialize({
    required String appId,
    required String userId,
    bool deferSyncStart = false,
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
      await resetSaleDeviceIdCache();
      await _abortInFlightInit();
      await logout();
      await dispose();
    }

    _userId = userId;
    print('✅ [INIT] UserId set to: $_userId');

    // Join only when the same user is already being initialized. A stale in-flight
    // init (e.g. QR login torn down mid-flight) must not block PIN login forever.
    if (_isInitializing) {
      if (_initTargetUserId == userId) {
        print('⏳ [INIT] Already initializing, waiting for result...');
        return _initCompleter?.future;
      }
      print(
        '⚠️ [INIT] Stale init in progress for $_initTargetUserId '
        '(requested $userId) — aborting and restarting',
      );
      await _abortInFlightInit();
    }

    // Return existing instance if available and properly initialized
    if (_ditto != null && _lockAcquired) {
      print(
        '✅ [INIT] Using existing Ditto instance (hashCode: ${_ditto.hashCode}) with active lock',
      );
      return _ditto;
    }

    final isLoginIdentity = userId.startsWith('login-');

    _isInitializing = true;
    _initTargetUserId = userId;
    _initCompleter = Completer<Ditto?>();
    final initGeneration = _initGeneration;
    print('🔄 [INIT] Set _isInitializing = true');

    try {
      print(
        '🔐 [INIT] loginFlow=$isLoginIdentity (QR/desktop login uses isolated store + cloud-only sync)',
      );

      // Get the persistence directory first
      print('📂 [INIT] Getting persistence directory...');
      final persistenceDirectory = await DatabasePath.getDatabaseDirectory(
        subDirectory: isLoginIdentity ? 'login_ditto/$userId' : 'db2',
      );
      print('📂 [INIT] Persistence directory: $persistenceDirectory');

      if (persistenceDirectory.isEmpty) {
        print('❌ [INIT FAIL] persistenceDirectory is empty');
        _isInitializing = false;
        _initCompleter?.complete(null);
        _initCompleter = null;
        return null;
      }

      // File locks are for desktop/mobile multi-process safety only. WASM/web
      // builds may still resolve the dart:io lock stub at compile time; skip here.
      if (kIsWeb) {
        _lockAcquired = true;
        print('✅ [INIT] Web — skipping file lock');
      } else {
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
      }

      // Initialize Ditto
      print('🔧 [INIT] Calling Ditto.init()...');
      await Ditto.init();
      print('✅ [INIT] Ditto.init() completed');

      final cloudUrl = 'https://$appId.cloud.ditto.live';
      final webSocketUrl = 'wss://$appId.cloud.ditto.live/';

      print('🔧 [INIT] Creating DittoConfig (Ditto v5)...');
      final config = DittoConfig(
        databaseID: appId,
        connect: DittoConfigConnectServer(url: cloudUrl),
        persistenceDirectory: persistenceDirectory,
      );
      print('✅ [INIT] Calling Ditto.open(config)...');
      _ditto = await Ditto.open(config);
      print(
        '✅ [INIT] Ditto.open() completed, instance hashCode: ${_ditto.hashCode}',
      );

      // Required for server connections before sync.start.
      await _ditto!.auth.setExpirationHandler((ditto, timeUntilExpiration) {
        print(
          '🔐 [AUTH] expiration handler '
          '(expires in ${timeUntilExpiration.inSeconds}s)',
        );
        unawaited(_performAuthentication(ditto, appId));
      });

      if (!isLoginIdentity) {
        try {
          await _ditto!.store.execute(
            'ALTER SYSTEM SET DQL_STRICT_MODE = true',
          );
          print('✅ [INIT] DQL_STRICT_MODE=true (v4-compatible semantics)');
        } catch (e) {
          print('⚠️ [INIT] DQL_STRICT_MODE setup skipped: $e');
        }
      } else {
        print('⏭️ [INIT] Skipping Ditto maintenance queries for QR login flow');
      }

      // Name + transports BEFORE DittoService.setDitto — SyncMixin uses deviceName
      // to detect login peers; default host names wrongly enable AWDL/BLE + sync.
      final userName = platformUserName;
      final platform = getPlatformName();
      // Per-browser install suffix (web) or stable native suffix — see
      // [resolveDittoInstallSuffix]. deviceName embeds userId so sale device id
      // changes when the logged-in user changes on this install.
      final installSuffix = await resolveDittoInstallSuffix();
      _ditto!.deviceName = '$userName-$platform-$userId-$installSuffix';
      await resetSaleDeviceIdCache();

      try {
        print('🔧 [INIT] Configuring transports...');
        if (isLoginIdentity || kIsWeb) {
          // Web/WASM and QR login: cloud WebSocket only (no BLE/AWDL/mDNS).
          _ditto!.transportConfig = TransportConfig.builder(
            connect: Connect(webSocketUrls: {webSocketUrl}),
          ).build();
          print(
            '✅ [INIT] Cloud WebSocket only '
            '(${kIsWeb ? "web/WASM" : "QR login"})',
          );
        } else {
          _ditto!.updateTransportConfig((config) {
            config.setAllPeerToPeerEnabled(true);
            config.connect.webSocketUrls = {webSocketUrl};
          });
          print('✅ [INIT] Peer-to-peer transports + cloud WebSocket enabled');
        }
      } catch (e) {
        print('⚠️ [INIT] Error configuring Ditto transports: $e');
      }

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

      if (isLoginIdentity) {
        print(
          '🔐 [INIT] Authenticating QR-login Ditto before starting sync...',
        );
        _qrLoginSyncInFlight = _authenticateThenStartSync(
          appId,
          initGeneration: initGeneration,
        );
      } else if (deferSyncStart) {
        print('⏭️ [INIT] Sync start deferred (login fast path)');
      } else {
        print('🔐 [INIT] Authenticating before cloud sync...');
        await _authenticateThenStartSync(
          appId,
          initGeneration: initGeneration,
        );
      }

      if (!_isInitGenerationCurrent(initGeneration)) {
        print('⏭️ [INIT] Discarding stale init result (generation $initGeneration)');
        return null;
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
      if (_isInitGenerationCurrent(initGeneration) &&
          !(_initCompleter?.isCompleted ?? true)) {
        _initCompleter?.completeError(e);
      }
      if (_isInitGenerationCurrent(initGeneration)) {
        rethrow;
      }
      return null;
    } finally {
      if (_isInitGenerationCurrent(initGeneration)) {
        _isInitializing = false;
        _initCompleter = null;
        _initTargetUserId = null;
      }
    }
  }

  static bool _isInitGenerationCurrent(int generation) =>
      generation == _initGeneration;

  /// Unblock waiters when [dispose] or user switch tears down a running init.
  static Future<void> _abortInFlightInit() async {
    if (!_isInitializing) return;
    print('🛑 [INIT] Aborting in-flight Ditto initialization');
    _initGeneration++;
    final completer = _initCompleter;
    _isInitializing = false;
    _initCompleter = null;
    _initTargetUserId = null;
    if (completer != null && !completer.isCompleted) {
      completer.complete(null);
    }
  }

  /// Awaits QR/desktop login auth+sync started during [initialize].
  ///
  /// Desktop QR login must not register Ditto sync subscriptions until this
  /// returns true — otherwise login events from the phone never replicate.
  Future<bool> ensureQrLoginCloudReady({
    Duration timeout = const Duration(seconds: 60),
  }) async {
    final inFlight = _qrLoginSyncInFlight;
    if (inFlight != null) {
      try {
        await inFlight.timeout(timeout);
      } catch (e) {
        print('⚠️ [QR LOGIN] auth/sync in-flight failed or timed out: $e');
      }
    }

    final ditto = _ditto;
    if (ditto == null) {
      print('❌ [QR LOGIN] no Ditto instance after init');
      return false;
    }

    final ready = isAuthenticated(ditto) && ditto.sync.isActive;
    if (ready) {
      print('✅ [QR LOGIN] cloud replication ready');
    } else {
      print(
        '❌ [QR LOGIN] cloud not ready '
        '(auth=${ditto.auth.status}, sync=${ditto.sync.isActive})',
      );
    }
    return ready;
  }

  Future<void> _authenticateThenStartSync(
    String appId, {
    required int initGeneration,
  }) async {
    final ditto = _ditto;
    if (ditto == null) return;

    try {
      if (!_isInitGenerationCurrent(initGeneration) || _ditto != ditto) {
        return;
      }

      // Ditto v5 server mode: sync.start drives auth via the expiration handler.
      try {
        if (!ditto.sync.isActive) {
          print('🔧 [INIT] Starting Ditto sync (JWT via expiration handler)...');
          ditto.sync.start();
        }
      } catch (e) {
        print('⚠️ [INIT] sync.start before auth: $e');
      }

      final authed = await _waitForAuthenticated(
        ditto,
        appId: appId,
        initGeneration: initGeneration,
      );

      if (!_isInitGenerationCurrent(initGeneration) || _ditto != ditto) {
        return;
      }

      if (!authed) {
        print('❌ [INIT] Ditto authentication failed or timed out');
        return;
      }

      print(
        '✅ [INIT] Authenticated and syncing. '
        'sync=${ditto.sync.isActive}, auth=${ditto.auth.status}',
      );
    } finally {
      _qrLoginSyncInFlight = null;
    }
  }

  Future<bool> _waitForAuthenticated(
    Ditto ditto, {
    required String appId,
    required int initGeneration,
    Duration timeout = const Duration(seconds: 60),
  }) async {
    if (isAuthenticated(ditto)) {
      print('✅ [AUTH] Already authenticated (${ditto.auth.status.userID})');
      return true;
    }

    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      if (!_isInitGenerationCurrent(initGeneration) || _ditto != ditto) {
        return false;
      }
      if (isAuthenticated(ditto)) {
        print('✅ [AUTH] Authenticated (${ditto.auth.status.userID})');
        return true;
      }
      if (_dittoAuthInFlight == null) {
        unawaited(_performAuthentication(ditto, appId));
      }
      await Future.delayed(const Duration(milliseconds: 200));
    }

    print('❌ [AUTH] Timed out after ${timeout.inSeconds}s');
    return isAuthenticated(ditto);
  }

  static Future<void> _awaitInFlightWork({
    Duration timeout = const Duration(seconds: 3),
  }) async {
    final qrSync = _qrLoginSyncInFlight;
    final auth = _dittoAuthInFlight;
    _qrLoginSyncInFlight = null;

    for (final work in [qrSync, auth]) {
      if (work == null) continue;
      try {
        await work.timeout(timeout);
      } catch (_) {
        // Dispose wins — ignore auth/sync errors on a closing instance.
      }
    }
    _dittoAuthInFlight = null;
  }

  /// JWT auth only — does not start replication. Use before Brick/SQLite init on
  /// startup so Ditto local reads (e.g. LoginChoices `getUserAccess`) work
  /// without contending on sqlite3 with Brick.
  Future<void> ensureAuthenticated({required String appId}) async {
    final ditto = _ditto;
    if (ditto == null) return;
    await _performAuthentication(ditto, appId);
  }

  /// Completes cloud auth + sync after [initialize] with [deferSyncStart: true].
  Future<void> ensureAuthenticatedAndSyncing({required String appId}) async {
    final ditto = _ditto;
    if (ditto == null) return;
    if (ditto.sync.isActive) return;

    final authed = await _performAuthentication(ditto, appId);
    if (_ditto != ditto || !authed) return;

    try {
      if (!ditto.sync.isActive) {
        ditto.sync.start();
      }
      print(
        '✅ [INIT] Deferred sync started. is sync active: ${ditto.sync.isActive}',
      );
    } catch (e) {
      print('⚠️ [INIT] Error starting deferred Ditto sync: $e');
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
    _ditto = null;
    await _abortInFlightInit();
    _userId = null;
    _lockMechanism = null;
    _lockAcquired = false;
    _dittoAuthInFlight = null;
    print('✅ DittoSingleton reset complete');
  }

  /// Dispose Ditto instance properly and release lock.
  ///
  /// [quick] uses shorter waits when tearing down the isolated QR-login store
  /// so "Switch to PIN login" does not freeze the UI.
  Future<void> dispose({bool quick = false}) async {
    await _abortInFlightInit();
    await _awaitInFlightWork(
      timeout: quick
          ? const Duration(milliseconds: 400)
          : const Duration(seconds: 3),
    );
    if (_ditto != null) {
      try {
        print('🛑 Stopping Ditto sync and disposing singleton...');
        _ditto!.sync.stop();
        try {
          await _ditto!.close();
        } catch (e) {
          print('⚠️ Error closing Ditto instance: $e');
        }
        await Future.delayed(
          quick
              ? const Duration(milliseconds: 50)
              : const Duration(milliseconds: 500),
        );
        _ditto = null;
        DittoService.instance.clearDittoInstance();
        await _releaseLock();
        print('✅ Ditto singleton disposed and lock released');
      } catch (e) {
        print('❌ Error disposing Ditto singleton: $e');
        _ditto = null;
        DittoService.instance.clearDittoInstance();
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
        _ditto!.sync.stop();
        await _ditto!.auth.logout();
        _userId = null;
        print('✅ Ditto logout complete');
      } catch (e) {
        print('❌ Error during Ditto logout: $e');
      }
    }
  }

  Future<bool> _performAuthentication(Ditto ditto, String appId) {
    final existing = DittoSingleton._dittoAuthInFlight;
    if (existing != null) {
      print('⏳ [AUTH] Joining in-flight Ditto authentication');
      return existing;
    }
    final inFlight = _performAuthenticationOnce(ditto, appId).whenComplete(() {
      DittoSingleton._dittoAuthInFlight = null;
    });
    DittoSingleton._dittoAuthInFlight = inFlight;
    return inFlight;
  }

  Future<bool> _performAuthenticationOnce(Ditto ditto, String appId) async {
    try {
      if (_ditto != ditto) {
        print('⏭️ [AUTH] Skipping auth — Ditto instance was replaced');
        return false;
      }

      print('🔐 Starting Ditto authentication for appId: $appId');

      if (_userId == null) {
        throw StateError(
          'Ditto authentication failed: User ID is null. '
          'Ensure initialize() is called with a valid userId.',
        );
      }

      const provider = 'auth-provider-01';
      final userID = '$_userId@flipper.rw';

      print('🔑 Generating JWT for user: $userID');
      final token = await YBAuthIdentity.generateJWT(
        userID,
        true,
        appId: appId,
      );

      if (_ditto != ditto) {
        print('⏭️ [AUTH] Skipping login — Ditto instance was disposed');
        return false;
      }

      print('🚀 Logging in to Ditto with token');
      final result = await ditto.auth.login(token: token, provider: provider);
      if (isAuthenticated(ditto)) {
        final authedAs = ditto.auth.status.userID ?? userID;
        print('✅ Ditto authentication successful for user: $authedAs');
        if (result.exception != null) {
          print(
            '⚠️ [AUTH] login reported ${result.exception} but peer is '
            'authenticated — treating as success (WASM quirk)',
          );
        }
        return true;
      }
      if (result.exception != null) {
        throw result.exception!;
      }
      print('❌ Ditto authentication failed: not authenticated after login');
      return false;
    } catch (e, stackTrace) {
      print('❌ Ditto authentication failed: $e');
      print('Stack trace: $stackTrace');
      return false;
    }
  }
}

class YBAuthIdentity {
  static Future<String> generateJWT(
    String userID,
    bool isUserRegistered, {
    required String appId,
  }) async {
    final url = Uri.parse(
      '${AppSecrets.apihubProdDomain}/v2/api/auth/ditto/login',
    );

    final response = await http
        .post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'userId': userID, 'appId': appId}),
        )
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw TimeoutException(
            'Ditto JWT auth request to $url timed out',
          ),
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
