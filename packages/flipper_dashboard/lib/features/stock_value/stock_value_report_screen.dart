import 'dart:developer';

import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class StockValueReportScreen extends ConsumerWidget {
  const StockValueReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(stockValueReportProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F9FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Stock Value',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        actions: [
          reportAsync.when(
            data: (r) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${r.productsCount} products',
                    style: GoogleFonts.jetBrainsMono(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: reportAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => Center(
          child: Text(
            'Unable to load stock report.',
            style: GoogleFonts.outfit(color: Colors.black54),
          ),
        ),
        data: (report) {
          _debugLogReport(report);
          return _StockValueReportBody(report: report);
        },
      ),
    );
  }

  void _debugLogReport(StockValueReportData report) {
    if (!kDebugMode) return;

    log(
      '[StockValueReport] branchId=${report.branchId} '
      'productsCount=${report.productsCount} '
      'needsRestock=${report.needsRestockCount} '
      'totalValue=${report.totalValue} '
      'incomplete=${report.isPossiblyIncomplete}',
    );

    if (report.lowAndCriticalItems.isNotEmpty) {
      final sample = report.lowAndCriticalItems.take(10).toList();
      for (final item in sample) {
        log(
          '[StockValueReport][LowItem] '
          'variantId=${item.variantId} '
          'name="${item.name}" '
          'bcd=${item.bcd} '
          'category="${item.categoryName}" '
          'severity=${item.severity.name} '
          'currentStock=${item.currentStock} '
          'minStock=${item.minStock}',
        );
      }
      if (report.lowAndCriticalItems.length > sample.length) {
        log(
          '[StockValueReport] low/critical items truncated '
          '(${sample.length}/${report.lowAndCriticalItems.length})',
        );
      }
    } else {
      log('[StockValueReport] low/critical items: none');
    }

    if (report.valueByCategory.isNotEmpty) {
      final sample = report.valueByCategory.take(10).toList();
      for (final c in sample) {
        log(
          '[StockValueReport][Category] '
          'name="${c.categoryName}" '
          'products=${c.productsCount} '
          'value=${c.value} '
          'percent=${(c.percentOfTotal * 100).toStringAsFixed(1)}',
        );
      }
      if (report.valueByCategory.length > sample.length) {
        log(
          '[StockValueReport] categories truncated '
          '(${sample.length}/${report.valueByCategory.length})',
        );
      }
    } else {
      log('[StockValueReport] categories: none');
    }
  }
}

class _StockValueReportBody extends StatefulWidget {
  final StockValueReportData report;

  const _StockValueReportBody({required this.report});

  @override
  State<_StockValueReportBody> createState() => _StockValueReportBodyState();
}

class _StockValueReportBodyState extends State<_StockValueReportBody> {
  final _lowCriticalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final report = widget.report;

    return RefreshIndicator(
      onRefresh: () async {
        // Provider refresh is handled by parent; this keeps UX consistent.
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: _summaryTile(
                    title: 'TOTAL VALUE',
                    value: '${formatNumber(report.totalValue)}',
                    subtitle: 'RWF · ${report.productsCount} items',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryTile(
                    title: 'NEEDS RESTOCK',
                    value: '${report.needsRestockCount}',
                    subtitle: 'critical or low',
                    valueColor: report.needsRestockCount > 0
                        ? const Color(0xFFB91C1C)
                        : const Color(0xFF16A34A),
                  ),
                ),
              ],
            ),
            if (report.isPossiblyIncomplete) ...[
              const SizedBox(height: 10),
              Text(
                'Data may be incomplete (partial sync).',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
              ),
            ],
            const SizedBox(height: 14),
            if (report.needsRestockCount > 0) ...[
              _restockBanner(
                count: report.needsRestockCount,
                onViewAll: () {
                  final ctx = _lowCriticalKey.currentContext;
                  if (ctx != null) {
                    Scrollable.ensureVisible(
                      ctx,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),
            ],
            _sectionTitle('LOW & CRITICAL ITEMS', key: _lowCriticalKey),
            const SizedBox(height: 10),
            if (report.lowAndCriticalItems.isEmpty)
              _emptyCard('No low-stock items in local data.')
            else
              _lowCriticalList(report.lowAndCriticalItems),
            const SizedBox(height: 18),
            _sectionTitle('VALUE BY CATEGORY'),
            const SizedBox(height: 10),
            if (report.valueByCategory.isEmpty)
              _emptyCard('No category breakdown available.')
            else
              _categoryBreakdown(report),
          ],
        ),
      ),
    );
  }

  Widget _summaryTile({
    required String title,
    required String value,
    required String subtitle,
    Color valueColor = const Color(0xFF111827),
  }) {
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

  Widget _restockBanner({
    required int count,
    required VoidCallback onViewAll,
  }) {
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

  Widget _sectionTitle(String text, {Key? key}) {
    return Text(
      text,
      key: key,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w800,
        color: Colors.black54,
        letterSpacing: 0.1 * 12,
      ),
    );
  }

  Widget _emptyCard(String text) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(text, style: GoogleFonts.outfit(color: Colors.black54)),
    );
  }

  Widget _lowCriticalList(List<StockValueLowItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => Divider(
          height: 1,
          color: Colors.black.withValues(alpha: 0.06),
        ),
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

  Widget _categoryBreakdown(StockValueReportData report) {
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
                        color: const Color(0xFF1F6FEB),
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
                      Color(0xFF1F6FEB),
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

