import 'package:flipper_web/features/dashboard/widgets/performance_metrics.dart';
import 'package:flipper_web/features/dashboard/widgets/sales_chart.dart';
import 'package:flutter/material.dart';

class PerformanceDashboard extends StatelessWidget {
  const PerformanceDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [const PerformanceMetrics()],
        ),
      ),
    );
  }
}
