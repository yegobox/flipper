import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_localize/flipper_localize.dart';

class TestApp extends StatelessWidget {
  final Widget child;

  const TestApp({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        home: Scaffold(body: child),
        localizationsDelegates: [...FlipperLocalizationDelegates.delegates],
        supportedLocales: FlipperLocalizationDelegates.supportedLocales,
      ),
    );
  }
}
