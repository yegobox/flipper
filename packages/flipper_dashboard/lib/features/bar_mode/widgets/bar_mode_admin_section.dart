import 'package:flutter/material.dart';
import 'package:flipper_dashboard/TenantManagement.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/view_models/flipperBaseModel.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

/// Service Mode (Bar Mode) section for [AdminControl].
class BarModeAdminSection extends StatefulWidget {
  const BarModeAdminSection({super.key});

  @override
  State<BarModeAdminSection> createState() => _BarModeAdminSectionState();
}

class _BarModeAdminSectionState extends State<BarModeAdminSection> {
  late bool _enabled;
  late bool _requirePin;
  late bool _floorFirst;
  late bool _managerSettle;
  late bool _autoLogout;
  List<Tenant> _staff = const [];

  @override
  void initState() {
    super.initState();
    _enabled = BarModeSettings.enabled;
    _requirePin = BarModeSettings.requirePin;
    _floorFirst = BarModeSettings.floorFirst;
    _managerSettle = BarModeSettings.managerSettle;
    _autoLogout = BarModeSettings.autoLogout;
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staff = await FlipperBaseModel.fetchBarStaffTenants();
    if (!mounted) return;
    setState(() => _staff = staff);
  }

  Future<void> _onMasterToggle(bool value) async {
    setState(() => _enabled = value);
    BarModeSettings.setEnabled(value);
    if (value) {
      final branchId = ProxyService.box.getBranchId();
      if (branchId != null) {
        await ProxyService.getStrategy(Strategy.capella)
            .seedDefaultFloorPlan(branchId: branchId);
      }
    }
  }

  void _openUserManagement() {
    showDialog(
      context: context,
      builder: (_) => const TenantManagement(),
    ).then((_) => _loadStaff());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BarAdminEyebrow(label: 'Service Mode'),
        _heroCard(),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: BarCard(
              child: Column(
                children: [
                  BarSubRow(
                    showTopBorder: false,
                    icon: Icons.lock_outline,
                    title: 'Require PIN to switch cashier',
                    subtitle:
                        'Each cashier logs in with their 6-digit PIN before adding to a tab.',
                    value: _requirePin,
                    onChanged: (v) {
                      setState(() => _requirePin = v);
                      BarModeSettings.setRequirePin(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.grid_view_rounded,
                    title: 'Open the table floor on login',
                    subtitle:
                        'After PIN login, land on the table floor instead of a single cart.',
                    value: _floorFirst,
                    onChanged: (v) {
                      setState(() => _floorFirst = v);
                      BarModeSettings.setFloorFirst(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.shield_outlined,
                    title: 'Manager PIN required to settle',
                    subtitle:
                        'Only a manager PIN can take payment and close a table.',
                    value: _managerSettle,
                    onChanged: (v) {
                      setState(() => _managerSettle = v);
                      BarModeSettings.setManagerSettle(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.logout,
                    title: 'Auto-logout after saving to a tab',
                    subtitle: 'Return to the PIN lock after Save to tab.',
                    value: _autoLogout,
                    onChanged: (v) {
                      setState(() => _autoLogout = v);
                      BarModeSettings.setAutoLogout(v);
                    },
                  ),
                ],
              ),
            ),
          ),
          crossFadeState:
              _enabled ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
        ),
        const SizedBox(height: 22),
        const BarAdminEyebrow(label: 'Staff & PINs', accent: BarTokens.violet),
        if (_staff.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'No staff yet. Add users in User Management — they appear here with their PINs.',
              style: GoogleFonts.outfit(fontSize: 13, color: BarTokens.ink3),
            ),
          )
        else
          BarCard(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                for (var i = 0; i < _staff.length; i++)
                  BarStaffRow(
                    tenant: _staff[i],
                    color: barColorForTenant(_staff[i].id, _staff),
                    showTopBorder: i > 0,
                    onEdit: _openUserManagement,
                  ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.fromLTRB(0, 16, 0, 2),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0x00F0F2F5),
                BarTokens.adminPageBg,
              ],
              stops: [0.0, 0.4],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BarGhostButton(
                label: 'Cancel',
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 12),
              BarPrimaryButton(
                label: 'Open POS with Bar Mode',
                onPressed: _enabled
                    ? () {
                        BarModeSettings.setLaunchOnStart(true);
                        locator<RouterService>().navigateTo(BarModeRoute());
                      }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heroCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 22),
      decoration: BoxDecoration(
        color: BarTokens.surface,
        borderRadius: BorderRadius.circular(BarTokens.radiusLg),
        border: Border.all(
          color: _enabled ? BarTokens.blue : BarTokens.line,
          width: 1.5,
        ),
        boxShadow: _enabled
            ? [
                BoxShadow(
                  color: BarTokens.blue.withValues(alpha: 0.08),
                  blurRadius: 0,
                  spreadRadius: 3,
                ),
              ]
            : BarTokens.shadow1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: _enabled ? BarTokens.blue : BarTokens.blueTint,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.storefront_outlined,
              color: _enabled ? Colors.white : BarTokens.blue,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Table Service (Bar Mode)',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          letterSpacing: -0.18,
                          color: BarTokens.ink1,
                        ),
                      ),
                    ),
                    if (_enabled) ...[
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: BarTokens.winTint,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'ON',
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                            color: BarTokens.win,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Turns the register into a shared bar terminal: staff keep a running tab per table, log rounds under their own PIN, and hand off between cashiers without losing the bill. Leave off for standard retail checkout.',
                  style: GoogleFonts.outfit(
                    fontSize: 13.5,
                    color: BarTokens.ink2,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          BarToggle(value: _enabled, onChanged: _onMasterToggle),
        ],
      ),
    );
  }
}
