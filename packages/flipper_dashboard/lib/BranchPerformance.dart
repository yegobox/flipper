// ignore_for_file: unused_result

import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flipper_design_system/flipper_design_system.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/inventory_movement_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'BranchDropdown.dart';

/// Currently highlighted variant id (shared with the chart + list).
final selectedItemProvider = StateProvider<String?>((ref) => null);

const _kBlue = Color(0xFF1F6FEB);
const _kGreen = Color(0xFF16A34A);
const _kAmber = Color(0xFFF59E0B);
const _kRed = Color(0xFFDC2626);
const _kPurple = Color(0xFF7C3AED);
const _kSurface = Color(0xFFF8F9FA);
const _kBorder = Color(0x14000000);

/// How many bars the chart shows. A hundred hair-thin bars tell an owner
/// nothing; the top slice plus a tooltip does.
const _kMaxBars = 12;

/// Items expiring inside this window are worth acting on today.
const _kExpirySoonDays = 30;

/// Below this many days of stock left, an owner should be reordering.
const _kReorderDays = 7;
const _kCriticalCoverDays = 3;

enum _StockStatus { out, low, healthy }

enum _Filter { all, reorder, low, out, expiring, dead, shrink }

enum _SortBy { stockAsc, coverAsc, soldDesc, valueDesc, stockDesc, nameAsc }

enum _ChartMetric { stock, sold, revenue, cover }

/// One row of the dashboard: live stock joined to measured movement, so the
/// list, the chart and the KPIs all agree on the same numbers.
class _Line {
  _Line({
    required this.variant,
    required this.movement,
    required this.windowDays,
    required this.movementKnown,
  })  : name = _displayName(variant),
        current = (variant.stock?.currentStock ?? 0).toDouble(),
        low = (variant.stock?.lowStock ?? 0).toDouble(),
        unitPrice = _effectiveUnitPrice(variant),
        expiry = variant.expirationDate,
        updatedAt = variant.stock?.lastTouched ?? variant.lastTouched;

  final Variant variant;
  final VariantMovement movement;
  final int windowDays;

  /// False while movement is loading or when Ditto could not be read — the UI
  /// shows "—" instead of presenting zero sales as fact.
  final bool movementKnown;

  final String name;
  final double current;
  final double low;
  final double unitPrice;
  final DateTime? expiry;
  final DateTime? updatedAt;

  String get id => variant.id;

  String get category => (variant.categoryName?.trim().isNotEmpty ?? false)
      ? variant.categoryName!.trim()
      : 'Uncategorised';

  String get unit => (variant.unit?.trim().isNotEmpty ?? false)
      ? variant.unit!.trim()
      : 'units';

  /// Units sold in the window, measured from completed sale lines.
  double get sold => movement.unitsSold;

  double get revenue => movement.revenue;

  double get profit => movement.profit;

  double get margin => movement.margin;

  double get value => current * unitPrice;

  double get velocity => movement.velocityPerDay(windowDays);

  double? get daysOfCover => movement.daysOfCover(current, windowDays);

  double get sellThrough => movement.sellThrough(current);

  double get shrink => movement.shrink;

  double get adjustment => movement.adjustment;

  /// Units that came in during the window, closed against live stock.
  double? get restocked {
    final received = movement.restocked;
    if (received == null) return null;
    final last = movement.lastRemainingStock;
    final late = last == null ? 0.0 : math.max(0.0, current - last);
    return received + late;
  }

  _StockStatus get status {
    if (current <= 0) return _StockStatus.out;
    if (low > 0 && current <= low) return _StockStatus.low;
    return _StockStatus.healthy;
  }

  /// Selling faster than the stock on hand can cover.
  bool get needsReorder {
    if (status == _StockStatus.out) return true;
    final cover = daysOfCover;
    return cover != null && cover < _kReorderDays;
  }

  int? get daysToExpiry {
    if (expiry == null) return null;
    return expiry!.difference(DateTime.now()).inDays;
  }

  bool get isExpired => (daysToExpiry ?? 1) < 0;

  bool get isExpiringSoon {
    final d = daysToExpiry;
    return d != null && d >= 0 && d <= _kExpirySoonDays;
  }

  /// Stock on the shelf that did not sell once in the window — tied-up cash.
  bool get isDeadStock => movementKnown && current > 0 && sold <= 0;

  bool matches(String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    return name.toLowerCase().contains(q) ||
        variant.name.toLowerCase().contains(q) ||
        category.toLowerCase().contains(q) ||
        (variant.sku?.toLowerCase().contains(q) ?? false) ||
        (variant.bcd?.toLowerCase().contains(q) ?? false) ||
        (variant.itemCd?.toLowerCase().contains(q) ?? false);
  }

  static String _displayName(Variant v) {
    final product = v.productName?.trim();
    if (product != null && product.isNotEmpty) return product;
    return v.name.trim().isEmpty ? 'Unnamed item' : v.name.trim();
  }

  static double _effectiveUnitPrice(Variant v) {
    final retail = (v.retailPrice ?? 0).toDouble();
    if (retail > 0) return retail;
    return (v.supplyPrice ?? 0).toDouble();
  }
}

class BranchPerformance extends ConsumerStatefulWidget {
  const BranchPerformance({Key? key}) : super(key: key);

  @override
  ConsumerState<BranchPerformance> createState() => BranchPerformanceState();
}

