import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// macOS has no [flutter_native_splash] native target — show the Books logo
/// while async startup runs before the real [MaterialApp] mounts.
class BooksStartupSplash extends StatelessWidget {
  const BooksStartupSplash({super.key});

  static const _logoPath = 'assets/icons/flipper-logo.svg';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SvgPicture(
            SvgAssetLoader(_logoPath),
            width: 96,
            height: 96,
          ),
        ),
      ),
    );
  }
}
