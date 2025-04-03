import 'package:flutter/material.dart';
import 'screens/inventory_dashboard_screen.dart';

class InventoryDashboardApp extends StatelessWidget {
  const InventoryDashboardApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the parent context's theme instead of defining a new one
    return const Material(
      child: InventoryDashboardScreen(),
    );
  }
}
