import 'package:flipper_dashboard/login_choices.dart';
import 'package:flipper_dashboard/printing.dart';
import 'package:flipper_dashboard/backup.dart';
import 'package:flipper_dashboard/tax_configuration.dart';
import 'package:flipper_dashboard/add_discount.dart';
import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/devices.dart';
import 'package:flipper_dashboard/drawer.dart' as drawer;
import 'package:flipper_dashboard/no_net.dart';
import 'package:flipper_dashboard/after_sale.dart';
import 'package:flipper_dashboard/collect_cash.dart';
import 'package:flipper_dashboard/create/add_category.dart';
import 'package:flipper_dashboard/create/add_variation.dart';
import 'package:flipper_dashboard/create/color_tile.dart';
import 'package:flipper_dashboard/create/list_categories.dart';
import 'package:flipper_dashboard/create/list_units.dart';
import 'package:flipper_dashboard/create/receive_stock.dart';
import 'package:flipper_dashboard/customers.dart';
import 'package:flipper_dashboard/flipper_app.dart';
import 'package:flipper_dashboard/inapp_browser.dart';
import 'package:flipper_dashboard/order.dart';
import 'package:flipper_dashboard/payment_options.dart';
import 'package:flipper_dashboard/scanner_view.dart';
import 'package:flipper_dashboard/sell.dart';
import 'package:flipper_dashboard/setting_secreen.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_dashboard/switch_branch_view.dart';
import 'package:flipper_dashboard/transactions_details.dart';
import 'package:flipper_dashboard/tenant_add.dart';
import 'package:flipper_login/pin_login.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_socials/ui/views/home/home_view.dart';
import 'package:flipper_socials/ui/views/startup/social_startup_view.dart';
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:flipper_login/login.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/isar_models.dart';

