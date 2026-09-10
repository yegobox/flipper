import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_people_strip.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

class HotelLockMobileScreen extends ConsumerStatefulWidget {
  const HotelLockMobileScreen({super.key});

  @override
  ConsumerState<HotelLockMobileScreen> createState() =>
      _HotelLockMobileScreenState();
}

class _HotelLockMobileScreenState extends ConsumerState<HotelLockMobileScreen> {
  Tenant? _selected;

  /// The tenant whose PIN actually verified.
  Tenant? _verified;

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(hotelStaffProvider);

    return ColoredBox(
      color: HotelTokens.bg,
      child: staffAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load staff')),
        data: (staff) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const HotelDeskBrand(),
              const SizedBox(height: 14),
              Text(
                'FRONT DESK · SHARED REGISTER',
                style: GoogleFonts.outfit(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: HotelTokens.ink4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Who's on the desk?",
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 18),
              BarMobilePeopleStrip(
                staff: staff,
                selected: _selected,
                onSelect: (p) => setState(() {
                  _selected = p;
                  _verified = null;
                }),
              ),
              const SizedBox(height: 20),
              BarKeypad(
                mobile: true,
                enabled: _selected != null,
                title: _selected?.name ?? '—',
                hint: _selected == null
                    ? 'Tap your name above, then enter your PIN'
                    : 'Enter your 6-digit PIN to open the desk',
                avatarLabel: _selected == null
                    ? null
                    : hotelClerkInitials(_selected!.name),
                avatarColor: _selected == null ? null : HotelTokens.occupiedInk,
                // Captured at verification time, not re-read here: the
                // people strip stays tappable while the PIN check awaits, so
                // a valid PIN could otherwise sign in a different tenant.
                verifyPin: (pin) async {
                  final selected = _selected;
                  if (selected == null) return false;
                  final ok = await barVerifyStaffPin(selected, pin);
                  _verified = ok ? selected : null;
                  return ok;
                },
                onSubmit: (_) {
                  final verified = _verified;
                  if (verified != null) {
                    ref.read(hotelModeProvider.notifier).login(verified);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.settings_outlined,
                    size: 13,
                    color: HotelTokens.ink4,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Hotel mode configured by admin on the main terminal',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        color: HotelTokens.ink4,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
