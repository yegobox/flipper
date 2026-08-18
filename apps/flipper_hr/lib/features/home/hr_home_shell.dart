import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Signed-in HR chrome: the app bar, the account menu, and the module nav.
///
/// Wraps every HR page rather than hosting one, because HR now has more than one
/// module and two audiences. Which destinations appear is decided by
/// [hrSessionProvider] — what the database can prove about the session — not by a
/// flag the client sets: an employee who cannot read the roster must not be shown
/// a tab that will only fail.
class HrHomeShell extends ConsumerStatefulWidget {
  const HrHomeShell({super.key, required this.child});

  /// The active route's page.
  final Widget child;

  @override
  ConsumerState<HrHomeShell> createState() => _HrHomeShellState();
}

class _HrHomeShellState extends ConsumerState<HrHomeShell> {
  bool _isSigningOut = false;

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
    final profile = ref.watch(currentUserProfileProvider).value;
    final business = ref.watch(selectedBusinessProvider);
    final branch = ref.watch(selectedBranchProvider);
    // A session that has not resolved yet shows no destinations rather than a
    // guess: flashing a People tab at an employee and taking it away again is
    // worse than a beat of nothing.
    final session = ref.watch(hrSessionProvider).value ?? HrSession.none;
    final destinations = hrDestinationsFor(session);
    final location = GoRouterState.of(context).uri.path;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flipper HR'),
        actions: [
          if (business != null)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: Center(
                child: Text(
                  [business.name, branch?.name]
                      .where((v) => v != null && v.isNotEmpty)
                      .join(' · '),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ),
          PopupMenuButton<String>(
            key: const Key('hr-account-menu'),
            tooltip: 'Account',
            icon: const Icon(Icons.account_circle_outlined),
            onSelected: (value) {
              switch (value) {
                case 'switch':
                  context.go('/business-selection');
                case 'signOut':
                  _signOut();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                enabled: false,
                child: Text(profile?.phoneNumber ?? 'Signed in'),
              ),
              const PopupMenuDivider(),
              // Only useful to someone with more than one business to switch
              // between, which is exactly the roster-managing case.
              if (session.canManageRoster)
                const PopupMenuItem(
                  value: 'switch',
                  child: Text('Switch business or branch'),
                ),
              PopupMenuItem(
                value: 'signOut',
                child: Text(_isSigningOut ? 'Signing out…' : 'Sign out'),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: widget.child,
      // One destination is not a choice; a bar of one tab is chrome that does
      // nothing. Self-service employees see no nav at all.
      bottomNavigationBar: destinations.length < 2
          ? null
          : NavigationBar(
              key: const Key('hr-module-nav'),
              selectedIndex: _indexOf(destinations, location),
              onDestinationSelected: (index) =>
                  context.go(destinations[index].path),
              destinations: [
                for (final d in destinations)
                  NavigationDestination(
                    key: Key('hr-nav-${d.path.replaceAll('/', '')}'),
                    icon: Icon(d.icon),
                    label: d.label,
                  ),
              ],
            ),
    );
  }

  /// The destination whose path the current location sits under, or 0.
  ///
  /// Prefix-matched so a future detail route (`/people/<id>`) keeps its parent
  /// tab selected instead of resetting the bar.
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
///
/// Pure function of the session so the rule is testable without a router: an
/// owner gets the roster and the approvals queue; anyone with their own record
/// gets their leave; a session that resolves to nothing gets the roster entry so
/// the People page can show its access diagnostic rather than a blank shell.
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
        path: '/approvals',
        label: 'Approvals',
        icon: Icons.fact_check_outlined,
      ),
    );
  }
  if (session.hasOwnRecord) {
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
