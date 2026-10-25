import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flipper_web/core/routing/app_entry_route.dart';
import 'package:flipper_web/features/apps/apps_screen.dart';
import 'package:flipper_web/features/login/auth_providers.dart' as login_auth;
import 'package:flipper_web/features/login/auth_wrapper.dart';
import 'package:flipper_web/features/billing/presentation/books_billing_gate.dart';
import 'package:flipper_web/features/billing/presentation/books_subscribe_page.dart';
import 'package:flipper_web/modules/accounting/accounting_module.dart';
import 'package:flipper_web/features/login/pin_screen.dart';
import 'package:flipper_web/features/login/signup_view.dart';
import 'package:flipper_web/features/business_selection/business_selection_wrapper.dart';
import 'package:flipper_web/features/custom_payment/presentation/custom_payment_page.dart';
import 'package:flipper_web/features/pos/pos_route_page.dart';
import 'package:flipper_web/features/shop/shop_route_page.dart';
import 'package:flipper_web/router/app_redirect.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  final authRefresh = ValueNotifier<int>(0);

  // Listen to auth state and trigger refreshes
  ref.listen<AsyncValue<login_auth.AuthState>>(
    login_auth.authStateProvider,
    (_, __) => authRefresh.value++,
  );

  ref.onDispose(() {
    authRefresh.dispose();
  });

  final authState = ref.watch(login_auth.authStateProvider);

  return GoRouter(
    refreshListenable: authRefresh,
    initialLocation:
        shopDeepLinkLocation(Uri.base) ?? unauthenticatedEntryLocation,
    observers: [createPostHogObserver()],
    routes: [
      // Root shows AuthWrapper which will choose appropriate screen
      GoRoute(path: '/', builder: (context, state) => const AuthWrapper()),
      // Public routes
      // Named: sign-out paths navigate with goNamed(AppRoute.login.name).
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const PinScreen(),
      ),
      GoRoute(path: '/signup', builder: (context, state) => const SignupView()),
      // Public: the apps and the Atlas launcher download, signed in or out.
      GoRoute(path: '/apps', builder: (context, state) => const AppsScreen()),
      // Business selection screen after authentication
      GoRoute(
        path: '/business-selection',
        name: 'businessSelection',
        builder: (context, state) => const BusinessSelectionWrapper(),
      ),
      // Books sits behind the subscription: the gate reads the business's
      // shared `plans` row and shows the paywall until it is paid.
      GoRoute(
        path: '/accounting',
        name: 'accounting',
        builder: (context, state) =>
            const BooksBillingGate(child: AccountingModuleScreen()),
      ),
      // The POS, opened from Books' app launcher. Same subscription rule as
      // Books (and the native app): a paid business, or the paywall.
      GoRoute(
        path: '/pos',
        name: 'pos',
        pageBuilder: (context, state) => const NoTransitionPage(
          // NoTransitionPage: the POS mounts the Stacked navigator, whose
          // global key must never be in the tree twice mid-transition.
          child: BooksBillingGate(child: PosRoutePage()),
        ),
      ),
      // The paywall itself — auth-protected, never billing-gated. `planId` is
      // set when Dodo redirects back after a card checkout.
      GoRoute(
        path: '/subscribe',
        name: 'subscribe',
        builder: (context, state) => BooksSubscribePage(
          resumePlanId: state.uri.queryParameters['planId'],
        ),
      ),
      // Staff-only: negotiated-price subscription payments. Auth is checked
      // here; the staff allowlist is checked by the page (it is async) and,
      // independently, by the connector.
      GoRoute(
        path: '/custom-payment',
        name: 'customPayment',
        builder: (context, state) => const CustomPaymentPage(),
      ),
      // Public: a business's online shop. Customers order without an
      // account; see `features/shop`.
      GoRoute(
        path: '/shop/:slug',
        builder: (context, state) => ShopRoutePage(
          route: ShopRoute.catalog,
          slug: state.pathParameters['slug']!,
        ),
        routes: [
          GoRoute(
            path: 'checkout',
            builder: (context, state) => ShopRoutePage(
              route: ShopRoute.checkout,
              slug: state.pathParameters['slug']!,
            ),
          ),
          GoRoute(
            path: 'order/:id',
            builder: (context, state) => ShopRoutePage(
              route: ShopRoute.order,
              slug: state.pathParameters['slug']!,
              orderId: state.pathParameters['id'],
              token: state.uri.queryParameters['t'],
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        redirect: (context, state) => '/accounting',
      ),
    ],
    redirect: (context, state) => appRedirect(
      path: state.uri.path,
      authenticated: authState is AsyncLoading
          ? null
          : authState.maybeWhen(
              data: (s) => s == login_auth.AuthState.authenticated,
              orElse: () => false,
            ),
      opensOnLoginScreen: opensOnLoginScreen,
    ),
  );
});
