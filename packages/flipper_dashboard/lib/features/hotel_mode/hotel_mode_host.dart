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
      await _resolveEntry();
    });
  }

  /// Decides the opening screen once branch settings are known.
  ///
  /// The desk stays on [HotelScreen.starting] until this resolves, so a branch
  /// that does not use a PIN never flashes a lock screen it will dismiss by
  /// itself, and a branch that does use one never shows the desk first.
  Future<void> _resolveEntry() async {
    final notifier = ref.read(hotelModeProvider.notifier);
    try {
      if (ref.read(hotelModeProvider).activeClerk != null) {
        notifier.setScreen(HotelScreen.dashboard);
        return;
      }

      if (HotelModeSettings.requirePin) {
        notifier.resolveEntry(requirePin: true);
        return;
      }

      // PIN entry off: the desk runs as whoever is signed into the app, so
      // charges are still attributed to a real tenant. A signed-in user who
      // matches no staff record gets the lock rather than someone else's
      // identity — and someone else's rights.
      final signedIn = await _signedInStaffMember();
      if (!mounted) return;

      notifier.resolveEntry(requirePin: false, signedInClerk: signedIn);
      if (signedIn == null) {
        notifier.showToast('Sign in with your PIN to open the desk');
      }
    } catch (e) {
      // Never leave the desk on the starting screen, and never open it on a
      // failure: an unreadable setting is not permission to skip the lock.
      if (mounted) notifier.resolveEntry(requirePin: true);
    }
  }

  Future<Tenant?> _signedInStaffMember() async {
    final userId = ProxyService.box.getUserId()?.trim();
    if (userId == null || userId.isEmpty) return null;

    final staff = await ref.read(hotelStaffProvider.future);
    for (final tenant in staff) {
      if (tenant.userId?.trim() == userId) return tenant;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final hotel = ref.watch(hotelModeProvider);

    final Widget screen = switch (hotel.screen) {
      HotelScreen.starting => const ColoredBox(
        color: HotelTokens.posBg,
        child: Center(child: CircularProgressIndicator()),
      ),
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
                child: KeyedSubtree(key: ValueKey(hotel.screen), child: screen),
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
