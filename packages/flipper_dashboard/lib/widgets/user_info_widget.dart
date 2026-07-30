import 'package:flipper_dashboard/BranchSelectionMixin.dart';
import 'package:flipper_dashboard/logout/dashboard_sign_out.dart';
import 'package:flipper_dashboard/logout/pos_user_switch.dart';
import 'package:flipper_dashboard/logout/pos_user_switch_lock_provider.dart';
import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/branch_business_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    show branchSelectionProvider, businessesProvider, buttonIndexProvider;
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/branch.model.dart';

/// A compact widget showing user information in the top bar
class UserInfoWidget extends StatefulHookConsumerWidget {
  const UserInfoWidget({super.key, this.handoffTopBarStyle = false});

  /// Handoff `.pos-user` chip (POS top bar).
  final bool handoffTopBarStyle;

  @override
  ConsumerState<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends ConsumerState<UserInfoWidget>
    with BranchSelectionMixin {
  String _userName = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final name = _resolveLoggedInUserName();
    if (mounted) {
      setState(() {
        _userName = name;
      });
    }
  }

  /// Primary label is the signed-in person; branch stays on the second line.
  String _resolveLoggedInUserName() {
    final storedName = ProxyService.box.getUserName()?.trim();
    if (storedName != null && storedName.isNotEmpty) {
      return storedName;
    }

    final cachedName = ProxyService.box.readString(key: 'userName')?.trim();
    if (cachedName != null && cachedName.isNotEmpty) {
      return cachedName;
    }

    final userId = ProxyService.box.getUserId();
    if (userId != null && userId.isNotEmpty) {
      if (userId.contains('@')) {
        return _formatName(userId.split('@').first);
      }
      return userId;
    }

    final phone = ProxyService.box.getUserPhone();
    if (phone != null && phone.isNotEmpty) {
      return phone;
    }

    return 'User';
  }

