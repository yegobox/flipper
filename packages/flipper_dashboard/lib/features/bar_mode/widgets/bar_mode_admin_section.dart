import 'package:flutter/material.dart';
import 'package:flipper_models/helpers/tenant_supabase_queries.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flipper_dashboard/TenantManagement.dart';
import 'package:flipper_dashboard/features/bar_mode/bar_mode_settings.dart';
import 'package:flipper_dashboard/features/bar_mode/providers/bar_mode_providers.dart';
import 'package:flipper_dashboard/features/bar_mode/theme/bar_tokens.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_admin_widgets.dart';
import 'package:flipper_dashboard/features/bar_mode/widgets/bar_floor_plan_editor.dart';
import 'package:flipper_dashboard/features/hotel_mode/hotel_mode_settings.dart';
import 'package:flipper_dashboard/features/service_mode_hotkey.dart';
import 'package:flipper_dashboard/features/service_mode_switch.dart';
import 'package:flipper_localize/flipper_localize.dart';
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
  bool _enabled = false;
  bool _requirePin = true;
  bool _floorFirst = true;
  bool _managerSettle = true;
  bool _autoLogout = false;
  List<Tenant> _staff = const [];
  String? _deletingStaffKey;

  @override
  void initState() {
    super.initState();
    serviceModeRevision.addListener(_onServiceModeChanged);
    _syncFromLocalCache();
    _loadSettings();
    _loadStaff();
  }

  @override
  void dispose() {
    serviceModeRevision.removeListener(_onServiceModeChanged);
    super.dispose();
  }

  /// The sibling Hotel section may have just turned Bar Mode off.
  void _onServiceModeChanged() {
    if (mounted) setState(_syncFromLocalCache);
  }

  void _syncFromLocalCache() {
    _enabled = BarModeSettings.enabled;
    _requirePin = BarModeSettings.requirePin;
    _floorFirst = BarModeSettings.floorFirst;
    _managerSettle = BarModeSettings.managerSettle;
    _autoLogout = BarModeSettings.autoLogout;
  }

  Future<void> _loadSettings() async {
    await BarModeSettings.hydrateForActiveBranch();
    if (!mounted) return;
    setState(_syncFromLocalCache);
    BarModeSettings.startWatchingActiveBranch();
  }

  Future<void> _loadStaff() async {
    final staff = await FlipperBaseModel.fetchBarStaffTenants();
    if (!mounted) return;
    setState(() => _staff = List<Tenant>.from(staff));
  }

  void _removeStaffFromList(Tenant tenant) {
    setState(() {
      _staff = _staff
          .where((row) => !barStaffRowMatchesDeleted(row, tenant))
          .toList();
    });
  }

  Future<void> _confirmDeleteStaff(Tenant tenant) async {
    if (_deletingStaffKey != null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(dialogContext.flipperL10n.barRemoveStaffTitle),
          content: Text(
            dialogContext.flipperL10n.barRemoveStaffBody(
              tenant.name ?? dialogContext.flipperL10n.barThisStaffMember,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(dialogContext.flipperL10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(dialogContext.flipperL10n.delete),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;

    final deleteKey = barStaffDeleteKey(tenant);
    setState(() => _deletingStaffKey = deleteKey);
    try {
      await TenantSupabaseQueries.removeStaffFromBusiness(tenant: tenant);
      if (!mounted) return;
      _removeStaffFromList(tenant);
      await _loadStaff();
      if (!mounted) return;
      showCustomSnackBarUtil(context, context.flipperL10n.barStaffRemoved);
    } catch (_) {
      if (!mounted) return;
      showCustomSnackBarUtil(
        context,
        context.flipperL10n.barStaffRemoveFailed,
        backgroundColor: Colors.red.shade600,
      );
    } finally {
      if (mounted && _deletingStaffKey == deleteKey) {
        setState(() => _deletingStaffKey = null);
      }
    }
  }

  Future<void> _onMasterToggle(bool value) async {
    setState(() => _enabled = value);
    BarModeSettings.setEnabled(value);
    notifyServiceModeChanged();
    if (value) {
      // A property can offer both. Which surface a given terminal shows is a
      // device choice, so turning the bar on no longer shuts the desk down.
      if (HotelModeSettings.enabled && mounted) {
        showCustomSnackBarUtil(
          context,
          context.flipperL10n.barModeAlongsideHotel,
        );
      }
      final branchId = ProxyService.box.getBranchId();
      if (branchId != null) {
        await ProxyService.getStrategy(
          Strategy.capella,
        ).seedDefaultFloorPlan(branchId: branchId);
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
    final l10n = context.flipperL10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BarAdminEyebrow(label: l10n.barAdminServiceMode),
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
                    title: l10n.barRequirePinTitle,
                    subtitle: l10n.barRequirePinSubtitle,
                    value: _requirePin,
                    onChanged: (v) {
                      setState(() => _requirePin = v);
                      BarModeSettings.setRequirePin(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.grid_view_rounded,
                    title: l10n.barFloorFirstTitle,
                    subtitle: l10n.barFloorFirstSubtitle,
                    value: _floorFirst,
                    onChanged: (v) {
                      setState(() => _floorFirst = v);
                      BarModeSettings.setFloorFirst(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.shield_outlined,
                    title: l10n.barManagerSettleTitle,
                    subtitle: l10n.barManagerSettleSubtitle,
                    value: _managerSettle,
                    onChanged: (v) {
                      setState(() => _managerSettle = v);
                      BarModeSettings.setManagerSettle(v);
                    },
                  ),
                  BarSubRow(
                    icon: Icons.logout,
                    title: l10n.barAutoLogoutTitle,
                    subtitle: l10n.barAutoLogoutSubtitle,
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
          crossFadeState: _enabled
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 280),
        ),
        if (_enabled) ...[
          const SizedBox(height: 22),
          BarAdminEyebrow(label: l10n.barAdminFloorTables),
          const BarFloorPlanEditor(),
        ],
        const SizedBox(height: 22),
        BarAdminEyebrow(
          label: l10n.barAdminStaffPins,
          accent: BarTokens.violet,
        ),
        if (_staff.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              l10n.barNoStaffYet,
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
                    key: ValueKey(
                      'bar_staff_${_staff[i].id}_${_staff[i].userId}',
                    ),
                    tenant: _staff[i],
                    color: barColorForTenant(_staff[i].id, _staff),
                    showTopBorder: i > 0,
                    isDeleteLoading:
                        _deletingStaffKey == barStaffDeleteKey(_staff[i]),
                    onEdit: _openUserManagement,
                    onDelete:
                        barStaffDeleteAllowed(
                          target: _staff[i],
                          currentUserId: ProxyService.box.getUserId(),
                        )
                        ? () => _confirmDeleteStaff(_staff[i])
                        : null,
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
              colors: [Color(0x00F0F2F5), BarTokens.adminPageBg],
              stops: [0.0, 0.4],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              BarGhostButton(
                label: l10n.cancel,
                onPressed: () => Navigator.of(context).maybePop(),
              ),
              const SizedBox(width: 12),
              BarPrimaryButton(
                label: l10n.barOpenPosWithBarMode,
                onPressed: _enabled
                    ? () {
                        BarModeSettings.setLaunchOnStart(true);
                        locator<RouterService>().navigateTo(BarModeHostRoute());
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
                        context.flipperL10n.barTableServiceTitle,
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
                          context.flipperL10n.hotelOnBadge,
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
                  context.flipperL10n.barModeDescription(
                    serviceModeHotkeyLabel,
                  ),
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
