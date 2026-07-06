import 'package:flutter/material.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

class BarLockScreen extends ConsumerStatefulWidget {
  const BarLockScreen({super.key});

  @override
  ConsumerState<BarLockScreen> createState() => _BarLockScreenState();
}

class _BarLockScreenState extends ConsumerState<BarLockScreen> {
  Tenant? _selected;

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(barStaffProvider);

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
                'Bar mode · Shared register',
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
                          error: (_, __) => const Text('Could not load staff'),
                          data: (allStaff) => _peoplePane(allStaff),
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
                              : 'Enter your 6-digit PIN to log orders',
                          avatarLabel: _selected == null
                              ? null
                              : barTenantInitials(_selected!.name),
                          avatarColor: _selected == null
                              ? null
                              : barColorForTenant(
                                  _selected!.id,
                                  staffAsync.value ?? [],
                                ),
                          verifyPin: (pin) async {
                            final selected = _selected;
                            if (selected == null) return false;
                            return barVerifyStaffPin(selected, pin);
                          },
                          onSubmit: (_) {
                            if (_selected != null) {
                              ref
                                  .read(barModeProvider.notifier)
                                  .login(_selected!);
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
          'WHO\'S ON THE REGISTER?',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: BarTokens.ink4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Who\'s on the register?',
          style: GoogleFonts.outfit(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: BarTokens.ink1,
          ),
        ),
        const SizedBox(height: 18),
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
                  onTap: () => setState(() => _selected = person),
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
                                person.name ?? 'Staff',
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
