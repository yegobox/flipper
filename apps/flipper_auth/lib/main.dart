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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auth App',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/home': (context) => const TOTPScreen(),
      },
    );
  }
}
