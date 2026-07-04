import 'package:flipper_dashboard/dashboard_shell.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/event_bus.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

DashboardPage? dashboardPageFromPendingName(String name) {
  switch (name) {
    case 'delegations':
      return DashboardPage.delegations;
    case 'orders':
      return DashboardPage.orders;
    case 'reports':
      return DashboardPage.reports;
    case 'inventory':
      return DashboardPage.inventory;
    default:
      return null;
  }
}

void openDashboardPage(WidgetRef ref, String pageName) {
  final page = dashboardPageFromPendingName(pageName);
  if (page == null) return;
  ref.read(selectedPageProvider.notifier).state = page;
  ProxyService.box.remove(key: kPendingDashboardPageKey);
}

void applyPendingDashboardPage(WidgetRef ref) {
  final pending = ProxyService.box.readString(key: kPendingDashboardPageKey);
  if (pending == null || pending.isEmpty) return;
  openDashboardPage(ref, pending);
}

/// Listens for notification / deep-link requests to open an inner dashboard tab.
void usePendingDashboardPageNavigation(WidgetRef ref) {
  useEffect(() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      applyPendingDashboardPage(ref);
    });

    final subscription = EventBus().on<OpenDashboardPageEvent>().listen((event) {
      openDashboardPage(ref, event.page);
    });

    return subscription.cancel;
  }, const []);
}
