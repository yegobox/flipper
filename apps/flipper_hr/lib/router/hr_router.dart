import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_hr/features/auth/hr_auth_gate.dart';
import 'package:flipper_hr/features/home/hr_branch_scope.dart';
import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/features/leave/leave_approvals_page.dart';
import 'package:flipper_hr/features/leave/my_leave_page.dart';
import 'package:flipper_hr/features/people/people_page.dart';
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

  /// The branch approvals queue.
  static const approvals = 'hrApprovals';
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
            builder: (context, state) => HrBranchScope(
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
          GoRoute(
            path: '/approvals',
            name: HrRoute.approvals,
            builder: (context, state) => HrBranchScope(
              builder:
                  (
                    context, {
                    required businessId,
                    required branchId,
                    required branchName,
                  }) => _Approvals(
                    branchId: branchId,
                    branchName: branchName,
                  ),
            ),
          ),
          GoRoute(
            path: '/leave',
            name: HrRoute.myLeave,
            builder: (context, state) => const MyLeavePage(),
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

/// Reads the signed-in profile so a decision records who made it.
///
/// A thin wrapper rather than a parameter threaded through [HrBranchScope]: the
/// decider is an identity concern, and the branch scope has no business knowing
/// about it.
class _Approvals extends ConsumerWidget {
  const _Approvals({required this.branchId, required this.branchName});

  final String branchId;
  final String? branchName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(currentUserProfileProvider).value;
    return LeaveApprovalsPage(
      branchId: branchId,
      branchName: branchName,
      deciderUserId: profile?.id,
    );
  }
}
