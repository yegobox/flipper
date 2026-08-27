import 'package:flipper_hr/features/billing/presentation/hr_billing_gate.dart';
import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/home/hr_sidebar_state.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_identity.dart';
import 'package:flipper_hr/features/session/data/hr_identity_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  /// Typing in the topbar puts the term into the roster's own filter and opens
  /// it — one search box, one result list, no second implementation to keep in
  /// step with `applyPeopleQuery`.
  void _search(String term) {
    ref.read(peopleQueryProvider.notifier).setSearch(term);
    if (GoRouterState.of(context).uri.path != '/people') {
      context.go('/people');
    }
  }

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
      final collapsed = ref.watch(hrSidebarCollapsedProvider);
      return Scaffold(
        backgroundColor: HrTokens.workspaceBg,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HrSidebar(
              destinations: destinations,
              location: location,
              isSigningOut: _isSigningOut,
              onSignOut: _signOut,
              collapsed: collapsed,
            ),
            Expanded(
              child: Column(
                children: [
                  _HrTopbar(
                    location: location,
                    destinations: destinations,
                    collapsed: collapsed,
                    onToggleSidebar: () => ref
                        .read(hrSidebarCollapsedProvider.notifier)
                        .toggle(),
                    isSigningOut: _isSigningOut,
                    onSignOut: _signOut,
                    canSearch: session.canManageRoster,
                    onSearch: _search,
                  ),
                  const HrBillingNotice(
                    padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
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
      backgroundColor: HrTokens.workspaceBg,
      appBar: AppBar(
        backgroundColor: HrTokens.surface,
        surfaceTintColor: Colors.transparent,
        foregroundColor: HrTokens.ink1,
        elevation: 0,
        titleSpacing: 8,
        title: const _HrWordmark(),
        actions: [
          _AccountButton(isSigningOut: _isSigningOut, onSignOut: _signOut),
          const SizedBox(width: 8),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: HrTokens.line),
        ),
      ),
      drawer: Drawer(
        backgroundColor: HrTokens.sidebarBg,
        child: _HrSidebar(
          destinations: destinations,
          location: location,
          isSigningOut: _isSigningOut,
          onSignOut: _signOut,
          // A drawer is opened to read the labels; collapsing it there would
          // leave a rail floating in an empty sheet.
          collapsed: false,
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
    required this.collapsed,
    this.inDrawer = false,
  });

  final List<HrDestination> destinations;
  final String location;
  final bool isSigningOut;
  final VoidCallback onSignOut;
  final bool collapsed;
  final bool inDrawer;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(selectedBusinessProvider);
    final branch   = ref.watch(selectedBranchProvider);

    final entityName = business?.name ?? 'Flipper HR';
    final subtitle   = branch?.name ?? '';

    return AnimatedContainer(
      duration: HrTokens.motion,
      curve: Curves.easeOutCubic,
      width: collapsed ? HrTokens.railWidth : HrTokens.sidebarWidth,
      decoration: const BoxDecoration(
        color: HrTokens.sidebarBg,
        border: Border(right: BorderSide(color: HrTokens.border)),
      ),
      // The two widths are laid out at their own size and clipped, so labels
      // slide out of view instead of overflowing while the width animates.
      child: ClipRect(
        child: OverflowBox(
          alignment: Alignment.centerLeft,
          minWidth: collapsed ? HrTokens.railWidth : HrTokens.sidebarWidth,
          maxWidth: collapsed ? HrTokens.railWidth : HrTokens.sidebarWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Brand ──────────────────────────────────────────────────────
              Padding(
                padding: collapsed
                    ? const EdgeInsets.fromLTRB(0, 18, 0, 14)
                    : const EdgeInsets.fromLTRB(18, 18, 18, 14),
                child: _HrWordmark(compact: collapsed),
              ),

              // ── Entity switcher ────────────────────────────────────────────
              Padding(
                padding: collapsed
                    ? const EdgeInsets.fromLTRB(0, 0, 0, 8)
                    : const EdgeInsets.fromLTRB(10, 0, 10, 8),
                child: _EntitySwitcher(
                  entityName: entityName,
                  subtitle: subtitle,
                  collapsed: collapsed,
                  onTap: () {
                    if (inDrawer) Navigator.of(context).pop();
                    context.go('/business-selection');
                  },
                ),
              ),

              // ── Nav items ──────────────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: collapsed ? 10 : 8,
                    vertical: 4,
                  ),
                  children: [
                    for (final group in hrNavGroups(destinations)) ...[
                      // The heading is what makes a nav a map rather than a
                      // list: "Manage" and "You" are two different jobs, and
                      // someone who has both switches between them all day.
                      if (!collapsed && group.title != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                          child: Text(
                            group.title!.toUpperCase(),
                            style: HrType.overline,
                          ),
                        ),
                      if (collapsed && group.title != null)
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Divider(height: 1, color: HrTokens.line),
                        ),
                      for (final d in group.destinations)
                        _SidebarNavItem(
                          key: Key('hr-sidebar-${d.path.replaceAll('/', '')}'),
                          destination: d,
                          selected: _isSelected(d, location),
                          collapsed: collapsed,
                          onTap: () {
                            if (inDrawer) Navigator.of(context).pop();
                            context.go(d.path);
                          },
                        ),
                    ],
                  ],
                ),
              ),

              // ── Account footer ─────────────────────────────────────────────
              _SidebarAccountFooter(
                isSigningOut: isSigningOut,
                onSignOut: onSignOut,
                collapsed: collapsed,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static bool _isSelected(HrDestination d, String location) =>
      location == d.path || location.startsWith('${d.path}/');
}

// ─── Entity switcher ──────────────────────────────────────────────────────────

class _EntitySwitcher extends StatelessWidget {
  const _EntitySwitcher({
    required this.entityName,
    required this.subtitle,
    required this.collapsed,
    required this.onTap,
  });

  final String entityName;
  final String subtitle;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final avatar = _GradientAvatar(
      label: hrInitials(entityName),
      fallbackIcon: Icons.storefront_outlined,
    );

    if (collapsed) {
      return Center(
        child: Tooltip(
          message: subtitle.isEmpty ? entityName : '$entityName · $subtitle',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(HrTokens.radiusSm),
              child: Padding(padding: const EdgeInsets.all(4), child: avatar),
            ),
          ),
        ),
      );
    }

    return Material(
      color: HrTokens.sidebarBg2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusMd),
        side: const BorderSide(color: HrTokens.line),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(HrTokens.radiusMd),
        hoverColor: HrTokens.surface2,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              avatar,
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
                        color: HrTokens.ink1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: const TextStyle(fontSize: 11.5, color: HrTokens.ink3),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.unfold_more, color: HrTokens.ink4, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sidebar nav item ─────────────────────────────────────────────────────────

class _SidebarNavItem extends StatelessWidget {
  const _SidebarNavItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.collapsed,
    required this.onTap,
  });

  final HrDestination destination;
  final bool selected;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor  = selected ? HrTokens.accent : HrTokens.ink3;
    final labelColor = selected ? HrTokens.accent : HrTokens.ink2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Tooltip(
        message: destination.label,
        // A rail has no labels, so its tooltip is the label — it appears at
        // once. Expanded, the label is already on screen and a tooltip that
        // races the pointer is just noise.
        waitDuration: Duration(milliseconds: collapsed ? 200 : 600),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(HrTokens.radiusSm),
            hoverColor: HrTokens.surface2,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.ease,
              height: 40,
              padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 12),
              decoration: BoxDecoration(
                color: selected ? HrTokens.accentTint : Colors.transparent,
                borderRadius: BorderRadius.circular(HrTokens.radiusSm),
              ),
              child: Row(
                mainAxisAlignment: collapsed
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                children: [
                  Icon(destination.icon, size: 18, color: iconColor),
                  if (!collapsed) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        destination.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: labelColor,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sidebar account footer ───────────────────────────────────────────────────

class _SidebarAccountFooter extends ConsumerWidget {
  const _SidebarAccountFooter({
    required this.isSigningOut,
    required this.onSignOut,
    required this.collapsed,
  });

  final bool isSigningOut;
  final VoidCallback onSignOut;
  final bool collapsed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(hrIdentityOrUnknownProvider);

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: HrTokens.line)),
      ),
      padding: EdgeInsets.all(collapsed ? 6 : 10),
      child: _AccountMenu(
        identity: identity,
        isSigningOut: isSigningOut,
        onSignOut: onSignOut,
        offset: const Offset(0, -8),
        child: collapsed
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: _CircleAvatar(label: identity.initials, radius: 16),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    _CircleAvatar(label: identity.initials),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            identity.name,
                            key: const Key('hr-account-name'),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: HrTokens.ink1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (identity.secondary != null)
                            Text(
                              identity.secondary!,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: HrTokens.ink3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    if (isSigningOut)
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      const Icon(Icons.more_horiz, color: HrTokens.ink3, size: 18),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─── Topbar ───────────────────────────────────────────────────────────────────

class _HrTopbar extends ConsumerWidget {
  const _HrTopbar({
    required this.location,
    required this.destinations,
    required this.collapsed,
    required this.onToggleSidebar,
    required this.isSigningOut,
    required this.onSignOut,
    required this.canSearch,
    required this.onSearch,
  });

  final String location;
  final List<HrDestination> destinations;
  final bool collapsed;
  final VoidCallback onToggleSidebar;
  final bool isSigningOut;
  final VoidCallback onSignOut;

  /// Only for sessions that have a roster to search.
  final bool canSearch;

  final ValueChanged<String> onSearch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = destinations.firstWhere(
      (d) => location == d.path || location.startsWith('${d.path}/'),
      orElse: () => destinations.isNotEmpty
          ? destinations.first
          : const HrDestination(path: '/', label: 'HR', icon: Icons.home),
    );

    return Container(
      height: HrTokens.topbarHeight,
      padding: const EdgeInsets.fromLTRB(10, 0, 16, 0),
      decoration: const BoxDecoration(
        color: HrTokens.surface,
        border: Border(bottom: BorderSide(color: HrTokens.line)),
      ),
      child: Row(
        children: [
          _IconAction(
            key: const Key('hr-sidebar-toggle'),
            icon: collapsed
                ? Icons.menu_open_outlined
                : Icons.menu_outlined,
            tooltip: collapsed ? 'Expand the menu' : 'Collapse the menu',
            onTap: onToggleSidebar,
          ),
          const SizedBox(width: 8),
          // Breadcrumb
          const Text('HR', style: TextStyle(fontSize: 13, color: HrTokens.ink3)),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.chevron_right, size: 14, color: HrTokens.ink3),
          ),
          Flexible(
            child: Text(
              current.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: HrTokens.ink1,
              ),
            ),
          ),
          const Spacer(),
          // Search sends you to the roster with the term already typed — the
          // one index HR has. It is a real control rather than an icon that
          // opens a palette that does not exist yet.
          if (canSearch)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: HrSearchField(
                key: const Key('hr-topbar-search'),
                hintText: 'Search people…',
                onChanged: onSearch,
              ),
            ),
          const SizedBox(width: 8),
          _AccountButton(
            // The topbar's menu signs out for real. It used to be handed a
            // no-op, so "Sign out" up here did nothing.
            isSigningOut: isSigningOut,
            onSignOut: onSignOut,
          ),
        ],
      ),
    );
  }
}

