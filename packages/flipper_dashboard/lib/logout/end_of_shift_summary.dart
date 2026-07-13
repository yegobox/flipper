import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_dashboard/export/export_report_transactions.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/transaction_report_plu_filters.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/sync/capella/capella_sync.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/sync/shift_sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';

/// Snapshot shown in the end-of-shift dialog for the signed-in agent only.
class EndOfShiftSummary {
  final String agentLabel;
  final String branchName;
  final bool hasOpenShift;
  final DateTime? shiftStartedAt;
  final Duration shiftDuration;
  final double totalCollected;
  final double cashDrawer;
  final double mobileMoney;
  final int salesCompleted;
  final int itemsSold;

  const EndOfShiftSummary({
    required this.agentLabel,
    required this.branchName,
    required this.hasOpenShift,
    this.shiftStartedAt,
    required this.shiftDuration,
    required this.totalCollected,
    required this.cashDrawer,
    required this.mobileMoney,
    required this.salesCompleted,
    required this.itemsSold,
  });

  static const empty = EndOfShiftSummary(
    agentLabel: 'Agent',
    branchName: 'Branch',
    hasOpenShift: false,
    shiftDuration: Duration.zero,
    totalCollected: 0,
    cashDrawer: 0,
    mobileMoney: 0,
    salesCompleted: 0,
    itemsSold: 0,
  );
}

String formatAgentShortName(String? fullName) {
  final trimmed = fullName?.trim();
  if (trimmed == null || trimmed.isEmpty) return 'Agent';
  final parts =
      trimmed.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  if (parts.length == 1) return parts.first;
  final first = parts.first;
  final lastInitial = parts.last[0].toUpperCase();
  return '$first $lastInitial.';
}

bool _isMobileMoneyMethod(String? method) {
  final m = (method ?? '').trim().toUpperCase();
  if (m.isEmpty) return false;
  if (paymentMethodIsCredit(method)) return false;
  if (m == 'CASH') return false;
  return m.contains('MOMO') ||
      m.contains('MOBILE') ||
      m.contains('MTN') ||
      m.contains('AIRTEL') ||
      m.contains('MPESA') ||
      m.contains('WALLET');
}

bool _isCompletedShiftSale(ITransaction tx, Shift shift) {
  if (!transactionIsReportExportSale(tx)) return false;
  if (tx.status != COMPLETE) return false;
  return tx.shiftId?.trim() == shift.id;
}

/// Sales explicitly tagged with the open shift id (same scope as close-shift).
Future<List<ITransaction>> _loadShiftSales({
  required Shift shift,
  required String userId,
  required String branchId,
}) async {
  if (ProxyService.ditto.isReady()) {
    try {
      final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;
      final sales = await capella.listSalesForOpenShift(
        shiftId: shift.id,
        agentId: userId,
        branchId: branchId,
      );
      return sales.where((tx) => _isCompletedShiftSale(tx, shift)).toList();
    } catch (_) {
      // Fall through to Brick.
    }
  }

  final repo = Repository();
  final transactions = await repo.get<ITransaction>(
    query: Query(
      where: [
        Where('shiftId').isExactly(shift.id),
        Where('agentId').isExactly(userId),
        Where('branchId').isExactly(branchId),
        Where('status').isExactly(COMPLETE),
      ],
    ),
    policy: OfflineFirstGetPolicy.localOnly,
  );

  return transactions
      .where((tx) => _isCompletedShiftSale(tx, shift))
      .toList();
}

Future<int> _countItemsSold(List<ITransaction> sales) async {
  if (sales.isEmpty) return 0;

  final ids = sales
      .map((t) => t.id.toString())
      .where((id) => id.isNotEmpty)
      .toList(growable: false);
  if (ids.isEmpty) return 0;

  if (ProxyService.ditto.isReady()) {
    try {
      final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;
      const chunk = 400;
      var total = 0;
      for (var i = 0; i < ids.length; i += chunk) {
        final end = (i + chunk < ids.length) ? i + chunk : ids.length;
        final grouped = await capella.transactionItemsForIds(ids.sublist(i, end));
        for (final item in grouped.values.expand((e) => e)) {
          if (item.isRefunded == true) continue;
          if (transactionReportCashMovementPluLine(item)) continue;
          total += item.qty.round();
        }
      }
      return total;
    } catch (_) {
      // Fall through to Brick.
    }
  }

  final repo = Repository();
  final items = await repo.get<TransactionItem>(
    query: Query(where: [Where('transactionId').isIn(ids)]),
    policy: OfflineFirstGetPolicy.localOnly,
  );

  var total = 0;
  for (final item in items) {
    if (item.isRefunded == true) continue;
    if (transactionReportCashMovementPluLine(item)) continue;
    total += item.qty.round();
  }
  return total;
}

