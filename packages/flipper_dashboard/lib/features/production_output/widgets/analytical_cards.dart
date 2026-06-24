import 'package:flutter/material.dart';
import '../models/production_output_models.dart';

/// SAP Fiori-inspired Analytical Cards widget
///
/// Displays tile-based KPIs with micro-charts and semantic colors
/// for variance analysis and trend visualization.
class AnalyticalCards extends StatelessWidget {
  final ProductionSummary summary;
  final bool isLoading;
  final bool isMobile;

  const AnalyticalCards({
    Key? key,
    required this.summary,
    this.isLoading = false,
    this.isMobile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    // Use column layout for mobile
    if (isMobile) {
      return Column(
        children: [
          _AnalyticalCard(
            title: 'Efficiency Rate',
            value: '${summary.efficiency.toStringAsFixed(1)}%',
            subtitle: summary.efficiencyRating,
            trend: summary.efficiency >= 100 ? 'up' : 'down',
            color: _getEfficiencyColor(summary.efficiency),
            microChart: _buildEfficiencyChart(),
            isCompact: true,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _AnalyticalCard(
                  title: 'Completion',
                  value: '${summary.completionRate.toStringAsFixed(0)}%',
                  subtitle: '${summary.completedOrders}/${summary.totalOrders}',
                  trend: summary.completionRate >= 80 ? 'up' : 'stable',
                  color: _getCompletionColor(summary.completionRate),
                  microChart: _buildCompletionChart(),
                  isCompact: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _VarianceReasonCard(
                  varianceByReason: summary.varianceByReason,
                  isCompact: true,
                ),
              ),
            ],
          ),
        ],
      );
    }

    // Desktop layout
    return Row(
      children: [
        Expanded(
          child: _AnalyticalCard(
            title: 'Efficiency Rate',
            value: '${summary.efficiency.toStringAsFixed(1)}%',
            subtitle: summary.efficiencyRating,
            trend: summary.efficiency >= 100 ? 'up' : 'down',
            color: _getEfficiencyColor(summary.efficiency),
            microChart: _buildEfficiencyChart(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _AnalyticalCard(
            title: 'Completion Rate',
            value: '${summary.completionRate.toStringAsFixed(1)}%',
            subtitle: '${summary.completedOrders} of ${summary.totalOrders}',
            trend: summary.completionRate >= 80 ? 'up' : 'stable',
            color: _getCompletionColor(summary.completionRate),
            microChart: _buildCompletionChart(),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _VarianceReasonCard(
            varianceByReason: summary.varianceByReason,
          ),
        ),
      ],
    );
  }

  Color _getEfficiencyColor(double efficiency) {
    if (efficiency >= 100) return Color(VarianceColors.positive);
    if (efficiency >= 90) return Color(VarianceColors.warning);
    return Color(VarianceColors.negative);
  }

  Color _getCompletionColor(double completionRate) {
    if (completionRate >= 80) return Color(VarianceColors.positive);
    if (completionRate >= 50) return Color(VarianceColors.warning);
    return Color(VarianceColors.negative);
  }

  Widget _buildEfficiencyChart() {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (index) {
          final height = 15.0 + (index * 3.5);
          final color = index < 3
              ? Color(VarianceColors.negative)
              : index < 5
              ? Color(VarianceColors.warning)
              : Color(VarianceColors.positive);
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              height: height,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCompletionChart() {
    final completed = summary.completionRate / 100;
    return Container(
      height: 8,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: completed.clamp(0.0, 1.0),
        child: Container(
          decoration: BoxDecoration(
            color: _getCompletionColor(summary.completionRate),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Row(
      children: List.generate(
        isMobile ? 2 : 3,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < (isMobile ? 1 : 2) ? 16 : 0),
            height: isMobile ? 100 : 160,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual analytical card widget
class _AnalyticalCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final String trend;
  final Color color;
  final Widget microChart;
  final bool isCompact;

  const _AnalyticalCard({
    Key? key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.trend,
    required this.color,
    required this.microChart,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isCompact ? 12 : 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _TrendIndicator(trend: trend, color: color),
            ],
          ),
          SizedBox(height: isCompact ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              fontSize: isCompact ? 24 : 32,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: isCompact ? 11 : 12,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          microChart,
        ],
      ),
    );
  }
}

/// Trend indicator widget
class _TrendIndicator extends StatelessWidget {
  final String trend;
  final Color color;

  const _TrendIndicator({Key? key, required this.trend, required this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData icon;
    switch (trend) {
      case 'up':
        icon = Icons.trending_up;
        break;
      case 'down':
        icon = Icons.trending_down;
        break;
      default:
        icon = Icons.trending_flat;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, size: 16, color: color),
    );
  }
}

/// Variance reason breakdown card
class _VarianceReasonCard extends StatelessWidget {
  final Map<String, double> varianceByReason;
  final bool isCompact;

  const _VarianceReasonCard({
    Key? key,
    required this.varianceByReason,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedReasons = varianceByReason.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final total = sortedReasons.fold<double>(0, (sum, e) => sum + e.value);

    return Container(
      padding: EdgeInsets.all(isCompact ? 12 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Variance Reasons',
            style: TextStyle(
              fontSize: isCompact ? 12 : 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: isCompact ? 8 : 12),
          if (total == 0)
            Center(
              child: Padding(
                padding: EdgeInsets.all(isCompact ? 8 : 16),
                child: Text(
                  'No data',
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: isCompact ? 12 : 14,
                  ),
                ),
              ),
            )
          else
            ...sortedReasons.take(isCompact ? 3 : 4).map((entry) {
              final percentage = total > 0 ? (entry.value / total) * 100 : 0.0;
              return _VarianceReasonRow(
                reason: _formatReasonName(entry.key),
                count: entry.value.toInt(),
                percentage: percentage.toDouble(),
                color: _getReasonColor(entry.key),
                isCompact: isCompact,
              );
            }),
        ],
      ),
    );
  }

  String _formatReasonName(String reason) {
    return reason.substring(0, 1).toUpperCase() + reason.substring(1);
  }

  Color _getReasonColor(String reason) {
    switch (reason.toLowerCase()) {
      case 'machine':
        return Colors.orange;
      case 'material':
        return Colors.blue;
      case 'labor':
        return Colors.purple;
      case 'quality':
        return Colors.red;
      case 'planning':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

/// Individual variance reason row
class _VarianceReasonRow extends StatelessWidget {
  final String reason;
  final int count;
  final double percentage;
  final Color color;
  final bool isCompact;

  const _VarianceReasonRow({
    Key? key,
    required this.reason,
    required this.count,
    required this.percentage,
    required this.color,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isCompact ? 3 : 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              reason,
              style: TextStyle(
                fontSize: isCompact ? 11 : 12,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              fontSize: isCompact ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: isCompact ? 40 : 50,
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: (percentage / 100).clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
