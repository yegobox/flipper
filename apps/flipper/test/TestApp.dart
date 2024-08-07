import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: child,
        localizationsDelegates: [
          // Add your localization delegates here
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('es'),
        ],
      ),
    );
  }
}
