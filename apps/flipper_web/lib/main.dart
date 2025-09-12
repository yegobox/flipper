import 'package:flipper_web/core/secrets.dart' show AppSecrets;
import 'package:flipper_web/core/utils/platform.dart';
import 'package:flipper_web/features/login/auth_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    supabaseAnonKey = AppSecrets.supabaseAnonKey;
  }
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flipper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const AuthWrapper(),
    );
  }
}
