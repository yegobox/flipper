import 'package:flipper_web/features/home/theme/books_home_theme.dart';
import 'package:flipper_web/features/home/widgets/books_home_widgets.dart';
import 'package:flipper_web/features/login/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Light/dark switch for the marketing page.
///
/// It drives the app-wide [themeProvider] (light by default), so the choice
/// carries through to sign-in and the workspace behind it.
class BooksThemeToggle extends ConsumerWidget {
  const BooksThemeToggle({super.key, this.size = 38});

  final double size;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    // Semantics rather than Tooltip: the header sits inside a pinned
    // SliverAppBar's LayoutBuilder, where an overlay-backed Tooltip is the
    // known trigger for the `!_skipMarkNeedsLayout` assert.
    return Semantics(
      button: true,
      label: isDark ? 'Switch to light mode' : 'Switch to dark mode',
      child: PressScale(
        onTap: () => ref.read(themeProvider.notifier).toggle(),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.wash(0.03),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.line2),
          ),
          child: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            size: size * 0.48,
            color: AppColors.ink2,
          ),
        ),
      ),
    );
  }
}

/// Row form of [BooksThemeToggle] for the compact nav sheet.
class BooksThemeToggleTile extends ConsumerWidget {
  const BooksThemeToggleTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
        size: 20,
        color: AppColors.ink2,
      ),
      title: Text(
        isDark ? 'Light mode' : 'Dark mode',
        style: AppText.body.copyWith(color: AppColors.ink1),
      ),
      onTap: () => ref.read(themeProvider.notifier).toggle(),
    );
  }
}
