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

  flipperWebIsHostApp = true;
  postSelectionRouteName = HrRoute.home;
  brandPanelBuilder = (_) => const HrBrandPanel();

  await initializeCriticalDependencies();
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
      // Light only, deliberately. The signed-in chrome (sidebar, topbar, rail)
      // is a fixed light token set mirroring flipper_web's accounting shell, so
      // following the OS theme put dark Material pages inside white chrome —
      // the split visible on the subscribe screen. One theme until the shell
      // has a dark palette of its own.
      themeMode: ThemeMode.light,
      routerConfig: ref.watch(hrRouterProvider),
      // Web-native: remove Android overscroll glow; keep momentum scrolling.
      scrollBehavior: kIsWeb ? const _WebScrollBehavior() : null,
    );
  }
}

/// Removes the rubber-band / glow overscroll effect on web.
class _WebScrollBehavior extends MaterialScrollBehavior {
  const _WebScrollBehavior();

  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) =>
      child;
}
