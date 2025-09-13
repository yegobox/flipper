import 'package:flipper_web/features/dashboard/widgets/performance_dashboard.dart';
import 'package:flipper_web/features/dashboard/widgets/quick_actions.dart';
import 'package:flipper_web/features/dashboard/widgets/setup_progress.dart';
import 'package:flipper_web/features/dashboard/widgets/side_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SideNavBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        SetupProgress(),
                        SizedBox(height: 16),
                        PerformanceDashboard(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(flex: 1, child: QuickActions()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
