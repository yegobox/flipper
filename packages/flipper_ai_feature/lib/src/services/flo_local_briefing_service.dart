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
  ) async {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day);
    final end = start.add(const Duration(days: 1));
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

    final briefing =
        await buildFromTransactions(transactions, branchId, start, end);
    if (briefing == null) return null;

    final sales =
        transactions.where((tx) => (tx.subTotal ?? 0) > 0).toList();
    return {
      'period_label': 'today',
      'total_revenue': _parseStat(briefing, 'Revenue'),
      'units_sold': _parseStat(briefing, 'Units sold'),
      'transaction_count': sales.length,
      'data_source': 'device_ditto',
    };
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