class BranchPerformanceState extends ConsumerState<BranchPerformance> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  _Filter _filter = _Filter.all;
  _SortBy _sortBy = _SortBy.coverAsc;
  _ChartMetric _metric = _ChartMetric.sold;
  InventoryWindow _window = InventoryWindow.days30;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final branch = ref.watch(selectedBranchProvider);
    final branchId = branch?.id ?? ProxyService.box.getBranchId()!;
    final items = ref.watch(variantsProvider((branchId: branchId)));
    final movementArgs = (branchId: branchId, window: _window);
    final movement = ref.watch(inventoryMovementProvider(movementArgs));
    final selectedItemId = ref.watch(selectedItemProvider);

    final movementData = movement.asData?.value;
    final movementKnown = movementData != null && !movementData.unavailable;

    return SafeArea(
      top: false,
      child: Column(
        children: [
          _Header(
            branchName: branch?.name,
            itemCount: items.asData?.value.length,
            onRefresh: () {
              ref.invalidate(variantsProvider((branchId: branchId)));
              ref.invalidate(inventoryMovementProvider(movementArgs));
              ref.read(selectedItemProvider.notifier).state = null;
            },
          ),
          const Divider(height: 1, color: _kBorder),
          Expanded(
            child: items.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorState(
                message: '$error',
                onRetry: () =>
                    ref.invalidate(variantsProvider((branchId: branchId))),
              ),
              data: (data) => data.isEmpty
                  ? const _EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No items in this branch yet',
                      message:
                          'Add products or record a purchase and stock will show up here.',
                    )
                  : _Body(
                      lines: [
                        for (final v in data)
                          _Line(
                            variant: v,
                            movement: movementData?.forVariant(v.id) ??
                                VariantMovement.empty,
                            windowDays: _window.days,
                            movementKnown: movementKnown,
                          ),
                      ],
                      window: _window,
                      movementLoading: movement.isLoading,
                      movementUnavailable:
                          movementData != null && movementData.unavailable,
                      salesCount: movementData?.salesCount ?? 0,
                      query: _query,
                      filter: _filter,
                      sortBy: _sortBy,
                      metric: _metric,
                      selectedItemId: selectedItemId,
                      searchController: _searchController,
                      onWindowChanged: (w) => setState(() => _window = w),
                      onQueryChanged: (q) => setState(() => _query = q),
                      onFilterChanged: (f) => setState(() => _filter = f),
                      onSortChanged: (s) => setState(() => _sortBy = s),
                      onMetricChanged: (m) => setState(() => _metric = m),
                      onSelect: (id) =>
                          ref.read(selectedItemProvider.notifier).state = id,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.branchName,
    required this.itemCount,
    required this.onRefresh,
  });

  final String? branchName;
  final int? itemCount;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      branchName ?? 'Current branch',
      if (itemCount != null) '$itemCount items tracked',
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _kBlue.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Icon(Icons.inventory_2_outlined, color: _kBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inventory Dashboard',
                  style: GoogleFonts.outfit(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style:
                      GoogleFonts.outfit(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          const BranchDropdown(),
          IconButton(
            onPressed: onRefresh,
            tooltip: 'Refresh stock and sales figures',
            icon: const Icon(Icons.refresh, size: 20),
            visualDensity: VisualDensity.compact,
          ),
          if (Navigator.of(context).canPop())
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              tooltip: 'Close',
              icon: const Icon(Icons.close, size: 20),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.lines,
    required this.window,
    required this.movementLoading,
    required this.movementUnavailable,
    required this.salesCount,
    required this.query,
    required this.filter,
    required this.sortBy,
    required this.metric,
    required this.selectedItemId,
    required this.searchController,
    required this.onWindowChanged,
    required this.onQueryChanged,
    required this.onFilterChanged,
    required this.onSortChanged,
    required this.onMetricChanged,
    required this.onSelect,
  });

  final List<_Line> lines;
  final InventoryWindow window;
  final bool movementLoading;
  final bool movementUnavailable;
  final int salesCount;
  final String query;
  final _Filter filter;
  final _SortBy sortBy;
  final _ChartMetric metric;
  final String? selectedItemId;
  final TextEditingController searchController;
  final ValueChanged<InventoryWindow> onWindowChanged;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<_Filter> onFilterChanged;
  final ValueChanged<_SortBy> onSortChanged;
  final ValueChanged<_ChartMetric> onMetricChanged;
  final ValueChanged<String?> onSelect;

  List<_Line> get _visible {
    final filtered = lines.where((l) {
      if (!l.matches(query)) return false;
      switch (filter) {
        case _Filter.all:
          return true;
        case _Filter.reorder:
          return l.needsReorder;
        case _Filter.low:
          return l.status == _StockStatus.low;
        case _Filter.out:
          return l.status == _StockStatus.out;
        case _Filter.expiring:
          return l.isExpiringSoon || l.isExpired;
        case _Filter.dead:
          return l.isDeadStock;
        case _Filter.shrink:
          return l.shrink > 0;
      }
    }).toList();

    filtered.sort((a, b) {
      switch (sortBy) {
        case _SortBy.stockAsc:
          return a.current.compareTo(b.current);
        case _SortBy.stockDesc:
          return b.current.compareTo(a.current);
        case _SortBy.coverAsc:
          // Out of stock first, then the shortest runway; items with no sales
          // have no runway to judge, so they sort last.
          final ac = a.daysOfCover ?? double.infinity;
          final bc = b.daysOfCover ?? double.infinity;
          if (ac == bc) return a.current.compareTo(b.current);
          return ac.compareTo(bc);
        case _SortBy.soldDesc:
          return b.sold.compareTo(a.sold);
        case _SortBy.valueDesc:
          return b.value.compareTo(a.value);
        case _SortBy.nameAsc:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      }
    });
    return filtered;
  }

  /// Movement figures are only trustworthy once the sales read has landed.
  bool get movementKnown => !movementLoading && !movementUnavailable;

  @override
  Widget build(BuildContext context) {
    final visible = _visible;
    final selected = lines.firstWhere(
      (l) => l.id == selectedItemId,
      orElse: () => lines.first,
    );
    final hasSelection =
        selectedItemId != null && lines.any((l) => l.id == selectedItemId);

    final totalValue = lines.fold<double>(0, (s, l) => s + l.value);
    final unitsOnHand = lines.fold<double>(0, (s, l) => s + l.current);
    final unitsSold = lines.fold<double>(0, (s, l) => s + l.sold);
    final revenue = lines.fold<double>(0, (s, l) => s + l.revenue);
    final profit = lines.fold<double>(0, (s, l) => s + l.profit);
    final shrinkUnits = lines.fold<double>(0, (s, l) => s + l.shrink);
    final shrinkValue =
        lines.fold<double>(0, (s, l) => s + l.shrink * l.unitPrice);
    final outCount = lines.where((l) => l.status == _StockStatus.out).length;
    final lowCount = lines.where((l) => l.status == _StockStatus.low).length;
    final reorderCount = lines.where((l) => l.needsReorder).length;
    final expiringCount =
        lines.where((l) => l.isExpiringSoon || l.isExpired).length;
    final deadStock = lines.where((l) => l.isDeadStock).toList();
    final deadValue = deadStock.fold<double>(0, (s, l) => s + l.value);
    final shrinkCount = lines.where((l) => l.shrink > 0).length;
    final topMover = lines.reduce((a, b) => a.sold >= b.sold ? a : b);
    final lastUpdated = lines
        .map((l) => l.updatedAt)
        .whereType<DateTime>()
        .fold<DateTime?>(
            null, (acc, d) => acc == null || d.isAfter(acc) ? d : acc);

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _WindowBar(
                window: window,
                loading: movementLoading,
                unavailable: movementUnavailable,
                salesCount: salesCount,
                onChanged: onWindowChanged,
              ),
              const SizedBox(height: 12),
              _KpiRow(
                totalValue: totalValue,
                unitsOnHand: unitsOnHand,
                skuCount: lines.length,
                unitsSold: unitsSold,
                revenue: revenue,
                profit: profit,
                window: window,
                movementKnown: movementKnown,
                outCount: outCount,
                reorderCount: reorderCount,
                activeFilter: filter,
                onFilter: onFilterChanged,
              ),
              const SizedBox(height: 12),
              _InsightRow(
                topMover: topMover,
                window: window,
                movementKnown: movementKnown,
                deadItemCount: deadStock.length,
                deadValue: deadValue,
                expiringCount: expiringCount,
                shrinkCount: shrinkCount,
                shrinkUnits: shrinkUnits,
                shrinkValue: shrinkValue,
                activeFilter: filter,
                onFilter: onFilterChanged,
                onSelect: onSelect,
              ),
              const SizedBox(height: 16),
              _ChartCard(
                lines: _chartLines(visible),
                totalCount: visible.length,
                metric: metric,
                window: window,
                selectedItemId: hasSelection ? selectedItemId : null,
                onMetricChanged: onMetricChanged,
                onSelect: onSelect,
              ),
              if (hasSelection) ...[
                const SizedBox(height: 12),
                _SelectedLineCard(
                  line: selected,
                  window: window,
                  onClear: () => onSelect(null),
                ),
              ],
              const SizedBox(height: 16),
              _ListToolbar(
                controller: searchController,
                query: query,
                filter: filter,
                sortBy: sortBy,
                expiringCount: expiringCount,
                deadCount: deadStock.length,
                lowCount: lowCount,
                outCount: outCount,
                reorderCount: reorderCount,
                shrinkCount: shrinkCount,
                onQueryChanged: onQueryChanged,
                onFilterChanged: onFilterChanged,
                onSortChanged: onSortChanged,
              ),
              const SizedBox(height: 8),
              _ResultSummary(
                shown: visible.length,
                total: lines.length,
                value: visible.fold<double>(0, (s, l) => s + l.value),
                lastUpdated: lastUpdated,
              ),
              const SizedBox(height: 8),
            ]),
          ),
        ),
        if (visible.isEmpty)
          const SliverToBoxAdapter(
            child: _EmptyState(
              icon: Icons.search_off,
              title: 'Nothing matches these filters',
              message: 'Clear the search or pick a different filter.',
            ),
          )
        else
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final line = visible[index];
                  return _ItemRow(
                    line: line,
                    isSelected: line.id == selectedItemId,
                    onTap: () =>
                        onSelect(line.id == selectedItemId ? null : line.id),
                  );
                },
                childCount: visible.length,
              ),
            ),
          ),
      ],
    );
  }

  /// Top slice of the visible items, ranked by whatever the chart is showing.
  List<_Line> _chartLines(List<_Line> visible) {
    if (metric == _ChartMetric.cover) {
      // Urgency reads best ascending: shortest runway on the left.
      final withCover = visible.where((l) => l.daysOfCover != null).toList()
        ..sort((a, b) => a.daysOfCover!.compareTo(b.daysOfCover!));
      return withCover.take(_kMaxBars).toList();
    }
    final ranked = [...visible]..sort((a, b) {
      switch (metric) {
        case _ChartMetric.stock:
          return b.current.compareTo(a.current);
        case _ChartMetric.sold:
          return b.sold.compareTo(a.sold);
        case _ChartMetric.revenue:
          return b.revenue.compareTo(a.revenue);
        case _ChartMetric.cover:
          return 0;
      }
    });
    return ranked.take(_kMaxBars).toList();
  }
}

