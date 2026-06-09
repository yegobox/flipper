import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flipper_web/features/business_selection/selected_business_restore.dart';
import 'package:flipper_web/modules/accounting/data/accounting_diagnostics.dart';
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
    ref.watch(selectedBusinessRestoreProvider);
    ref.watch(accountingAutoPosterProvider);
    ref.watch(accountingStartupDiagnosticsProvider);

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
