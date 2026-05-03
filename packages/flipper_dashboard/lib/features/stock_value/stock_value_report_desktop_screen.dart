import 'dart:async' show unawaited;

import 'package:fl_chart/fl_chart.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'stock_value_product_detail_dialog.dart';
import 'stock_value_report_common.dart';

class StockValueReportDesktopScreen extends ConsumerWidget {
  const StockValueReportDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(stockValueReportProvider);

    return Scaffold(
      backgroundColor: kStockValuePageBg,
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Unable to load stock report.',
            style: GoogleFonts.outfit(color: Colors.black54, fontSize: 16),
          ),
        ),
        data: (report) => _StockValueDesktopScaffold(
          report: report,
          onClose: () => Navigator.of(context).pop(),
          onRefresh: () async {
            ref.invalidate(stockValueReportProvider);
            await ref.read(stockValueReportProvider.future);
          },
        ),
      ),
    );
  }
}

enum _ProductFilter { all, ok, low, critical }

class _StockValueDesktopScaffold extends StatefulWidget {
  final StockValueReportData report;
  final VoidCallback onClose;
  final Future<void> Function() onRefresh;

  const _StockValueDesktopScaffold({
    required this.report,
    required this.onClose,
    required this.onRefresh,
  });

  @override
  State<_StockValueDesktopScaffold> createState() =>
      _StockValueDesktopScaffoldState();
}

