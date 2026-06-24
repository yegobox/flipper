import 'package:flutter/material.dart';
import '../models/production_output_models.dart';

/// SAP Fiori-inspired Object Page Header widget
///
/// Displays KPI tiles at the top of the production output screen
/// with planned quantity, actual quantity, variance %, and efficiency.
class ObjectPageHeader extends StatelessWidget {
  final ProductionSummary summary;
  final bool isLoading;
  final bool isMobile;

  const ObjectPageHeader({
    Key? key,
    required this.summary,
    this.isLoading = false,
    this.isMobile = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 12 : 16),
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
          // Header title
          Row(
            children: [
              Icon(
                Icons.factory_outlined,
                color: Color(VarianceColors.neutral),
                size: isMobile ? 20 : 24,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Production Overview',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                    fontSize: isMobile ? 16 : 20,
                  ),
                ),
              ),
              // Efficiency badge
              _buildEfficiencyBadge(context),
            ],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          // KPI tiles - use grid for mobile
          isLoading
              ? _buildLoadingKpis()
              : isMobile
              ? _buildMobileKpis()
              : _buildDesktopKpis(),
        ],
      ),
    );
  }

  Widget _buildDesktopKpis() {
    return Row(
      children: [
        Expanded(
          child: _KpiTile(
            label: 'Planned',
            value: summary.totalPlanned.toStringAsFixed(0),
            icon: Icons.schedule,
            color: Color(VarianceColors.neutral),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiTile(
            label: 'Actual',
            value: summary.totalActual.toStringAsFixed(0),
            icon: Icons.check_circle_outline,
            color: summary.isPositiveVariance
                ? Color(VarianceColors.positive)
                : Color(VarianceColors.negative),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiTile(
            label: 'Variance',
            value: '${summary.variancePercentage.toStringAsFixed(1)}%',
            icon: Icons.trending_up,
            color: summary.isPositiveVariance
                ? Color(VarianceColors.positive)
                : Color(VarianceColors.negative),
            showSign: true,
            isPositive: summary.isPositiveVariance,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _KpiTile(
            label: 'Work Orders',
            value: '${summary.completedOrders}/${summary.totalOrders}',
            icon: Icons.assignment,
            color: Color(VarianceColors.neutral),
            subtitle: 'Completed',
          ),
        ),
      ],
    );
  }

  Widget _buildMobileKpis() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _KpiTile(
                label: 'Planned',
                value: summary.totalPlanned.toStringAsFixed(0),
                icon: Icons.schedule,
                color: Color(VarianceColors.neutral),
                isCompact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _KpiTile(
                label: 'Actual',
                value: summary.totalActual.toStringAsFixed(0),
                icon: Icons.check_circle_outline,
                color: summary.isPositiveVariance
                    ? Color(VarianceColors.positive)
                    : Color(VarianceColors.negative),
                isCompact: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _KpiTile(
                label: 'Variance',
                value: '${summary.variancePercentage.toStringAsFixed(1)}%',
                icon: Icons.trending_up,
                color: summary.isPositiveVariance
                    ? Color(VarianceColors.positive)
                    : Color(VarianceColors.negative),
                showSign: true,
                isPositive: summary.isPositiveVariance,
                isCompact: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _KpiTile(
                label: 'Orders',
                value: '${summary.completedOrders}/${summary.totalOrders}',
                icon: Icons.assignment,
                color: Color(VarianceColors.neutral),
                isCompact: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEfficiencyBadge(BuildContext context) {
    final color = summary.efficiency >= 100
        ? Color(VarianceColors.positive)
        : summary.efficiency >= 90
        ? Color(VarianceColors.warning)
        : Color(VarianceColors.negative);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 12,
        vertical: isMobile ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.speed, size: isMobile ? 14 : 16, color: color),
          const SizedBox(width: 4),
          Text(
            '${summary.efficiency.toStringAsFixed(1)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: isMobile ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingKpis() {
    return Row(
      children: List.generate(
        isMobile ? 2 : 4,
        (index) => Expanded(
          child: Container(
            margin: EdgeInsets.only(right: index < (isMobile ? 1 : 3) ? 12 : 0),
            height: isMobile ? 60 : 80,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Individual KPI tile widget
class _KpiTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final bool showSign;
  final bool isPositive;
  final bool isCompact;

  const _KpiTile({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.showSign = false,
    this.isPositive = true,
    this.isCompact = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isCompact ? 10 : 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: isCompact ? 14 : 16,
                color: color.withValues(alpha: 0.7),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: isCompact ? 11 : 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: isCompact ? 6 : 8),
          Row(
            children: [
              if (showSign)
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  size: isCompact ? 14 : 18,
                  color: color,
                ),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isCompact ? 18 : 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[800],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: isCompact ? 10 : 11,
                color: Colors.grey[500],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
