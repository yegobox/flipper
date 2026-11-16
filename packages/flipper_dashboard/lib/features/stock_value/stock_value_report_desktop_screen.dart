import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_design_system/flipper_design_system.dart';

import 'dart:async' show Timer, unawaited;

import 'package:flipper_models/providers/stock_value_report_provider.dart';
import 'package:flipper_services/utils.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'stock_value_insights.dart';
import 'stock_value_product_detail_dialog.dart';
import 'stock_value_report_common.dart';

class StockValueReportDesktopScreen extends ConsumerWidget {
  const StockValueReportDesktopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(stockValueReportProvider);
    void close() => Navigator.of(context).pop();

    return Scaffold(
      backgroundColor: kStockValuePageBg,
      // The header (with the shared close button) renders in every state so
      // the page is never a blank white screen while data loads.
      body: reportAsync.when(
        // A reload keeps the loaded page (and the user's search, filter and
        // scroll) on screen instead of flashing back to the skeleton.
        skipLoadingOnReload: true,
        loading: () => _StockValueLoadingShell(onClose: close),
        error: (_, __) => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _StockValueTopBar(onClose: close),
              const Divider(height: 1),
              Expanded(
                child: Center(
                  child: Text(
                    context.flipperL10n.stockValueLoadError,
                    style: GoogleFonts.outfit(
                      color: Colors.black54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        data: (report) => StockValueDesktopView(
          report: report,
          onClose: close,
          onRefresh: () async {
            ref.invalidate(stockValueReportProvider);
            await ref.read(stockValueReportProvider.future);
          },
        ),
      ),
    );
  }
}

/// Header shared by loading / error / data states: shared round close button
/// (same as [CustomAppBar]/Cash Book), title, and optional subtitle + actions.
class _StockValueTopBar extends StatelessWidget {
  final VoidCallback onClose;
  final String? subtitle;
  final List<Widget> actions;

  const _StockValueTopBar({
    required this.onClose,
    this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          SizedBox(
            width: 56,
            child: Center(
              child: AppBarRoundIconButton(
                icon: Icons.close,
                onPressed: onClose,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.flipperL10n.stockValueTitle,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
          ...actions,
        ],
      ),
    );
  }
}

/// Skeleton shown while the report loads: real header + grey placeholder
/// cards mirroring the loaded layout, so the shell is visible immediately.
class _StockValueLoadingShell extends StatelessWidget {
  final VoidCallback onClose;

  const _StockValueLoadingShell({required this.onClose});

  @override
  Widget build(BuildContext context) {
    Widget shellCard({double? height, Widget? child}) {
      return Container(
        height: height,
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
        child: child,
      );
    }

    Widget bar(double width) {
      return Container(
        width: width,
        height: 12,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(6),
        ),
      );
    }

    Widget kpiPlaceholder() {
      return shellCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [bar(90), bar(130), bar(70)],
        ),
      );
    }

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StockValueTopBar(
            onClose: onClose,
            subtitle: context.flipperL10n.stockValueLoadingProducts,
          ),
          const Divider(height: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 120,
                    child: Row(
                      children: [
                        for (var i = 0; i < 4; i++) ...[
                          if (i > 0) const SizedBox(width: 12),
                          Expanded(child: kpiPlaceholder()),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 3,
                          child: shellCard(
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 3),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: 360,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              shellCard(
                                height: 220,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: bar(140),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: shellCard(
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: bar(120),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// [restock] is the restock-alert list itself ("View all"): every line whose
/// min-stock alert fired, whatever its status, out of stock included.
enum _ProductFilter { all, ok, low, critical, out, restock }

enum _SortKey { name, category, unitPrice, stock, value }

/// Height of one product row. Fixed so the list is laid out lazily: only the
/// rows on screen are built, however big the catalogue is.
const double _kRowExtent = 48;

/// Below this width the insights column moves above the table.
const double _kWideLayoutMinWidth = 1100;

/// The loaded Stock Value page. Public so widget tests can pump it with a
/// fixed report, without Riverpod or Ditto.
class StockValueDesktopView extends StatefulWidget {
  final StockValueReportData report;
  final VoidCallback onClose;
  final Future<void> Function() onRefresh;

  const StockValueDesktopView({
    super.key,
    required this.report,
    required this.onClose,
    required this.onRefresh,
  });

  @override
  State<StockValueDesktopView> createState() => _StockValueDesktopViewState();
}

class _StockValueDesktopViewState extends State<StockValueDesktopView> {
  final _search = TextEditingController();
  // Each scroll view has its own controller; on desktop a Scrollbar otherwise
  // falls back to an unattached PrimaryScrollController and throws.
  final _scroll = ScrollController();
  final _sideScroll = ScrollController();
  Timer? _searchDebounce;

  String _query = '';
  _ProductFilter _filter = _ProductFilter.all;
  String? _category;
  _SortKey _sortKey = _SortKey.value;
  bool _sortAscending = false;
  var _refreshedAt = DateTime.now();

  /// Lower-cased "name category bcd" per [StockValueReportData.allProducts]
  /// entry, built once per report rather than on every keystroke.
  List<String> _haystack = const [];

  /// Variant ids in [StockValueReportData.lowAndCriticalItems].
  Set<String> _restockIds = const {};

  /// Rows after search, category, status filter and sort.
  List<StockValueProductLine> _rows = const [];

  /// Rows per status after search and category (not the status filter), so
  /// each chip says how many rows choosing it would show.
  Map<StockValueLineStatus, int> _statusCounts = const {};
  int _matchingCount = 0;

  @override
  void initState() {
    super.initState();
    _reindex();
  }

  @override
  void didUpdateWidget(covariant StockValueDesktopView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.report, widget.report)) {
      _refreshedAt = DateTime.now();
      _reindex();
    }
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    _sideScroll.dispose();
    super.dispose();
  }

  void _reindex() {
    final report = widget.report;
    _haystack = [
      for (final p in report.allProducts)
        '${p.name} ${p.categoryName} ${p.bcd ?? ''}'.toLowerCase(),
    ];
    _restockIds = {for (final i in report.lowAndCriticalItems) i.variantId};
    if (_category != null &&
        !report.valueByCategory.any((c) => c.categoryName == _category)) {
      _category = null;
    }
    _recompute();
  }

  bool _passesFilter(StockValueProductLine line) {
    final status = line.status;
    switch (_filter) {
      case _ProductFilter.all:
        return true;
      case _ProductFilter.ok:
        return status == StockValueLineStatus.ok;
      case _ProductFilter.low:
        return status == StockValueLineStatus.low;
      case _ProductFilter.critical:
        return status == StockValueLineStatus.critical;
      case _ProductFilter.out:
        return status == StockValueLineStatus.out;
      case _ProductFilter.restock:
        return _restockIds.contains(line.variantId);
    }
  }

  void _recompute() {
    final all = widget.report.allProducts;
    final counts = <StockValueLineStatus, int>{};
    var matching = 0;
    final rows = <StockValueProductLine>[];
    for (var i = 0; i < all.length; i++) {
      final p = all[i];
      if (_category != null && p.categoryName != _category) continue;
      if (_query.isNotEmpty && !_haystack[i].contains(_query)) continue;
      matching++;
      counts[p.status] = (counts[p.status] ?? 0) + 1;
      if (_passesFilter(p)) rows.add(p);
    }
    rows.sort(_compare);
    _rows = rows;
    _statusCounts = counts;
    _matchingCount = matching;
  }

  int _compare(StockValueProductLine a, StockValueProductLine b) {
    int byName() => a.name.toLowerCase().compareTo(b.name.toLowerCase());
    final int primary;
    switch (_sortKey) {
      case _SortKey.name:
        primary = byName();
        break;
      case _SortKey.category:
        primary = a.categoryName.toLowerCase().compareTo(
          b.categoryName.toLowerCase(),
        );
        break;
      case _SortKey.unitPrice:
        primary = a.unitPrice.compareTo(b.unitPrice);
        break;
      case _SortKey.stock:
        primary = a.currentStock.compareTo(b.currentStock);
        break;
      case _SortKey.value:
        primary = a.lineValue.compareTo(b.lineValue);
        break;
    }
    final directed = _sortAscending ? primary : -primary;
    return directed != 0 ? directed : byName();
  }

  void _update(VoidCallback change) {
    setState(() {
      change();
      _recompute();
    });
  }

  void _onSearchChanged(String text) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      _update(() => _query = text.trim().toLowerCase());
    });
  }

  void _setFilter(_ProductFilter filter) => _update(() => _filter = filter);

  /// "View all" on the restock panel: every alert, so the search and the
  /// category that may hide some of them are cleared too.
  void _showAllRestockAlerts() {
    _searchDebounce?.cancel();
    _search.clear();
    _update(() {
      _filter = _ProductFilter.restock;
      _category = null;
      _query = '';
    });
  }

  void _toggleCategory(String category) =>
      _update(() => _category = _category == category ? null : category);

  void _sortBy(_SortKey key) => _update(() {
    if (_sortKey == key) {
      _sortAscending = !_sortAscending;
    } else {
      _sortKey = key;
      // Text reads A→Z; numbers read biggest first.
      _sortAscending = key == _SortKey.name || key == _SortKey.category;
    }
  });

  Future<void> _onRefresh() async {
    await widget.onRefresh();
    if (mounted) setState(() => _refreshedAt = DateTime.now());
  }

  void _openLine(String variantId) {
    for (final p in widget.report.allProducts) {
      if (p.variantId == variantId) {
        showStockValueProductDetailDialog(context, line: p);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.report;
    final timeStr = MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay.fromDateTime(_refreshedAt));

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _topBar(context, report: report, timeStr: timeStr),
          const Divider(height: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= _kWideLayoutMinWidth;
                final insights = <Widget>[
                  StockValueCategoryPie(
                    report: report,
                    totalValue: report.totalValue,
                    selected: _category,
                    onSelect: _toggleCategory,
                  ),
                  const SizedBox(height: 16),
                  StockValueRestockPanel(
                    count: report.needsRestockCount,
                    items: report.lowAndCriticalItems,
                    onOpen: _openLine,
                    onViewAll: _showAllRestockAlerts,
                  ),
                ];

                final main = Scrollbar(
                  controller: _scroll,
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: CustomScrollView(
                      controller: _scroll,
                      physics: const AlwaysScrollableScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                          sliver: SliverToBoxAdapter(
                            child: _kpiRow(context, report),
                          ),
                        ),
                        if (!wide)
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                            sliver: SliverToBoxAdapter(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: insights,
                              ),
                            ),
                          ),
                        SliverPadding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                          sliver: _productsPanel(context, report),
                        ),
                      ],
                    ),
                  ),
                );
                if (!wide) return main;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: main),
                    SizedBox(
                      width: 380,
                      child: Scrollbar(
                        controller: _sideScroll,
                        child: SingleChildScrollView(
                          controller: _sideScroll,
                          padding: const EdgeInsets.fromLTRB(0, 16, 20, 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: insights,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _exportCsv(BuildContext context, List<StockValueProductLine> rows) {
    if (rows.isEmpty) {
      showWarningNotification(
        context,
        context.flipperL10n.stockValueNoRowsToExport,
      );
      return;
    }
    final buf = StringBuffer();
    final l10n = context.flipperL10n;
    buf.writeln(
      [
        l10n.stockValueCsvProduct,
        l10n.category,
        'BCD',
        l10n.stockValueCsvUnitPrice,
        l10n.stockValueCsvStock,
        l10n.stockValueCsvLineValue,
        l10n.stockValueCsvStatus,
      ].map(_csv).join(','),
    );
    for (final p in rows) {
      buf.writeln(
        '${_csv(p.name)},${_csv(p.categoryName)},${_csv(p.bcd ?? '')},${p.unitPrice},${p.currentStock},${p.lineValue},${p.status.name}',
      );
    }
    unawaited(Clipboard.setData(ClipboardData(text: buf.toString())));
    showSuccessNotification(context, l10n.stockValueCopiedCsvRows(rows.length));
  }

  String _csv(String s) {
    if (s.contains(',') || s.contains('"')) {
      return '"${s.replaceAll('"', '""')}"';
    }
    return s;
  }

  Widget _topBar(
    BuildContext context, {
    required StockValueReportData report,
    required String timeStr,
  }) {
    final l10n = context.flipperL10n;
    return _StockValueTopBar(
      onClose: widget.onClose,
      subtitle: l10n.stockValueDesktopSubtitle(
        report.productsCount,
        report.valueByCategory.length,
        timeStr,
      ),
      actions: [
        SizedBox(
          width: 240,
          height: 40,
          child: TextField(
            key: const Key('stockValueSearch'),
            controller: _search,
            onChanged: _onSearchChanged,
            style: GoogleFonts.outfit(fontSize: 14),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              hintText: l10n.stockValueSearchHint,
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
        const SizedBox(width: 4),
        IconButton(
          tooltip: l10n.refresh,
          onPressed: () => unawaited(_onRefresh()),
          icon: const Icon(Icons.refresh, color: Color(0xFF64748B)),
        ),
        const SizedBox(width: 4),
        FilledButton.tonal(
          onPressed: () => _exportCsv(context, _rows),
          child: Text(l10n.stockValueExport, style: GoogleFonts.outfit()),
        ),
        const SizedBox(width: 8),
        FilledButton(
          onPressed: () =>
              showInfoNotification(context, l10n.stockValueRestockHint),
          child: Text(l10n.stockValueRestockOrder, style: GoogleFonts.outfit()),
        ),
      ],
    );
  }

  Widget _kpiRow(BuildContext context, StockValueReportData report) {
    final l10n = context.flipperL10n;
    int pct(int n) => report.productsCount <= 0
        ? 0
        : (100 * n / report.productsCount).round();
    final attention = report.lowCount + report.criticalCount;
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final n = w >= 860 ? 4 : (w >= 520 ? 2 : 1);
        return GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: n,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: n == 1 ? 3.2 : (n == 2 ? 2.4 : 1.7),
          children: [
            StockValueKpiCard(
              borderColor: const Color(0xFF1F6FEB),
              title: l10n.stockValueTotalStockValue,
              value: 'RWF ${formatNumber(report.totalValue)}',
              subtitle: report.totalCostValue > 0
                  ? l10n.stockValueCostAndMargin(
                      'RWF ${formatNumber(report.totalCostValue)}',
                      'RWF ${formatNumber(report.marginValue)}',
                    )
                  : l10n.stockValueProductsCount(report.productsCount),
              badge: l10n.stockValueAtRetailSupply,
              selected: _filter == _ProductFilter.all && _category == null,
              onTap: () => _update(() {
                _filter = _ProductFilter.all;
                _category = null;
              }),
            ),
            StockValueKpiCard(
              borderColor: const Color(0xFF16A34A),
              title: l10n.stockValueHealthyStock,
              value: '${report.healthyStockCount}',
              subtitle: l10n.stockValueWellStocked,
              badge: l10n.stockValuePercentOfCatalogue(
                pct(report.healthyStockCount).toString(),
              ),
              selected: _filter == _ProductFilter.ok,
              onTap: () => _setFilter(_ProductFilter.ok),
            ),
            StockValueKpiCard(
              borderColor: const Color(0xFFDC2626),
              title: l10n.stockValueCriticalLow,
              value: '$attention',
              subtitle: l10n.stockValueNeedRestocking,
              badge: l10n.stockValueReviewAlerts,
              selected:
                  _filter == _ProductFilter.low ||
                  _filter == _ProductFilter.critical ||
                  _filter == _ProductFilter.restock,
              onTap: attention == 0
                  ? null
                  : () => _setFilter(
                      report.criticalCount > 0
                          ? _ProductFilter.critical
                          : _ProductFilter.low,
                    ),
            ),
            StockValueKpiCard(
              borderColor: const Color(0xFF64748B),
              title: l10n.stockValueStatusOut,
              value: '${report.outOfStockCount}',
              subtitle: l10n.stockValueNoUnitsOnHand,
              badge: l10n.stockValuePercentOfCatalogue(
                pct(report.outOfStockCount).toString(),
              ),
              selected: _filter == _ProductFilter.out,
              onTap: report.outOfStockCount == 0
                  ? null
                  : () => _setFilter(_ProductFilter.out),
            ),
          ],
        );
      },
    );
  }

  Widget _productsPanel(BuildContext context, StockValueReportData report) {
    final l10n = context.flipperL10n;
    final rows = _rows;
    const hPad = EdgeInsets.symmetric(horizontal: 16);

    Widget chip(String label, _ProductFilter value, int count) {
      final sel = value == _filter;
      return ActionChip(
        key: Key('stockValueFilter_${value.name}'),
        label: Text(
          '$label · $count',
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        onPressed: () => _setFilter(value),
        visualDensity: VisualDensity.compact,
        side: sel
            ? const BorderSide(color: kStockValueAccentBlue, width: 1.2)
            : null,
        backgroundColor: sel
            ? kStockValueAccentBlue.withValues(alpha: 0.12)
            : null,
      );
    }

    int count(StockValueLineStatus s) => _statusCounts[s] ?? 0;

    return DecoratedSliver(
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
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.list_alt_outlined, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            l10n.stockValueAllProducts,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.stockValueRowsShown(
                              rows.length.toString(),
                              report.productsCount.toString(),
                            ),
                            key: const Key('stockValueRowsShown'),
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),
                          if (_category != null) ...[
                            const SizedBox(width: 8),
                            InputChip(
                              key: const Key('stockValueCategoryChip'),
                              label: Text(
                                _category!,
                                style: GoogleFonts.outfit(fontSize: 12),
                              ),
                              visualDensity: VisualDensity.compact,
                              deleteButtonTooltipMessage: l10n.clear,
                              onDeleted: () => _update(() => _category = null),
                            ),
                          ],
                          if (_filter == _ProductFilter.restock) ...[
                            const SizedBox(width: 8),
                            InputChip(
                              key: const Key('stockValueRestockChip'),
                              label: Text(
                                l10n.stockValueRestockAlerts,
                                style: GoogleFonts.outfit(fontSize: 12),
                              ),
                              visualDensity: VisualDensity.compact,
                              deleteButtonTooltipMessage: l10n.clear,
                              onDeleted: () => _setFilter(_ProductFilter.all),
                            ),
                          ],
                        ],
                      ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          chip(
                            l10n.stockValueFilterAll,
                            _ProductFilter.all,
                            _matchingCount,
                          ),
                          chip(
                            l10n.stockValueStatusOk,
                            _ProductFilter.ok,
                            count(StockValueLineStatus.ok),
                          ),
                          chip(
                            l10n.stockValueStatusLow,
                            _ProductFilter.low,
                            count(StockValueLineStatus.low),
                          ),
                          chip(
                            l10n.stockValueStatusCritical,
                            _ProductFilter.critical,
                            count(StockValueLineStatus.critical),
                          ),
                          chip(
                            l10n.stockValueStatusOut,
                            _ProductFilter.out,
                            count(StockValueLineStatus.out),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (report.isPossiblyIncomplete)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        l10n.stockValuePartialSync,
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (rows.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    l10n.stockValueNoProductsMatch,
                    style: GoogleFonts.outfit(color: Colors.black54),
                  ),
                ),
              ),
            )
          else ...[
            PinnedHeaderSliver(
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: hPad,
                  child: _ProductTableHeader(
                    sortKey: _sortKey,
                    ascending: _sortAscending,
                    onSort: _sortBy,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              sliver: SliverFixedExtentList(
                itemExtent: _kRowExtent,
                delegate: SliverChildBuilderDelegate(
                  (context, i) => _ProductDataRow(line: rows[i]),
                  childCount: rows.length,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// Shared column widths so the header and the rows line up.
const double _kColBcd = 80;
const double _kColPrice = 100;
const double _kColStock = 120;
const double _kColValue = 110;
const double _kColStatus = 104;

/// Narrowest the flexible Product and Category columns may get before a
/// fixed column is dropped.
const double _kMinProductWidth = 120;
const double _kMinCategoryWidth = 80;

/// Narrowest the Value column gets before it is hidden.
const double _kMinValueWidth = 48;

/// Which columns the product table shows at a given width. Below what
/// everything needs, BCD goes first, then Unit price, Category, Stock and
/// Status; on a pane narrower still, Value narrows and finally goes, so
/// Product never shrinks to nothing and the fixed columns never overflow
/// ([fixedWidth] <= width at any width). The header and the rows ask with
/// the same width, so they line up.
@visibleForTesting
class StockValueTableColumns {
  final bool bcd;
  final bool unitPrice;
  final bool category;
  final bool stock;
  final bool status;

  /// Width of the Value column; 0 when it is hidden.
  final double valueWidth;

  const StockValueTableColumns({
    required this.bcd,
    required this.unitPrice,
    required this.category,
    required this.stock,
    required this.status,
    required this.valueWidth,
  });

  bool get value => valueWidth > 0;

  /// Width of the fixed-width columns shown; the rest goes to Product (and
  /// Category).
  double get fixedWidth =>
      (bcd ? _kColBcd : 0) +
      (unitPrice ? _kColPrice : 0) +
      (stock ? _kColStock : 0) +
      valueWidth +
      (status ? _kColStatus : 0);

  factory StockValueTableColumns.forWidth(double width) {
    var bcd = true, unitPrice = true, category = true, stock = true;
    var status = true;
    bool fits() {
      final fixed =
          (bcd ? _kColBcd : 0) +
          (unitPrice ? _kColPrice : 0) +
          (stock ? _kColStock : 0) +
          _kColValue +
          (status ? _kColStatus : 0);
      final flexible = _kMinProductWidth + (category ? _kMinCategoryWidth : 0);
      return width - fixed >= flexible;
    }

    if (!fits()) bcd = false;
    if (!fits()) unitPrice = false;
    if (!fits()) category = false;
    if (!fits()) stock = false;
    if (!fits()) status = false;
    // Only Product and Value left: Value takes what Product leaves, and goes
    // once that is too narrow for an amount.
    final room = (width - _kMinProductWidth).clamp(0.0, _kColValue);
    return StockValueTableColumns(
      bcd: bcd,
      unitPrice: unitPrice,
      category: category,
      stock: stock,
      status: status,
      valueWidth: room < _kMinValueWidth ? 0 : room,
    );
  }
}

class _ProductTableHeader extends StatelessWidget {
  final _SortKey sortKey;
  final bool ascending;
  final ValueChanged<_SortKey> onSort;

  const _ProductTableHeader({
    required this.sortKey,
    required this.ascending,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final style = GoogleFonts.outfit(
      fontSize: 11,
      fontWeight: FontWeight.w800,
      color: Colors.black45,
    );

    Widget sortable(String label, _SortKey key, {bool alignEnd = false}) {
      final active = key == sortKey;
      final text = Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: active ? style.copyWith(color: Colors.black87) : style,
      );
      return InkWell(
        key: Key('stockValueSort_${key.name}'),
        onTap: () => onSort(key),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: alignEnd
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Flexible(child: text),
              if (active)
                Icon(
                  ascending ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12,
                  color: Colors.black87,
                ),
            ],
          ),
        ),
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.12)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, box) {
          final cols = StockValueTableColumns.forWidth(box.maxWidth);
          return Row(
            children: [
              Expanded(
                flex: 2,
                child: sortable(l10n.stockValueColProduct, _SortKey.name),
              ),
              if (cols.category)
                Expanded(
                  child: sortable(
                    l10n.stockValueColCategory,
                    _SortKey.category,
                  ),
                ),
              if (cols.bcd)
                SizedBox(
                  width: _kColBcd,
                  child: Text('BCD', style: style),
                ),
              if (cols.unitPrice)
                SizedBox(
                  width: _kColPrice,
                  child: sortable(
                    l10n.stockValueColUnitPrice,
                    _SortKey.unitPrice,
                  ),
                ),
              if (cols.stock)
                SizedBox(
                  width: _kColStock,
                  child: sortable(l10n.stockValueColStock, _SortKey.stock),
                ),
              if (cols.value)
                SizedBox(
                  width: cols.valueWidth,
                  child: sortable(
                    l10n.stockValueColValue,
                    _SortKey.value,
                    alignEnd: true,
                  ),
                ),
              if (cols.status)
                SizedBox(
                  width: _kColStatus,
                  child: Text(
                    l10n.stockValueColStatus,
                    textAlign: TextAlign.right,
                    style: style,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _ProductDataRow extends StatelessWidget {
  final StockValueProductLine line;

  const _ProductDataRow({required this.line});

  @override
  Widget build(BuildContext context) {
    final l10n = context.flipperL10n;
    final String label;
    final Color fg;
    final Color bg;
    switch (line.status) {
      case StockValueLineStatus.ok:
        label = l10n.stockValueStatusOk;
        fg = const Color(0xFF16A34A);
        bg = const Color(0xFFDCFCE7);
        break;
      case StockValueLineStatus.low:
        label = l10n.stockValueStatusLow;
        fg = const Color(0xFF92400E);
        bg = const Color(0xFFFEF3C7);
        break;
      case StockValueLineStatus.critical:
        label = l10n.stockValueStatusCritical;
        fg = const Color(0xFFB91C1C);
        bg = const Color(0xFFFEE2E2);
        break;
      case StockValueLineStatus.out:
        label = l10n.stockValueStatusOut;
        fg = const Color(0xFF475569);
        bg = const Color(0xFFE2E8F0);
        break;
    }

    final denom = line.minStock > 0 ? (line.minStock * 2) : 1.0;
    var progress = (line.currentStock / denom).clamp(0.0, 1.0);
    if (line.minStock <= 0) {
      progress = line.currentStock > 0 ? 1.0 : 0.0;
    }
    final negative = line.currentStock < 0;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black.withValues(alpha: 0.06)),
        ),
      ),
      child: InkWell(
        onTap: () => showStockValueProductDetailDialog(context, line: line),
        hoverColor: kStockValueAccentBlue.withValues(alpha: 0.06),
        child: LayoutBuilder(
          builder: (context, box) {
            final cols = StockValueTableColumns.forWidth(box.maxWidth);
            return Row(
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
                if (cols.category)
                  Expanded(
                    child: Text(
                      line.categoryName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                if (cols.bcd)
                  SizedBox(
                    width: _kColBcd,
                    child: Text(
                      (line.bcd == null || line.bcd!.isEmpty) ? '—' : line.bcd!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlipperFonts.mono(fontSize: 12),
                    ),
                  ),
                if (cols.unitPrice)
                  SizedBox(
                    width: _kColPrice,
                    child: Text(
                      'RWF ${formatNumber(line.unitPrice)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlipperFonts.mono(fontSize: 12),
                    ),
                  ),
                if (cols.stock)
                  SizedBox(
                    width: _kColStock,
                    child: Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              minHeight: 6,
                              backgroundColor: Colors.black.withValues(
                                alpha: 0.08,
                              ),
                              valueColor: AlwaysStoppedAnimation<Color>(fg),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          width: 40,
                          child: Text(
                            line.currentStock.toStringAsFixed(0),
                            textAlign: TextAlign.right,
                            maxLines: 1,
                            style: FlipperFonts.mono(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: negative ? const Color(0xFFB91C1C) : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (cols.value)
                  SizedBox(
                    width: cols.valueWidth,
                    child: Text(
                      'RWF ${formatNumber(line.lineValue)}',
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlipperFonts.mono(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (cols.status)
                  SizedBox(
                    width: _kColStatus,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
            );
          },
        ),
      ),
    );
  }
}
