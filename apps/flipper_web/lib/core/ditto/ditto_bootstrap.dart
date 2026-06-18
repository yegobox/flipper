import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Initializes [DittoSingleton] after login and refreshes accounting providers
/// so they pick Ditto when available.
abstract final class DittoBootstrap {
  static Future<bool> ensureInitialized(
    Ref ref, {
    required String userId,
  }) async {
    final trimmed = userId.trim();
    if (trimmed.isEmpty) {
      debugPrint('[DittoBootstrap] skip — empty userId');
      return false;
    }

    if (DittoSingleton.instance.isReady && DittoService.instance.isReady()) {
      debugPrint('[DittoBootstrap] already ready userId=$trimmed');
      return true;
    }

    final appId = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;
    debugPrint('[DittoBootstrap] initializing appId=$appId userId=$trimmed');

    try {
      final ditto = await DittoSingleton.instance.initialize(
        appId: appId,
        userId: trimmed,
      );
      final ready = ditto != null && DittoService.instance.isReady();
      debugPrint('[DittoBootstrap] initialize finished ready=$ready');

      if (ready && ref.mounted) {
        _invalidateAccountingData(ref);
      }
      return ready;
    } catch (e, st) {
      debugPrint('[DittoBootstrap] initialize FAILED: $e\n$st');
      return false;
    }
  }

  static void _invalidateAccountingData(Ref ref) {
    debugPrint(
      '[DittoBootstrap] invalidating accounting providers → will re-resolve backend',
    );
    ref.invalidate(accountingRepositoryProvider);
    ref.invalidate(accountingLedgerRepositoryProvider);
    ref.invalidate(rawTransactionStreamProvider);
    ref.invalidate(rawTransactionItemsProvider);
    ref.invalidate(chartOfAccountsStreamProvider);
    ref.invalidate(journalEntriesStreamProvider);
    ref.invalidate(bankLinesStreamProvider);
  }

  static Future<void> disposeOnSignOut() async {
    debugPrint('[DittoBootstrap] sign-out — disposing Ditto');
    try {
      await DittoSingleton.instance.dispose();
    } catch (e) {
      debugPrint('[DittoBootstrap] dispose error: $e');
    }
  }
}
