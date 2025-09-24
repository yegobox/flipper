import 'package:flipper_web/core/secrets.dart' show AppSecrets;
// router and auth wiring moved to router_provider
import 'package:flipper_web/features/login/theme_provider.dart';
import 'package:flipper_web/core/localization/locale_provider.dart';
import 'package:flipper_web/router/router_provider.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// go_router is used via the provider
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_web/l10n/app_localizations.dart';

import 'core/utils/platform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String supabaseUrl;
  String supabaseAnonKey;

  if (kDebugMode) {
    if (isAndroid) {
      supabaseUrl = "http://10.0.2.2:54321";
    } else {
      supabaseUrl = AppSecrets.localSuperbaseUrl;
    }
    supabaseAnonKey = AppSecrets.localSupabaseAnonKey;
  } else {
    supabaseUrl = AppSecrets.superbaseurl;
    supabaseAnonKey = AppSecrets.supabaseAnonKeyPublishable;
  }
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  // Pre-initialize DittoService singleton if running on web
  // This ensures we handle the initialization in a controlled way before any
  // repository tries to use it
  if (kIsWeb) {
    // Get the singleton instance
    final dittoService = DittoService.instance;

    // Register web-specific hooks for cleanup
    dittoService.registerWebDisposeHooks();

    // Initialize in the background without waiting, so we don't block the app startup
    dittoService
        .initialize()
        .then((_) {
          debugPrint('DittoService pre-initialized successfully');
        })
        .catchError((error) {
          debugPrint('DittoService pre-initialization failed: $error');
          debugPrint('App will continue without offline sync capabilities');
        });
  }

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      darkTheme: ThemeData.dark(),
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