class _StockValueDesktopScaffoldState
    extends State<_StockValueDesktopScaffold> {
  final _search = TextEditingController();
  _ProductFilter _filter = _ProductFilter.all;
  var _refreshedAt = DateTime.now();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final query = _search.text.trim().toLowerCase();
    var rows = report.allProducts.where((p) {
      if (query.isEmpty) return true;
      if (p.name.toLowerCase().contains(query)) return true;
      if (p.categoryName.toLowerCase().contains(query)) return true;
      if (p.bcd != null && p.bcd!.toLowerCase().contains(query)) return true;
      return false;
    }).toList();

    switch (_filter) {
      case _ProductFilter.all:
        break;
      case _ProductFilter.ok:
        rows = rows.where((p) => p.status == StockValueLineStatus.ok).toList();
        break;
      case _ProductFilter.low:
        rows = rows.where((p) => p.status == StockValueLineStatus.low).toList();
        break;
      case _ProductFilter.critical:
        rows = rows
            .where((p) => p.status == StockValueLineStatus.critical)
            .toList();
        break;
    }

    final t = _refreshedAt;
    final timeStr = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(t));

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _topBar(
            context,
            report: report,
            timeStr: timeStr,
            onExport: () {
              _exportCsv(context, rows);
            },
            onRestockStub: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Use inventory or receive stock to restock items.',
                    style: GoogleFonts.outfit(),
                  ),
                ),
              );
            },
          ),
          const Divider(height: 1),
          Expanded(
            child: Scrollbar(
              child: RefreshIndicator(
                onRefresh: _onPullRefresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _kpiRow(context, report),
                      const SizedBox(height: 20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _productsPanel(
                              context,
                              report: report,
                              rows: rows,
                              onFilter: (f) => setState(() => _filter = f),
                              filter: _filter,
                            ),
                          ),
                          const SizedBox(width: 20),
                          SizedBox(
                            width: 360,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _ValueByCategoryPie(
                                  report: report,
                                  totalValue: report.totalValue,
                                ),
                                const SizedBox(height: 16),
                                _RestockSidePanel(
                                  count: report.needsRestockCount,
                                  items: report.lowAndCriticalItems,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportCsv(BuildContext context, List<StockValueProductLine> rows) {
    if (rows.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No rows to export for the current filter.',
            style: GoogleFonts.outfit(),
          ),
        ),
      );
      return;
    }
    final buf = StringBuffer();
    buf.writeln('Product,Category,BCD,Unit price,Stock,Line value,Status');
    for (final p in rows) {
      buf.writeln(
        '${_csv(p.name)},${_csv(p.categoryName)},${_csv(p.bcd ?? '')},${p.unitPrice},${p.currentStock},${p.lineValue},${p.status.name}',
      );
    }
    unawaited(Clipboard.setData(ClipboardData(text: buf.toString())));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied ${rows.length} rows as CSV to clipboard.',
          style: GoogleFonts.outfit(),
        ),
      ),
    );
  }

  String _csv(String s) {
    if (s.contains(',') || s.contains('"')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }

  Future<void> _onPullRefresh() async {
    await widget.onRefresh();
    if (mounted) {
      setState(() => _refreshedAt = DateTime.now());
    }
  }

  Widget _topBar(
    BuildContext context, {
    required StockValueReportData report,
    required String timeStr,
    required VoidCallback onExport,
    required VoidCallback onRestockStub,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: widget.onClose,
            icon: const Icon(Icons.close),
            tooltip: 'Close',
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Stock Value',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${report.productsCount} products across ${report.valueByCategory.length} categories · Last updated today at $timeStr',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 220,
            height: 40,
            child: TextField(
              controller: _search,
              onChanged: (_) => setState(() {}),
              style: GoogleFonts.outfit(fontSize: 14),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                hintText: 'Search product or BCD...',
                hintStyle: GoogleFonts.outfit(
                  color: Colors.black45,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Color(0xFF64748B),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Colors.black.withValues(alpha: 0.1),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton.tonal(
            onPressed: onExport,
            child: Text('Export', style: GoogleFonts.outfit()),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: onRestockStub,
            child: Text('+ Restock order', style: GoogleFonts.outfit()),
          ),
        ],
      ),
    );
  }

  Widget _kpiRow(BuildContext context, StockValueReportData report) {
    final catPct = report.productsCount <= 0
        ? 0
        : (100 * report.healthyStockCount / report.productsCount).round();
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final n = w >= 1000 ? 4 : (w >= 600 ? 2 : 1);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: n,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: n == 1 ? 3.2 : 1.55,
          children: [
            _KpiCard(
              borderColor: const Color(0xFF1F6FEB),
              title: 'Total stock value',
              value: 'RWF ${formatNumber(report.totalValue)}',
              subtitle: '${report.productsCount} products',
              badge: 'At retail/supply value',
            ),
            _KpiCard(
              borderColor: const Color(0xFF16A34A),
              title: 'Healthy stock',
              value: '${report.healthyStockCount}',
              subtitle: 'products well stocked',
              badge: '$catPct% of catalogue',
            ),
            _KpiCard(
              borderColor: const Color(0xFFDC2626),
              title: 'Critical / low',
              value: '${report.needsRestockCount}',
              subtitle: 'need restocking',
              badge: 'review alerts →',
            ),
            _KpiCard(
              borderColor: const Color(0xFFF59E0B),
              title: 'Highest value item',
              value: report.topByLineValue?.name ?? '—',
              subtitle: report.topByLineValue == null
                  ? 'No value on hand'
                  : 'RWF ${formatNumber(report.topByLineValue!.lineValue)} · ${report.topByLineValue!.currentStock.toStringAsFixed(0)} units',
              badge: report.topByLineValue == null
                  ? '—'
                  : '${(report.topByLineValue!.lineShareOfTotal * 100).round()}% of total value',
            ),
          ],
        );
      },
    );
  }

  Widget _productsPanel(
    BuildContext context, {
    required StockValueReportData report,
    required List<StockValueProductLine> rows,
    required void Function(_ProductFilter) onFilter,
    required _ProductFilter filter,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.list_alt_outlined, size: 20),
              const SizedBox(width: 8),
              Text(
                'All products',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _filterChip('All', _ProductFilter.all, filter, onFilter),
              const SizedBox(width: 6),
              _filterChip('OK', _ProductFilter.ok, filter, onFilter),
              const SizedBox(width: 6),
              _filterChip('Low', _ProductFilter.low, filter, onFilter),
              const SizedBox(width: 6),
              _filterChip(
                'Critical',
                _ProductFilter.critical,
                filter,
                onFilter,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (report.isPossiblyIncomplete)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                'Data may be incomplete (partial sync).',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
              ),
            ),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'No products match the current search or filter.',
                  style: GoogleFonts.outfit(color: Colors.black54),
                ),
              ),
            )
          else ...[
            _ProductTableHeader(),
            const Divider(height: 1),
            ...rows.map((p) => _ProductDataRow(line: p)),
          ],
        ],
      ),
    );
  }

  Widget _filterChip(
    String label,
    _ProductFilter value,
    _ProductFilter current,
    void Function(_ProductFilter) onFilter,
  ) {
    final sel = value == current;
    return ActionChip(
      label: Text(label, style: GoogleFonts.outfit(fontSize: 12)),
      onPressed: () => onFilter(value),
      visualDensity: VisualDensity.compact,
      side: sel ? const BorderSide(color: Color(0xFF1F6FEB), width: 1.2) : null,
      backgroundColor: sel
          ? const Color(0xFF1F6FEB).withValues(alpha: 0.12)
          : null,
    );
  }
}

class _KpiCard extends StatelessWidget {
  final Color borderColor;
  final String title;
  final String value;
  final String subtitle;
  final String badge;

