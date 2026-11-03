import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_people_strip.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_shell.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_dashboard/features/service_mode_shell.dart';
import 'package:flipper_localize/flipper_localize.dart';
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

  /// The tenant whose PIN actually verified.
  Tenant? _verified;

  /// Re-reads the roster and the grants: a phone that opened the desk
  /// offline fell back to "open to all" and should pick up the real ones.
  Future<void> _reloadStaff() async {
    ref.invalidate(serviceModeGrantsProvider);
    ref.invalidate(barStaffProvider);
    try {
      await ref.read(barSignInStaffProvider.future);
    } catch (_) {
      // The error state offers Retry again.
    }
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(barSignInStaffProvider);
    final l10n = context.flipperL10n;

    return BarMobileShell(
      backgroundColor: BarTokens.bg,
      body: staffAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.barCouldNotLoadStaff),
              TextButton(onPressed: _reloadStaff, child: Text(l10n.retry)),
              const ServiceModeCloseButton(color: BarTokens.ink3),
            ],
          ),
        ),
        data: (staff) => _picker(staff),
      ),
    );
  }

  Widget _picker(List<Tenant> staff) {
    final l10n = context.flipperL10n;
    // Dropped once a refresh removes them from the roster.
    final selected = barPickInRoster(_selected, staff);
    return RefreshIndicator(
      onRefresh: _reloadStaff,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.centerRight,
              child: ServiceModeCloseButton(color: BarTokens.ink3),
            ),
            const SizedBox(height: 8),
            const BarFlipperBrand(),
            const SizedBox(height: 14),
            Text(
              l10n.barModeSharedRegister.toUpperCase(),
              style: GoogleFonts.outfit(
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
                color: BarTokens.ink4,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              l10n.barWhosServing,
              style: GoogleFonts.outfit(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(height: 18),
            BarMobilePeopleStrip(
              staff: staff,
              selected: selected,
              onSelect: (p) => setState(() {
                _selected = p;
                _verified = null;
              }),
            ),
            const SizedBox(height: 20),
            BarKeypad(
              mobile: true,
              enabled: selected != null,
              title: selected?.name ?? '—',
              hint: selected == null
                  ? l10n.barLockHintTapAbove
                  : l10n.barLockHintEnterPin,
              avatarLabel: selected == null
                  ? null
                  : barTenantInitials(selected.name),
              avatarColor: selected == null
                  ? null
                  : barColorForTenant(selected.id, staff),
              // Checked against the roster as it is now, not the tenant
              // captured at the tap: a refresh may have removed them or
              // changed their PIN. Captured at verification time, so a
              // tap on someone else while the check awaits signs in nobody
              // but the one who verified.
              verifyPin: (pin) async {
                final current = barPickInRoster(
                  _selected,
                  ref.read(barSignInStaffProvider).value,
                );
                _verified = null;
                if (current == null) return false;
                final ok = await barVerifyStaffPin(current, pin);
                _verified = ok ? current : null;
                return ok;
              },
              onSubmit: (_) {
                final verified = _verified;
                if (verified != null) {
                  ref.read(barModeProvider.notifier).login(verified);
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
                    l10n.barConfiguredByAdmin,
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
    );
  }
}
