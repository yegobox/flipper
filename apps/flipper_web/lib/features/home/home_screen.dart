import 'package:flipper_web/features/home/books_home_page.dart';
import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Public entry for the Flipper Books marketing landing page.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Theme(
      data: BooksHomeTheme.data,
      child: const BooksHomePage(),
    );
  }
}