Future<double> _sumMobilePayments({
  required List<ITransaction> sales,
  required String branchId,
}) async {
  if (sales.isEmpty) return 0;

  final saleIds = sales.map((t) => t.id.toString()).toList();
  final sums = await getPaymentSumsByTransactionIdsChunked(
    saleIds,
    branchId: branchId,
  );

  double mobileMoney = 0;

  if (ProxyService.ditto.isReady()) {
    try {
      final capella = ProxyService.getStrategy(Strategy.capella) as CapellaSync;
      final ditto = capella.dittoService.dittoInstance;
      if (ditto != null && saleIds.isNotEmpty) {
        final placeholders = saleIds
            .asMap()
            .entries
            .map((e) => ':t${e.key}')
            .join(', ');
        final arguments = <String, dynamic>{
          for (var i = 0; i < saleIds.length; i++) 't$i': saleIds[i],
        };
        final result = await ditto.store.execute(
          'SELECT * FROM transaction_payment_records '
          'WHERE transactionId IN ($placeholders)',
          arguments: arguments,
        );
        for (final item in result.items) {
          final data = Map<String, dynamic>.from(item.value);
          final method = data['paymentMethod'] as String?;
          if (paymentMethodIsCredit(method)) continue;
          final amt = parsePaymentAmount(data['amount']);
          if (_isMobileMoneyMethod(method)) {
            mobileMoney += amt;
          }
        }
        return mobileMoney;
      }
    } catch (_) {
      // Fall through to per-txn fallback.
    }
  }

  for (final tx in sales) {
    final tid = tx.id.toString();
    final sumsForTx = sums[tid];
    double paid = 0;
    if (sumsForTx != null && sumsForTx.hasAnyRecord) {
      paid = sumsForTx.byHand;
    } else {
      paid = tx.cashReceived ?? tx.subTotal ?? 0.0;
    }
    if (paid <= 0) continue;
    final pt = (tx.paymentType ?? 'CASH').toUpperCase();
    if (_isMobileMoneyMethod(pt)) {
      mobileMoney += paid;
    }
  }

  return mobileMoney;
}

/// Money totals from the open [Shift] row (same source as close-shift dialog).
Future<({double cash, double mobile, double total})> _loadPaymentBreakdown({
  required Shift shift,
  required List<ITransaction> sales,
  required String branchId,
}) async {
  final opening = shift.openingBalance.toDouble();
  final shiftSales = (shift.cashSales ?? 0).toDouble();
  final totalFromShift = ((shift.expectedCash ?? (opening + shiftSales)) - opening)
      .clamp(0.0, double.infinity);

  final mobileMoney = await _sumMobilePayments(
    sales: sales,
    branchId: branchId,
  );
  final cashDrawer = (totalFromShift - mobileMoney).clamp(0.0, double.infinity);

  return (
    cash: cashDrawer,
    mobile: mobileMoney,
    total: totalFromShift > 0 ? totalFromShift : shiftSales,
  );
}

Future<EndOfShiftSummary> loadEndOfShiftSummary({
  String? branchName,
}) async {
  final userId = ProxyService.box.getUserId();
  final branchId = ProxyService.box.getBranchId();
  final agentLabel = formatAgentShortName(ProxyService.box.getUserName());
  final resolvedBranch = branchName?.trim();
  final branchLabel = (resolvedBranch != null && resolvedBranch.isNotEmpty)
      ? resolvedBranch
      : 'Branch';

  if (userId == null || branchId == null) {
    return EndOfShiftSummary.empty.copyWith(
      agentLabel: agentLabel,
      branchName: branchLabel,
    );
  }

  final shift = await shiftSync.getCurrentShift(userId: userId);
  if (shift == null || shift.userId != userId) {
    return EndOfShiftSummary(
      agentLabel: agentLabel,
      branchName: branchLabel,
      hasOpenShift: false,
      shiftDuration: Duration.zero,
      totalCollected: 0,
      cashDrawer: 0,
      mobileMoney: 0,
      salesCompleted: 0,
      itemsSold: 0,
    );
  }

  final sales = await _loadShiftSales(
    shift: shift,
    userId: userId,
    branchId: branchId,
  );
  final payments = await _loadPaymentBreakdown(
    shift: shift,
    sales: sales,
    branchId: branchId,
  );
  final itemsSold = await _countItemsSold(sales);

  return EndOfShiftSummary(
    agentLabel: agentLabel,
    branchName: branchLabel,
    hasOpenShift: true,
    shiftStartedAt: shift.startAt,
    shiftDuration: DateTime.now().difference(shift.startAt),
    totalCollected: payments.total,
    cashDrawer: payments.cash,
    mobileMoney: payments.mobile,
    salesCompleted: sales.length,
    itemsSold: itemsSold,
  );
}

extension on EndOfShiftSummary {
  EndOfShiftSummary copyWith({
    String? agentLabel,
    String? branchName,
  }) {
    return EndOfShiftSummary(
      agentLabel: agentLabel ?? this.agentLabel,
      branchName: branchName ?? this.branchName,
      hasOpenShift: hasOpenShift,
      shiftStartedAt: shiftStartedAt,
      shiftDuration: shiftDuration,
      totalCollected: totalCollected,
      cashDrawer: cashDrawer,
      mobileMoney: mobileMoney,
      salesCompleted: salesCompleted,
      itemsSold: itemsSold,
    );
  }
}
