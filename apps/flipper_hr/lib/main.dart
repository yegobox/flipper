import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_hr/features/branding/hr_brand_panel.dart';
import 'package:flipper_hr/router/hr_router.dart';
import 'package:flipper_web/core/branding/brand_panel_builder.dart';
import 'package:flipper_web/core/flipper_web_host.dart';
import 'package:flipper_web/core/routing/post_selection_route.dart';
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/core/utils/http_overrides.dart';
import 'package:flipper_web/core/utils/initialization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // HR reuses flipper_web's auth stack, which stores login identity and the
  // sale device id in SharedPreferences when this is true. The alternative path
  // needs Flipper POS's GetIt-registered box, which HR never registers.
  flipperWebIsHostApp = true;

  // Where the shared business/branch selector lands once a branch is picked.
  postSelectionRouteName = HrRoute.home;

  // Sign-in and sign-up are flipper_web's screens; the right-hand panel is
  // ours, so HR does not sign people in under Books' branding.
  brandPanelBuilder = (_) => const HrBrandPanel();

  // Installs HttpOverrides / trusted certs before any http.Client is built.
  await initializeCriticalDependencies();

  // Same Supabase project as Books, so one account works in both apps.
  await initializeSupabase();

  await FlipperAnalytics.initialize(
    appName: 'flipper_hr',
    platformName: 'web',
    projectToken: AppSecrets.postHogProjectToken,
    store: SharedPreferencesAnalyticsEventStore(),
    contextProvider: CallbackAnalyticsContextProvider(
      appName: 'flipper_hr',
      platformName: 'web',
      buildMode: kDebugMode ? 'debug' : 'release',
    ),
  );

  runApp(const ProviderScope(child: FlipperHrApp()));
}

class FlipperHrApp extends ConsumerWidget {
  const FlipperHrApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Flipper HR',
      debugShowCheckedModeBanner: false,
      theme: FlipperTheme.light(allowRuntimeFontFetching: kIsWeb),
      darkTheme: FlipperTheme.dark(allowRuntimeFontFetching: kIsWeb),
      themeMode: ThemeMode.system,
      routerConfig: ref.watch(hrRouterProvider),
    );
  }
}
