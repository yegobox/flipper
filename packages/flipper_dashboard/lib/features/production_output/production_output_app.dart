import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/production_output_screen.dart';

/// Production Output feature app entry point
///
/// SAP Fiori-inspired design for tracking planned vs actual production output.
/// Follows the pattern from InventoryDashboardApp.
class ProductionOutputApp extends StatelessWidget {
  const ProductionOutputApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(
      child: Material(child: ProductionOutputScreen()),
    );
  }
}
