import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_people_strip.dart';
import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Result of a successful staff + PIN selection in [PosSwitchUserDialog].
class PosSwitchUserSelection {
  const PosSwitchUserSelection({
    required this.tenant,
    required this.pin,
  });

  final Tenant tenant;
  final String pin;
}

/// Staff picker + 6-digit PIN dialog for POS full-session user switch.
class PosSwitchUserDialog extends ConsumerStatefulWidget {
  const PosSwitchUserDialog({super.key});

  static Future<PosSwitchUserSelection?> show(BuildContext context) {
    return showDialog<PosSwitchUserSelection>(
      context: context,
      barrierColor: const Color(0x66101828),
      builder: (_) => const PosSwitchUserDialog(),
    );
  }

  @override
  ConsumerState<PosSwitchUserDialog> createState() =>
      _PosSwitchUserDialogState();
}

class _PosSwitchUserDialogState extends ConsumerState<PosSwitchUserDialog> {
  Tenant? _selected;

  List<Tenant> _filterStaff(List<Tenant> all) {
    final currentUserId = ProxyService.box.getUserId();
    if (currentUserId == null || currentUserId.isEmpty) return all;
    return all
        .where((t) => (t.userId ?? '').trim() != currentUserId)
        .toList(growable: false);
  }

  void _complete(String pin) {
    final selected = _selected;
    if (selected == null) return;
    Navigator.of(context).pop(
      PosSwitchUserSelection(tenant: selected, pin: pin),
    );
  }

  @override
  Widget build(BuildContext context) {
    final staffAsync = ref.watch(barStaffProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < PosLayoutBreakpoints.mobileLayoutMaxWidth ||
        width < 720;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 28,
        vertical: isMobile ? 24 : 32,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Material(
        color: PosTokens.surface,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isMobile ? 420 : 860,
            maxHeight: isMobile ? 720 : 640,
            minHeight: isMobile ? 520 : 560,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(context),
              Expanded(
                child: staffAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Could not load staff'),
                    ),
                  ),
                  data: (allStaff) {
                    final staff = _filterStaff(allStaff);
                    if (staff.isEmpty) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                            'No other staff members available to switch to.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return isMobile
                        ? _mobileBody(staff)
                        : _desktopBody(staff);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Switch User',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.ink1,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Select a staff member and enter their PIN',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: PosTokens.ink3,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            style: IconButton.styleFrom(
              backgroundColor: PosTokens.surface2,
              foregroundColor: PosTokens.ink3,
              minimumSize: const Size(36, 36),
              shape: const CircleBorder(),
            ),
            icon: const Icon(Icons.close_rounded, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _desktopBody(List<Tenant> staff) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 300,
          child: Container(
            color: PosTokens.surface2,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: _peoplePane(staff),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Center(
                      child: BarKeypad(
                        tight: true,
                        enabled: _selected != null,
                        title: _selected?.name ?? '—',
                        hint: _selected == null
                            ? 'Tap a name on the left, then enter their PIN'
                            : 'Enter the 6-digit PIN to switch',
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
                        onSubmit: _complete,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _mobileBody(List<Tenant> staff) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          BarMobilePeopleStrip(
            staff: staff,
            selected: _selected,
            onSelect: (p) => setState(() => _selected = p),
          ),
          const SizedBox(height: 16),
          BarKeypad(
            mobile: true,
            enabled: _selected != null,
            title: _selected?.name ?? '—',
            hint: _selected == null
                ? 'Tap a name above, then enter their PIN'
                : 'Enter the 6-digit PIN to switch',
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
            onSubmit: _complete,
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
          'WHO\'S NEXT?',
          style: GoogleFonts.outfit(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
            color: PosTokens.ink4,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select staff',
          style: GoogleFonts.outfit(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: PosTokens.ink1,
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: ListView.separated(
            itemCount: staff.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final person = staff[i];
              final selected = _selected?.id == person.id;
              final color = barColorForTenant(person.id, staff);
              return Material(
                color: selected ? PosTokens.blueTint : PosTokens.surface,
                borderRadius: BorderRadius.circular(PosTokens.radiusSm),
                child: InkWell(
                  onTap: () => setState(() => _selected = person),
                  borderRadius: BorderRadius.circular(PosTokens.radiusSm),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(PosTokens.radiusSm),
                      border: Border.all(
                        color: selected ? PosTokens.blue : PosTokens.line,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            barTenantInitials(person.name),
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                person.name ?? 'Staff',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: PosTokens.ink1,
                                ),
                              ),
                              Text(
                                BarStaffRow.roleLabel(person),
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: PosTokens.ink3,
                                ),
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
