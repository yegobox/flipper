import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

class BarManagerPinModal extends ConsumerWidget {
  const BarManagerPinModal({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final staff = ref.watch(barStaffProvider).value ?? [];
    final managers = staff.where(barTenantIsManager).toList();

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
                child: const Icon(Icons.shield_outlined, color: BarTokens.violet),
              ),
              const SizedBox(height: 12),
              Text(
                'Manager approval',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Settling a bill needs a manager PIN.',
                style: GoogleFonts.outfit(color: BarTokens.ink3),
              ),
              const SizedBox(height: 20),
              BarKeypad(
                tight: true,
                title: 'Manager',
                hint: 'Enter manager 6-digit PIN',
                verifyPin: (pin) async {
                  for (final m in managers) {
                    if (await barVerifyStaffPin(m, pin)) return true;
                  }
                  return false;
                },
                errorText: 'Not a manager PIN',
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
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
