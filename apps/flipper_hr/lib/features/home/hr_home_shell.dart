import 'package:flipper_dashboard/pos_layout_breakpoints.dart';
import 'package:flipper_dashboard/widgets/pos_handoff_icon.dart';
import 'package:flipper_dashboard/widgets/pos_side_rail.dart';
import 'package:flipper_design_system/flipper_design_system.dart'
    show CustomAppBar;
import 'package:flipper_hr/features/billing/presentation/hr_billing_gate.dart';
import 'package:flipper_hr/features/branding/hr_tokens.dart';
import 'package:flipper_hr/features/host/hr_host.dart';
import 'package:flipper_hr/features/people/data/people_providers.dart';
import 'package:flipper_hr/features/session/data/hr_identity.dart';
import 'package:flipper_hr/features/session/data/hr_identity_providers.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_hr/features/ui/hr_ui.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// ─── Shell ────────────────────────────────────────────────────────────────────

/// Signed-in HR chrome: on desktop, the POS rail (shared widgets, so the two
/// apps cannot drift) beside the page under a header row; on a phone, a
/// header, drawer and bottom nav.
class HrHomeShell extends ConsumerStatefulWidget {
  const HrHomeShell({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<HrHomeShell> createState() => _HrHomeShellState();
}

class _HrHomeShellState extends ConsumerState<HrHomeShell> {
  bool _isSigningOut = false;

  // Breakpoint below which the sidebar collapses to a drawer.
  static const double _sidebarBreakpoint = hrSidebarBreakpoint;

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
    final session = ref.watch(hrSessionProvider).value ?? HrSession.none;
    final destinations = hrDestinationsFor(session);
    final location = GoRouterState.of(context).uri.path;
    final isWide = MediaQuery.sizeOf(context).width >= _sidebarBreakpoint;

    if (isWide) {
      // The POS desktop layout: a header row spanning the logo cell and the
      // top bar, then the rail beside the page.
      return Scaffold(
        backgroundColor: HrTokens.workspaceBg,
        body: Column(
          children: [
            _HrTopbar(
              location: location,
              destinations: destinations,
              isSigningOut: _isSigningOut,
              onSignOut: _signOut,
              canSearch: session.canManageRoster,
              onSearch: _search,
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PosRailFrame(
                    child: _HrRail(
                      destinations: destinations,
                      location: location,
                      isSigningOut: _isSigningOut,
                      onSignOut: _signOut,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        const HrBillingNotice(
                          padding: EdgeInsets.fromLTRB(24, 12, 24, 0),
                        ),
                        Expanded(child: widget.child),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ── Narrow: drawer + bottom nav ──────────────────────────────────────────
    final host = ref.watch(hrHostProvider);
    // On a phone every back button is Flipper's CustomAppBar: always inside
    // the mobile app, and on the web for a detail page, where there is a
    // level to go back up to. A top-level web page keeps the brand bar.
    final mobileHeader = host.isEmbedded || hrParentPath(location) != null;
    return Scaffold(
      backgroundColor: HrTokens.workspaceBg,
      appBar: mobileHeader
          ? CustomAppBar(
              key: const Key('hr-embedded-app-bar'),
              title: hrTitleFor(destinations, location),
              icon: Icons.arrow_back,
              onPop: () => hrEmbeddedBack(context, host, location),
            )
          : AppBar(
              backgroundColor: HrTokens.surface,
              surfaceTintColor: Colors.transparent,
              foregroundColor: HrTokens.ink1,
              elevation: 0,
              titleSpacing: 8,
              title: const _HrWordmark(),
              actions: [
                _AccountButton(
                  isSigningOut: _isSigningOut,
                  onSignOut: _signOut,
                ),
                const SizedBox(width: 8),
              ],
              bottom: const PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(height: 1, color: HrTokens.line),
              ),
            ),
      drawer: Drawer(
        backgroundColor: HrTokens.sidebarBg,
        child: _HrDrawerMenu(
          destinations: destinations,
          location: location,
          isSigningOut: _isSigningOut,
          onSignOut: _signOut,
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

// ─── Rail (desktop) ───────────────────────────────────────────────────────────

/// HR's desktop menu, drawn with the POS rail's own widgets so the two apps
/// look and behave the same: icons named by tooltip, a hairline between the
/// "manage" and "you" groups, the red exit entry and the branch at the foot.
class _HrRail extends ConsumerWidget {
  const _HrRail({
    required this.destinations,
    required this.location,
    required this.isSigningOut,
    required this.onSignOut,
  });

  final List<HrDestination> destinations;
  final String location;
  final bool isSigningOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(hrHostProvider);
    final business = ref.watch(selectedBusinessProvider);
    final branch = ref.watch(selectedBranchProvider);
    final entityName = business?.name ?? 'Flipper HR';
    final branchName = branch?.name ?? '';
    final l10n = context.flipperL10n;

    return PosRailColumn(
      groups: [
        for (final group in hrNavGroups(destinations))
          [
            for (final d in group.destinations)
              PosRailItem(
                key: Key('hr-sidebar-${d.path.replaceAll('/', '')}'),
                iconBuilder: (c) => Icon(d.icon, color: c),
                isSelected: _isSelected(d, location),
                onTap: () => context.go(d.path),
                tooltip: d.label,
              ),
          ],
      ],
      bottom: [
        // Embedded, the account belongs to the host: the exit leads back to
        // Flipper rather than signing the whole app out.
        PosRailItem(
          key: const Key('hr-rail-exit'),
          iconBuilder: (c) => posRailSvg(PosRailSvgs.logout, c),
          isSelected: false,
          isLogout: true,
          onTap: host.ownsAccount
              ? (isSigningOut ? () {} : onSignOut)
              : host.exit,
          tooltip: !host.ownsAccount
              ? l10n.hrBackToFlipper
              : (isSigningOut ? l10n.hrSigningOut : l10n.signOut),
        ),
      ],
      footer: Padding(
        padding: const EdgeInsets.fromLTRB(0, 6, 0, 12),
        child: Tooltip(
          key: const Key('hr-rail-branch'),
          message: branchName.isEmpty
              ? entityName
              : '$entityName · $branchName',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              // Embedded, the branch is the host's; picking another happens
              // there, so the avatar is a label, not a button.
              onTap: host.ownsAccount
                  ? () => context.go('/business-selection')
                  : null,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: _CircleAvatar(
                  label: hrInitials(
                    branchName.isEmpty ? entityName : branchName,
                  ),
                  radius: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool _isSelected(HrDestination d, String location) =>
    location == d.path || location.startsWith('${d.path}/');

// ─── Drawer (narrow only) ─────────────────────────────────────────────────────

/// The phone drawer: everything the bottom bar has no room for, with labels,
/// since a drawer is opened to read them.
class _HrDrawerMenu extends ConsumerWidget {
  const _HrDrawerMenu({
    required this.destinations,
    required this.location,
    required this.isSigningOut,
    required this.onSignOut,
  });

  final List<HrDestination> destinations;
  final String location;
  final bool isSigningOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final business = ref.watch(selectedBusinessProvider);
    final branch = ref.watch(selectedBranchProvider);

    final entityName = business?.name ?? 'Flipper HR';
    final subtitle = branch?.name ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Brand ────────────────────────────────────────────────────────────
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 18, 18, 14),
          child: _HrWordmark(),
        ),

        // ── Entity switcher ──────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
          child: _EntitySwitcher(
            entityName: entityName,
            subtitle: subtitle,
            // Embedded, the branch is the host's; picking another happens
            // there, so the card is a label, not a button.
            onTap: ref.watch(hrHostProvider).ownsAccount
                ? () {
                    Navigator.of(context).pop();
                    context.go('/business-selection');
                  }
                : null,
          ),
        ),

        // ── Nav items ────────────────────────────────────────────────────────
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            children: [
              for (final group in hrNavGroups(destinations)) ...[
                // The heading is what makes a nav a map rather than a list:
                // "Manage" and "You" are two different jobs, and someone who
                // has both switches between them all day.
                if (group.title != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 14, 12, 6),
                    child: Text(
                      group.title!.toUpperCase(),
                      style: HrType.overline,
                    ),
                  ),
                for (final d in group.destinations)
                  _DrawerNavItem(
                    key: Key('hr-drawer-${d.path.replaceAll('/', '')}'),
                    destination: d,
                    selected: _isSelected(d, location),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.go(d.path);
                    },
                  ),
              ],
            ],
          ),
        ),

        // ── Account footer ───────────────────────────────────────────────────
        _DrawerAccountFooter(isSigningOut: isSigningOut, onSignOut: onSignOut),
      ],
    );
  }
}

// ─── Entity switcher ──────────────────────────────────────────────────────────

class _EntitySwitcher extends StatelessWidget {
  const _EntitySwitcher({
    required this.entityName,
    required this.subtitle,
    required this.onTap,
  });

  final String entityName;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
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
              _GradientAvatar(
                label: hrInitials(entityName),
                fallbackIcon: Icons.storefront_outlined,
              ),
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
              const Icon(Icons.unfold_more, color: HrTokens.ink4, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Drawer nav item ──────────────────────────────────────────────────────────

class _DrawerNavItem extends StatelessWidget {
  const _DrawerNavItem({
    super.key,
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final HrDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected ? HrTokens.accent : HrTokens.ink3;
    final labelColor = selected ? HrTokens.accent : HrTokens.ink2;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
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
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: selected ? HrTokens.accentTint : Colors.transparent,
              borderRadius: BorderRadius.circular(HrTokens.radiusSm),
            ),
            child: Row(
              children: [
                Icon(destination.icon, size: 18, color: iconColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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

// ─── Drawer account footer ────────────────────────────────────────────────────

class _DrawerAccountFooter extends ConsumerWidget {
  const _DrawerAccountFooter({
    required this.isSigningOut,
    required this.onSignOut,
  });

  final bool isSigningOut;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final identity = ref.watch(hrIdentityOrUnknownProvider);

    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: HrTokens.line)),
      ),
      padding: const EdgeInsets.all(10),
      child: _AccountMenu(
        identity: identity,
        isSigningOut: isSigningOut,
        onSignOut: onSignOut,
        offset: const Offset(0, -8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
    required this.isSigningOut,
    required this.onSignOut,
    required this.canSearch,
    required this.onSearch,
  });

  final String location;
  final List<HrDestination> destinations;
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
      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
      decoration: const BoxDecoration(
        color: HrTokens.surface,
        border: Border(bottom: BorderSide(color: HrTokens.line)),
      ),
      child: Row(
        children: [
          // The mark sits in a cell as wide as the rail, so it lines up with
          // the rail's icons, as the POS logo does.
          const SizedBox(
            width: PosLayoutBreakpoints.sideMenuWidth,
            child: Center(child: _BrandMark()),
          ),
          const SizedBox(width: 16),
          // Breadcrumb
          const Text(
            'HR',
            style: TextStyle(fontSize: 13, color: HrTokens.ink3),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.chevron_right, size: 14, color: HrTokens.ink3),
          ),
          // Expanded, not Flexible beside a Spacer: a loose child leaves its
          // unused share at the row's end, so search and the avatar stopped
          // short of the right edge.
          Expanded(
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
          // Search sends you to the roster with the term already typed — the
          // one index HR has. It is a real control rather than an icon that
          // opens a palette that does not exist yet.
          if (canSearch)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 300),
              child: HrSearchField(
                key: const Key('hr-topbar-search'),
                hintText: context.flipperL10n.hrSearchPeople,
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

// ─── Account menu ─────────────────────────────────────────────────────────────

/// The one account menu, shared by the topbar and the sidebar footer so the two
/// never drift apart.
class _AccountMenu extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final host = ref.watch(hrHostProvider);
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
        if (value == 'exit') host.exit();
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
        // Embedded, the account belongs to the host: signing out here would
        // sign the whole app out of Supabase, and the branch is picked there.
        if (!host.ownsAccount)
          PopupMenuItem(
            value: 'exit',
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.arrow_back,
                size: 18,
                color: HrTokens.ink2,
              ),
              title: Text(context.flipperL10n.hrBackToFlipper),
            ),
          ),
        if (host.ownsAccount)
          PopupMenuItem(
            value: 'switch',
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.swap_horiz,
                size: 18,
                color: HrTokens.ink2,
              ),
              title: Text(context.flipperL10n.hrSwitchBusinessOrBranch),
            ),
          ),
        if (host.ownsAccount)
          PopupMenuItem(
            value: 'signOut',
            child: ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.logout, size: 18, color: HrTokens.ink2),
              title: Text(
                isSigningOut
                    ? context.flipperL10n.hrSigningOut
                    : context.flipperL10n.signOut,
              ),
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

  /// A phone's bottom bar holds five targets comfortably. Past that, the first
  /// four stay and the fifth opens the drawer, which lists everything.
  static const maxVisible = 5;

  @override
  Widget build(BuildContext context) {
    final overflow = destinations.length > maxVisible;
    final visible = overflow
        ? destinations.take(maxVisible - 1).toList()
        : destinations;
    final idx = _indexOf(visible, location);
    final current = _indexOf(destinations, location);
    // Somewhere only the drawer reaches: light up "More".
    final onHidden = overflow && current >= visible.length;
    return NavigationBar(
      key: const Key('hr-module-nav'),
      backgroundColor: HrTokens.surface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: HrTokens.accentTint,
      selectedIndex: onHidden ? visible.length : idx,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (i) {
        if (overflow && i == visible.length) {
          Scaffold.of(context).openDrawer();
          return;
        }
        context.go(visible[i].path);
      },
      destinations: [
        for (final d in visible)
          NavigationDestination(
            key: Key('hr-nav-${d.path.replaceAll('/', '')}'),
            icon: Icon(d.icon, color: HrTokens.ink3),
            selectedIcon: Icon(d.icon, color: HrTokens.accent),
            label: d.label,
          ),
        if (overflow)
          NavigationDestination(
            key: const Key('hr-nav-more'),
            icon: const Icon(Icons.menu, color: HrTokens.ink3),
            selectedIcon: const Icon(Icons.menu, color: HrTokens.accent),
            label: context.flipperL10n.more,
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
    // The same Flipper logo the POS shows above its rail.
    return PosHandoffIcons.svg('flipper-logo', size: 26);
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
  const selfService = {'/my-time', '/leave', '/my-pay'};

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
    HrNavGroup(title: FlipperL10n.current.hrNavYou, destinations: mine),
  ];
}

/// The modules this session may open, in nav order.
/// Below this width the shell is a phone layout: no sidebar, a header bar.
const double hrSidebarBreakpoint = 840;

/// The name of the page at [location]: its destination's label, or the
/// module's name where no destination matches.
String hrTitleFor(List<HrDestination> destinations, String location) {
  for (final d in destinations) {
    if (location == d.path || location.startsWith('${d.path}/')) {
      return d.label;
    }
  }
  return FlipperL10n.current.hrAndPayroll;
}

/// Back, inside the mobile app: up one level from a detail page (one person's
/// pay → Payroll), out to Flipper from a top-level one.
void hrEmbeddedBack(BuildContext context, HrHost host, String location) {
  final parent = hrParentPath(location);
  if (parent != null) {
    context.go(parent);
  } else {
    host.exit();
  }
}

/// `/pay/e-1` → `/pay`; null for a top-level page.
String? hrParentPath(String location) {
  final segments = Uri.parse(location).pathSegments;
  if (segments.length < 2) return null;
  return '/${segments.sublist(0, segments.length - 1).join('/')}';
}

List<HrDestination> hrDestinationsFor(HrSession session) {
  final destinations = <HrDestination>[];
  final l10n = FlipperL10n.current;
  if (session.canManageRoster) {
    destinations.add(
      HrDestination(
        path: '/overview',
        label: l10n.home,
        icon: Icons.space_dashboard_outlined,
      ),
    );
  }
  if (session.canManageRoster || session.landing == HrLanding.unresolved) {
    destinations.add(
      HrDestination(
        path: '/people',
        label: l10n.hrPeople,
        icon: Icons.groups_outlined,
      ),
    );
  }
  if (session.canManageRoster) {
    destinations.add(
      HrDestination(
        path: '/pay',
        label: l10n.hrPayroll,
        icon: Icons.payments_outlined,
      ),
    );
    destinations.add(
      HrDestination(
        path: '/attendance',
        label: l10n.hrAttendance,
        icon: Icons.schedule_outlined,
      ),
    );
  }
  if (session.canApproveLeave) {
    destinations.add(
      HrDestination(
        path: '/approvals',
        label: l10n.hrApprovals,
        icon: Icons.fact_check_outlined,
      ),
    );
  }
  if (session.hasOwnRecord) {
    destinations.add(
      HrDestination(
        path: '/my-time',
        label: l10n.hrMyTime,
        icon: Icons.timer_outlined,
      ),
    );
    destinations.add(
      HrDestination(
        path: '/leave',
        label: l10n.hrMyLeave,
        icon: Icons.beach_access_outlined,
      ),
    );
    destinations.add(
      HrDestination(
        path: '/my-pay',
        label: l10n.hrMyPay,
        icon: Icons.receipt_long_outlined,
      ),
    );
  }
  return destinations;
}
