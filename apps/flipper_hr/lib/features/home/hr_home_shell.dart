import 'package:flipper_hr/features/billing/presentation/hr_billing_gate.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─── Design tokens (mirrors AccountingTokens) ────────────────────────────────

abstract final class _T {
  static const Color workspaceBg = Color(0xFFF1F4FA);
  static const Color sidebarBg   = Color(0xFFFFFFFF);
  static const Color sidebarBg2  = Color(0xFFF7F9FE);
  static const Color border      = Color(0xFFE5E7EB);
  static const Color surface     = Color(0xFFFFFFFF);
  static const Color surface2    = Color(0xFFF4F6FB);
  static const Color ink1        = Color(0xFF0B1220);
  static const Color ink2        = Color(0xFF4A5567);
  static const Color ink3        = Color(0xFF7E8AA0);
  static const Color ink4        = Color(0xFF9AA8BC);
  static const Color line        = Color(0xFFE6ECF5);
  static const Color accent      = Color(0xFF2563EB);
  static const Color accentTint  = Color(0xFFEAF1FE);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF2563EB), Color(0xFF4F46E5)],
    stops: [0, 0.52, 1],
  );

  static const double sidebarWidth  = 240;
  static const double topbarHeight  = 56;
  static const double radiusSm      = 10;
  static const double radiusMd      = 14;
}

// ─── Shell ────────────────────────────────────────────────────────────────────

/// Signed-in HR chrome: sidebar nav + topbar, matching the flipper_web
/// accounting shell layout and token set exactly.
class HrHomeShell extends ConsumerStatefulWidget {
  const HrHomeShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<HrHomeShell> createState() => _HrHomeShellState();
}

class _HrHomeShellState extends ConsumerState<HrHomeShell> {
  bool _isSigningOut = false;

  // Breakpoint below which the sidebar collapses to a drawer.
  static const double _sidebarBreakpoint = 840.0;

