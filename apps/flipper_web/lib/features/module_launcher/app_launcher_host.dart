import 'package:flutter/material.dart';

/// Supplies a native app-launcher callback when [AccountingModuleScreen] runs
/// outside GoRouter (e.g. embedded in the Flipper native app).
class AppLauncherHost extends InheritedWidget {
  const AppLauncherHost({
    super.key,
    required this.onOpenLauncher,
    required super.child,
    this.hostProvidesHeader = false,
  });

  final VoidCallback onOpenLauncher;

  /// The host draws the mobile header itself (the Flipper app's CustomAppBar,
  /// with its back button and title), so Books leaves out its own brand row
  /// rather than naming itself twice.
  final bool hostProvidesHeader;

  static AppLauncherHost? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLauncherHost>();
  }

  @override
  bool updateShouldNotify(AppLauncherHost oldWidget) {
    return onOpenLauncher != oldWidget.onOpenLauncher ||
        hostProvidesHeader != oldWidget.hostProvidesHeader;
  }
}
