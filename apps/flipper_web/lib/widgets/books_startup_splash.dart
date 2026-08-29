import 'package:flutter/material.dart';

/// macOS has no [flutter_native_splash] native target — show the Books logo
/// while async startup runs before the real [MaterialApp] mounts.
class BooksStartupSplash extends StatelessWidget {
  const BooksStartupSplash({super.key});

  static const _logoPath = 'assets/accounting_logo_transparent.png';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image(
            image: AssetImage(_logoPath),
            width: 128,
            height: 128,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
