import 'package:flutter/material.dart';
import '../models/production_output_models.dart';

/// SAP Fiori-inspired Smart Chart widget for variance visualization
///
/// Displays a combo chart with bars for planned/actual quantities
/// and a line for variance percentage over time.
class VarianceChart extends StatelessWidget {
  final List<VarianceDataPoint> dataPoints;
  final bool isLoading;

  const VarianceChart({
    Key? key,
    required this.dataPoints,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (dataPoints.isEmpty) {
      return _buildEmptyState();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          _buildLegend(),
          const SizedBox(height: 16),
          Expanded(child: _buildChart()),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.bar_chart, color: Color(VarianceColors.neutral), size: 20),
        const SizedBox(width: 8),
        Text(
          'Planned vs Actual Output',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          'Last ${dataPoints.length} days',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        _LegendItem(color: Color(VarianceColors.neutral), label: 'Planned'),
        const SizedBox(width: 16),
        _LegendItem(color: Color(VarianceColors.positive), label: 'Actual'),
        const SizedBox(width: 16),
        _LegendItem(color: Colors.orange, label: 'Variance %', isDashed: true),
      ],
    );
  }

  Widget _buildChart() {
    // Calculate max value for scaling
    double maxValue = 0;
    for (final point in dataPoints) {
      if (point.planned > maxValue) maxValue = point.planned;
      if (point.actual > maxValue) maxValue = point.actual;
    }
    maxValue = maxValue * 1.2; // Add 20% padding

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final chartHeight = constraints.maxHeight - 30; // Leave room for labels
        final barWidth = (chartWidth / dataPoints.length) * 0.35;

        return Stack(
          children: [
            // Grid lines
            _buildGridLines(chartHeight),
            // Bars
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: dataPoints.map((point) {
                return _buildBarGroup(
                  point: point,
                  maxValue: maxValue,
                  chartHeight: chartHeight,
                  barWidth: barWidth,
                );
              }).toList(),
            ),
            // Variance line overlay
            CustomPaint(
              size: Size(chartWidth, chartHeight),
              painter: _VarianceLinePainter(
                dataPoints: dataPoints,
                maxVariance: 50, // Max 50% variance for scale
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGridLines(double height) {
    return Column(
      children: List.generate(5, (index) {
        return Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey[200]!,
                  width: index == 0 ? 0 : 1,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildBarGroup({
    required VarianceDataPoint point,
    required double maxValue,
    required double chartHeight,
    required double barWidth,
  }) {
    final plannedHeight = maxValue > 0
        ? (point.planned / maxValue) * chartHeight
        : 0.0;
    final actualHeight = maxValue > 0
        ? (point.actual / maxValue) * chartHeight
        : 0.0;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Planned bar
              Container(
                width: barWidth,
                height: plannedHeight.clamp(0.0, chartHeight - 20),
                decoration: BoxDecoration(
                  color: Color(VarianceColors.neutral).withOpacity(0.7),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(2),
                  ),
                ),
              ),
              const SizedBox(width: 2),
              // Actual bar
              Container(
                width: barWidth,
                height: actualHeight.clamp(0.0, chartHeight - 20),
                decoration: BoxDecoration(
                  color: point.actual >= point.planned
                      ? Color(VarianceColors.positive).withOpacity(0.7)
                      : Color(VarianceColors.negative).withOpacity(0.7),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          // X-axis label
          Text(
            _formatDayLabel(point.date),
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'No data available',
              style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDayLabel(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[date.weekday - 1];
  }
}

/// Legend item widget
class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDashed;

  const _LegendItem({
    Key? key,
    required this.color,
    required this.label,
    this.isDashed = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: isDashed ? 2 : 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(isDashed ? 1 : 2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

/// Custom painter for variance line
class _VarianceLinePainter extends CustomPainter {
  final List<VarianceDataPoint> dataPoints;
  final double maxVariance;

  _VarianceLinePainter({required this.dataPoints, required this.maxVariance});

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.length < 2) return;

    final paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final segmentWidth = size.width / dataPoints.length;

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final variancePercent = point.variancePercentage.clamp(
        -maxVariance,
        maxVariance,
      );
      final x = segmentWidth * i + segmentWidth / 2;
      // Invert Y and center at middle
      final y =
          size.height / 2 - (variancePercent / maxVariance) * (size.height / 2);

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Draw dots at each point
    final dotPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    for (int i = 0; i < dataPoints.length; i++) {
      final point = dataPoints[i];
      final variancePercent = point.variancePercentage.clamp(
        -maxVariance,
        maxVariance,
      );
      final x = segmentWidth * i + segmentWidth / 2;
      final y =
          size.height / 2 - (variancePercent / maxVariance) * (size.height / 2);
      canvas.drawCircle(Offset(x, y), 3, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