/// Period selector — every movement figure on the page follows it.
class _WindowBar extends StatelessWidget {
  const _WindowBar({
    required this.window,
    required this.loading,
    required this.unavailable,
    required this.salesCount,
    required this.onChanged,
  });

  final InventoryWindow window;
  final bool loading;
  final bool unavailable;
  final int salesCount;
  final ValueChanged<InventoryWindow> onChanged;

  @override
  Widget build(BuildContext context) {
    final String status;
    final Color statusColor;
    if (loading) {
      status = 'Reading sales…';
      statusColor = Colors.black45;
    } else if (unavailable) {
      status = 'Sales movement unavailable — stock figures only';
      statusColor = _kRed;
    } else {
      status = '$salesCount completed ${salesCount == 1 ? 'sale' : 'sales'} '
          'in ${window.longLabel}';
      statusColor = Colors.black45;
    }

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              unavailable ? Icons.cloud_off : Icons.history_toggle_off,
              size: 16,
              color: statusColor,
            ),
            const SizedBox(width: 6),
            Text(
              status,
              style: GoogleFonts.outfit(fontSize: 12, color: statusColor),
            ),
            if (loading) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ],
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final w in InventoryWindow.values) ...[
              if (w != InventoryWindow.values.first) const SizedBox(width: 6),
              _MetricChip(
                label: w.shortLabel,
                isActive: w == window,
                onTap: () => onChanged(w),
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _KpiRow extends StatelessWidget {
  const _KpiRow({
    required this.totalValue,
    required this.unitsOnHand,
    required this.skuCount,
    required this.unitsSold,
    required this.revenue,
    required this.profit,
    required this.window,
    required this.movementKnown,
    required this.outCount,
    required this.reorderCount,
    required this.activeFilter,
    required this.onFilter,
  });

  final double totalValue;
  final double unitsOnHand;
  final int skuCount;
  final double unitsSold;
  final double revenue;
  final double profit;
  final InventoryWindow window;
  final bool movementKnown;
  final int outCount;
  final int reorderCount;
  final _Filter activeFilter;
  final ValueChanged<_Filter> onFilter;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      _StatTile(
        icon: Icons.account_balance_wallet_outlined,
        color: _kBlue,
        label: 'STOCK VALUE',
        value: 'RWF ${formatNumber(totalValue)}',
        caption: '${_qty(unitsOnHand)} units · $skuCount items',
      ),
      _StatTile(
        icon: Icons.trending_up,
        color: _kGreen,
        label: 'SOLD · ${window.shortLabel.toUpperCase()}',
        value: movementKnown ? _qty(unitsSold) : '—',
        caption: movementKnown
            ? 'RWF ${formatNumber(revenue)} in · '
                'RWF ${formatNumber(profit)} profit'
            : 'waiting for sales data',
      ),
      _StatTile(
        icon: Icons.remove_shopping_cart_outlined,
        color: _kRed,
        label: 'OUT OF STOCK',
        value: '$outCount',
        caption: outCount == 0 ? 'nothing to restock' : 'tap to see them',
        onTap: outCount == 0
            ? null
            : () => onFilter(
                activeFilter == _Filter.out ? _Filter.all : _Filter.out),
        isActive: activeFilter == _Filter.out,
      ),
      _StatTile(
        icon: Icons.local_shipping_outlined,
        color: _kAmber,
        label: 'REORDER NOW',
        value: movementKnown ? '$reorderCount' : '—',
        caption: !movementKnown
            ? 'waiting for selling pace'
            : reorderCount == 0
                ? 'every item has runway'
                : 'under $_kReorderDays days of stock left',
        onTap: reorderCount == 0
            ? null
            : () => onFilter(activeFilter == _Filter.reorder
                ? _Filter.all
                : _Filter.reorder),
        isActive: activeFilter == _Filter.reorder,
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) {
        final columns = c.maxWidth < 560 ? 2 : 4;
        return _Grid(columns: columns, spacing: 12, children: tiles);
      },
    );
  }
}

