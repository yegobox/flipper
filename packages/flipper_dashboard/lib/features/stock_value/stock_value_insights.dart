import 'package:fl_chart/fl_chart.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'stock_value_report_common.dart';

/// Side widgets of the desktop Stock Health page: KPI cards, the
/// value-by-category donut (its legend filters the table), restock alerts
/// and expiry alerts.

class StockValueKpiCard extends StatelessWidget {
  final Color borderColor;
  final String title;
  final String value;
  final String subtitle;
  final String badge;
  final bool selected;
  final VoidCallback? onTap;

  const StockValueKpiCard({
    super.key,
    required this.borderColor,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badge,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(14);
    return Material(
      color: Colors.white,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border(
              left: BorderSide(color: borderColor, width: selected ? 6 : 4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: selected ? 0.10 : 0.04),
                blurRadius: selected ? 10 : 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlipperFonts.mono(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: borderColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  badge,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: borderColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Color> _categoryPieColors() => const [
  Color(0xFF1F6FEB),
  Color(0xFF16A34A),
  Color(0xFFDC2626),
  Color(0xFFF59E0B),
  Color(0xFF8B5CF6),
  Color(0xFF0D9488),
  Color(0xFFEC4899),
];

class StockValueCategoryPie extends StatelessWidget {
  final StockValueReportData report;
  final double totalValue;
  final String? selected;
  final ValueChanged<String> onSelect;

  const StockValueCategoryPie({
    required this.report,
    required this.totalValue,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final groups = report.valueByCategory;
    if (groups.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          context.flipperL10n.stockValueNoCategoryData,
          style: GoogleFonts.outfit(color: Colors.black54),
        ),
      );
    }
    final colors = _categoryPieColors();

    // Slices: top categories drawn individually; anything below 2% of total
    // (or beyond the color palette) merged into a single "Others" slice so the
    // pie doesn't render hairline slivers with overlapping 0% labels.
    final major = <StockValueCategoryBreakdown>[];
    var othersValue = 0.0;
    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      if (g.value > 0 && g.percentOfTotal >= 0.02 && major.length < 6) {
        major.add(g);
      } else {
        othersValue += g.value <= 0 ? 0 : g.value;
      }
    }

    final sections = <PieChartSectionData>[];
    PieChartSectionData section(
      double value,
      double pct,
      Color color, {
      bool highlighted = false,
    }) {
      final showTitle = pct >= 5;
      return PieChartSectionData(
        color: color,
        value: value <= 0 ? 0.0001 : value,
        title: '${pct.round()}%',
        showTitle: showTitle,
        radius: highlighted ? 58 : 52,
        titleStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      );
    }

    for (var i = 0; i < major.length; i++) {
      final g = major[i];
      sections.add(
        section(
          g.value,
          g.percentOfTotal * 100,
          colors[i % colors.length],
          highlighted: g.categoryName == selected,
        ),
      );
    }
    if (othersValue > 0) {
      final othersPct = totalValue <= 0 ? 0.0 : 100 * othersValue / totalValue;
      sections.add(section(othersValue, othersPct, const Color(0xFF94A3B8)));
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.flipperL10n.stockValueByCategory,
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 1,
                    centerSpaceRadius: 48,
                    sections: sections,
                    pieTouchData: PieTouchData(enabled: false),
                  ),
                ),
                // Total sits in the donut hole (centerSpaceRadius: 48).
                Text(
                  '${_shortM(totalValue)}\nRWF',
                  textAlign: TextAlign.center,
                  style: FlipperFonts.mono(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Each legend row filters the product table to that category.
          ...groups.map((c) {
            // Legend dot mirrors the pie: majors get palette colors, merged
            // small categories share the grey "Others" slice color.
            final majorIndex = major.indexOf(c);
            final dotColor = majorIndex >= 0
                ? colors[majorIndex % colors.length]
                : const Color(0xFF94A3B8);
            final isSelected = c.categoryName == selected;
            return InkWell(
              key: Key('stockValueCategory_${c.categoryName}'),
              onTap: () => onSelect(c.categoryName),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? kStockValueAccentBlue.withValues(alpha: 0.10)
                      : null,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        c.categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ),
                    Text(
                      'RWF ${formatNumber(c.value)}',
                      style: FlipperFonts.mono(fontSize: 12),
                    ),
                    const SizedBox(width: 6),
                    SizedBox(
                      width: 34,
                      child: Text(
                        '${(c.percentOfTotal * 100).round()}%',
                        textAlign: TextAlign.right,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

String _shortM(double v) {
  if (v >= 1e6) {
    return '${(v / 1e6).toStringAsFixed(2)}M';
  }
  if (v >= 1e3) {
    return '${(v / 1e3).toStringAsFixed(2)}K';
  }
  return v.toStringAsFixed(0);
}

class StockValueRestockPanel extends StatelessWidget {
  static const int _maxShown = 8;

  final int count;
  final List<StockValueLowItem> items;
  final ValueChanged<String> onOpen;
  final VoidCallback onViewAll;

  const StockValueRestockPanel({
    required this.count,
    required this.items,
    required this.onOpen,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.stockValueRestockAlerts,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '$count',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFFB91C1C),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Text(
              l10n.stockValueNoRestockAlerts,
              style: GoogleFonts.outfit(color: Colors.black54, fontSize: 13),
            )
          else ...[
            for (var i = 0; i < items.length && i < _maxShown; i++) ...[
              if (i > 0) const Divider(height: 1),
              _restockRow(context, items[i]),
            ],
            if (items.length > _maxShown)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: onViewAll,
                  child: Text(
                    l10n.stockValueViewAllArrow,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _restockRow(BuildContext context, StockValueLowItem item) {
    return InkWell(
      onTap: () => onOpen(item.variantId),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 18,
              color: Colors.orange.shade800,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.bcd == null || item.bcd!.isEmpty
                        ? item.name
                        : '${item.name} (${item.bcd})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    item.categoryName,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    context.flipperL10n.stockValueUnitsMin(
                      formatStockQty(item.currentStock),
                      formatStockQty(item.minStock),
                    ),
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: const Color(0xFFB91C1C),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const Color _kExpiredFg = Color(0xFFB91C1C);
const Color _kExpiringFg = Color(0xFFB45309);

/// A line's expiry date, coloured by how urgent it is: red once expired,
/// amber when it expires within [kStockExpiringSoonDays], grey otherwise.
class StockValueExpiryText extends StatelessWidget {
  final StockValueProductLine line;

  const StockValueExpiryText({super.key, required this.line});

  @override
  Widget build(BuildContext context) {
    final date = line.expiryDate;
    final Color color;
    switch (line.expiryState) {
      case StockExpiryState.expired:
        color = _kExpiredFg;
        break;
      case StockExpiryState.soon:
        color = _kExpiringFg;
        break;
      case StockExpiryState.ok:
      case StockExpiryState.none:
        color = Colors.black54;
        break;
    }
    return Text(
      date == null
          ? '—'
          : MaterialLocalizations.of(context).formatShortDate(date.toLocal()),
      textAlign: TextAlign.right,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: FlipperFonts.mono(
        fontSize: 12,
        fontWeight: line.hasExpiryAlert ? FontWeight.w700 : FontWeight.w400,
        color: color,
      ),
    );
  }
}

/// Expired and soon-to-expire stock still on hand, soonest first.
class StockValueExpiryPanel extends StatelessWidget {
  static const int _maxShown = 8;

  final List<StockValueProductLine> items;
  final ValueChanged<String> onOpen;
  final VoidCallback onViewAll;

  const StockValueExpiryPanel({
    super.key,
    required this.items,
    required this.onOpen,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    return Container(
      key: const Key('stockValueExpiryPanel'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                l10n.stockValueExpiryAlerts,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (items.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${items.length}',
                    style: GoogleFonts.outfit(
                      color: _kExpiringFg,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          if (items.isEmpty)
            Text(
              l10n.stockValueNoExpiryAlerts,
              style: GoogleFonts.outfit(color: Colors.black54, fontSize: 13),
            )
          else ...[
            for (var i = 0; i < items.length && i < _maxShown; i++) ...[
              if (i > 0) const Divider(height: 1),
              _row(context, items[i]),
            ],
            if (items.length > _maxShown)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  key: const Key('stockValueExpiryViewAll'),
                  onPressed: onViewAll,
                  child: Text(
                    l10n.stockValueViewAllArrow,
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _row(BuildContext context, StockValueProductLine line) {
    final l10n = context.flipperL10n;
    final expired = line.expiryState == StockExpiryState.expired;
    final color = expired ? _kExpiredFg : _kExpiringFg;
    final date = MaterialLocalizations.of(
      context,
    ).formatShortDate(line.expiryDate!.toLocal());
    return InkWell(
      onTap: () => onOpen(line.variantId),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              expired ? Icons.event_busy_outlined : Icons.schedule_outlined,
              size: 18,
              color: color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${formatStockQty(line.currentStock)} · '
                    'RWF ${formatNumber(line.lineValue)}',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    expired
                        ? l10n.stockValueExpiredOn(date)
                        : l10n.stockValueExpiresOn(date),
                    style: GoogleFonts.outfit(fontSize: 12, color: color),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
