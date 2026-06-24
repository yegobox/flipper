import 'package:flipper_dashboard/native_books_context_bridge.dart';
import 'package:flipper_dashboard/widgets/dashboard_all_apps_sheet.dart';
import 'package:flipper_web/features/module_launcher/app_launcher_host.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Native host for Flipper Books — wraps [AccountingModuleScreen] and wires the
/// desktop topbar apps button to the dashboard All apps sheet.
class BooksModuleEntry extends ConsumerStatefulWidget {
  const BooksModuleEntry({super.key});

  static const routeName = 'BooksModule';

  @override
  ConsumerState<BooksModuleEntry> createState() => _BooksModuleEntryState();
}

class _BooksModuleEntryState extends ConsumerState<BooksModuleEntry> {
  late final Future<void> _nativeContextReady;

  @override
  void initState() {
    super.initState();
    // Provider writes must not run during initState/build — defer to next event loop.
    _nativeContextReady = Future<void>(() => restoreNativeBooksContext(ref));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _nativeContextReady,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return AppLauncherHost(
          onOpenLauncher: () => DashboardAllAppsSheet.show(context, ref),
          child: const AccountingModuleScreen(),
        );
      },
    );
  }
}
