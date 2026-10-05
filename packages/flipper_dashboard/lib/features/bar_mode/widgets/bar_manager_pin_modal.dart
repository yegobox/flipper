import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

class BarManagerPinModal extends ConsumerWidget {
  const BarManagerPinModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(barStaffProvider).value ?? [];
    final managers = staff.where(barTenantIsManager).toList();
    final l10n = context.flipperL10n;
    final isMobile = BarLayoutBreakpoints.isBarMobileLayout(
      MediaQuery.sizeOf(context).width,
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
              color: BarTokens.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(BarTokens.mobileSheetRadius),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: BarTokens.lineStrong,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    color: BarTokens.violetTint,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: BarTokens.violet,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.hotelManagerApproval,
                  style: GoogleFonts.outfit(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  l10n.barSettleNeedsManagerPin,
                  style: GoogleFonts.outfit(
                    color: BarTokens.ink3,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 18),
                BarKeypad(
                  tight: true,
                  title: l10n.hotelManager,
                  hint: l10n.hotelEnterManagerPin,
                  verifyPin: (pin) async {
                    for (final m in managers) {
                      if (await barVerifyStaffPin(m, pin)) return true;
                    }
                    return false;
                  },
                  errorText: l10n.hotelNotManagerPin,
                  onSubmit: (pin) async {
                    Tenant? manager;
                    for (final m in managers) {
                      if (await barVerifyStaffPin(m, pin)) {
                        manager = m;
                        break;
                      }
                    }
                    if (manager != null) {
                      ref
                          .read(barModeProvider.notifier)
                          .elevateManager(manager);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () =>
                      ref.read(barModeProvider.notifier).hideManagerPin(),
                  child: Text(l10n.cancel),
                ),
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
            color: BarTokens.surface,
            borderRadius: BorderRadius.circular(BarTokens.radiusXl),
            boxShadow: BarTokens.shadow3,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: BarTokens.violetTint,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: BarTokens.violet,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.hotelManagerApproval,
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                l10n.barSettleNeedsManagerPin,
                style: GoogleFonts.outfit(color: BarTokens.ink3),
              ),
              const SizedBox(height: 20),
              BarKeypad(
                tight: true,
                title: l10n.hotelManager,
                hint: l10n.hotelEnterManagerPin,
                verifyPin: (pin) async {
                  for (final m in managers) {
                    if (await barVerifyStaffPin(m, pin)) return true;
                  }
                  return false;
                },
                errorText: l10n.hotelNotManagerPin,
                onSubmit: (pin) async {
                  Tenant? manager;
                  for (final m in managers) {
                    if (await barVerifyStaffPin(m, pin)) {
                      manager = m;
                      break;
                    }
                  }
                  if (manager != null) {
                    ref.read(barModeProvider.notifier).elevateManager(manager);
                  }
                },
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () =>
                    ref.read(barModeProvider.notifier).hideManagerPin(),
                child: Text(l10n.cancel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