  String _getInitials(String name) {
    name = name.trim();
    if (name.isEmpty) return 'U';

    final parts = name.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    }
    return 'U';
  }

  String _formatName(String emailName) {
    // Convert "john.doe" or "john_doe" to "John Doe"
    final parts = emailName.replaceAll('_', '.').split('.');
    return parts
        .map(
          (part) => part.isEmpty
              ? ''
              : '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  String? _activeBranchName() {
    final name = ref.watch(
      activeBranchProvider.select((async) => async.asData?.value.name),
    );
    final trimmed = name?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  Future<void> _setDefaultBranch(Branch branch) async {
    ref.read(branchSelectionProvider.notifier).setLoading(true);
    // ignore: unused_result
    ref.refresh(businessesProvider);
    // ignore: unused_result
    ref.refresh(branchesProvider(businessId: ProxyService.box.getBusinessId()));
  }

  Future<void> _signOut() async {
    final dialogService = locator<DialogService>();
    final routerService = locator<RouterService>();
    await completeDashboardSignOut(
      context: context,
      dialogService: dialogService,
      routerService: routerService,
      loaderUseRootNavigator: true,
    );
  }

  Future<void> _openBranchSwitchDialog() async {
    ref.read(buttonIndexProvider.notifier).setIndex(2);
    await showBranchSwitchDialog(
      context: context,
      setDefaultBranch: _setDefaultBranch,
      handleBranchSelection: handleBranchSelection,
      onLogout: _signOut,
    );
  }

  Future<void> _openSwitchUserDialog() async {
    final dialogService = locator<DialogService>();
    await beginPosUserSwitchLock(
      context: context,
      ref: ref,
      dialogService: dialogService,
    );
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'switchBranch':
        _openBranchSwitchDialog();
      case 'switchUser':
        _openSwitchUserDialog();
      case 'logOut':
        _signOut();
    }
  }

  Widget _nameColumn({
    required BuildContext context,
    required String displayName,
    required String? branchName,
    required TextStyle nameStyle,
    required TextStyle branchStyle,
  }) {
    // Cap width so long business/branch names ellipsize instead of
    // overflowing the top bar icons.
    final maxTextWidth = (MediaQuery.sizeOf(context).width * 0.18).clamp(
      96.0,
      180.0,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxTextWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            displayName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            style: nameStyle,
          ),
          if (branchName != null)
            Text(
              branchName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: branchStyle,
            ),
        ],
      ),
    );
  }

  Widget _profileChip({
    required String displayName,
    required String? branchName,
  }) {
    if (widget.handoffTopBarStyle) {
      return Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: PosTokens.gradBrand,
              ),
              child: Text(
                _getInitials(_userName),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 10),
            _nameColumn(
              context: context,
              displayName: displayName,
              branchName: branchName,
              nameStyle: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: PosTokens.ink1,
                height: 1.15,
              ),
              branchStyle: const TextStyle(
                fontSize: 11.5,
                color: PosTokens.ink3,
                height: 1.15,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(Icons.expand_more, size: 18, color: PosTokens.ink3),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Theme.of(
              context,
            ).primaryColor.withValues(alpha: 0.1),
            child: Text(
              _getInitials(_userName),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          _nameColumn(
            context: context,
            displayName: displayName,
            branchName: branchName,
            nameStyle: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            branchStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          Icon(Icons.expand_more, size: 18, color: Colors.grey.shade600),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<bool>(posUserSwitchLockProvider, (prev, next) {
      if (prev == true && next == false) {
        _loadUserInfo();
      }
    });

    final displayName = widget.handoffTopBarStyle
        ? _userName.toUpperCase()
        : _userName;
    final branchName = _activeBranchName();
    final locked = ref.watch(posUserSwitchLockProvider);
    final logoutLabel = context.flipperL10n.logOut;

    return PopupMenuButton<String>(
      tooltip: 'Account',
      offset: const Offset(0, 52),
      elevation: 10,
      shadowColor: const Color(0x33103240),
      color: PosTokens.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: PosTokens.line),
      ),
      constraints: const BoxConstraints(minWidth: 260, maxWidth: 300),
      padding: EdgeInsets.zero,
      onSelected: _onMenuSelected,
      itemBuilder: (BuildContext context) => [
        _AccountMenuHeaderEntry(
          initials: _getInitials(_userName),
          displayName: displayName,
          branchName: branchName,
        ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'switchBranch',
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: const _AccountMenuRow(
            icon: Icons.storefront_outlined,
            label: 'Switch Branch',
            iconColor: PosTokens.blue,
            iconBackground: PosTokens.blueTint,
          ),
        ),
        if (!locked)
          PopupMenuItem<String>(
            value: 'switchUser',
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            child: const _AccountMenuRow(
              icon: Icons.switch_account_outlined,
              label: 'Switch User',
              iconColor: PosTokens.blue,
              iconBackground: PosTokens.blueTint,
            ),
          ),
        const PopupMenuDivider(height: 1),
        PopupMenuItem<String>(
          value: 'logOut',
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: _AccountMenuRow(
            icon: Icons.logout_rounded,
            label: logoutLabel,
            iconColor: PosTokens.lossInk,
            iconBackground: PosTokens.lossTint,
            labelColor: PosTokens.lossInk,
          ),
        ),
      ],
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: _profileChip(displayName: displayName, branchName: branchName),
      ),
    );
  }
}

/// Non-selectable profile summary at the top of the account menu.
///
/// A disabled [PopupMenuItem] would grey this out; a custom entry keeps full
/// opacity while still participating in the menu layout.
class _AccountMenuHeaderEntry extends PopupMenuEntry<String> {
  const _AccountMenuHeaderEntry({
    required this.initials,
    required this.displayName,
    required this.branchName,
  });

  final String initials;
  final String displayName;
  final String? branchName;

  @override
  double get height => 72;

  @override
  bool represents(String? value) => false;

  @override
  State<_AccountMenuHeaderEntry> createState() =>
      _AccountMenuHeaderEntryState();
}

class _AccountMenuHeaderEntryState extends State<_AccountMenuHeaderEntry> {
  @override
  Widget build(BuildContext context) {
    return _AccountMenuHeader(
      initials: widget.initials,
      displayName: widget.displayName,
      branchName: widget.branchName,
    );
  }
}

class _AccountMenuHeader extends StatelessWidget {
  const _AccountMenuHeader({
    required this.initials,
    required this.displayName,
    required this.branchName,
  });

  final String initials;
  final String displayName;
  final String? branchName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: PosTokens.gradBrand,
            ),
            child: Text(
              initials,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: PosTokens.ink1,
                    height: 1.2,
                  ),
                ),
                if (branchName != null) ...[
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.storefront_outlined,
                        size: 12,
                        color: PosTokens.ink3,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          branchName!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: PosTokens.ink3,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.iconBackground,
    this.labelColor = PosTokens.ink1,
  });

  final IconData icon;
  final String label;
  final Color iconColor;
  final Color iconBackground;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, size: 17, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: labelColor,
            ),
          ),
        ),
      ],
    );
  }
}