/// A square, quiet icon button — the topbar's only affordance shape.
class _IconAction extends StatelessWidget {
  const _IconAction({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(HrTokens.radiusSm),
          hoverColor: HrTokens.surface2,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(icon, size: 20, color: HrTokens.ink2),
          ),
        ),
      ),
    );
  }
}

// ─── Account menu ─────────────────────────────────────────────────────────────

/// The one account menu, shared by the topbar and the sidebar footer so the two
/// never drift apart.
class _AccountMenu extends StatelessWidget {
  const _AccountMenu({
    required this.identity,
    required this.isSigningOut,
    required this.onSignOut,
    required this.offset,
    required this.child,
  });

  final HrIdentity identity;
  final bool isSigningOut;
  final VoidCallback onSignOut;
  final Offset offset;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: '',
      // Anchored over the child, as the accounting shell's menus are: the
      // footer's offset lifts it clear of the sidebar's bottom edge, the
      // topbar's drops it below the avatar.
      offset: offset,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(HrTokens.radiusMd),
      ),
      color: HrTokens.surface,
      onSelected: (value) {
        if (value == 'switch') context.go('/business-selection');
        if (value == 'signOut') onSignOut();
      },
      itemBuilder: (_) => [
        PopupMenuItem<String>(
          enabled: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                identity.name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: HrTokens.ink1,
                ),
              ),
              if (identity.secondary != null)
                Text(
                  identity.secondary!,
                  style: const TextStyle(fontSize: 12, color: HrTokens.ink3),
                ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem(
          value: 'switch',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.swap_horiz, size: 18, color: HrTokens.ink2),
            title: Text('Switch business or branch'),
          ),
        ),
        PopupMenuItem(
          value: 'signOut',
          child: ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout, size: 18, color: HrTokens.ink2),
            title: Text(isSigningOut ? 'Signing out…' : 'Sign out'),
          ),
        ),
      ],
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(HrTokens.radiusSm),
          hoverColor: HrTokens.surface2,
          // The InkWell is decoration only: PopupMenuButton owns the gesture,
          // and giving this one an onTap would open the menu twice.
          child: child,
        ),
      ),
    );
  }
}

