import 'package:flipper_dashboard/widgets/dashboard_all_apps_sheet.dart';
import 'package:flipper_web/features/module_launcher/app_launcher_host.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Native host for Flipper Books — wraps [AccountingModuleScreen] and wires the
/// desktop topbar apps button to the dashboard All apps sheet.
class BooksModuleEntry extends ConsumerWidget {
  const BooksModuleEntry({super.key});

  static const routeName = 'BooksModule';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppLauncherHost(
      onOpenLauncher: () => DashboardAllAppsSheet.show(context, ref),
      child: const AccountingModuleScreen(),
    );
  }
}
