// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flipper_auth/features/auth/views/login_screen.dart';
import 'package:flipper_auth/features/totp/views/totp_screen.dart';
import 'package:flipper_auth/core/secrets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppSecrets.superbaseurl,
    anonKey: AppSecrets.supabaseAnonKey,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  // Change to StatefulWidget
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState(); // Create a State
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Listen for auth changes and navigate accordingly
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        // User is signed in, navigate to home
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else if (event == AuthChangeEvent.signedOut) {
        // User is signed out, navigate to login
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine initial route based on current user
    final initialRoute =
        Supabase.instance.client.auth.currentUser == null ? '/' : '/home';

    return MaterialApp(
      title: 'Auth App',
      initialRoute: initialRoute, // Set initial route dynamically
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const TOTPScreen(),
      },
    );
  }
}
