// router and auth wiring moved to router_provider
import 'package:flipper_web/features/login/theme_provider.dart';
import 'package:flipper_web/core/localization/locale_provider.dart';
import 'package:flipper_web/router/router_provider.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flutter/material.dart';
// go_router is used via the provider
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/l10n/app_localizations.dart';
import 'package:flipper_web/modules/accounting/data/accounting_backend_config.dart';
import 'package:flipper_web/core/utils/initialization.dart';
import 'package:flipper_web/core/utils/http_overrides.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Run any critical IO-only initialization (sets HttpOverrides and trusted certs)
  // This is awaited so subsequent
  // initialization and network clients pick up the settings.
  await initializeCriticalDependencies();

  // Initialize Supabase
  await initializeSupabase();

  // Ditto initializes after login via DittoBootstrap (needs pin user id).
  debugPrint(
    '[flipper_web] startup: Supabase ready; Ditto initializes after login',
  );
  AccountingBackendConfig.logStartupConfig();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(localeProvider);
    // notify GoRouter to refresh when auth state changes
    // Use the GoRouter provided by Riverpod
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flipper',
      theme: FlipperTheme.light(),
      darkTheme: FlipperTheme.dark(),
      themeMode: themeMode,
      locale: locale,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('fr'), Locale('sw')],
    );
  }
}
