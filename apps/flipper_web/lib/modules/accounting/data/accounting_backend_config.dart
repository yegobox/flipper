import 'package:flutter/foundation.dart';

/// Which persistence layer Books uses for POS transactions + GL (ledger).
///
/// Default is **ditto** (no Supabase fallback when Ditto is still starting).
///
/// ```bash
/// # Default — Ditto only
/// flutter run -d chrome
///
/// # Supabase only (explicit opt-in)
/// flutter run -d chrome --dart-define=ACCOUNTING_BACKEND=supabase
/// ```
enum AccountingBackendStrategy {
  ditto,
  supabase,
}

abstract final class AccountingBackendConfig {
  static const _raw = String.fromEnvironment(
    'ACCOUNTING_BACKEND',
    defaultValue: 'ditto',
  );

  static AccountingBackendStrategy get strategy {
    switch (_raw.trim().toLowerCase()) {
      case 'supabase':
        return AccountingBackendStrategy.supabase;
      default:
        return AccountingBackendStrategy.ditto;
    }
  }

  static String get strategyLabel => strategy.name;

  /// Whether [layer] uses Ditto. No Supabase fallback when strategy is [ditto].
  static bool useDitto({
    required AccountingBackendStrategy strategy,
    required bool dittoReady,
    required AccountingDataLayer layer,
  }) {
    if (strategy == AccountingBackendStrategy.supabase) {
      return false;
    }
    if (!dittoReady) {
      debugPrint(
        '[Accounting] strategy=ditto — Ditto not ready yet (${layer.name}); '
        'using Ditto repositories (empty until init completes)',
      );
    }
    return true;
  }

  static void logStartupConfig() {
    debugPrint(
      '[Accounting] ACCOUNTING_BACKEND=$_raw (resolved=${strategy.name}, no fallback)',
    );
  }
}

enum AccountingDataLayer {
  transactions,
  ledger,
}
