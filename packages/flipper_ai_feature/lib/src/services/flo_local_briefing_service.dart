import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:intl/intl.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

import '../models/flo_models.dart';

/// Builds today's briefing from on-device Capella/Ditto sales (instant after checkout).
class FloLocalBriefingService {
  static Stream<FloDailyBriefing?> watchToday(String branchId) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
    final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;

    return capella
        .transactionsStream(
          startDate: start,
          endDate: end,
          branchId: branchId,
          skipOriginalTransactionCheck: true,
          removeAdjustmentTransactions: true,
          forceRealData: true,
        )
        .asyncMap(
          (transactions) =>
              buildFromTransactions(transactions, branchId, start, end),
        );
  }

  static Future<FloDailyBriefing?> buildFromTransactions(
    List<ITransaction> transactions,
    String branchId,
    DateTime start,
    DateTime end,
  ) async {
    final sales = transactions.where((tx) => (tx.subTotal ?? 0) > 0).toList();
    if (sales.isEmpty) return null;

    final revenue = sales.fold<double>(
      0,
      (sum, tx) => sum + (tx.subTotal ?? 0),
    );
    if (revenue < 0.01) return null;

    final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;
    final items = await capella.fetchTransactionItemsReportScope(
      startDate: start,
      endDate: end,
      branchId: branchId,
    );
    final units = _countUnits(sales, items);
    final unitCount = units >= 1 ? units.round() : sales.length;

    final now = DateTime.now();
    final dateLabel = DateFormat('d MMM').format(now);
    final txCount = sales.length;
    final txLabel = txCount == 1 ? '1 transaction' : '$txCount transactions';
    final rev = _formatRwf(revenue);

    return FloDailyBriefing(
      dateLabel: dateLabel,
      headline: 'Sales are coming in today.',
      bodyHtml:
          'Revenue reached <b>RWF $rev</b> across <b>$txLabel</b> ($unitCount units) so far today — live from your device.',
      stats: [
        FloBriefingStat(
          label: 'Revenue',
          unit: 'RWF',
          value: rev,
        ),
        const FloBriefingStat(
          label: 'Net profit',
          unit: 'RWF',
          value: '—',
        ),
        FloBriefingStat(
          label: 'Units sold',
          value: '$unitCount',
        ),
      ],
      empty: false,
    );
  }

  static double _countUnits(
    List<ITransaction> sales,
    List<TransactionItem> items,
  ) {
    final saleIds = sales.map((t) => t.id).toSet();
    var units = 0.0;
    for (final item in items) {
      if (item.active == false) continue;
      if (!_itemMatchesSale(item, saleIds)) continue;
      units += item.qty.toDouble();
    }
    return units;
  }

  static bool _itemMatchesSale(TransactionItem item, Set<String> saleIds) {
    final tid = item.transactionId?.trim();
    if (tid == null || tid.isEmpty) return false;
    if (saleIds.contains(tid)) return true;
    final compact = tid.replaceAll('-', '').toLowerCase();
    for (final id in saleIds) {
      if (id.replaceAll('-', '').toLowerCase() == compact) return true;
    }
    return false;
  }

  static Future<Map<String, dynamic>?> todayDeviceSalesContext(
    String branchId,
  ) =>
      deviceSalesContext(branchId, SalesPeriod.today());

  /// On-device sales context for an arbitrary [period] (today, yesterday, this
  /// week, …). Returns aggregates + a per-item breakdown. Returns a zeroed
  /// context (not null) when there were simply no sales in the window, so the
  /// model can say "no sales <period>" instead of guessing; returns null only
  /// when the data could not be loaded.
  static Future<Map<String, dynamic>?> deviceSalesContext(
    String branchId,
    SalesPeriod period,
  ) async {
    final start = period.start;
    final end = period.end;
    final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;

    List<ITransaction> transactions;
    try {
      transactions = await capella
          .transactionsStream(
            startDate: start,
            endDate: end,
            branchId: branchId,
            skipOriginalTransactionCheck: true,
            removeAdjustmentTransactions: true,
            forceRealData: true,
          )
          .first
          .timeout(const Duration(seconds: 8));
    } catch (_) {
      return null;
    }

    final sales = transactions.where((tx) => (tx.subTotal ?? 0) > 0).toList();
    if (sales.isEmpty) {
      return {
        'period_label': period.label,
        'total_revenue': 0,
        'units_sold': 0,
        'transaction_count': 0,
        'top_items': const <Map<String, dynamic>>[],
        'data_source': 'device_ditto',
      };
    }

    final revenue = sales.fold<double>(0, (s, tx) => s + (tx.subTotal ?? 0));
    // Item-level breakdown so the model answers "what sold?" from real data
    // instead of inventing product names.
    final topItems = await _topItemsSold(branchId, start, end, sales);
    final units = topItems.fold<num>(0, (s, it) => s + (it['qty'] as num? ?? 0));

    return {
      'period_label': period.label,
      'total_revenue': revenue.round(),
      'units_sold': units > 0 ? units : sales.length,
      'transaction_count': sales.length,
      'top_items': topItems,
      'data_source': 'device_ditto',
    };
  }

  /// Aggregates today's sold items by name → [{name, qty, revenue}], sorted by
  /// quantity desc, capped at 12. Empty when there is no item-level data.
  static Future<List<Map<String, dynamic>>> _topItemsSold(
    String branchId,
    DateTime start,
    DateTime end,
    List<ITransaction> sales,
  ) async {
    try {
      final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;
      final items = await capella.fetchTransactionItemsReportScope(
        startDate: start,
        endDate: end,
        branchId: branchId,
      );
      final saleIds = sales.map((t) => t.id).toSet();
      final qtyByName = <String, double>{};
      final revByName = <String, double>{};
      for (final it in items) {
        if (it.active == false) continue;
        if (!_itemMatchesSale(it, saleIds)) continue;
        final name = it.name.trim().isEmpty ? 'Unnamed item' : it.name.trim();
        final qty = it.qty.toDouble();
        final rev = it.totAmt?.toDouble() ?? (it.price.toDouble() * qty);
        qtyByName[name] = (qtyByName[name] ?? 0) + qty;
        revByName[name] = (revByName[name] ?? 0) + rev;
      }
      final names = qtyByName.keys.toList()
        ..sort((a, b) => qtyByName[b]!.compareTo(qtyByName[a]!));
      return [
        for (final n in names.take(12))
          {
            'name': n,
            'qty': qtyByName[n]! % 1 == 0
                ? qtyByName[n]!.toInt()
                : double.parse(qtyByName[n]!.toStringAsFixed(2)),
            'revenue': revByName[n]!.round(),
          },
      ];
    } catch (_) {
      return const [];
    }
  }

  /// Prefer local when revenue matches or beats remote and units are at least as high.
  static FloDailyBriefing? merge(FloDailyBriefing? remote, FloDailyBriefing? local) {
    if (remote == null || remote.empty) return local;
    if (local == null || local.empty) return remote;
    final remoteRevenue = _parseStat(remote, 'Revenue');
    final localRevenue = _parseStat(local, 'Revenue');
    final remoteUnits = _parseStat(remote, 'Units sold');
    final localUnits = _parseStat(local, 'Units sold');
    if (localRevenue >= remoteRevenue - 0.01 && localUnits >= remoteUnits) {
      return local;
    }
    if (localRevenue > remoteRevenue) return local;
    return remote;
  }

  static double _parseStat(FloDailyBriefing briefing, String label) {
    for (final stat in briefing.stats) {
      if (stat.label != label) continue;
      final digits = stat.value.replaceAll(RegExp(r'[^0-9.]'), '');
      return double.tryParse(digits) ?? 0;
    }
    return 0;
  }

  static String _formatRwf(double value) {
    final whole = value.round();
    return NumberFormat('#,###').format(whole);
  }
}