/// Lays children out in a fixed number of equal-width columns.
class _Grid extends StatelessWidget {
  const _Grid({
    required this.columns,
    required this.spacing,
    required this.children,
  });

  final int columns;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i += columns) {
      final slice =
          children.sublist(i, math.min(i + columns, children.length));
      // IntrinsicHeight is required: this grid sits in a SliverList (unbounded
      // height). CrossAxisAlignment.stretch on a Row needs a finite max
      // height; without IntrinsicHeight the row children never get a size
      // (`hasSize` / LayoutBuilder re-entry), which then sticks MouseTracker
      // (`!_debugDuringDeviceUpdate`) for the rest of the session.
      rows.add(IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var j = 0; j < columns; j++) ...[
              if (j > 0) SizedBox(width: spacing),
              Expanded(
                child: j < slice.length ? slice[j] : const SizedBox.shrink(),
              ),
            ],
          ],
        ),
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < rows.length; i++) ...[
          if (i > 0) SizedBox(height: spacing),
          rows[i],
        ],
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.value,
    required this.caption,
    this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String value;
  final String caption;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.08) : _kSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.5) : _kBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black45,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: FlipperFonts.mono(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              caption,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightRow extends StatelessWidget {
  const _InsightRow({
    required this.topMover,
    required this.window,
    required this.movementKnown,
    required this.deadItemCount,
    required this.deadValue,
    required this.expiringCount,
    required this.shrinkCount,
    required this.shrinkUnits,
    required this.shrinkValue,
    required this.activeFilter,
    required this.onFilter,
    required this.onSelect,
  });

  final _Line topMover;
  final InventoryWindow window;
  final bool movementKnown;
  final int deadItemCount;
  final double deadValue;
  final int expiringCount;
  final int shrinkCount;
  final double shrinkUnits;
  final double shrinkValue;
  final _Filter activeFilter;
  final ValueChanged<_Filter> onFilter;
  final ValueChanged<String?> onSelect;

  @override
  Widget build(BuildContext context) {
    final hasSales = topMover.sold > 0;
    final tiles = <Widget>[
      _InsightTile(
        icon: Icons.star_rounded,
        color: _kAmber,
        title: !movementKnown
            ? 'Reading sales…'
            : hasSales
                ? topMover.name
                : 'No sales in this period',
        label: 'BEST SELLER · ${window.shortLabel.toUpperCase()}',
        caption: !movementKnown
            ? 'Measured from completed sales'
            : hasSales
                ? '${_qty(topMover.sold)} ${topMover.unit} sold · '
                    'RWF ${formatNumber(topMover.revenue)} in'
                : 'Pick a longer period or check the till',
        onTap: movementKnown && hasSales ? () => onSelect(topMover.id) : null,
      ),
      _InsightTile(
        icon: Icons.hourglass_bottom,
        color: _kPurple,
        title: !movementKnown
            ? '—'
            : deadItemCount == 0
                ? 'Everything is moving'
                : 'RWF ${formatNumber(deadValue)} tied up',
        label: 'NOT SELLING',
        caption: !movementKnown
            ? 'Waiting for sales data'
            : deadItemCount == 0
                ? 'Every item sold at least once in ${window.longLabel}'
                : '$deadItemCount items with stock and no sales '
                    'in ${window.longLabel}',
        onTap: deadItemCount == 0
            ? null
            : () => onFilter(
                activeFilter == _Filter.dead ? _Filter.all : _Filter.dead),
        isActive: activeFilter == _Filter.dead,
      ),
      _InsightTile(
        icon: Icons.inventory_outlined,
        color: shrinkCount == 0 ? _kGreen : _kRed,
        title: !movementKnown
            ? '—'
            : shrinkCount == 0
                ? 'Counts match'
                : 'RWF ${formatNumber(shrinkValue)} lost',
        label: 'STOCK LOSS',
        caption: !movementKnown
            ? 'From stock recounts in this period'
            : shrinkCount == 0
                ? 'No shortfall found in recounts'
                : '${_qty(shrinkUnits)} units missing across $shrinkCount items',
        onTap: shrinkCount == 0
            ? null
            : () => onFilter(
                activeFilter == _Filter.shrink ? _Filter.all : _Filter.shrink),
        isActive: activeFilter == _Filter.shrink,
      ),
      _InsightTile(
        icon: Icons.event_busy_outlined,
        color: expiringCount == 0 ? _kGreen : _kRed,
        title: expiringCount == 0
            ? 'No expiry risk'
            : '$expiringCount items at risk',
        label: 'EXPIRY WATCH',
        caption: expiringCount == 0
            ? 'Nothing expiring in the next $_kExpirySoonDays days'
            : 'Expired or expiring within $_kExpirySoonDays days',
        onTap: expiringCount == 0
            ? null
            : () => onFilter(activeFilter == _Filter.expiring
                ? _Filter.all
                : _Filter.expiring),
        isActive: activeFilter == _Filter.expiring,
      ),
    ];

    return LayoutBuilder(
      builder: (context, c) => _Grid(
        columns: c.maxWidth < 720
            ? 1
            : c.maxWidth < 1040
                ? 2
                : 4,
        spacing: 12,
        children: tiles,
      ),
    );
  }
}

class _InsightTile extends StatelessWidget {
  const _InsightTile({
    required this.icon,
    required this.color,
    required this.label,
    required this.title,
    required this.caption,
    this.onTap,
    this.isActive = false,
  });

  final IconData icon;
  final Color color;
  final String label;
  final String title;
  final String caption;
  final VoidCallback? onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.5) : _kBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Colors.black38,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.black54,
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

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.lines,
    required this.totalCount,
    required this.metric,
    required this.window,
    required this.selectedItemId,
    required this.onMetricChanged,
    required this.onSelect,
  });

  final List<_Line> lines;
  final int totalCount;
  final _ChartMetric metric;
  final InventoryWindow window;
  final String? selectedItemId;
  final ValueChanged<_ChartMetric> onMetricChanged;
  final ValueChanged<String?> onSelect;

  String get _title => switch (metric) {
        _ChartMetric.stock => 'Stock on hand',
        _ChartMetric.sold => 'Units sold · ${window.shortLabel}',
        _ChartMetric.revenue => 'Revenue · ${window.shortLabel}',
        _ChartMetric.cover => 'Days of stock left',
      };

  String get _subtitle => switch (metric) {
        _ChartMetric.stock => 'Tap a bar to select the item.',
        _ChartMetric.sold =>
          'Measured from completed sales. Tap a bar to select.',
        _ChartMetric.revenue =>
          'Selling value of what actually left the shelf.',
        _ChartMetric.cover =>
          'At the current selling pace — shortest runway first.',
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBorder),
      ),
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
                  const Icon(Icons.bar_chart_rounded, size: 20, color: _kBlue),
                  const SizedBox(width: 8),
                  Text(
                    _title,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    totalCount > lines.length
                        ? '· top ${lines.length} of $totalCount'
                        : '· $totalCount items',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MetricChip(
                    label: 'Sold',
                    isActive: metric == _ChartMetric.sold,
                    onTap: () => onMetricChanged(_ChartMetric.sold),
                  ),
                  const SizedBox(width: 6),
                  _MetricChip(
                    label: 'Revenue',
                    isActive: metric == _ChartMetric.revenue,
                    onTap: () => onMetricChanged(_ChartMetric.revenue),
                  ),
                  const SizedBox(width: 6),
                  _MetricChip(
                    label: 'Stock',
                    isActive: metric == _ChartMetric.stock,
                    onTap: () => onMetricChanged(_ChartMetric.stock),
                  ),
                  const SizedBox(width: 6),
                  _MetricChip(
                    label: 'Days left',
                    isActive: metric == _ChartMetric.cover,
                    onTap: () => onMetricChanged(_ChartMetric.cover),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _subtitle,
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.black38),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 240,
            child: _StockBarChart(
              lines: lines,
              metric: metric,
              window: window,
              selectedItemId: selectedItemId,
              onSelect: onSelect,
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? _kBlue : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: isActive ? _kBlue : _kBorder),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _StockBarChart extends StatelessWidget {
  const _StockBarChart({
    required this.lines,
    required this.metric,
    required this.window,
    required this.selectedItemId,
    required this.onSelect,
  });

  final List<_Line> lines;
  final _ChartMetric metric;
  final InventoryWindow window;
  final String? selectedItemId;
  final ValueChanged<String?> onSelect;

  double _metricOf(_Line line) => switch (metric) {
        _ChartMetric.stock => line.current,
        _ChartMetric.sold => line.sold,
        _ChartMetric.revenue => line.revenue,
        // Cap the runway so one slow-moving item does not flatten the rest.
        _ChartMetric.cover => math.min(line.daysOfCover ?? 0, 90),
      };

  Color _colorOf(_Line line) {
    if (line.id == selectedItemId) return _kBlue;
    if (metric == _ChartMetric.cover) {
      final cover = line.daysOfCover ?? double.infinity;
      if (cover < _kCriticalCoverDays) return _kRed;
      if (cover < _kReorderDays) return _kAmber;
      return _kGreen.withValues(alpha: 0.6);
    }
    return switch (line.status) {
      _StockStatus.out => _kRed.withValues(alpha: 0.55),
      _StockStatus.low => _kAmber,
      _StockStatus.healthy => _kBlue.withValues(alpha: 0.55),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (lines.isEmpty) {
      return Center(
        child: Text(
          metric == _ChartMetric.cover
              ? 'No selling pace yet — nothing sold in this period'
              : 'Nothing to chart',
          textAlign: TextAlign.center,
          style: GoogleFonts.outfit(fontSize: 13, color: Colors.black38),
        ),
      );
    }

    final maxValue = lines.map(_metricOf).fold<double>(0, math.max);
    final maxY = maxValue <= 0 ? 1.0 : maxValue * 1.18;

    // Zero-duration: AnimatedWidgetBaseState ticks otherwise rebuild the
    // chart (and surrounding slivers) every frame while data settles, which
    // re-enters LayoutBuilders in the same CustomScrollView.
    return BarChart(
      duration: Duration.zero,
      BarChartData(
        maxY: maxY,
        alignment: BarChartAlignment.spaceAround,
        // Critically: keep [handleBuiltInTouches] false. When true, fl_chart
        // calls setState on every mouse hover to show its tooltip. That rebuild
        // runs inside MouseTracker's device-update phase; Flutter's
        // `_deviceUpdatePhase` has no try/finally, so any assert/exception
        // leaves `_debugDuringDeviceUpdate` stuck true and every later frame
        // floods `!_debugDuringDeviceUpdate` for the rest of the session.
        // Selection details live in [_SelectedLineCard] after a tap instead.
        barTouchData: BarTouchData(
          enabled: true,
          handleBuiltInTouches: false,
          touchCallback: (event, response) {
            final spot = response?.spot;
            if (spot == null || event is! FlTapUpEvent) return;
            final index = spot.touchedBarGroupIndex;
            if (index < 0 || index >= lines.length) return;
            final line = lines[index];
            final next = line.id == selectedItemId ? null : line.id;
            // Defer past pointer/mouse-tracker dispatch so selecting a bar
            // does not tear the tree down mid hit-test.
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onSelect(next);
            });
          },
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 4,
          getDrawingHorizontalLine: (_) => const FlLine(
            color: Color(0x11000000),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(),
          rightTitles: const AxisTitles(),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 44,
              interval: maxY / 4,
              getTitlesWidget: (value, meta) {
                if (value <= 0) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Text(
                    formatNumber(value),
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      color: Colors.black38,
                    ),
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 58,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= lines.length) {
                  return const SizedBox.shrink();
                }
                final line = lines[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Transform.rotate(
                    angle: -0.62,
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      width: 66,
                      child: Text(
                        line.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                        style: GoogleFonts.outfit(
                          fontSize: 10,
                          fontWeight: line.id == selectedItemId
                              ? FontWeight.w700
                              : FontWeight.w400,
                          color: line.id == selectedItemId
                              ? _kBlue
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < lines.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: _metricOf(lines[i]),
                  width: 18,
                  color: _colorOf(lines[i]),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: maxY,
                    color: const Color(0x08000000),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SelectedLineCard extends StatelessWidget {
  const _SelectedLineCard({
    required this.line,
    required this.window,
    required this.onClear,
  });

  final _Line line;
  final InventoryWindow window;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final days = line.daysToExpiry;
    final cover = line.daysOfCover;
    final restocked = line.restocked;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _kBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kBlue.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  line.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _StatusPill(line: line),
              IconButton(
                onPressed: onClear,
                tooltip: 'Clear selection',
                icon: const Icon(Icons.close, size: 16),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Movement measured over ${window.longLabel}',
            style: GoogleFonts.outfit(fontSize: 11, color: Colors.black45),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _MiniMetric(
                label: 'In stock',
                value: '${_qty(line.current)} ${line.unit}',
              ),
              _MiniMetric(
                label: 'Sold',
                value: line.movementKnown ? _qty(line.sold) : '—',
              ),
              _MiniMetric(
                label: 'Revenue',
                value: line.movementKnown
                    ? 'RWF ${formatNumber(line.revenue)}'
                    : '—',
              ),
              _MiniMetric(
                label: 'Profit',
                value: line.movementKnown
                    ? 'RWF ${formatNumber(line.profit)} '
                        '(${(line.margin * 100).toStringAsFixed(0)}%)'
                    : '—',
              ),
              _MiniMetric(
                label: 'Selling pace',
                value: line.movementKnown
                    ? '${_qty(line.velocity)} ${line.unit}/day'
                    : '—',
              ),
              _MiniMetric(
                label: 'Stock left',
                value: !line.movementKnown
                    ? '—'
                    : cover == null
                        ? 'no sales'
                        : _coverLabel(cover),
                color: cover != null && cover < _kReorderDays ? _kRed : null,
              ),
              _MiniMetric(
                label: 'Sell-through',
                value: line.movementKnown
                    ? '${(line.sellThrough * 100).toStringAsFixed(0)}%'
                    : '—',
              ),
              if (restocked != null && restocked > 0)
                _MiniMetric(
                  label: 'Received (est.)',
                  value: '${_qty(restocked)} ${line.unit}',
                ),
              if (line.adjustment != 0)
                _MiniMetric(
                  label: line.adjustment < 0 ? 'Missing at count' : 'Found at count',
                  value: _qty(line.adjustment.abs()),
                  color: line.adjustment < 0 ? _kRed : _kGreen,
                ),
              _MiniMetric(
                label: 'Unit price',
                value: 'RWF ${formatNumber(line.unitPrice)}',
              ),
              _MiniMetric(
                label: 'Stock value',
                value: 'RWF ${formatNumber(line.value)}',
              ),
              _MiniMetric(
                label: 'Alert level',
                value: line.low > 0 ? _qty(line.low) : 'not set',
              ),
              if (line.movement.lastSoldAt != null)
                _MiniMetric(
                  label: 'Last sold',
                  value: timeago.format(line.movement.lastSoldAt!),
                ),
              if (days != null)
                _MiniMetric(
                  label: 'Expiry',
                  value: days < 0
                      ? 'expired'
                      : days == 0
                          ? 'today'
                          : 'in $days days',
                  color: days <= _kExpirySoonDays ? _kRed : null,
                ),
              if (line.updatedAt != null)
                _MiniMetric(
                  label: 'Stock updated',
                  value: timeago.format(line.updatedAt!),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.black38,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: FlipperFonts.mono(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _ListToolbar extends StatelessWidget {
  const _ListToolbar({
    required this.controller,
    required this.query,
    required this.filter,
    required this.sortBy,
    required this.expiringCount,
    required this.deadCount,
    required this.lowCount,
    required this.outCount,
    required this.reorderCount,
    required this.shrinkCount,
    required this.onQueryChanged,
    required this.onFilterChanged,
    required this.onSortChanged,
  });

  final TextEditingController controller;
  final String query;
  final _Filter filter;
  final _SortBy sortBy;
  final int expiringCount;
  final int deadCount;
  final int lowCount;
  final int outCount;
  final int reorderCount;
  final int shrinkCount;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<_Filter> onFilterChanged;
  final ValueChanged<_SortBy> onSortChanged;

  static const _sortLabels = {
    _SortBy.coverAsc: 'Runs out soonest',
    _SortBy.stockAsc: 'Lowest stock first',
    _SortBy.soldDesc: 'Best selling first',
    _SortBy.valueDesc: 'Highest value first',
    _SortBy.stockDesc: 'Highest stock first',
    _SortBy.nameAsc: 'Name A–Z',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, c) {
            final search = SizedBox(
              height: 40,
              child: TextField(
                controller: controller,
                onChanged: onQueryChanged,
                style: GoogleFonts.outfit(fontSize: 14),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: 'Search item, category, SKU or barcode',
                  hintStyle: GoogleFonts.outfit(
                    fontSize: 13,
                    color: Colors.black38,
                  ),
                  prefixIcon: const Icon(Icons.search, size: 18),
                  suffixIcon: query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear, size: 16),
                          onPressed: () {
                            controller.clear();
                            onQueryChanged('');
                          },
                        ),
                  filled: true,
                  fillColor: _kSurface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _kBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: _kBorder),
                  ),
                ),
              ),
            );
            final sort = _SortDropdown(
              sortBy: sortBy,
              labels: _sortLabels,
              onChanged: onSortChanged,
            );
            if (c.maxWidth < 560) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [search, const SizedBox(height: 10), sort],
              );
            }
            return Row(
              children: [
                Expanded(child: search),
                const SizedBox(width: 12),
                sort,
              ],
            );
          },
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FilterChip(
              label: 'All items',
              isActive: filter == _Filter.all,
              onTap: () => onFilterChanged(_Filter.all),
            ),
            _FilterChip(
              label: 'Reorder now ($reorderCount)',
              color: _kAmber,
              isActive: filter == _Filter.reorder,
              onTap: () => onFilterChanged(_Filter.reorder),
            ),
            _FilterChip(
              label: 'Out of stock ($outCount)',
              color: _kRed,
              isActive: filter == _Filter.out,
              onTap: () => onFilterChanged(_Filter.out),
            ),
            _FilterChip(
              label: 'Running low ($lowCount)',
              color: _kAmber,
              isActive: filter == _Filter.low,
              onTap: () => onFilterChanged(_Filter.low),
            ),
            _FilterChip(
              label: 'Not selling ($deadCount)',
              color: _kPurple,
              isActive: filter == _Filter.dead,
              onTap: () => onFilterChanged(_Filter.dead),
            ),
            _FilterChip(
              label: 'Stock loss ($shrinkCount)',
              color: _kRed,
              isActive: filter == _Filter.shrink,
              onTap: () => onFilterChanged(_Filter.shrink),
            ),
            _FilterChip(
              label: 'Expiry risk ($expiringCount)',
              color: _kPurple,
              isActive: filter == _Filter.expiring,
              onTap: () => onFilterChanged(_Filter.expiring),
            ),
          ],
        ),
      ],
    );
  }
}

class _SortDropdown extends StatelessWidget {
  const _SortDropdown({
    required this.sortBy,
    required this.labels,
    required this.onChanged,
  });

  final _SortBy sortBy;
  final Map<_SortBy, String> labels;
  final ValueChanged<_SortBy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _kSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<_SortBy>(
          value: sortBy,
          isDense: true,
          icon: const Icon(Icons.swap_vert, size: 18),
          borderRadius: BorderRadius.circular(10),
          style: GoogleFonts.outfit(fontSize: 13, color: Colors.black87),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          items: [
            for (final entry in labels.entries)
              DropdownMenuItem(value: entry.key, child: Text(entry.value)),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
    this.color = _kBlue,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.12) : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isActive ? color.withValues(alpha: 0.6) : _kBorder,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive ? color : Colors.black54,
          ),
        ),
      ),
    );
  }
}

