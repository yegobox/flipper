import 'package:flipper_web/core/utils/error_logging.dart';
import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/modules/accounting/shell/desktop/accounting_desktop_shell.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Public entry for the Flipper Books (Accounting) module.
class AccountingModuleScreen extends ConsumerWidget {
  const AccountingModuleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restore = ref.watch(selectedBusinessRestoreProvider);

    return restore.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) {
        logCaughtError(
          error,
          stackTrace,
          type: 'business_context_restore',
        );
        return Scaffold(
          body: Center(
            child: Text('Could not restore business context: $error'),
          ),
        );
      },
      // Bootstrap + Ditto observers only after restore — avoids tearing down
      // FFI callbacks while replication is still notifying (macOS crash).
      data: (_) => const _AccountingBootstrappedShell(),
    );
  }
}

class _AccountingBootstrappedShell extends ConsumerWidget {
  const _AccountingBootstrappedShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(accountingCoaBootstrapProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) => logCaughtError(
          error,
          stackTrace,
          type: 'accounting_bootstrap',
        ),
      );
    });
    // COA bootstrap + journal replication run in background; views use
    // accountingLoadingProvider for per-section spinners.
    ref.watch(accountingCoaBootstrapProvider);
    ref.watch(accountingJournalReplicationProvider);
    ref.watch(accountingAutoPosterProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= SITokens.desktopBreakpoint) {
          return const AccountingDesktopShell();
        }
        return const AccountingMobileShell();
      },
    );
  }
}
