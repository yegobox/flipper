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
  final nav = navigator ?? Navigator.maybeOf(context, rootNavigator: true);
  if (nav == null) {
    await ProxyService.box.writeString(key: 'defaultApp', value: 'Books');
    return;
  }

  await openBooksModuleOn(nav);
}

/// Opens Books with only a [NavigatorState] in hand — for callers that no longer
/// have a live [BuildContext], e.g. the login flow after it cleared the stack.
///
/// Resolves when Books is popped, so callers that just want it on screen should
/// not await it.
Future<void> openBooksModuleOn(NavigatorState navigator) async {
  await ProxyService.box.writeString(key: 'defaultApp', value: 'Books');

  popBooksModuleIfOpen(navigator);

  final isDesktop =
      MediaQuery.sizeOf(navigator.context).width >= SITokens.desktopBreakpoint;

  await navigator.push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: isDesktop,
      settings: const RouteSettings(name: BooksModuleEntry.routeName),
      builder: (_) => const BooksModuleEntry(),
    ),
  );
}
