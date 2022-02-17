import 'package:flipper_login/login.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:flipper_models/models/models.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:google_ui/google_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';
import 'package:flipper_chat/omni/omni_contacts.dart';
import 'package:flipper_chat/omni_chat.dart';
import 'package:flipper_dashboard/add_discount.dart';
import 'package:flipper_dashboard/add_product_view.dart';
import 'package:flipper_dashboard/devices.dart';
import 'package:flipper_dashboard/no_net.dart';
import 'package:flipper_dashboard/after_sale.dart';
import 'package:flipper_dashboard/analytic.dart';
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
import 'package:flipper_dashboard/order_summary.dart';
import 'package:flipper_dashboard/payment_options.dart';
import 'package:flipper_dashboard/scanner_view.dart';
import 'package:flipper_dashboard/sell.dart';
import 'package:flipper_dashboard/setting_secreen.dart';
import 'package:flipper_dashboard/startup_view.dart';
import 'package:flipper_dashboard/switch_branch_view.dart';
import 'package:flipper_login/pin_login.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_routing/finance_app.dart';
import 'package:go_router/go_router.dart';

class LoginInfo extends ChangeNotifier {
  var _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;
  set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  var _needSignUp = false;
  bool get needSignUp => _needSignUp;
  set needSignUp(bool value) {
    _needSignUp = value;
    notifyListeners();
  }

  var _switchBranch = false;
  bool get switchBranch => _switchBranch;
  set switchBranch(bool value) {
    _switchBranch = value;
    notifyListeners();
  }

  var _country = "";
  String get country => _country;
  set country(String value) {
    _country = value;
    notifyListeners();
  }

  var _noNet = false;
  bool get noNet => _noNet;
  set noNet(bool value) {
    _noNet = value;
    notifyListeners();
  }
}

final loginInfo = LoginInfo();

class Gate extends StatefulWidget {
  const Gate({Key? key}) : super(key: key);

  @override
  State<Gate> createState() => _GateState();
}

class _GateState extends State<Gate> {
  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: Routes.boot,
      refreshListenable: loginInfo,
      redirect: (state) {
        final bool loggedIn = loginInfo.isLoggedIn;
        final bool needSignUp = loginInfo.needSignUp;
        final String country = loginInfo.country;
        final bool noNet = loginInfo.noNet;
        final bool needSwitchBranch = loginInfo.switchBranch;
        final bool isLogging = state.subloc == '/login';
        final bool isArleadyHome = state.subloc == '/home';
        final bool isArleadyNoNet = state.subloc == '/nonetwork';
        final bool isArleadySignup =
            state.subloc == Routes.signup + "/$country";
        if (noNet && isLogging) {
          return "/nonetwork";
        }
        if (needSwitchBranch && loggedIn) {
          return "/switchbranch";
        }
        if (loggedIn &&
            needSignUp &&
            !isArleadySignup &&
            !isArleadyHome &&
            !isLogging) {
          return Routes.signup + "/$country";
        }
        if (!loggedIn && !isLogging && !isArleadyNoNet) {
          return Routes.login;
        }
        // TODOif we don't check if we are aready on home page, the goRouter
        // will throw a loop error since we may push the page to the stack
        // more than once https://github.com/csells/go_router/discussions/364
        if (loggedIn && !isArleadyHome && !needSignUp) {
          return Routes.home;
        }
        if (loggedIn && !isLogging && !isArleadyHome && !needSignUp) {
          return Routes.home;
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
          path: '/omni',
          name: 'chat',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const OmniChat(),
          ),
        ),
        GoRoute(
          path: '/contacts',
          name: 'contacts',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const OmniContacts(),
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
          path: '/product',
          name: 'product',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const AddProductView(),
          ),
        ),
        GoRoute(
          path: '/product/:id',
          name: 'editProduct',
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
            child: AddDiscount(),
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
          path: '/stock/:id',
          name: 'stock',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: ReceiveStock(
              variantId: int.parse(state.params['id']!),
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
            child: AddCategory(),
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
          path: '/summary',
          name: 'summary',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: OrderSummary(),
          ),
        ),
        GoRoute(
          path: '/sell',
          name: 'sell',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: Sell(
              product: state.extra! as ProductSync,
            ),
          ),
        ),
        GoRoute(
          path: '/pay',
          name: 'pay',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: Payments(),
          ),
        ),
        GoRoute(
          path: '/collect/:paymentType',
          name: 'collect',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: CollectCashView(
              paymentType: state.params['paymentType']!,
            ),
          ),
        ),
        GoRoute(
          path: '/sale/:total',
          name: 'sale',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: AfterSale(
              totalOrderAmount: double.parse(state.params['total']!),
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
            child: Analytics(),
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
          path: '/finance',
          name: 'finance',
          pageBuilder: (context, state) => MaterialPage(
            key: state.pageKey,
            child: const FinanceApp(),
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
        )
      ],
    );
    return ViewModelBuilder<BusinessHomeViewModel>.reactive(
      viewModelBuilder: () => BusinessHomeViewModel(),
      onModelReady: (model) async {
        String? defaultLanguage = model.getSetting();

        defaultLanguage == null ? const Locale('en') : Locale(defaultLanguage);
      },
      builder: (context, model, child) {
        return ChangeNotifierProvider<LoginInfo>.value(
          value: loginInfo,
          child: OverlaySupport.global(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'flipper',
              // Define the light theme for the app, based on defined colors and
              // properties above.
              theme: GThemeGenerator.generate(),

              darkTheme: GThemeGenerator.generateDark(),

              localizationsDelegates: [
                FlutterFireUILocalizations.withDefaultOverrides(
                    const LabelOverrides()),
                const FlipperLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', 'US'), // English
                Locale('es', 'ES'), // Spanish
              ],
              locale: const Locale('en'),
              // locale: model
              //     .languageService.locale,
              themeMode: model.settingService.themeMode.value,
              routeInformationParser: router.routeInformationParser,
              routerDelegate: router.routerDelegate,
            ),
          ),
        );
      },
    );
  }
}
