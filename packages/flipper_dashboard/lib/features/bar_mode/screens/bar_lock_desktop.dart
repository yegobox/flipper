import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_people_strip.dart'
    show barPickInRoster;
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

class BarLockDesktopScreen extends ConsumerStatefulWidget {
  const BarLockDesktopScreen({super.key});

  @override
  ConsumerState<BarLockDesktopScreen> createState() =>
      _BarLockDesktopScreenState();
}

class _BarLockDesktopScreenState extends ConsumerState<BarLockDesktopScreen> {
  Tenant? _selected;

  /// Who passed the PIN check, captured at verification time.
  Tenant? _verified;

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(barSignInStaffProvider);
    final l10n = context.flipperL10n;
    // Dropped once a refresh removes them from the roster.
    final selected = barPickInRoster(_selected, staffAsync.value);

    return Container(
      color: BarTokens.bg,
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 34),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const BarFlipperBrand(),
              Text(
                l10n.barModeSharedRegister,
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: BarTokens.ink3,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 860,
                decoration: BoxDecoration(
                  color: BarTokens.surface,
                  borderRadius: BorderRadius.circular(BarTokens.radiusXl),
                  border: Border.all(color: BarTokens.line),
                  boxShadow: BarTokens.shadow3,
                ),
                clipBehavior: Clip.antiAlias,
                child: Row(
                  children: [
                    SizedBox(
                      width: 320,
                      child: Container(
                        color: BarTokens.surface2,
                        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                        child: staffAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (_, __) => Text(l10n.barCouldNotLoadStaff),
                          data: (allStaff) => _peoplePane(allStaff),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: BarKeypad(
                          enabled: selected != null,
                          title: selected?.name ?? '—',
                          hint: selected == null
                              ? l10n.barLockHintTapLeft
                              : l10n.barLockHintEnterPin,
                          avatarLabel: selected == null
                              ? null
                              : barTenantInitials(selected.name),
                          avatarColor: selected == null
                              ? null
                              : barColorForTenant(
                                  selected.id,
                                  staffAsync.value ?? [],
                                ),
                          // Checked against the roster as it is now, not the
                          // tenant captured at the tap: a refresh may have
                          // removed them or changed their PIN. Signed in from
                          // that check, so a tap on someone else while it
                          // awaits signs in nobody but the one who verified.
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
                            // Still on the roster: it may have refreshed
                            // while the PIN check awaited.
                            final verified = barPickInRoster(
                              _verified,
                              ref.read(barSignInStaffProvider).value,
                            );
                            if (verified != null) {
                              ref
                                  .read(barModeProvider.notifier)
                                  .login(verified);
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
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.barWhosOnRegister.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: BarTokens.ink4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.barWhosOnRegister,
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: BarTokens.ink1,
          ),
        ),
        const SizedBox(height: 18),
        if (staff.isEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.barLockNoStaff,
                style: GoogleFonts.outfit(fontSize: 13, color: BarTokens.ink3),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Grants too: a desk that started offline fell back to
                  // "open to all" and should pick up the real ones.
                  ref.invalidate(serviceModeGrantsProvider);
                  ref.invalidate(barStaffProvider);
                },
                child: Text(l10n.retry),
              ),
            ],
          ),
        Expanded(
          child: ListView.separated(
            itemCount: staff.length,
            separatorBuilder: (_, __) => const SizedBox(height: 9),
            itemBuilder: (context, i) {
              final person = staff[i];
              final selected = _selected?.id == person.id;
              final color = barColorForTenant(person.id, staff);
              return Material(
                color: selected ? BarTokens.blueTint : BarTokens.surface,
                borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                child: InkWell(
                  onTap: () => setState(() {
                    _selected = person;
                    _verified = null;
                  }),
                  borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(BarTokens.radiusMd),
                      border: Border.all(
                        color: selected ? BarTokens.blue : BarTokens.line,
                        width: 1.5,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: BarTokens.blue.withValues(alpha: 0.1),
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
                            color: color,
                            borderRadius: BorderRadius.circular(13),
                          ),
                          child: Text(
                            barTenantInitials(person.name),
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
                                person.name ?? l10n.barStaffFallback,
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
                                      color: BarTokens.ink3,
                                    ),
                                  ),
                                  if (barTenantIsManager(person)) ...[
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
            },
          ),
        ),
      ],
    );
  }
}
