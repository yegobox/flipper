import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flipper_rw/gate.dart';
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
import 'package:flipper_login/login.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stacked_themes/stacked_themes.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flutterfire_ui/i10n.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:google_ui/google_ui.dart';

import 'init.dart'
    if (dart.library.html) 'web_init.dart'
    if (dart.library.io) 'io_init.dart';

final isWindows = UniversalPlatform.isWindows;
final isMacOs = UniversalPlatform.isMacOS;
final isAndroid = UniversalPlatform.isAndroid;
final isWeb = UniversalPlatform.isWeb;
Future<void> backgroundHandler(RemoteMessage message) async {
  ProxyService.notification.display(message);
}

class FlipperHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = FlipperHttpOverrides();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await GetStorage.init();
  // done init in mobile.//done separation.
  setupLocator();
  await initDb();

  await ThemeManager.initialise();

  (!isWindows) ? FirebaseMessaging.onBackgroundMessage(backgroundHandler) : '';
  runZonedGuarded<Future<void>>(() async {
    await SentryFlutter.init(
      (options) {
        options.dsn =
            'https://f3b8abd190f84fa0abdb139178362bc2@o205255.ingest.sentry.io/6067680';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = 1.0;
      },
    );

    final router = GoRouter(
      initialLocation: Routes.home,
      refreshListenable: loginInfo,
      redirect: (state) {
        final bool loggedIn = loginInfo.isLoggedIn;
        final bool needSignUp = loginInfo.needSignUp;
        final onHome = state.subloc == Routes.home;
        final onLogin = state.subloc == Routes.login;
        final onNoNet = state.subloc == Routes.noNet;
        final String country = loginInfo.country.replaceAll(" ", "");
        final onSignUp = state.subloc == Routes.signup + "/$country";
        final bool noNet = loginInfo.noNet;

        final routeWithRedirectRules = [
          Routes.signup + "/$country",
          Routes.login,
          Routes.noNet,
          Routes.home,
        ];
        if (loggedIn &&
            !onHome &&
            routeWithRedirectRules.contains(state.subloc)) {
          return Routes.home;
        }
        if (needSignUp &&
            !onSignUp &&
            routeWithRedirectRules.contains(state.subloc)) {
          return Routes.signup + "/$country";
        }
        if (!loggedIn &&
            !onLogin &&
            routeWithRedirectRules.contains(state.subloc)) {
          return Routes.login;
        }
        if (noNet &&
            !onNoNet &&
            routeWithRedirectRules.contains(state.subloc)) {
          return Routes.noNet;
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
    ErrorWidget.builder = (details) => Material(
          key: const PageStorageKey('error'),
          child: Scaffold(
            body: SafeArea(
                child: Center(
              child: Column(
                children: [
                  Text('Error: ${details.exception.toString()}'),
                  ElevatedButton(
                    child: const Text('Retry'),
                    onPressed: () {},
                    style: ButtonStyle(
                      shape: MaterialStateProperty.resolveWith((states) {
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0),
                        );
                      }),
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.pressed)) {
                            return const ColorScheme.light().primary;
                          } else if (states.contains(MaterialState.disabled)) {
                            return Colors.grey.withOpacity(0.5);
                          }
                          return const ColorScheme.light().primary;
                        },
                      ),
                    ),
                  )
                ],
              ),
            )),
          ),
        );
    runApp(
      OverlaySupport.global(
        child: ChangeNotifierProvider.value(
          value: loginInfo,
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'flipper',
            // Define the light theme for the app, based on defined colors and
            // properties above.
            theme: GThemeGenerator.generate(),

            darkTheme: GThemeGenerator.generateDark(),

            localizationsDelegates: [
              FlutterFireUILocalizations.withDefaultOverrides(
                const LabelOverrides(),
              ),
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
            // themeMode: model.settingService.themeMode.value,
            themeMode: ThemeMode.system,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
          ),
        ),
      ),
    );
  }, (error, stack) async {
    await Sentry.captureException(error, stackTrace: stack);
    if (!isWindows) {
      recordBug(error, stack);
    }
  });
}