  const _KpiCard({
    required this.borderColor,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border(left: BorderSide(color: borderColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
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
            style: GoogleFonts.jetBrainsMono(
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
              style: GoogleFonts.outfit(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: borderColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle h() => GoogleFonts.outfit(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: Colors.black45,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text('PRODUCT', style: h())),
          Expanded(child: Text('CATEGORY', style: h())),
          SizedBox(width: 80, child: Text('BCD', style: h())),
          SizedBox(width: 100, child: Text('UNIT PRICE', style: h())),
          SizedBox(width: 120, child: Text('STOCK', style: h())),
          SizedBox(
            width: 110,
            child: Text('VALUE', textAlign: TextAlign.right, style: h()),
          ),
          SizedBox(
            width: 88,
            child: Text('STATUS', textAlign: TextAlign.right, style: h()),
          ),
        ],
      ),
    );
  }
}

class _ProductDataRow extends StatelessWidget {
  final StockValueProductLine line;

  const _ProductDataRow({required this.line});

  @override
  Widget build(BuildContext context) {
    final st = line.status;
    String label;
    Color fg;
    Color bg;
    switch (st) {
      case StockValueLineStatus.ok:
        label = 'OK';
        fg = const Color(0xFF16A34A);
        bg = const Color(0xFFDCFCE7);
        break;
      case StockValueLineStatus.low:
        label = 'Low';
        fg = const Color(0xFF92400E);
        bg = const Color(0xFFFEF3C7);
        break;
      case StockValueLineStatus.critical:
        label = 'Critical';
        fg = const Color(0xFFB91C1C);
        bg = const Color(0xFFFEE2E2);
    }

    final denom = line.minStock > 0 ? (line.minStock * 2) : 1.0;
    var progress = (line.currentStock / denom).clamp(0.0, 1.0);
    if (line.minStock <= 0) {
      progress = line.currentStock > 0 ? 1.0 : 0.0;
    }

    return InkWell(
      onTap: () => showStockValueProductDetailDialog(context, line: line),
      borderRadius: BorderRadius.circular(8),
      hoverColor: const Color(0xFF1F6FEB).withValues(alpha: 0.06),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                line.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            Expanded(
              child: Text(
                line.categoryName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(fontSize: 13, color: Colors.black54),
              ),
            ),
            SizedBox(
              width: 80,
              child: Text(
                line.bcd ?? '—',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.jetBrainsMono(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 100,
              child: Text(
                'RWF ${formatNumber(line.unitPrice)}',
                style: GoogleFonts.jetBrainsMono(fontSize: 12),
              ),
            ),
            SizedBox(
              width: 120,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.black.withValues(alpha: 0.08),
                      valueColor: AlwaysStoppedAnimation<Color>(fg),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    line.currentStock.toStringAsFixed(0),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 110,
              child: Text(
                'RWF ${formatNumber(line.lineValue)}',
                textAlign: TextAlign.right,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            SizedBox(
              width: 88,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: fg,
                    ),
                  ),
                ),
              ),
            ),
          ],
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

class _ValueByCategoryPie extends StatelessWidget {
  final StockValueReportData report;
  final double totalValue;

  const _ValueByCategoryPie({required this.report, required this.totalValue});

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
          'No category data.',
          style: GoogleFonts.outfit(color: Colors.black54),
        ),
      );
    }
    final colors = _categoryPieColors();
    final sections = <PieChartSectionData>[];
    for (var i = 0; i < groups.length; i++) {
      final g = groups[i];
      final v = g.value;
      final pct = (g.percentOfTotal * 100);
      sections.add(
        PieChartSectionData(
          color: colors[i % colors.length],
          value: v <= 0 ? 0.0001 : v,
          title: '${pct.round()}%',
          radius: 52,
          titleStyle: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      );
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
            'Value by category',
            style: GoogleFonts.outfit(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 1,
                centerSpaceRadius: 48,
                sections: sections,
                pieTouchData: PieTouchData(),
              ),
            ),
          ),
          Center(
            child: Text(
              '${_shortM(totalValue)} RWF',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...groups.asMap().entries.map((e) {
            final i = e.key;
            final c = e.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colors[i % colors.length],
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      c.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(fontSize: 13),
                    ),
                  ),
                  Text(
                    'RWF ${formatNumber(c.value)}',
                    style: GoogleFonts.jetBrainsMono(fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${(c.percentOfTotal * 100).round()}%',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
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

class _RestockSidePanel extends StatelessWidget {
  final int count;
  final List<StockValueLowItem> items;

  const _RestockSidePanel({required this.count, required this.items});

  @override
  Widget build(BuildContext context) {
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
                'Restock alerts',
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
              'No restock alerts.',
              style: GoogleFonts.outfit(color: Colors.black54, fontSize: 13),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length > 8 ? 8 : items.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final item = items[i];
                return Row(
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
                            '${item.currentStock.toStringAsFixed(0)} units, min: ${item.minStock.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: const Color(0xFFB91C1C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
