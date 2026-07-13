import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_desktop.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_mobile.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_layout_breakpoints.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BarLockScreen extends ConsumerWidget {
  const BarLockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (BarLayoutBreakpoints.isBarMobileLayout(constraints.maxWidth)) {
          return const BarLockMobileScreen();
        }
        return const BarLockDesktopScreen();
      },
    );
  }
}
