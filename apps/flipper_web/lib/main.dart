import 'package:flipper_web/core/secrets.dart' show AppSecrets;
// router and auth wiring moved to router_provider
import 'package:flipper_web/features/login/theme_provider.dart';
import 'package:flipper_web/core/localization/locale_provider.dart';
import 'package:flipper_web/router/router_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// go_router is used via the provider
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_web/l10n/app_localizations.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_web/services/ditto_service.dart';

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

  // Initialize Ditto
  await _initDitto();

  runApp(const ProviderScope(child: MyApp()));
}

/// Initializes Ditto with proper configuration for the Flipper app
Future<void> _initDitto() async {
  final appID = kDebugMode ? AppSecrets.appIdDebug : AppSecrets.appId;

  await Ditto.init();

  final identity = OnlinePlaygroundIdentity(
    appID: appID,
    token: kDebugMode
        ? 'd8b7ac92-004a-47ac-a052-ea8d92d5869f' // dev token
        : 'd8b7ac92-004a-47ac-a052-ea8d92d5869f',
    enableDittoCloudSync: false, // Required to be false to use custom URLs
  );

  final ditto = await Ditto.open(identity: identity);

  ditto.updateTransportConfig((config) {
    // Clear any existing configs first to prevent conflicts
    config.connect.webSocketUrls.clear();

    if (kIsWeb) {
      // For web, ensure P2P is completely disabled
      config.setAllPeerToPeerEnabled(false);
      // Add cloud sync URL
      config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
    } else {
      // Enable P2P for mobile/desktop
      config.setAllPeerToPeerEnabled(true);
      // Add cloud sync URL
      config.connect.webSocketUrls.add("wss://$appID.cloud.ditto.live");
    }
  });

  // Set device name for debugging
  final platformTag = kIsWeb ? "Web" : "Mobile";
  ditto.deviceName = "Flipper $platformTag (${ditto.deviceName})";

  // Disable DQL strict mode for flexibility
  await ditto.store.execute("ALTER SYSTEM SET DQL_STRICT_MODE = false");

  ditto.startSync();

  // Store the initialized Ditto instance in the service
  DittoService.instance.setDitto(ditto);
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