final router = GoRouter(
  initialLocation: Routes.coldStart,
  refreshListenable: loginInfo,
  redirect: (state) {
    final bool loggedIn = loginInfo.isLoggedIn;
    final bool needSignUp = loginInfo.needSignUp;
    final coldStart = state.subloc == Routes.coldStart;
    final onLogin = state.subloc == Routes.login;
    final onNoNet = state.subloc == Routes.noNet;
    final String country = loginInfo.country.replaceAll(" ", "");
    final onSignUp = state.subloc == "${Routes.signup}/$country";
    final bool noNet = loginInfo.noNet;
    final bool loginChoices = loginInfo.loginChoices;
    final onTenants = state.subloc == Routes.tenants;
    final routeWithRedirectRules = [
      "${Routes.signup}/$country",
      Routes.login,
      Routes.noNet,
      Routes.coldStart,
      Routes.tenants,
    ];

    if (needSignUp &&
        !onSignUp &&
        routeWithRedirectRules.contains(state.subloc)) {
      return "${Routes.signup}/$country";
    }

    if (loggedIn &&
        !coldStart &&
        routeWithRedirectRules.contains(state.subloc)) {
      return Routes.coldStart;
    }

    if (!loggedIn &&
        !onLogin &&
        !needSignUp &&
        !loginChoices &&
        routeWithRedirectRules.contains(state.subloc)) {
      return Routes.login;
    }

    if (noNet &&
        !onNoNet &&
        !onLogin &&
        !coldStart && // because if we are on home we don't need this condition
        routeWithRedirectRules.contains(state.subloc)) {
      return Routes.noNet;
    }

    if (loginChoices &&
        !onTenants &&
        !loggedIn &&
        routeWithRedirectRules.contains(state.subloc)) {
      return Routes.tenants;
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/boot',
      name: 'boot',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const StartUpView(),
      ),
    ),
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const StartUpView(),
      ),
    ),
    GoRoute(
      path: '/signup/:country',
      name: 'signup',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: SignUpFormView(
          countryNm: state.params['country']!,
        ),
      ),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const FlipperApp(),
      ),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const LoginView(),
      ),
    ),
    GoRoute(
      path: '/create/:handle',
      name: 'create',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const AddProductView(),
      ),
    ),
    GoRoute(
      path: '/edit/:handle/:id',
      name: 'edit',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: AddProductView(
          productId: int.parse(state.params['id']!),
        ),
      ),
    ),
    GoRoute(
      path: '/discount',
      name: 'discount',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const AddDiscount(),
      ),
    ),
    GoRoute(
      path: '/categories',
      name: 'categories',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: ListCategories(
          categories: state.extra! as List<Category>,
        ),
      ),
    ),
    GoRoute(
      path: '/colors',
      name: 'colors',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ColorTile(),
      ),
    ),
    GoRoute(
      path: '/stock/:id/:stock',
      name: 'stock',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: ReceiveStock(
          variantId: int.parse(state.params['id']!),
          existingStock: state.params['stock']!,
        ),
      ),
    ),
    GoRoute(
      path: '/variation/:productId',
      name: 'variation',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: AddVariation(
          productId: int.parse(state.params['productId']!),
        ),
      ),
    ),
    GoRoute(
      path: '/category',
      name: 'category',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const AddCategory(),
      ),
    ),
    GoRoute(
      path: '/units/:type',
      name: 'units',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: ListUnits(
          type: state.params['type']!,
        ),
      ),
    ),

    GoRoute(
      path: '/sell',
      name: 'sell',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Sell(
          product: state.extra! as Product,
        ),
      ),
    ),
    // Pass the order object
    GoRoute(
      path: '/pay',
      name: 'pay',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Payments(
          order: state.extra! as Order,
        ),
      ),
    ),
    GoRoute(
      path: '/collect/:paymentType',
      name: 'collect',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: CollectCashView(
          paymentType: state.params['paymentType']!,
          order: state.extra! as Order,
        ),
      ),
    ),
    GoRoute(
      path: '/sale/:total/:receiptType',
      name: 'sale',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: AfterSale(
          totalOrderAmount: double.parse(state.params['total']!),
          receiptType: state.params['receiptType']!,
          order: state.extra! as Order,
        ),
      ),
    ),
    GoRoute(
      path: '/trDetail',
      name: 'trDetail',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: TransactionDetail(
          order: state.extra! as Order,
        ),
      ),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: SettingsScreen(),
      ),
    ),
    GoRoute(
      path: '/switchBranch',
      name: 'switchBranch',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: SwitchBranchView(),
      ),
    ),
    GoRoute(
      path: Routes.analytics,
      name: 'analytics',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        // child: Analytics(),
        child: const Text("analytics were here"),
      ),
    ),
    GoRoute(
      path: "/scann/:intent",
      name: 'scann',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: ScannView(
          intent: state.params['intent']!,
        ),
      ),
    ),
    GoRoute(
      path: '/order',
      name: 'order',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: OrderView(),
      ),
    ),
    GoRoute(
      path: '/browse',
      name: 'browse',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const InAppBrowser(),
      ),
    ),
    GoRoute(
      path: '/customers/:orderId',
      name: 'customers',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Customers(
          orderId: int.parse(state.params['orderId']!),
        ),
      ),
    ),
    GoRoute(
      path: '/nonetwork',
      name: 'nonetwork',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const NoNet(),
      ),
    ),
    GoRoute(
      path: '/pin',
      name: 'pin',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: PinLogin(),
      ),
    ),
    GoRoute(
      path: '/devices/:pin',
      name: 'devices',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: Devices(pin: int.parse(state.params['pin']!)),
      ),
    ),
    GoRoute(
      path: '/tax_config',
      name: 'tax_config',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const TaxConfiguration(),
      ),
    ),
    GoRoute(
      path: '/printing',
      name: 'printing',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const Printing(),
      ),
    ),
    GoRoute(
      path: '/backup',
      name: 'backup',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const BackUp(),
      ),
    ),
    GoRoute(
      path: '/drawer/:state',
      name: 'drawer',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: drawer.DrawerScreen(
          open: state.params['state']!,
          drawer: state.extra != null ? state.extra as Drawers : null,
        ),
      ),
    ),
    GoRoute(
      path: '/tenants',
      name: 'tenants',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const LoginChoices(),
      ),
    ),
    GoRoute(
      path: '/tenant_add',
      name: 'tenant_add',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const TenantAdd(),
      ),
    ),

    /// socials routes
    GoRoute(
      path: '/cold-start',
      name: 'cold-start',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const ColdStartView(),
      ),
    ),
    GoRoute(
      path: '/onboarding',
      name: 'onboarding',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SocialHomeView(),
      ),
    ),
  ],
);
