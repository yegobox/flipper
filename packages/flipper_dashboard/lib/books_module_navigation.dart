import 'package:flipper_dashboard/books_module_entry.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/features/login/signin_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Pops the Books module route when it is on the navigation stack.
void popBooksModuleIfOpen(NavigatorState navigator) {
  navigator.popUntil((route) => route.settings.name != BooksModuleEntry.routeName);
}

/// Opens Flipper Books in-process via [AccountingModuleScreen] (no WebView).
///
/// Pass [navigator] when calling after an overlay closes (e.g. [AppChoiceDialog],
/// [DashboardAllAppsSheet]) — the overlay [BuildContext] is deactivated after pop.
Future<void> navigateToBooksModule(
  BuildContext context,
  WidgetRef ref, {
  NavigatorState? navigator,
}) async {
  await ProxyService.box.writeString(key: 'defaultApp', value: 'Books');

  final nav = navigator ?? Navigator.maybeOf(context, rootNavigator: true);
  if (nav == null) return;

  popBooksModuleIfOpen(nav);

  final isDesktop = MediaQuery.sizeOf(nav.context).width >= SITokens.desktopBreakpoint;

  await nav.push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: isDesktop,
      settings: const RouteSettings(name: BooksModuleEntry.routeName),
      builder: (_) => const BooksModuleEntry(),
    ),
  );
}
