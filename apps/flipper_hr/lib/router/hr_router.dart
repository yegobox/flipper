import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_hr/features/auth/hr_auth_gate.dart';
import 'package:flipper_hr/features/home/hr_home_shell.dart';
import 'package:flipper_hr/router/hr_redirect.dart';
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
  static const home = 'hrHome';
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
      GoRoute(
        path: '/people',
        name: HrRoute.home,
        builder: (context, state) => const HrHomeShell(),
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
