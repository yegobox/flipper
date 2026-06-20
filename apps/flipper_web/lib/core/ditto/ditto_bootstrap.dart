import 'package:flipper_web/core/secrets.dart';
import 'dart:async';

import 'package:flipper_web/core/session_persistence.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flipper_web/modules/accounting/data/accounting_diagnostics.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initializes [DittoSingleton] after login and refreshes accounting providers
/// so they pick Ditto when available.
abstract final class DittoBootstrap {
  static Future<bool>? _initInFlight;
  static String? _initInFlightUserId;
  static Completer<bool>? _initCompleter;

  /// Ensures Ditto is initialized when a session exists (Books, reload, cache).
  static Future<bool> kickoffIfNeeded(Ref ref) async {
    if (DittoService.instance.isReady() &&
        DittoSingleton.isAuthenticated(DittoService.instance.dittoInstance)) {
      _markReady(ref);
      return true;
    }

    var userId = ref.read(sessionApiUserIdProvider)?.trim();
    userId ??= (await SessionPersistence.readApiUserId())?.trim();
    userId ??= ref.read(userProfileCacheProvider)?.id.trim();

    if (userId == null || userId.isEmpty) {
      debugPrint('[DittoBootstrap] kickoff skipped — no userId');
      return false;
    }

    return ensureInitialized(ref, userId: userId);
  }

  static Future<bool> ensureInitialized(
    Ref ref, {
    required String userId,
  }) async {
    final trimmed = userId.trim();
    if (trimmed.isEmpty) {
      debugPrint('[DittoBootstrap] skip — empty userId');
      return false;
    }

    if (DittoSingleton.instance.isReady &&
        DittoService.instance.isReady() &&
        DittoSingleton.isAuthenticated(DittoSingleton.instance.ditto)) {
      debugPrint('[DittoBootstrap] already ready userId=$trimmed');
      _markReady(ref);
      return true;
    }

    if (_initInFlight != null && _initInFlightUserId == trimmed) {
      debugPrint('[DittoBootstrap] joining in-flight init userId=$trimmed');
      return _initInFlight!;
    }

    final appId = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
    debugPrint('[DittoBootstrap] initializing appId=$appId userId=$trimmed');

    final completer = Completer<bool>();
    _initInFlightUserId = trimmed;
    _initCompleter = completer;
    _initInFlight = completer.future;

    unawaited(
      _runInitialize(ref, appId: appId, userId: trimmed).then((ready) {
        if (!completer.isCompleted) completer.complete(ready);
      }).catchError((Object e, StackTrace st) {
        debugPrint('[DittoBootstrap] initialize FAILED: $e\n$st');
        if (ref.mounted) _markNotReady(ref);
        if (!completer.isCompleted) completer.complete(false);
      }).whenComplete(() {
        if (identical(_initCompleter, completer)) {
          _initCompleter = null;
          _initInFlight = null;
          _initInFlightUserId = null;
        }
      }),
    );

    return completer.future;
  }

  static Future<bool> _runInitialize(
    Ref ref, {
    required String appId,
    required String userId,
  }) async {
    try {
      final ditto = await DittoSingleton.instance.initialize(
        appId: appId,
        userId: userId,
      );
      final ready = ditto != null &&
          DittoService.instance.isReady() &&
          DittoSingleton.isAuthenticated(ditto);
      debugPrint(
        '[DittoBootstrap] initialize finished ready=$ready '
        'auth=${ditto?.auth.status}',
      );

      if (ref.mounted) {
        if (ready) {
          _markReady(ref);
        } else {
          _markNotReady(ref);
        }
      }
      return ready;
    } catch (e, st) {
      debugPrint('[DittoBootstrap] initialize FAILED: $e\n$st');
      if (ref.mounted) {
        _markNotReady(ref);
      }
      return false;
    }
  }

  static void _markReady(Ref ref) {
    ref.read(dittoReadyProvider.notifier).state = true;
    _invalidateAccountingData(ref);
  }

  static void _markNotReady(Ref ref) {
    ref.read(dittoReadyProvider.notifier).state = false;
  }

  static void _invalidateAccountingData(Ref ref) {
    debugPrint(
      '[DittoBootstrap] invalidating accounting providers → will re-resolve backend',
    );
    ref.invalidate(accountingRepositoryProvider);
    ref.invalidate(accountingLedgerRepositoryProvider);
    invalidateAccountingDataStreams(ref);
    ref.invalidate(accountingPostSyncBootstrapProvider);
    ref.invalidate(accountingStartupDiagnosticsProvider);
  }

  static Future<void> disposeOnSignOut(Ref ref) async {
    debugPrint('[DittoBootstrap] sign-out — disposing Ditto');
    _markNotReady(ref);
    try {
      await DittoSingleton.instance.dispose();
    } catch (e) {
      debugPrint('[DittoBootstrap] dispose error: $e');
    }
  }
}
