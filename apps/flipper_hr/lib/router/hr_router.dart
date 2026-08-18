import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_hr/features/attendance/attendance_page.dart';
import 'package:flipper_hr/features/billing/presentation/hr_billing_gate.dart';
import 'package:flipper_hr/features/billing/presentation/hr_subscribe_page.dart';
import 'package:flipper_hr/features/attendance/my_attendance_page.dart';
import 'package:flipper_hr/features/auth/hr_auth_gate.dart';
import 'package:flipper_hr/features/home/hr_branch_scope.dart';
import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/features/leave/leave_approvals_page.dart';
import 'package:flipper_hr/features/leave/my_leave_page.dart';
import 'package:flipper_hr/features/people/people_page.dart';
import 'package:flipper_hr/features/session/data/hr_session.dart';
import 'package:flipper_hr/features/session/data/hr_session_providers.dart';
import 'package:flipper_hr/router/hr_redirect.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/features/business_selection/business_selection_wrapper.dart';
import 'package:flipper_web/features/login/auth_providers.dart';
import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flipper_web/features/login/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Route names shared with flipper_web's login flow.
///
/// [PinScreen] navigates to `/business-selection` by path, and
/// [BusinessBranchSelector] uses the names `login` and
/// [postSelectionRouteName] — so both must exist here for the reused screens
/// to navigate correctly.
abstract final class HrRoute {
  static const login = 'login';
  static const signup = 'signup';
  static const businessSelection = 'businessSelection';

  /// The roster. Still the post-selection landing route, because picking a
  /// business only happens for someone who manages one.
  static const home = 'hrHome';

  /// Self-service leave. Reachable without a business selection.
  static const myLeave = 'hrMyLeave';

  /// The approvals queue: the open branch's for someone who manages the
  /// business, their own team's for a line manager.
  static const approvals = 'hrApprovals';

  /// The branch attendance board.
  static const attendance = 'hrAttendance';

  /// Own clock and timesheet. Reachable without a business selection, like
  /// [myLeave].
  static const myAttendance = 'hrMyAttendance';

  /// The paywall. Reachable while unpaid — it is the one manager surface that
  /// must not be behind the subscription it sells.
  static const subscribe = 'hrSubscribe';
}

final hrRouterProvider = Provider<GoRouter>((ref) {
  final authRefresh = ValueNotifier<int>(0);

  ref.listen<AsyncValue<AuthState>>(
    authStateProvider,
    (_, __) => authRefresh.value++,
  );
  ref.onDispose(authRefresh.dispose);

  final authState = ref.watch(authStateProvider);

  return GoRouter(
    refreshListenable: authRefresh,
    initialLocation: '/',
    observers: [createPostHogObserver()],
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HrAuthGate()),
      GoRoute(
        path: '/login',
        name: HrRoute.login,
        builder: (context, state) => const PinScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: HrRoute.signup,
        builder: (context, state) => const SignupView(),
      ),
      GoRoute(
        path: '/business-selection',
        name: HrRoute.businessSelection,
        builder: (context, state) => const BusinessSelectionWrapper(),
      ),
      // Everything below shares the signed-in chrome, so switching modules does
      // not rebuild the app bar or re-resolve the session.
      ShellRoute(
        builder: (context, state, child) => HrHomeShell(child: child),
        routes: [
          GoRoute(
            path: '/people',
            name: HrRoute.home,
            // Gated: the roster belongs to whoever runs the business, and they
            // are the one who can pay for it. Self-service leave and time below
            // are deliberately left open.
            builder: (context, state) => HrBillingGate(
              featureName: 'The roster',
              child: HrBranchScope(
                builder:
                    (
                      context, {
                      required businessId,
                      required branchId,
                      required branchName,
                    }) => PeoplePage(
                      businessId: businessId,
                      branchId: branchId,
                      branchName: branchName,
                    ),
              ),
            ),
          ),
          GoRoute(
            path: '/approvals',
            name: HrRoute.approvals,
            builder: (context, state) => const HrBillingGate(
              featureName: 'Approvals',
              child: _Approvals(),
            ),
          ),
          GoRoute(
            path: '/attendance',
            name: HrRoute.attendance,
            builder: (context, state) => HrBillingGate(
              featureName: 'The attendance board',
              child: HrBranchScope(
                builder:
                    (
                      context, {
                      required businessId,
                      required branchId,
                      required branchName,
                    }) => AttendancePage(
                      businessId: businessId,
                      branchId: branchId,
                      branchName: branchName,
                    ),
              ),
            ),
          ),
          GoRoute(
            path: '/leave',
            name: HrRoute.myLeave,
            builder: (context, state) => const MyLeavePage(),
          ),
          GoRoute(
            path: '/my-time',
            name: HrRoute.myAttendance,
            builder: (context, state) => const MyAttendancePage(),
          ),
          GoRoute(
            path: '/subscribe',
            name: HrRoute.subscribe,
            builder: (context, state) => const HrSubscribePage(),
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      if (authState is AsyncLoading) return null;

      return hrRedirectLocation(
        isAuthenticated: authState.maybeWhen(
          data: (s) => s == AuthState.authenticated,
          orElse: () => false,
        ),
        path: state.uri.path,
      );
    },
  );
});

/// Scopes the approvals queue, and reads the signed-in profile so a decision
/// records who made it.
///
/// Unlike the roster and the board, this route cannot simply demand a branch.
/// Since migration 0007 a line manager approves their own team's leave without
/// managing any business, so for them there is no selection to make and
/// [HrBranchScope] would strand them on "pick a branch" — the exact dead end the
/// auth gate avoids for self-service leave. The branch is therefore asked for only
/// when the session actually manages a business; everyone else gets the
/// team-scoped queue.
///
/// The decider is read here rather than threaded through the scope: it is an
/// identity concern, and the branch scope has no business knowing about it.
class _Approvals extends ConsumerWidget {
  const _Approvals();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    final deciderUserId = profile?.id;
    // Unresolved counts as "no business scope": the team queue works for
    // everybody, while the branch queue would show a selector to someone who has
    // nothing to select.
    final session = ref.watch(hrSessionProvider).value ?? HrSession.none;

    if (!session.canManageRoster) {
      return LeaveApprovalsPage(deciderUserId: deciderUserId);
    }
    return HrBranchScope(
      builder:
          (
            context, {
            required businessId,
            required branchId,
            required branchName,
          }) => LeaveApprovalsPage(
            branchId: branchId,
            branchName: branchName,
            deciderUserId: deciderUserId,
          ),
    );
  }
}
