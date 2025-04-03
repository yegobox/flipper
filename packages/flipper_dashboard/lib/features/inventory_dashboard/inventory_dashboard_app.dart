import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/inventory_dashboard_screen.dart';

class InventoryDashboardApp extends StatelessWidget {
  const InventoryDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Wrap with ProviderScope to enable Riverpod
    return const ProviderScope(
      child: Material(
        child: InventoryDashboardScreen(),
      ),
    );
  }
}
