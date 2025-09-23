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
      backgroundColor: const Color(0xFFF9FAFB),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SideNavBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const SetupProgress(),
                          const SizedBox(height: 24),
                          const PerformanceDashboard(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 24),
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