/// The topbar / app bar avatar.
class _AccountButton extends ConsumerWidget {
  const _AccountButton({required this.isSigningOut, required this.onSignOut});

  final bool isSigningOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(hrIdentityOrUnknownProvider);

    return Tooltip(
      message: identity.name,
      child: _AccountMenu(
        identity: identity,
        isSigningOut: isSigningOut,
        onSignOut: onSignOut,
        offset: const Offset(0, 40),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: _CircleAvatar(
            key: const Key('hr-account-avatar'),
            label: identity.initials,
            radius: 16,
          ),
        ),
      ),
    );
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
      backgroundColor: HrTokens.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: HrTokens.accentTint,
      selectedIndex: idx,
      onDestinationSelected: (i) => context.go(destinations[i].path),
      destinations: [
        for (final d in destinations)
          NavigationDestination(
            key: Key('hr-nav-${d.path.replaceAll('/', '')}'),
            icon: Icon(d.icon, color: HrTokens.ink3),
            selectedIcon: Icon(d.icon, color: HrTokens.accent),
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
  const _HrWordmark({this.compact = false});

  /// Mark only — what the rail and a narrow app bar have room for.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return const Center(
        child: Tooltip(message: 'Flipper HR', child: _BrandMark()),
      );
    }

    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BrandMark(),
        SizedBox(width: 10),
        Text(
          'Flipper HR',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: HrTokens.ink1,
          ),
        ),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        gradient: HrTokens.brandGradient,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: const Icon(Icons.groups, color: Colors.white, size: 16),
    );
  }
}

