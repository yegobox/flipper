import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color kStockValuePageBg = Color(0xFFF8F9FA);
const Color kStockValueAccentBlue = Color(0xFF1F6FEB);

/// Shared summary card used on mobile stock value report.
class StockValueSummaryTile extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color valueColor;

  const StockValueSummaryTile({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    this.valueColor = const Color(0xFF111827),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.black54,
              letterSpacing: 0.08 * 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: valueColor,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class StockValueRestockBanner extends StatelessWidget {
  final int count;
  final VoidCallback onViewAll;

  const StockValueRestockBanner({
    super.key,
    required this.count,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFCEFD8),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8CDA3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.orange.shade800),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$count items need restocking attention',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: onViewAll,
            child: Text(
              'View all →',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class StockValueSectionTitle extends StatelessWidget {
  final String text;
  const StockValueSectionTitle(this.text, {super.key, this.titleKey});
  final Key? titleKey;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      key: titleKey,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Colors.black54,
        letterSpacing: 0.1 * 12,
      ),
    );
  }
}

class StockValueEmptyCard extends StatelessWidget {
  final String text;
  const StockValueEmptyCard(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: GoogleFonts.outfit(color: Colors.black54)),
    );
  }
}

class StockValueLowCriticalList extends StatelessWidget {
  final List<StockValueLowItem> items;

  const StockValueLowCriticalList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            Divider(height: 1, color: Colors.black.withValues(alpha: 0.06)),
        itemBuilder: (context, index) {
          final item = items[index];
          final isCritical = item.severity == StockSeverity.critical;

          final chipBg = isCritical
              ? const Color(0xFFFEE2E2)
              : const Color(0xFFFEF3C7);
          final chipFg = isCritical
              ? const Color(0xFFB91C1C)
              : const Color(0xFF92400E);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.bcd == null || item.bcd!.isEmpty
                            ? item.name
                            : '${item.name} (BCD: ${item.bcd})',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.categoryName,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: chipBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          isCritical ? 'Critical' : 'Low',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: chipFg,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${item.currentStock.toStringAsFixed(0)} units',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isCritical
                            ? const Color(0xFFB91C1C)
                            : const Color(0xFF92400E),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'min: ${item.minStock.toStringAsFixed(0)}',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class StockValueCategoryBreakdownList extends StatelessWidget {
  final StockValueReportData report;

  const StockValueCategoryBreakdownList({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: report.valueByCategory.map((c) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: kStockValueAccentBlue,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.categoryName,
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${c.productsCount} items',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'RWF ${formatNumber(c.value)}',
                          style: GoogleFonts.jetBrainsMono(
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${(c.percentOfTotal * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: c.percentOfTotal,
                    minHeight: 6,
                    backgroundColor: Colors.black.withValues(alpha: 0.06),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      kStockValueAccentBlue,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
