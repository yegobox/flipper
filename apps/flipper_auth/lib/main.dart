// lib/main.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_auth/features/auth/views/login_screen.dart';
import 'package:flipper_auth/features/totp/views/totp_screen.dart';
import 'package:flipper_auth/core/secrets.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_web/core/localization/locale_provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppSecrets.superbaseurl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final StreamSubscription _authSub;
  @override
  void initState() {
    super.initState();
    // Listen for auth changes and navigate accordingly
    _authSub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        navigatorKey.currentState?.pushReplacementNamed('/home');
      } else if (event == AuthChangeEvent.signedOut) {
        navigatorKey.currentState?.pushReplacementNamed('/');
      }
    });
  }

  @override
  void dispose() {
    _authSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine initial route based on current user
    final initialRoute =
        Supabase.instance.client.auth.currentUser == null ? '/' : '/home';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Auth App',
      locale: ref.watch(localeProvider),
      localizationsDelegates: FlipperLocalizationDelegates.delegates,
      supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      initialRoute: initialRoute, // Set initial route dynamically
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const TOTPScreen(),
      },
    );
  }
}
