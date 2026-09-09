import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_folio_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_calendar_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_dashboard_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_lock_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_quotations_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/screens/hotel_rooms_screen.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_manager_pin_modal.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Root Hotel Mode screen machine (rooms → folio).
///
/// Same shell as Bar Mode: the terminal is a shared register, so it opens on
/// a PIN lock, any staff member can sign in, and settling a folio can be
/// gated behind a manager PIN. A branch that runs a single signed-in
/// receptionist can switch the lock off ([HotelModeSettings.requirePin]).
class HotelModeHost extends ConsumerStatefulWidget {
  const HotelModeHost({super.key});

  @override
  ConsumerState<HotelModeHost> createState() => _HotelModeHostState();
}

class _HotelModeHostState extends ConsumerState<HotelModeHost> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final branchId = ProxyService.box.getBranchId();
      await HotelModeSettings.hydrateForActiveBranch();
      HotelModeSettings.startWatchingActiveBranch();
      if (branchId != null) {
        await ProxyService.getStrategy(
          Strategy.capella,
        ).seedDefaultRooms(branchId: branchId);
      }
      if (HotelModeSettings.enabled) {
        HotelModeSettings.setLaunchOnStart(true);
      }
      if (!mounted) return;
      if (HotelModeSettings.requirePin) {
        ref.read(hotelModeProvider.notifier).setScreen(HotelScreen.lock);
      } else {
        await _signInSignedInTenant();
      }
    });
  }

  /// PIN entry off: the desk runs as whoever is signed into the app, so charges
  /// still get attributed to a real tenant rather than to nobody.
  Future<void> _signInSignedInTenant() async {
    if (!mounted) return;
    if (ref.read(hotelModeProvider).activeClerk != null) return;

    final staff = await ref.read(hotelStaffProvider.future);
    if (!mounted || staff.isEmpty) return;

    final userId = ProxyService.box.getUserId()?.trim();
    Tenant? me;
    for (final tenant in staff) {
      if (userId != null && tenant.userId?.trim() == userId) {
        me = tenant;
        break;
      }
    }
    ref.read(hotelModeProvider.notifier).login(me ?? staff.first);
  }

  @override
  Widget build(BuildContext context) {
    final hotel = ref.watch(hotelModeProvider);

    final Widget screen = switch (hotel.screen) {
      HotelScreen.lock => const HotelLockScreen(),
      HotelScreen.dashboard => const HotelDashboardScreen(),
      HotelScreen.rooms => const HotelRoomsScreen(),
      HotelScreen.calendar => const HotelCalendarScreen(),
      HotelScreen.quotes => const HotelQuotationsScreen(),
      HotelScreen.folio => const HotelFolioScreen(),
    };

    return Scaffold(
      backgroundColor: HotelTokens.stageBg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = HotelLayoutBreakpoints.isHotelMobileLayout(
            constraints.maxWidth,
          );

          final stack = Stack(
            children: [
              AnimatedSwitcher(
                duration: HotelTokens.fadeIn,
                child: KeyedSubtree(
                  key: ValueKey(hotel.screen),
                  child: screen,
                ),
              ),
              if (hotel.showManagerModal) const HotelManagerPinModal(),
              if (hotel.toastMessage != null)
                HotelToast(
                  message: hotel.toastMessage!,
                  mobile: isMobile,
                  onDone: () =>
                      ref.read(hotelModeProvider.notifier).clearToast(),
                ),
            ],
          );

          if (isMobile) return SafeArea(child: stack);

          // Uniform scale from the design canvas, extended to the window's
          // aspect ratio so the desk fills the screen instead of letterboxing
          // on the stage background — same trick as [BarModeHost].
          final s = [
            constraints.maxWidth / HotelTokens.canvasWidth,
            constraints.maxHeight / HotelTokens.canvasHeight,
          ].reduce((a, b) => a < b ? a : b);
          if (!s.isFinite || s <= 0) return const SizedBox.shrink();

          return SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.fill,
              child: SizedBox(
                width: constraints.maxWidth / s,
                height: constraints.maxHeight / s,
                child: stack,
              ),
            ),
          );
        },
      ),
    );
  }
}
