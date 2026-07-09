import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_settle_desktop.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_settle_mobile.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_layout_breakpoints.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BarSettleScreen extends ConsumerWidget {
  const BarSettleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (BarLayoutBreakpoints.isBarMobileLayout(constraints.maxWidth)) {
          return const BarSettleMobileScreen();
        }
        return const BarSettleDesktopScreen();
      },
    );
  }
}
