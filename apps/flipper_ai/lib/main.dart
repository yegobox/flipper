// lib/main.dart
// Standalone AI App - Uses flipper_auth for authentication
// AI feature is provided by flipper_ai_feature package

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_auth/features/auth/views/login_screen.dart';
import 'package:flipper_ai_feature/flipper_ai_feature.dart';
import 'package:flipper_models/secrets.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase (same configuration as flipper_auth and flipper app)
  await Supabase.initialize(
    url: AppSecrets.superbaseurl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  
  runApp(const ProviderScope(child: AiApp()));
}

class AiApp extends StatefulWidget {
  const AiApp({super.key});

  @override
  State<AiApp> createState() => _AiAppState();
}

class _AiAppState extends State<AiApp> {
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
      title: 'Flipper AI',
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const LoginScreen(), // Reuse flipper_auth login
        '/home': (context) => const AiScreen(), // Use AiScreen from flipper_ai_feature
      },
    );
  }
}
