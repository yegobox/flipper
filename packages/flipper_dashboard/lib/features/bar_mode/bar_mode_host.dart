import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_floor_screen.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_lock_screen.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_pos_screen.dart';
import 'package:flipper_dashboard/features/bar_mode/screens/bar_settle_screen.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_manager_pin_modal.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_toast.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Root Bar Mode screen machine (lock → floor → pos → settle).
class BarModeHost extends ConsumerStatefulWidget {
  const BarModeHost({super.key});

  @override
  ConsumerState<BarModeHost> createState() => _BarModeHostState();
}

class _BarModeHostState extends ConsumerState<BarModeHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final branchId = ProxyService.box.getBranchId();
      await BarModeSettings.hydrateForActiveBranch();
      BarModeSettings.startWatchingActiveBranch();
      if (branchId != null) {
        await ProxyService.getStrategy(Strategy.capella)
            .seedDefaultFloorPlan(branchId: branchId);
      }
      if (BarModeSettings.enabled) {
        BarModeSettings.setLaunchOnStart(true);
      }
      ref.read(barModeProvider.notifier).setScreen(BarScreen.lock);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bar = ref.watch(barModeProvider);

    Widget screen;
    switch (bar.screen) {
      case BarScreen.lock:
        screen = const BarLockScreen();
      case BarScreen.tables:
        screen = const BarFloorScreen();
      case BarScreen.pos:
        screen = const BarPosScreen();
      case BarScreen.settle:
        screen = const BarSettleScreen();
    }

    return Scaffold(
      backgroundColor: BarTokens.stageBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Uniform scale from the 1440x912 design canvas, but extend the
          // canvas to the window's aspect ratio so the UI fills the whole
          // screen instead of letterboxing on the stage background. The
          // extra space is absorbed by the flexible layouts inside screens.
          final s = [
            constraints.maxWidth / BarTokens.canvasWidth,
            constraints.maxHeight / BarTokens.canvasHeight,
          ].reduce((a, b) => a < b ? a : b);
          if (!s.isFinite || s <= 0) return const SizedBox.shrink();

          final canvasWidth = constraints.maxWidth / s;
          final canvasHeight = constraints.maxHeight / s;

          return SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: canvasWidth,
                height: canvasHeight,
                child: Stack(
                  children: [
                    AnimatedSwitcher(
                      duration: BarTokens.fadeIn,
                      child: KeyedSubtree(
                        key: ValueKey(bar.screen),
                        child: screen,
                      ),
                    ),
                    if (bar.showManagerModal) const BarManagerPinModal(),
                    if (bar.toastMessage != null)
                      BarToast(
                        message: bar.toastMessage!,
                        onDone: () =>
                            ref.read(barModeProvider.notifier).clearToast(),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
