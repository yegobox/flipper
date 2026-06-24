import 'package:flutter/material.dart';

/// Supplies a native app-launcher callback when [AccountingModuleScreen] runs
/// outside GoRouter (e.g. embedded in the Flipper native app).
class AppLauncherHost extends InheritedWidget {
  const AppLauncherHost({
    super.key,
    required this.onOpenLauncher,
    required super.child,
  });

  final VoidCallback onOpenLauncher;

  static AppLauncherHost? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppLauncherHost>();
  }

  @override
  bool updateShouldNotify(AppLauncherHost oldWidget) {
    return onOpenLauncher != oldWidget.onOpenLauncher;
  }
}
