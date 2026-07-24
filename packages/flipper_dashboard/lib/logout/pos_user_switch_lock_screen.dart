import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_layout_breakpoints.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_keypad.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_mobile_people_strip.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_shared_widgets.dart';
import 'package:flipper_dashboard/logout/pos_switch_user_dialog.dart';
import 'package:flipper_dashboard/logout/pos_user_switch.dart';
import 'package:flipper_dashboard/logout/pos_user_switch_lock_provider.dart';
import 'package:flipper_models/sync/utils/bar_mode_utils.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Full-area lock that replaces the dashboard until a staff member enters PIN.
/// Layout matches [BarLockDesktopScreen] / [BarLockMobileScreen].
class PosUserSwitchLockScreen extends ConsumerStatefulWidget {
  const PosUserSwitchLockScreen({super.key});

  @override
  ConsumerState<PosUserSwitchLockScreen> createState() =>
      _PosUserSwitchLockScreenState();
}

class _PosUserSwitchLockScreenState
    extends ConsumerState<PosUserSwitchLockScreen> {
  Tenant? _selected;
  bool _busy = false;
  bool _refreshing = false;

  Future<void> _refreshStaff() async {
    if (_busy || _refreshing) return;
    setState(() => _refreshing = true);
    try {
      final staff = await ref.refresh(barStaffProvider.future);
      if (!mounted) return;
      final selected = _selected;
      if (selected != null && !staff.any((t) => t.id == selected.id)) {
        setState(() => _selected = null);
      }
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _onPinSubmit(String pin) async {
    final selected = _selected;
    if (selected == null || _busy) return;

    setState(() => _busy = true);
    final dialogService = locator<DialogService>();
    final ok = await completePosUserSwitchAfterPin(
      context: context,
      ref: ref,
      dialogService: dialogService,
      selection: PosSwitchUserSelection(tenant: selected, pin: pin),
    );
    if (!mounted) return;
    if (!ok) {
      setState(() => _busy = false);
      return;
    }
    ref.read(posUserSwitchLockProvider.notifier).state = false;
  }

  Widget _staffLoadError() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Could not load staff',
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: BarTokens.ink3,
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: _refreshing ? null : _refreshStaff,
            icon: _refreshing
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh, size: 18),
            label: Text(
              'Retry',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _refreshIconButton({Color? color}) {
    return IconButton(
      tooltip: 'Refresh staff list',
      onPressed: (_busy || _refreshing) ? null : _refreshStaff,
      icon: _refreshing
          ? SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: color ?? BarTokens.ink3,
              ),
            )
          : Icon(Icons.refresh, size: 20, color: color ?? BarTokens.ink3),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = BarLayoutBreakpoints.isBarMobileLayout(width);

    return isMobile ? _buildMobile() : _buildDesktop();
  }

  Widget _buildDesktop() {
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
                'POS · Shared register',
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
              child: SizedBox(
                width: 860,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: BarTokens.surface,
                        borderRadius:
                            BorderRadius.circular(BarTokens.radiusXl),
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
                              padding:
                                  const EdgeInsets.fromLTRB(22, 26, 22, 26),
                              child: staffAsync.when(
                                skipLoadingOnReload: true,
                                loading: () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                error: (_, __) => _staffLoadError(),
                                data: (allStaff) {
                                  if (allStaff.isEmpty) {
                                    return Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: _refreshIconButton(),
                                        ),
                                        const Expanded(
                                          child: Center(
                                            child: Text(
                                              'No staff members available.',
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                  return _peoplePane(allStaff);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(30),
                              child: AbsorbPointer(
                                absorbing: _busy,
                                child: BarKeypad(
                                  enabled: _selected != null && !_busy,
                                  title: _selected?.name ?? '—',
                                  hint: _selected == null
                                      ? 'Tap your name on the left, then enter your PIN'
                                      : 'Enter your 6-digit PIN to open POS',
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
                                  onSubmit: _onPinSubmit,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (_busy)
                      Positioned.fill(
                        child: _BusyOverlay(
                          name: _selected?.name,
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

  Widget _buildMobile() {
    final staffAsync = ref.watch(barStaffProvider);

    return Container(
      color: BarTokens.bg,
      child: SafeArea(
        child: Stack(
          children: [
            staffAsync.when(
              skipLoadingOnReload: true,
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (_, __) => _staffLoadError(),
              data: (staff) => RefreshIndicator(
                color: BarTokens.blue,
                onRefresh: _refreshStaff,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: AbsorbPointer(
                    absorbing: _busy,
                    child: Column(
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Expanded(child: BarFlipperBrand()),
                            _refreshIconButton(),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'POS · SHARED REGISTER',
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
                        if (staff.isEmpty)
                          const Padding(
                            padding: EdgeInsets.all(24),
                            child: Text('No staff members available.'),
                          )
                        else ...[
                          BarMobilePeopleStrip(
                            staff: staff,
                            selected: _selected,
                            onSelect: (p) => setState(() => _selected = p),
                          ),
                          const SizedBox(height: 20),
                          BarKeypad(
                            mobile: true,
                            enabled: _selected != null && !_busy,
                            title: _selected?.name ?? '—',
                            hint: _selected == null
                                ? 'Tap your name above, then enter your PIN'
                                : 'Enter your 6-digit PIN to open POS',
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
                            onSubmit: _onPinSubmit,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (_busy)
              Positioned.fill(
                child: _BusyOverlay(name: _selected?.name),
              ),
          ],
        ),
      ),
    );
  }

  Widget _peoplePane(List<Tenant> staff) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
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
                ],
              ),
            ),
            _refreshIconButton(),
          ],
        ),
        const SizedBox(height: 18),
        Expanded(
          child: RefreshIndicator(
            color: BarTokens.blue,
            onRefresh: _refreshStaff,
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
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
                  onTap: _busy
                      ? null
                      : () => setState(() => _selected = person),
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
        ),
      ],
    );
  }
}

/// Soft in-card status while login finishes — no AlertDialog.
class _BusyOverlay extends StatelessWidget {
  const _BusyOverlay({this.name});

  final String? name;

  @override
  Widget build(BuildContext context) {
    final label = (name != null && name!.trim().isNotEmpty)
        ? 'Opening POS for ${name!.trim()}…'
        : 'Opening POS…';

    return ClipRRect(
      borderRadius: BorderRadius.circular(BarTokens.radiusXl),
      child: ColoredBox(
        color: BarTokens.surface.withValues(alpha: 0.82),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: BarTokens.blue,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: BarTokens.ink1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Replaces [child] (entire dashboard shell) with [PosUserSwitchLockScreen]
/// while the lock is on — sidebar and top bar are hidden, same as Bar Mode.
class PosUserSwitchGate extends ConsumerWidget {
  const PosUserSwitchGate({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locked = ref.watch(posUserSwitchLockProvider);
    if (locked) {
      return const SizedBox.expand(child: PosUserSwitchLockScreen());
    }
    return child;
  }
}
