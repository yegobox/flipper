import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_people_strip.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_shell.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

class BarLockMobileScreen extends ConsumerStatefulWidget {
  const BarLockMobileScreen({super.key});

  @override
  ConsumerState<BarLockMobileScreen> createState() =>
      _BarLockMobileScreenState();
}

class _BarLockMobileScreenState extends ConsumerState<BarLockMobileScreen> {
  Tenant? _selected;

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(barStaffProvider);

    return BarMobileShell(
      backgroundColor: BarTokens.bg,
      body: staffAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text('Could not load staff')),
        data: (staff) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const BarFlipperBrand(),
              const SizedBox(height: 14),
              Text(
                'BAR MODE · SHARED REGISTER',
                style: GoogleFonts.outfit(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: BarTokens.ink4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                "Who's serving?",
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
                onSelect: (p) => setState(() => _selected = p),
              ),
              const SizedBox(height: 20),
              BarKeypad(
                mobile: true,
                enabled: _selected != null,
                title: _selected?.name ?? '—',
                hint: _selected == null
                    ? 'Tap your name above, then enter your PIN'
                    : 'Enter your 6-digit PIN to log orders',
                avatarLabel: _selected == null
                    ? null
                    : barTenantInitials(_selected!.name),
                avatarColor: _selected == null
                    ? null
                    : barColorForTenant(_selected!.id, staff),
                verifyPin: (pin) async {
                  final selected = _selected;
                  if (selected == null) return false;
                  return barVerifyStaffPin(selected, pin);
                },
                onSubmit: (_) {
                  if (_selected != null) {
                    ref.read(barModeProvider.notifier).login(_selected!);
                  }
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.settings_outlined, size: 13, color: BarTokens.ink4),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Bar mode configured by admin on the main terminal',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontSize: 11.5,
                        color: BarTokens.ink4,
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
