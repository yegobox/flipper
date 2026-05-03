import 'dart:async' show unawaited;
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flipper_dashboard/DesktopProductAdd.dart';

/// Range for chart + summary figures (mock: 7D / 30D / 90D).
enum _SalesRange { d7, d30, d90 }

void showStockValueProductDetailDialog(
  BuildContext context, {
  required StockValueProductLine line,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.4),
    builder: (ctx) => _ProductDetailDialogBody(line: line),
  );
}

class _ProductDetailDialogBody extends StatefulWidget {
  const _ProductDetailDialogBody({required this.line});

  final StockValueProductLine line;

  @override
  State<_ProductDetailDialogBody> createState() =>
      _ProductDetailDialogBodyState();
}

class _ProductDetailDialogBodyState extends State<_ProductDetailDialogBody> {
  bool _loading = true;
  String? _error;
  List<TransactionItem> _items = [];
  Variant? _variant;
  _SalesRange _range = _SalesRange.d7;

  StockValueProductLine get line => widget.line;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null || branchId.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'No branch selected.';
        });
        return;
      }
      final items = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(
            branchId: branchId,
            variantId: line.variantId,
            fetchRemote: true,
          );
      final variant = await ProxyService.strategy.getVariant(
        id: line.variantId,
      );
      if (!mounted) return;
      setState(() {
        _items = items;
        _variant = variant;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load sales data.';
      });
    }
  }

  DateTime _itemTime(TransactionItem i) =>
      i.lastTouched ?? i.createdAt ?? DateTime(2000);

  bool _isRefund(TransactionItem i) => i.isRefunded == true;

  Iterable<TransactionItem> _itemsInRange(_SalesRange r) {
    final now = DateTime.now();
    final days = switch (r) {
      _SalesRange.d7 => 7,
      _SalesRange.d30 => 30,
      _SalesRange.d90 => 90,
    };
    final start = now.subtract(Duration(days: days));
    return _items.where((i) {
      if (_isRefund(i)) return false;
      final t = _itemTime(i);
      return !t.isBefore(start) &&
          !t.isAfter(now.add(const Duration(seconds: 1)));
    });
  }

  double _lineRevenue(TransactionItem i) {
    final tot = i.totAmt;
    if (tot != null && tot > 0) return tot.toDouble();
    return (i.price * i.qty).toDouble();
  }

  double _supplyUnit() => (_variant?.supplyPrice ?? 0).toDouble();

  @override
  Widget build(BuildContext context) {
    final initials = _initials(line.name);
    final inRange = _itemsInRange(_range).toList();
    double totalRev = 0;
    double totalQty = 0;
    double totalProfit = 0;
    final sup = _supplyUnit();
    for (final i in inRange) {
      final rev = _lineRevenue(i);
      final q = i.qty.toDouble();
      totalRev += rev;
      totalQty += q;
      totalProfit += rev - sup * q;
    }

    final marginPct = totalRev > 0 ? (100 * totalProfit / totalRev) : 0.0;
    final stockValue = line.lineValue;
    final unit = line.unitPrice;
    final distinctTx = inRange
        .map((e) => e.transactionId)
        .whereType<String>()
        .toSet()
        .length;
    final avgTx = distinctTx > 0
        ? totalRev / distinctTx
        : (inRange.isNotEmpty ? totalRev / inRange.length : 0.0);
    final turnover = line.currentStock > 0.05
        ? (totalQty / line.currentStock)
        : totalQty;

    final spots = _spotsForRange(inRange, _range);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 920, maxHeight: 720),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          clipBehavior: Clip.antiAlias,
          child: _loading
              ? const SizedBox(
                  height: 320,
                  child: Center(child: CircularProgressIndicator()),
                )
              : _error != null
              ? Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_error!, style: GoogleFonts.outfit()),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text('Close', style: GoogleFonts.outfit()),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _header(context, initials),
                      const SizedBox(height: 20),
                      _summaryRow(
                        stockValue: stockValue,
                        unit: unit,
                        totalRev: totalRev,
                        totalQty: totalQty,
                        totalProfit: totalProfit,
                        marginPct: marginPct,
                      ),
                      const SizedBox(height: 20),
                      _chartCard(context, spots),
                      const SizedBox(height: 20),
                      _detailGrid(
                        turnover: turnover,
                        marginPct: marginPct,
                        avgTx: avgTx,
                        unitsSold: totalQty,
                      ),
                      const SizedBox(height: 24),
                      _footerActions(context),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  List<FlSpot> _spotsForRange(List<TransactionItem> inRange, _SalesRange r) {
    if (inRange.isEmpty) return [];
    final now = DateTime.now();
    final days = switch (r) {
      _SalesRange.d7 => 7,
      _SalesRange.d30 => 30,
      _SalesRange.d90 => 90,
    };
    final start = now.subtract(Duration(days: days));
    final bucketCount = switch (r) {
      _SalesRange.d7 => 7,
      _SalesRange.d30 => 10,
      _SalesRange.d90 => 12,
    };
    final y = List<double>.filled(bucketCount, 0);
    for (final i in inRange) {
      final t = _itemTime(i);
      if (t.isBefore(start)) continue;
      final rel =
          t.difference(start).inSeconds / Duration(days: days).inSeconds;
      var b = (rel * bucketCount).floor();
      b = b.clamp(0, bucketCount - 1);
      y[b] += i.qty.toDouble();
    }
    return [for (var j = 0; j < bucketCount; j++) FlSpot(j.toDouble(), y[j])];
  }

  Widget _header(BuildContext context, String initials) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Color(0xFF1F6FEB),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Text(
            initials,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                line.name,
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    line.bcd == null || line.bcd!.isEmpty
                        ? 'BCD: —'
                        : 'BCD: ${line.bcd}',
                    style: GoogleFonts.outfit(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  Text('·', style: GoogleFonts.outfit(color: Colors.black38)),
                  Text(
                    line.categoryName,
                    style: GoogleFonts.outfit(
                      color: Colors.black54,
                      fontSize: 13,
                    ),
                  ),
                  Text('·', style: GoogleFonts.outfit(color: Colors.black38)),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF16A34A),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${line.currentStock.toStringAsFixed(0)} in stock',
                        style: GoogleFonts.outfit(
                          color: const Color(0xFF16A34A),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text('·', style: GoogleFonts.outfit(color: Colors.black38)),
                  Text(
                    'RWF ${formatNumber(line.unitPrice)} / unit',
                    style: GoogleFonts.outfit(
                      color: const Color(0xFF0D9488),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }

  Widget _summaryRow({
    required double stockValue,
    required double unit,
    required double totalRev,
    required double totalQty,
    required double totalProfit,
    required double marginPct,
  }) {
    return LayoutBuilder(
      builder: (context, c) {
        final twoCol = c.maxWidth < 640;
        final children = [
          _statCard(
            icon: Icons.layers_outlined,
            iconColor: const Color(0xFF1F6FEB),
            label: 'STOCK VALUE',
            valueText: 'RWF ${_formatCompact(stockValue)}',
            valueColor: const Color(0xFF1F6FEB),
            caption:
                '${line.currentStock.toStringAsFixed(0)} units × RWF ${formatNumber(unit)}',
          ),
          _statCard(
            icon: Icons.trending_up,
            iconColor: const Color(0xFF16A34A),
            label: 'TOTAL SALES',
            valueText: 'RWF ${_formatCompact(totalRev)}',
            valueColor: const Color(0xFF16A34A),
            caption: '${totalQty.toStringAsFixed(0)} units sold (period)',
          ),
          _statCard(
            icon: Icons.attach_money,
            iconColor: const Color(0xFFDC2626),
            label: 'PROFIT',
            valueText:
                '${totalProfit >= 0 ? '+' : ''}RWF ${_formatCompact(totalProfit)}',
            valueColor: const Color(0xFF16A34A),
            caption: '${marginPct.toStringAsFixed(0)}% margin (est.)',
          ),
        ];
        if (twoCol) {
          return Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0) const SizedBox(height: 10),
                children[i],
              ],
            ],
          );
        }
        return Row(
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }

  Widget _statCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String valueText,
    required Color valueColor,
    required String caption,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black45,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            valueText,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _chartCard(BuildContext context, List<FlSpot> spots) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.show_chart, size: 20, color: Color(0xFF1F6FEB)),
              const SizedBox(width: 8),
              Text(
                'Stock Performance',
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              _rangeChip('7D', _SalesRange.d7),
              const SizedBox(width: 6),
              _rangeChip('30D', _SalesRange.d30),
              const SizedBox(width: 6),
              _rangeChip('90D', _SalesRange.d90),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: spots.isEmpty
                ? Center(
                    child: Text(
                      'No sales volume in this period.',
                      style: GoogleFonts.outfit(color: Colors.black54),
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: math.max(1, spots.length - 1).toDouble(),
                      minY: 0,
                      maxY: () {
                        final m = spots.map((s) => s.y).reduce(math.max);
                        return m <= 0 ? 1.0 : m * 1.15;
                      }(),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine: (v) =>
                            FlLine(color: Colors.black12, strokeWidth: 1),
                      ),
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: true,
                          color: const Color(0xFF1F6FEB),
                          barWidth: 2.5,
                          dotData: const FlDotData(show: true),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(
                              0xFF1F6FEB,
                            ).withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF1F6FEB),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Sales volume',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _rangeChip(String label, _SalesRange r) {
    final sel = _range == r;
    return ActionChip(
      label: Text(label, style: GoogleFonts.outfit(fontSize: 12)),
      onPressed: () => setState(() => _range = r),
      visualDensity: VisualDensity.compact,
      side: sel ? const BorderSide(color: Color(0xFF1F6FEB)) : null,
      backgroundColor: sel
          ? const Color(0xFF1F6FEB).withValues(alpha: 0.12)
          : const Color(0xFFF0F0F0),
    );
  }

  Widget _detailGrid({
    required double turnover,
    required double marginPct,
    required double avgTx,
    required double unitsSold,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.analytics_outlined, size: 20),
            const SizedBox(width: 8),
            Text(
              'Detailed metrics',
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, c) {
            final oneCol = c.maxWidth < 520;
            final a = _miniMetric(
              icon: Icons.autorenew,
              color: const Color(0xFF7C3AED),
              title: 'INVENTORY TURNOVER',
              value: '${turnover.toStringAsFixed(1)}x',
              bar: 0.35,
              barColor: const Color(0xFF7C3AED),
              footer: 'Relative to on-hand stock in this period.',
            );
            final b = _miniMetric(
              icon: Icons.wb_sunny_outlined,
              color: const Color(0xFFEA580C),
              title: 'GROSS MARGIN',
              value: '+${marginPct.toStringAsFixed(0)}%',
              bar: (marginPct.clamp(0, 100)) / 100.0,
              barColor: const Color(0xFF16A34A),
              footer: 'Estimated from retail vs supply on sold units.',
            );
            final c1 = _miniMetric(
              icon: Icons.credit_card,
              color: const Color(0xFF16A34A),
              title: 'AVG. TRANSACTION',
              value: 'RWF ${formatNumber(avgTx)}',
              bar: null,
              barColor: Colors.transparent,
              footer: 'Revenue / distinct transactions in range.',
            );
            final d = _miniMetric(
              icon: Icons.person_outline,
              color: const Color(0xFF1F6FEB),
              title: 'UNITS SOLD',
              value: unitsSold.toStringAsFixed(0),
              bar: (unitsSold / 500).clamp(0.0, 1.0),
              barColor: const Color(0xFF1F6FEB),
              footer: 'Total units in the selected range.',
            );
            if (oneCol) {
              return Column(
                children: [
                  a,
                  const SizedBox(height: 10),
                  b,
                  const SizedBox(height: 10),
                  c1,
                  const SizedBox(height: 10),
                  d,
                ],
              );
            }
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(child: a),
                    const SizedBox(width: 10),
                    Expanded(child: b),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(child: c1),
                    const SizedBox(width: 10),
                    Expanded(child: d),
                  ],
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _miniMetric({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
    required String footer,
    double? bar,
    required Color barColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          if (bar != null) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: bar,
                minHeight: 5,
                backgroundColor: Colors.black.withValues(alpha: 0.06),
                valueColor: AlwaysStoppedAnimation<Color>(barColor),
              ),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            footer,
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _footerActions(BuildContext context) {
    final productId = _variant?.productId;
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: _exportOne,
          icon: const Icon(Icons.download_outlined, size: 18),
          label: Text('Export', style: GoogleFonts.outfit()),
        ),
        const SizedBox(width: 8),
        FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFFFEE2E2),
            foregroundColor: const Color(0xFFB91C1C),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Delete product from inventory is not available here.',
                  style: GoogleFonts.outfit(),
                ),
              ),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline, size: 18),
              const SizedBox(width: 6),
              Text('Delete', style: GoogleFonts.outfit()),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel', style: GoogleFonts.outfit()),
        ),
        const SizedBox(width: 8),
        FilledButton.icon(
          onPressed: productId == null || productId.isEmpty
              ? null
              : () {
                  final id = productId;
                  final nav = Navigator.of(context, rootNavigator: true);
                  nav.pop();
                  nav.push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProductEntryScreen(productId: id),
                    ),
                  );
                },
          icon: const Icon(Icons.edit, size: 18),
          label: Text('Edit product', style: GoogleFonts.outfit()),
        ),
      ],
    );
  }

  void _exportOne() {
    final buf = StringBuffer()
      ..writeln('Product,${line.name}')
      ..writeln('BCD,${line.bcd ?? ''}')
      ..writeln('Category,${line.categoryName}')
      ..writeln('Stock,${line.currentStock}')
      ..writeln('Line value,${line.lineValue}');
    unawaited(Clipboard.setData(ClipboardData(text: buf.toString())));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Copied summary to clipboard.',
          style: GoogleFonts.outfit(),
        ),
      ),
    );
  }

  String _initials(String name) {
    final p = name.trim();
    if (p.isEmpty) return '?';
    final parts = p.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return ('${parts[0][0]}${parts[1][0]}').toUpperCase();
    }
    return p.length >= 2 ? p.substring(0, 2).toUpperCase() : p.toUpperCase();
  }

  String _formatCompact(double v) {
    if (v.abs() >= 1e6) {
      return '${(v / 1e6).toStringAsFixed(1)}M';
    }
    if (v.abs() >= 1e3) {
      return '${(v / 1e3).toStringAsFixed(1)}K';
    }
    return v.toStringAsFixed(0);
  }
}
