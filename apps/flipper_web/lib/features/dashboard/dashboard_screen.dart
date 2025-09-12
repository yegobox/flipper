
import 'package:flipper_web/features/login/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () {
              ref.read(themeProvider.notifier).state =
                  themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to your Dashboard!'),
      ),
    );
  }
}
