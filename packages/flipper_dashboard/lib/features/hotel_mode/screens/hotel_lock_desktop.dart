import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/hotel_mode/providers/hotel_mode_providers.dart';
import 'package:flipper_dashboard/features/hotel_mode/theme/hotel_tokens.dart';
import 'package:flipper_dashboard/features/hotel_mode/widgets/hotel_shared_widgets.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_models/sync/utils/hotel_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Shared-register lock for the front desk: pick your name, enter your PIN.
///
/// Reuses [BarKeypad] and the staff PIN verification path so a hotel and a bar
/// on the same business behave identically at the register.
class HotelLockDesktopScreen extends ConsumerStatefulWidget {
  const HotelLockDesktopScreen({super.key});

  @override
  ConsumerState<HotelLockDesktopScreen> createState() =>
      _HotelLockDesktopScreenState();
}

class _HotelLockDesktopScreenState
    extends ConsumerState<HotelLockDesktopScreen> {
  Tenant? _selected;

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(hotelStaffProvider);

    return Container(
      color: HotelTokens.bg,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 34),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const HotelDeskBrand(),
              Text(
                'Front desk · Shared register',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: HotelTokens.ink3,
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 860,
                decoration: BoxDecoration(
                  color: HotelTokens.surface,
                  borderRadius: BorderRadius.circular(HotelTokens.radiusXl),
                  border: Border.all(color: HotelTokens.line),
                  boxShadow: HotelTokens.shadow2,
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: Container(
                        color: HotelTokens.surface2,
                        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                        child: staffAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) => const Text('Could not load staff'),
                          data: _peoplePane,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: BarKeypad(
                          enabled: _selected != null,
                          title: _selected?.name ?? '—',
                          hint: _selected == null
                              ? 'Tap your name on the left, then enter your PIN'
                              : 'Enter your 6-digit PIN to open the desk',
                          avatarLabel: _selected == null
                              ? null
                              : hotelClerkInitials(_selected!.name),
                          avatarColor: _selected == null
                              ? null
                              : HotelTokens.occupiedInk,
                          verifyPin: (pin) async {
                            final selected = _selected;
                            if (selected == null) return false;
                            return barVerifyStaffPin(selected, pin);
                          },
                          onSubmit: (_) {
                            final selected = _selected;
                            if (selected != null) {
                              ref
                                  .read(hotelModeProvider.notifier)
                                  .login(selected);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _peoplePane(List<Tenant> staff) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "WHO'S ON THE DESK?",
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: HotelTokens.ink4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Sign in to reception',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: HotelTokens.ink1,
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: staff.isEmpty
              ? Text(
                  'No staff yet. Add users in User Management — they appear '
                  'here with their PINs.',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: HotelTokens.ink3,
                  ),
                )
              : ListView.separated(
                  itemCount: staff.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 9),
                  itemBuilder: (context, i) => _personTile(staff[i]),
                ),
        ),
      ],
    );
  }

  Widget _personTile(Tenant person) {
    final selected = _selected?.id == person.id;

    return Material(
      color: selected ? HotelTokens.blueTint : HotelTokens.surface,
      borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
      child: InkWell(
        onTap: () => setState(() => _selected = person),
        borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(HotelTokens.radiusMd),
            border: Border.all(
              color: selected ? HotelTokens.blue : HotelTokens.line,
              width: 1.5,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: HotelTokens.blue.withValues(alpha: 0.1),
                      spreadRadius: 3,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: HotelTokens.occupiedInk,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Text(
                  hotelClerkInitials(person.name),
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person.name ?? 'Staff',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          BarStaffRow.roleLabel(person),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: HotelTokens.ink3,
                          ),
                        ),
                        if (hotelTenantIsManager(person)) ...[
                          const SizedBox(width: 5),
                          const BarManagerTag(),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
