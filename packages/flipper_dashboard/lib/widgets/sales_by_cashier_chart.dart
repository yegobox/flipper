import 'package:flipper_dashboard/transaction_report_mock_cashiers.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

export 'package:flipper_dashboard/transaction_report_cashier_utils.dart'
    show cashierLabelFromAgentId, initialsFromLabel, cashierAccentColorForAgentId;

class CashierSalesEntry {
  const CashierSalesEntry({
    required this.cashierId,
    required this.cashierLabel,
    required this.initials,
    required this.salesTotal,
    required this.byHandTotal,
    required this.creditTotal,
  });

  final String cashierId;
  final String cashierLabel;
  final String initials;
  final double salesTotal;
  final double byHandTotal;
  final double creditTotal;
}

class SalesByCashierChart extends StatelessWidget {
  const SalesByCashierChart({
    super.key,
    required this.transactions,
    required this.paymentSumsByTransactionId,
    this.currencySymbol,
  });

  final List<ITransaction> transactions;
  final Map<String, TransactionPaymentSums>? paymentSumsByTransactionId;
  final String? currencySymbol;

  List<CashierSalesEntry> _buildEntries() {
    final sumsMap = paymentSumsByTransactionId ?? const {};
    final byCashier = <String, CashierSalesEntry>{};

    for (final tx in transactions) {
      final agentId = (tx.agentId ?? '').trim();
      if (agentId.isEmpty) continue;

      final s = sumsMap[tx.id.toString()];
      final byHand = (s == null || !s.hasAnyRecord) ? (tx.cashReceived ?? 0.0) : s.byHand;
      final credit = (s == null || !s.hasAnyRecord) ? 0.0 : s.credit;
      final sales = tx.subTotal ?? 0.0;

      final label = transactionReportCashierDisplayLabelForAgentId(agentId);
      final initials = transactionReportCashierInitialsForAgentId(agentId);

      final existing = byCashier[agentId];
      if (existing == null) {
        byCashier[agentId] = CashierSalesEntry(
          cashierId: agentId,
          cashierLabel: label,
          initials: initials,
          salesTotal: sales,
          byHandTotal: byHand,
          creditTotal: credit,
        );
      } else {
        byCashier[agentId] = CashierSalesEntry(
          cashierId: existing.cashierId,
          cashierLabel: existing.cashierLabel,
          initials: existing.initials,
          salesTotal: existing.salesTotal + sales,
          byHandTotal: existing.byHandTotal + byHand,
          creditTotal: existing.creditTotal + credit,
        );
      }
    }

    final list = byCashier.values.toList()
      ..sort((a, b) => b.salesTotal.compareTo(a.salesTotal));
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries();
    final maxSales = entries.fold<double>(
      0.0,
      (m, e) => e.salesTotal > m ? e.salesTotal : m,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'SALES BY CASHIER',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Colors.grey.shade600,
                  letterSpacing: 0.6,
                ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: entries.length,
              separatorBuilder: (_, __) => const SizedBox(height: 14),
              itemBuilder: (context, index) {
                final e = entries[index];
                return _CashierBarRow(
                  entry: e,
                  maxSales: maxSales,
                  currencySymbol: currencySymbol ?? ProxyService.box.defaultCurrency(),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 14,
            children: const [
              _LegendDot(color: Color(0xFF16A34A), label: 'Sales'),
              _LegendDot(color: Color(0xFF3B82F6), label: 'By hand'),
              _LegendDot(color: Color(0xFFF59E0B), label: 'Credit'),
            ],
          ),
        ],
      ),
    );
  }
}

class _CashierBarRow extends StatelessWidget {
  const _CashierBarRow({
    required this.entry,
    required this.maxSales,
    required this.currencySymbol,
  });

  final CashierSalesEntry entry;
  final double maxSales;
  final String currencySymbol;

  String _fmt(double v) {
    return double.parse(v.toStringAsFixed(2)).toCurrencyFormatted(
      symbol: currencySymbol,
    );
  }

  @override
  Widget build(BuildContext context) {
    double frac(double v) {
      if (maxSales <= 0.0001) return 0.0;
      return (v / maxSales).clamp(0.0, 1.0);
    }

    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: transactionReportCashierAvatarColorForAgentId(entry.cashierId),
          child: Text(
            entry.initials,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: Text(
            entry.cashierLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              _StackBar(
                fraction: frac(entry.salesTotal),
                color: const Color(0xFF16A34A),
                label: entry.salesTotal.toStringAsFixed(0),
              ),
              const SizedBox(height: 6),
              _StackBar(
                fraction: frac(entry.byHandTotal),
                color: const Color(0xFF3B82F6),
                label: entry.byHandTotal.toStringAsFixed(0),
                faint: true,
              ),
              const SizedBox(height: 6),
              _StackBar(
                fraction: frac(entry.creditTotal),
                color: const Color(0xFFF59E0B),
                label: entry.creditTotal.toStringAsFixed(0),
                faint: true,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 90,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _fmt(entry.salesTotal),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
              ),
              const SizedBox(height: 4),
              Text(
                _fmt(entry.byHandTotal),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _fmt(entry.creditTotal),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StackBar extends StatelessWidget {
  const _StackBar({
    required this.fraction,
    required this.color,
    this.label,
    this.faint = false,
  });

  final double fraction;
  final Color color;
  final String? label;
  final bool faint;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Container(
        height: 18,
        color: Colors.grey.shade100,
        child: Align(
          alignment: Alignment.centerLeft,
          child: FractionallySizedBox(
            widthFactor: fraction,
            child: Container(
              color: faint ? color.withValues(alpha: 0.85) : color,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.centerLeft,
              child: label == null
                  ? null
                  : Text(
                      label!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}