class _ResultSummary extends StatelessWidget {
  const _ResultSummary({
    required this.shown,
    required this.total,
    required this.value,
    required this.lastUpdated,
  });

  final int shown;
  final int total;
  final double value;
  final DateTime? lastUpdated;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Showing $shown of $total items · RWF ${formatNumber(value)} in view',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
          ),
        ),
        if (lastUpdated != null)
          Text(
            'Stock updated ${timeago.format(lastUpdated!)}',
            style: GoogleFonts.outfit(fontSize: 12, color: Colors.black38),
          ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({
    required this.line,
    required this.isSelected,
    required this.onTap,
  });

  final _Line line;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? _kBlue.withValues(alpha: 0.05) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? _kBlue.withValues(alpha: 0.4) : _kBorder,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, c) {
              final compact = c.maxWidth < 560;
              final wide = c.maxWidth >= 860;
              return Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                line.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            if (line.shrink > 0) ...[
                              const SizedBox(width: 6),
                              Tooltip(
                                message:
                                    '${_qty(line.shrink)} ${line.unit} missing '
                                    'at the last stock count',
                                child: const Icon(
                                  Icons.report_gmailerrorred,
                                  size: 14,
                                  color: _kRed,
                                ),
                              ),
                            ],
                            if (line.isExpired || line.isExpiringSoon) ...[
                              const SizedBox(width: 6),
                              Tooltip(
                                message: line.isExpired
                                    ? 'Expired'
                                    : 'Expires in ${line.daysToExpiry} days',
                                child: Icon(
                                  Icons.event_busy_outlined,
                                  size: 14,
                                  color: line.isExpired ? _kRed : _kPurple,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          [
                            line.category,
                            if (line.variant.sku?.isNotEmpty ?? false)
                              'SKU ${line.variant.sku}',
                          ].join(' · '),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: _ColumnFigure(
                      label: 'In stock',
                      value: '${_qty(line.current)} ${line.unit}',
                      color: switch (line.status) {
                        _StockStatus.out => _kRed,
                        _StockStatus.low => _kAmber,
                        _StockStatus.healthy => Colors.black87,
                      },
                    ),
                  ),
                  if (!compact) ...[
                    Expanded(
                      flex: 2,
                      child: _ColumnFigure(
                        label: 'Sold',
                        value: line.movementKnown ? _qty(line.sold) : '—',
                        color: Colors.black87,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: _CoverFigure(line: line),
                    ),
                    if (wide)
                      Expanded(
                        flex: 2,
                        child: _ColumnFigure(
                          label: 'Value',
                          value: 'RWF ${formatNumber(line.value)}',
                          color: _kGreen,
                        ),
                      ),
                    Expanded(
                      flex: 3,
                      child: _SellThroughBar(line: line),
                    ),
                    const SizedBox(width: 12),
                  ],
                  _StatusPill(line: line),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ColumnFigure extends StatelessWidget {
  const _ColumnFigure({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.outfit(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.black38,
            letterSpacing: 0.3,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: FlipperFonts.mono(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

/// Days of stock left at the measured selling pace — the reorder signal.
class _CoverFigure extends StatelessWidget {
  const _CoverFigure({required this.line});

  final _Line line;

  @override
  Widget build(BuildContext context) {
    final cover = line.daysOfCover;
    final String value;
    Color color = Colors.black87;

    if (!line.movementKnown) {
      value = '—';
    } else if (line.status == _StockStatus.out) {
      value = 'empty';
      color = _kRed;
    } else if (cover == null) {
      value = 'no sales';
      color = Colors.black38;
    } else {
      value = _coverLabel(cover);
      if (cover < _kCriticalCoverDays) {
        color = _kRed;
      } else if (cover < _kReorderDays) {
        color = _kAmber;
      }
    }

    return Tooltip(
      message: cover == null
          ? 'Needs sales in this period to work out a selling pace'
          : 'Selling ${_qty(line.velocity)} ${line.unit}/day — '
              '${_qty(line.current)} left',
      child: _ColumnFigure(label: 'Stock left', value: value, color: color),
    );
  }
}

class _SellThroughBar extends StatelessWidget {
  const _SellThroughBar({required this.line});

  final _Line line;

  @override
  Widget build(BuildContext context) {
    final pct = line.sellThrough;
    final available = line.movement.availableInWindow(line.current);
    return Tooltip(
      message: available == null
          ? '${_qty(line.sold)} sold against ${_qty(line.current)} still on '
              'the shelf'
          : '${_qty(line.sold)} of ${_qty(available)} ${line.unit} available '
              'in the period have sold',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SELL-THROUGH',
            style: GoogleFonts.outfit(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: Colors.black38,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: line.movementKnown ? pct : 0,
                    minHeight: 6,
                    backgroundColor: const Color(0x14000000),
                    valueColor: AlwaysStoppedAnimation(
                      pct >= 0.8 ? _kGreen : _kBlue,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                line.movementKnown
                    ? '${(pct * 100).toStringAsFixed(0)}%'
                    : '—',
                style: FlipperFonts.mono(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.line});

  final _Line line;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (line.status) {
      _StockStatus.out => ('Out of stock', _kRed),
      _StockStatus.low => ('Low', _kAmber),
      _StockStatus.healthy => line.needsReorder
          ? ('Reorder', _kAmber)
          : ('In stock', _kGreen),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black26),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style:
                GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: _kRed),
            const SizedBox(height: 12),
            Text(
              'Could not load stock',
              style:
                  GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.outfit(fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: Text('Try again', style: GoogleFonts.outfit()),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quantities read better without a trailing `.0`.
String _qty(double value) {
  if (value.abs() >= 100000) return formatNumber(value);
  return value == value.roundToDouble()
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
}

/// Days of stock left, phrased the way an owner would say it.
String _coverLabel(double days) {
  if (days < 1) return 'under a day';
  if (days < 60) return '${days.round()} days';
  if (days < 365) return '${(days / 30).round()} months';
  return 'over a year';
}