class _GradientAvatar extends StatelessWidget {
  const _GradientAvatar({required this.label, required this.fallbackIcon});

  /// Initials, or empty when there are none worth drawing.
  final String label;
  final IconData fallbackIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: HrTokens.brandGradient,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: label.isEmpty
          ? Icon(fallbackIcon, size: 18, color: Colors.white)
          : Text(
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
  const _CircleAvatar({super.key, required this.label, this.radius = 18});

  /// Initials, or empty for a person icon.
  ///
  /// Empty is the honest answer for a session known only by its phone number —
  /// the first two characters of `+250…` are not initials, they are noise.
  final String label;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: HrTokens.brandGradient,
        shape: BoxShape.circle,
      ),
      child: label.isEmpty
          ? Icon(Icons.person_outline, size: radius, color: Colors.white)
          : Text(
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

/// A titled run of destinations in the sidebar.
class HrNavGroup {
  const HrNavGroup({this.title, required this.destinations});

  /// Null for the first run, which needs no heading — nothing precedes it to be
  /// distinguished from.
  final String? title;

  final List<HrDestination> destinations;
}

/// Splits the nav into what this person does for the business and what they do
/// for themselves.
///
/// The split is by path rather than by session flags so it cannot drift from
/// [hrDestinationsFor]: `/my-time` and `/leave` are the self-service pair, and
/// everything else is management. Someone with only one of the two groups gets
/// one untitled run, because a lone heading labels nothing.
List<HrNavGroup> hrNavGroups(List<HrDestination> destinations) {
  const selfService = {'/my-time', '/leave'};

  final manage = [
    for (final d in destinations)
      if (!selfService.contains(d.path)) d,
  ];
  final mine = [
    for (final d in destinations)
      if (selfService.contains(d.path)) d,
  ];

  if (manage.isEmpty) return [HrNavGroup(destinations: mine)];
  if (mine.isEmpty) return [HrNavGroup(destinations: manage)];
  return [
    HrNavGroup(destinations: manage),
    HrNavGroup(title: 'You', destinations: mine),
  ];
}

/// The modules this session may open, in nav order.
List<HrDestination> hrDestinationsFor(HrSession session) {
  final destinations = <HrDestination>[];
  if (session.canManageRoster) {
    destinations.add(
      const HrDestination(
        path: '/overview',
        label: 'Home',
        icon: Icons.space_dashboard_outlined,
      ),
    );
  }
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