  Future<void> _signOut() async {
    if (_isSigningOut) return;
    setState(() => _isSigningOut = true);
    try {
      await ref.read(authServiceProvider).signOut();
    } catch (e) {
      debugPrint('[flipper_hr] sign out failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isSigningOut = false);
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final session      = ref.watch(hrSessionProvider).value ?? HrSession.none;
    final destinations = hrDestinationsFor(session);
    final location     = GoRouterState.of(context).uri.path;
    final isWide       = MediaQuery.sizeOf(context).width >= _sidebarBreakpoint;

    if (isWide) {
      return Scaffold(
        backgroundColor: _T.workspaceBg,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HrSidebar(
              destinations: destinations,
              location: location,
              isSigningOut: _isSigningOut,
              onSignOut: _signOut,
            ),
            Expanded(
              child: Column(
                children: [
                  _HrTopbar(location: location, destinations: destinations),
                  const HrBillingNotice(
                    padding: EdgeInsets.fromLTRB(16, 10, 16, 0),
                  ),
                  Expanded(child: widget.child),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ── Narrow: drawer + bottom nav ──────────────────────────────────────────
    return Scaffold(
      backgroundColor: _T.workspaceBg,
      appBar: AppBar(
        backgroundColor: _T.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 16,
        title: _HrWordmark(),
        actions: [
          _AccountButton(isSigningOut: _isSigningOut, onSignOut: _signOut),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(height: 1, color: _T.line),
        ),
      ),
      drawer: Drawer(
        backgroundColor: _T.sidebarBg,
        child: _HrSidebar(
          destinations: destinations,
          location: location,
          isSigningOut: _isSigningOut,
          onSignOut: _signOut,
          inDrawer: true,
        ),
      ),
      body: Column(
        children: [
          const HrBillingNotice(),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: destinations.length < 2
          ? null
          : _HrBottomNav(destinations: destinations, location: location),
    );
  }
}

// ─── Sidebar ──────────────────────────────────────────────────────────────────

class _HrSidebar extends ConsumerWidget {
  const _HrSidebar({
    required this.destinations,
    required this.location,
    required this.isSigningOut,
    required this.onSignOut,
    this.inDrawer = false,
  });

  final List<HrDestination> destinations;
  final String location;
  final bool isSigningOut;
  final VoidCallback onSignOut;
  final bool inDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(selectedBusinessProvider);
    final branch   = ref.watch(selectedBranchProvider);
    final profile  = ref.watch(currentUserProfileProvider).value;

    final entityName = business?.name ?? 'Flipper HR';
    final subtitle   = branch?.name ?? '';

    Widget sidebar = Container(
      width: _T.sidebarWidth,
      decoration: const BoxDecoration(
        color: _T.sidebarBg,
        border: Border(right: BorderSide(color: _T.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Brand ──────────────────────────────────────────────────────────
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 18, 18, 14),
            child: _HrWordmark(),
          ),

          // ── Entity switcher ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
            child: Material(
              color: _T.sidebarBg2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(_T.radiusMd),
                side: const BorderSide(color: _T.line),
              ),
              child: InkWell(
                onTap: () {
                  if (inDrawer) Navigator.of(context).pop();
                  context.go('/business-selection');
                },
                borderRadius: BorderRadius.circular(_T.radiusMd),
                hoverColor: _T.surface2,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      _GradientAvatar(label: _initials(entityName)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entityName,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: _T.ink1,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (subtitle.isNotEmpty)
                              Text(
                                subtitle,
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: _T.ink3,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      const Icon(Icons.unfold_more, color: _T.ink4, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Nav items ──────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              children: [
                for (final d in destinations)
                  _SidebarNavItem(
                    destination: d,
                    selected: _isSelected(d, location),
                    onTap: () {
                      if (inDrawer) Navigator.of(context).pop();
                      context.go(d.path);
                    },
                  ),
              ],
            ),
          ),

          // ── Account footer ─────────────────────────────────────────────────
          _SidebarAccountFooter(
            profile: profile,
            isSigningOut: isSigningOut,
            onSignOut: onSignOut,
          ),
        ],
      ),
    );

    // In a Drawer the width is managed by the Drawer widget itself.
    if (inDrawer) {
      return SizedBox(width: _T.sidebarWidth, child: sidebar);
    }
    return sidebar;
  }

  static bool _isSelected(HrDestination d, String location) =>
      location == d.path || location.startsWith('${d.path}/');

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : 'H';
  }
}

// ─── Sidebar nav item ─────────────────────────────────────────────────────────

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final HrDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor  = selected ? _T.accent : _T.ink3;
    final labelColor = selected ? _T.accent : _T.ink2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Tooltip(
        message: destination.label,
        waitDuration: const Duration(milliseconds: 600),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(_T.radiusSm),
          hoverColor: _T.surface2,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 120),
            curve: Curves.ease,
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: selected ? _T.accentTint : Colors.transparent,
              borderRadius: BorderRadius.circular(_T.radiusSm),
            ),
            child: Row(
              children: [
                Icon(destination.icon, size: 18, color: iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destination.label,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      color: labelColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sidebar account footer ───────────────────────────────────────────────────

class _SidebarAccountFooter extends StatelessWidget {
  const _SidebarAccountFooter({
    required this.profile,
    required this.isSigningOut,
    required this.onSignOut,
  });

  final UserProfile? profile;
  final bool isSigningOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final label = profile?.phoneNumber ?? 'Account';

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<String>(
          tooltip: '',
          offset: const Offset(0, -8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_T.radiusMd),
          ),
          onSelected: (value) {
            if (value == 'switch') context.go('/business-selection');
            if (value == 'signOut') onSignOut();
          },
          itemBuilder: (_) => [
            PopupMenuItem<String>(
              enabled: false,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: _T.ink3,
                ),
              ),
            ),
            const PopupMenuDivider(),
            const PopupMenuItem(
              value: 'switch',
              child: Text('Switch business or branch'),
            ),
            PopupMenuItem(
              value: 'signOut',
              child: Text(isSigningOut ? 'Signing out…' : 'Sign out'),
            ),
          ],
          child: InkWell(
            borderRadius: BorderRadius.circular(_T.radiusSm),
            hoverColor: _T.surface2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              child: Row(
                children: [
                  _CircleAvatar(label: _initials(label)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _T.ink1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSigningOut)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  else
                    const Icon(Icons.more_horiz, color: _T.ink3, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static String _initials(String s) {
    final parts = s.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return s.isNotEmpty ? s[0].toUpperCase() : 'U';
  }
}

// ─── Topbar ───────────────────────────────────────────────────────────────────

class _HrTopbar extends ConsumerWidget {
  const _HrTopbar({required this.location, required this.destinations});

  final String location;
  final List<HrDestination> destinations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = destinations.firstWhere(
      (d) => location == d.path || location.startsWith('${d.path}/'),
      orElse: () => destinations.isNotEmpty
          ? destinations.first
          : const HrDestination(path: '/', label: 'HR', icon: Icons.home),
    );

    return Container(
      height: _T.topbarHeight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: _T.surface,
        border: Border(bottom: BorderSide(color: _T.line)),
      ),
      child: Row(
        children: [
          // Breadcrumb
          Text(
            'HR',
            style: const TextStyle(fontSize: 13, color: _T.ink3),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.chevron_right, size: 14, color: _T.ink3),
          ),
          Text(
            current.label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _T.ink1,
            ),
          ),
          const Spacer(),
          _AccountButton(
            isSigningOut: false,
            onSignOut: () {},
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}

// ─── Account button (topbar) ──────────────────────────────────────────────────

class _AccountButton extends ConsumerWidget {
  const _AccountButton({required this.isSigningOut, required this.onSignOut});

  final bool isSigningOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final label   = profile?.phoneNumber ?? 'Account';

    return PopupMenuButton<String>(
      tooltip: 'Account',
      offset: const Offset(0, 44),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_T.radiusMd),
      ),
      onSelected: (value) {
        if (value == 'switch') context.go('/business-selection');
        if (value == 'signOut') onSignOut();
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Text(label, style: const TextStyle(fontSize: 12, color: _T.ink3)),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'switch',
          child: Text('Switch business or branch'),
        ),
        PopupMenuItem(
          value: 'signOut',
          child: Text(isSigningOut ? 'Signing out…' : 'Sign out'),
        ),
      ],
      child: Tooltip(
        message: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            hoverColor: _T.surface2,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: _CircleAvatar(label: _initials(label), radius: 16),
            ),
          ),
        ),
      ),
    );
  }

  static String _initials(String s) {
    final parts = s.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return s.isNotEmpty ? s[0].toUpperCase() : 'U';
  }
}

// ─── Bottom nav (narrow only) ─────────────────────────────────────────────────

class _HrBottomNav extends StatelessWidget {
  const _HrBottomNav({required this.destinations, required this.location});

  final List<HrDestination> destinations;
  final String location;

  @override
  Widget build(BuildContext context) {
    final idx = _indexOf(destinations, location);
    return NavigationBar(
      key: const Key('hr-module-nav'),
      selectedIndex: idx,
      onDestinationSelected: (i) => context.go(destinations[i].path),
      destinations: [
        for (final d in destinations)
          NavigationDestination(
            key: Key('hr-nav-${d.path.replaceAll('/', '')}'),
            icon: Icon(d.icon),
            label: d.label,
          ),
      ],
    );
  }

  static int _indexOf(List<HrDestination> destinations, String location) {
    for (var i = 0; i < destinations.length; i++) {
      if (location == destinations[i].path ||
          location.startsWith('${destinations[i].path}/')) {
        return i;
      }
    }
    return 0;
  }
}

// ─── Shared small widgets ─────────────────────────────────────────────────────

class _HrWordmark extends StatelessWidget {
  const _HrWordmark();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            gradient: _T.brandGradient,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: const Icon(Icons.groups, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 10),
        const Text(
          'Flipper HR',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: _T.ink1,
          ),
        ),
      ],
    );
  }
}

class _GradientAvatar extends StatelessWidget {
  const _GradientAvatar({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: _T.brandGradient,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _CircleAvatar extends StatelessWidget {
  const _CircleAvatar({required this.label, this.radius = 18});

  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: _T.brandGradient,
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: radius * 0.72,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}

// ─── Destinations (unchanged public API) ─────────────────────────────────────

/// One module in the nav.
class HrDestination {
  const HrDestination({
    required this.path,
    required this.label,
    required this.icon,
  });

  final String path;
  final String label;
  final IconData icon;
}

/// The modules this session may open, in nav order.
List<HrDestination> hrDestinationsFor(HrSession session) {
  final destinations = <HrDestination>[];
  if (session.canManageRoster || session.landing == HrLanding.unresolved) {
    destinations.add(
      const HrDestination(
        path: '/people',
        label: 'People',
        icon: Icons.groups_outlined,
      ),
    );
  }
  if (session.canManageRoster) {
    destinations.add(
      const HrDestination(
        path: '/attendance',
        label: 'Attendance',
        icon: Icons.schedule_outlined,
      ),
    );
  }
  if (session.canApproveLeave) {
    destinations.add(
      const HrDestination(
        path: '/approvals',
        label: 'Approvals',
        icon: Icons.fact_check_outlined,
      ),
    );
  }
  if (session.hasOwnRecord) {
    destinations.add(
      const HrDestination(
        path: '/my-time',
        label: 'My time',
        icon: Icons.timer_outlined,
      ),
    );
    destinations.add(
      const HrDestination(
        path: '/leave',
        label: 'My leave',
        icon: Icons.beach_access_outlined,
      ),
    );
  }
  return destinations;
}
