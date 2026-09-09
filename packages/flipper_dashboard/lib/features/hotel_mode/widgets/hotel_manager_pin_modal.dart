import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Manager approval keypad shown over the desk when a clerk without settle
/// rights tries to check a guest out.
class HotelManagerPinModal extends ConsumerWidget {
  const HotelManagerPinModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(hotelStaffProvider).value ?? const <Tenant>[];
    final managers = staff.where(hotelTenantIsManager).toList();
    final isMobile = HotelLayoutBreakpoints.isHotelMobileLayout(
      MediaQuery.sizeOf(context).width,
    );

    Future<Tenant?> findManager(String pin) async {
      for (final manager in managers) {
        if (await barVerifyStaffPin(manager, pin)) return manager;
      }
      return null;
    }

    final keypad = BarKeypad(
      tight: true,
      title: 'Manager',
      hint: 'Enter manager 6-digit PIN',
      errorText: 'Not a manager PIN',
      verifyPin: (pin) async => await findManager(pin) != null,
      onSubmit: (pin) async {
        final manager = await findManager(pin);
        if (manager != null) {
          ref.read(hotelModeProvider.notifier).elevateManager(manager);
        }
      },
    );

    final cancel = TextButton(
      onPressed: () => ref.read(hotelModeProvider.notifier).hideManagerPin(),
      child: const Text('Cancel'),
    );

    final heading = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: HotelTokens.reservedTint,
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.shield_outlined,
            color: HotelTokens.reservedInk,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Manager approval',
          style: GoogleFonts.outfit(fontSize: 19, fontWeight: FontWeight.w800),
        ),
        Text(
          'Settling a folio needs a manager PIN.',
          style: GoogleFonts.outfit(color: HotelTokens.ink3, fontSize: 13),
        ),
      ],
    );

    if (isMobile) {
      return Material(
        color: const Color(0x800B1220),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 30),
            decoration: const BoxDecoration(
              color: HotelTokens.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(HotelTokens.mobileSheetRadius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: HotelTokens.lineStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                heading,
                const SizedBox(height: 18),
                keypad,
                const SizedBox(height: 12),
                cancel,
              ],
            ),
          ),
        ),
      );
    }

    return Material(
      color: Colors.black54,
      child: Center(
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: HotelTokens.surface,
            borderRadius: BorderRadius.circular(HotelTokens.radiusXl),
            boxShadow: HotelTokens.shadow2,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              heading,
              const SizedBox(height: 20),
              keypad,
              const SizedBox(height: 12),
              cancel,
            ],
          ),
        ),
      ),
    );
  }
}
