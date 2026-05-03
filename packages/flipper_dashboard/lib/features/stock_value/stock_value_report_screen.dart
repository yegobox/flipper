import 'dart:developer';

import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'stock_value_report_common.dart';

class StockValueReportScreen extends ConsumerWidget {
  const StockValueReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(stockValueReportProvider);

    return Scaffold(
      backgroundColor: kStockValuePageBg,
      appBar: AppBar(
        backgroundColor: kStockValuePageBg,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
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

class _StockValueReportBody extends ConsumerStatefulWidget {
  final StockValueReportData report;

  const _StockValueReportBody({required this.report});

  @override
  ConsumerState<_StockValueReportBody> createState() =>
      _StockValueReportBodyState();
}

class _StockValueReportBodyState extends ConsumerState<_StockValueReportBody> {
  final _lowCriticalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(stockValueReportProvider);
        await ref.read(stockValueReportProvider.future);
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
                  child: StockValueSummaryTile(
                    title: 'TOTAL VALUE',
                    value: formatNumber(report.totalValue),
                    subtitle: 'RWF · ${report.productsCount} items',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StockValueSummaryTile(
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
              StockValueRestockBanner(
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
            StockValueSectionTitle(
              'LOW & CRITICAL ITEMS',
              titleKey: _lowCriticalKey,
            ),
            const SizedBox(height: 10),
            if (report.lowAndCriticalItems.isEmpty)
              const StockValueEmptyCard('No low-stock items in local data.')
            else
              StockValueLowCriticalList(items: report.lowAndCriticalItems),
            const SizedBox(height: 18),
            const StockValueSectionTitle('VALUE BY CATEGORY'),
            const SizedBox(height: 10),
            if (report.valueByCategory.isEmpty)
              const StockValueEmptyCard('No category breakdown available.')
            else
              StockValueCategoryBreakdownList(report: report),
          ],
        ),
      ),
    );
  }
}