/// A resolved date window for sales queries, with a human label for the prompt.
/// [end] is exclusive (i.e. `[start, end)`).
class SalesPeriod {
  final DateTime start;
  final DateTime end;
  final String label;
  const SalesPeriod(this.start, this.end, this.label);

  static SalesPeriod today() {
    final now = DateTime.now();
    final s = DateTime(now.year, now.month, now.day);
    return SalesPeriod(s, s.add(const Duration(days: 1)), 'today');
  }

  static SalesPeriod yesterday() {
    final now = DateTime.now();
    final s = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(days: 1));
    return SalesPeriod(s, s.add(const Duration(days: 1)), 'yesterday');
  }

  /// Best-effort natural-language detection of the period a question is about.
  /// Defaults to today when nothing matches.
  static SalesPeriod resolve(String message) {
    final m = message.toLowerCase();
    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);
    final tomorrow = midnight.add(const Duration(days: 1));

    if (m.contains('yesterday')) return yesterday();
    if (m.contains('last month')) {
      return SalesPeriod(DateTime(now.year, now.month - 1, 1),
          DateTime(now.year, now.month, 1), 'last month');
    }
    if (m.contains('this month') || m.contains('month')) {
      return SalesPeriod(DateTime(now.year, now.month, 1),
          DateTime(now.year, now.month + 1, 1), 'this month');
    }
    if (m.contains('last 7') ||
        m.contains('past 7') ||
        m.contains('last week') ||
        m.contains('past week')) {
      return SalesPeriod(
          midnight.subtract(const Duration(days: 7)), tomorrow, 'the last 7 days');
    }
    if (m.contains('this week') || m.contains('week')) {
      // Week starting Monday through end of today.
      final s = midnight.subtract(Duration(days: midnight.weekday - 1));
      return SalesPeriod(s, tomorrow, 'this week');
    }
    return today();
  }
}
