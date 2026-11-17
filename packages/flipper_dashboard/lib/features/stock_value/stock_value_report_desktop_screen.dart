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
import 'stock_value_table.dart';

export 'stock_value_table.dart' show StockValueTableColumns;

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
    final lead = <Widget>[
      SizedBox(
        width: 56,
        child: Center(
          child: AppBarRoundIconButton(icon: Icons.close, onPressed: onClose),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              context.flipperL10n.stockValueTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(fontSize: 13, color: Colors.black54),
              ),
            ],
          ],
        ),
      ),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: LayoutBuilder(
        builder: (context, box) {
          if (actions.isEmpty || box.maxWidth >= _kTopBarInlineMinWidth) {
            return Row(children: [...lead, ...actions]);
          }
          // Too narrow for the title and the actions on one line: the
          // actions go underneath and scroll sideways rather than squeeze
          // the title to nothing.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(children: lead),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: SingleChildScrollView(
                  key: const Key('stockValueTopBarActions'),
                  scrollDirection: Axis.horizontal,
                  child: Row(children: actions),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Narrowest top bar that fits the title beside the search, refresh,
/// export and restock actions.
const double _kTopBarInlineMinWidth = 900;

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
/// [expiryAlerts] is the expiry panel's "View all": expired and expiring soon.
enum _ProductFilter {
  all,
  ok,
  low,
  critical,
  out,
  restock,
  expired,
  expiring,
  expiryAlerts,
}

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
  StockValueSortKey _sortKey = StockValueSortKey.value;
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
  Map<StockExpiryState, int> _expiryCounts = const {};
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
      case _ProductFilter.expired:
        return line.expiryState == StockExpiryState.expired;
      case _ProductFilter.expiring:
        return line.expiryState == StockExpiryState.soon;
      case _ProductFilter.expiryAlerts:
        return line.hasExpiryAlert;
    }
  }

  void _recompute() {
    final all = widget.report.allProducts;
    final counts = <StockValueLineStatus, int>{};
    final expiry = <StockExpiryState, int>{};
    var matching = 0;
    final rows = <StockValueProductLine>[];
    for (var i = 0; i < all.length; i++) {
      final p = all[i];
      if (_category != null && p.categoryName != _category) continue;
      if (_query.isNotEmpty && !_haystack[i].contains(_query)) continue;
      matching++;
      counts[p.status] = (counts[p.status] ?? 0) + 1;
      expiry[p.expiryState] = (expiry[p.expiryState] ?? 0) + 1;
      if (_passesFilter(p)) rows.add(p);
    }
    rows.sort(_compare);
    _rows = rows;
    _statusCounts = counts;
    _expiryCounts = expiry;
    _matchingCount = matching;
  }

  int _compare(StockValueProductLine a, StockValueProductLine b) {
    int byName() => a.name.toLowerCase().compareTo(b.name.toLowerCase());
    if (_sortKey == StockValueSortKey.expiry) {
      // Lines without a date sit at the bottom whichever way the dates run.
      final ea = a.expiryDate, eb = b.expiryDate;
      if (ea == null || eb == null) {
        if (ea != eb) return ea == null ? 1 : -1;
        return byName();
      }
      final byDate = _sortAscending ? ea.compareTo(eb) : eb.compareTo(ea);
      return byDate != 0 ? byDate : byName();
    }
    final int primary;
    switch (_sortKey) {
      case StockValueSortKey.name:
        primary = byName();
        break;
      case StockValueSortKey.category:
        primary = a.categoryName.toLowerCase().compareTo(
          b.categoryName.toLowerCase(),
        );
        break;
      case StockValueSortKey.unitPrice:
        primary = a.unitPrice.compareTo(b.unitPrice);
        break;
      case StockValueSortKey.stock:
        primary = a.currentStock.compareTo(b.currentStock);
        break;
      case StockValueSortKey.value:
        primary = a.lineValue.compareTo(b.lineValue);
        break;
      case StockValueSortKey.expiry:
        primary = 0; // Handled above.
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

  /// "View all" on the expiry panel: every expired or expiring line.
  void _showAllExpiryAlerts() {
    _searchDebounce?.cancel();
    _search.clear();
    _update(() {
      _filter = _ProductFilter.expiryAlerts;
      _category = null;
      _query = '';
      _sortKey = StockValueSortKey.expiry;
      _sortAscending = true;
    });
  }

  void _toggleCategory(String category) =>
      _update(() => _category = _category == category ? null : category);

  void _sortBy(StockValueSortKey key) => _update(() {
    if (_sortKey == key) {
      _sortAscending = !_sortAscending;
    } else {
      _sortKey = key;
      // Text reads A→Z, dates soonest first; numbers read biggest first.
      _sortAscending =
          key == StockValueSortKey.name ||
          key == StockValueSortKey.category ||
          key == StockValueSortKey.expiry;
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
                  if (report.tracksExpiry) ...[
                    const SizedBox(height: 16),
                    StockValueExpiryPanel(
                      items: report.expiryAlerts,
                      onOpen: _openLine,
                      onViewAll: _showAllExpiryAlerts,
                    ),
                  ],
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
        l10n.stockValueColExpiry,
      ].map(_csv).join(','),
    );
    for (final p in rows) {
      final expiry = p.expiryDate == null
          ? ''
          : p.expiryDate!.toLocal().toIso8601String().substring(0, 10);
      buf.writeln(
        '${_csv(p.name)},${_csv(p.categoryName)},${_csv(p.bcd ?? '')},${p.unitPrice},${p.currentStock},${p.lineValue},${p.status.name},$expiry',
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
            if (report.tracksExpiry)
              StockValueKpiCard(
                key: const Key('stockValueExpiryCard'),
                borderColor: report.expiredCount > 0
                    ? const Color(0xFFB91C1C)
                    : const Color(0xFFF59E0B),
                title: l10n.stockValueColExpiry,
                value: l10n.stockValueExpiredCount(report.expiredCount),
                subtitle: l10n.stockValueExpiringWithin(
                  report.expiringSoonCount,
                  kStockExpiringSoonDays,
                ),
                badge: l10n.stockValueExpiredValue(
                  'RWF ${formatNumber(report.expiredValue)}',
                ),
                selected:
                    _filter == _ProductFilter.expired ||
                    _filter == _ProductFilter.expiring ||
                    _filter == _ProductFilter.expiryAlerts,
                onTap: report.expiryAlerts.isEmpty
                    ? null
                    : () => _setFilter(
                        report.expiredCount > 0
                            ? _ProductFilter.expired
                            : _ProductFilter.expiring,
                      ),
              )
            else
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
                          if (_filter == _ProductFilter.expiryAlerts) ...[
                            const SizedBox(width: 8),
                            InputChip(
                              key: const Key('stockValueExpiryChip'),
                              label: Text(
                                l10n.stockValueExpiryAlerts,
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
                          if (report.tracksExpiry) ...[
                            chip(
                              l10n.stockValueFilterExpired,
                              _ProductFilter.expired,
                              _expiryCounts[StockExpiryState.expired] ?? 0,
                            ),
                            chip(
                              l10n.stockValueFilterExpiring,
                              _ProductFilter.expiring,
                              _expiryCounts[StockExpiryState.soon] ?? 0,
                            ),
                          ],
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
                  child: StockValueTableHeader(
                    showExpiry: report.tracksExpiry,
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
                  (context, i) => StockValueProductRow(
                    line: rows[i],
                    showExpiry: report.tracksExpiry,
                  ),
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
