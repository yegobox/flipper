import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flipper_web/modules/accounting/shell/desktop/accounting_desktop_shell.dart';
import 'package:flipper_web/modules/accounting/shell/mobile/accounting_mobile_shell.dart';
import 'package:flutter/material.dart';

/// Public entry for the Flipper Books (Accounting) module.
class AccountingModuleScreen extends StatelessWidget {
  const AccountingModuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
