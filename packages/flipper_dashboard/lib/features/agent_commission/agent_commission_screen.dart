import 'package:flipper_dashboard/features/agent_commission/agent_commission_provider.dart';
import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_sale.dart';
import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';

const Color _kAccent = Color(0xff006AFE);
const Color _kAgentPurple = Color(0xFF6B4EA2);
const Color _kPageBg = Color(0xFFF3F4F6);

String _formatRwf(num value) => 'RWF ${value.round()}';

/// Commission-only shell for agents without full business dashboard login.
class AgentCommissionScreen extends ConsumerWidget {
  const AgentCommissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(agentCommissionPeriodProvider);
    final summaryAsync = ref.watch(agentCommissionSummaryProvider);

    return Scaffold(
      backgroundColor: _kPageBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Text(
          'My commission',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF111827),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(agentCommissionSummaryProvider),
            icon: const Icon(Icons.refresh, color: _kAccent),
          ),
          TextButton(
            onPressed: () async {
              await setCommissionOnlySession(false);
              await ProxyService.strategy.logOut();
              if (context.mounted) {
                locator<RouterService>().clearStackAndShow(LoginRoute());
              }
            },
            child: Text(
              'Sign out',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w600,
                color: _kAccent,
              ),
            ),
          ),
        ],
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorBody(
          message: 'Could not load commission data.',
          onRetry: () => ref.invalidate(agentCommissionSummaryProvider),
        ),
        data: (summary) => RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(agentCommissionSummaryProvider);
            await ref.read(agentCommissionSummaryProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              if (summary.agentName != null || summary.businessName != null)
                _ContextBanner(
                  agentName: summary.agentName,
                  businessName: summary.businessName,
                ),
              const SizedBox(height: 16),
              _PeriodSelector(
                selected: period,
                onSelected: (p) {
                  ref
                      .read(agentCommissionPeriodProvider.notifier)
                      .setPeriod(p);
                },
              ),
              const SizedBox(height: 16),
              _SummaryCards(summary: summary),
              const SizedBox(height: 20),
              Text(
                'ATTRIBUTED SALES',
                style: GoogleFonts.outfit(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${summary.saleCount} sale${summary.saleCount == 1 ? '' : 's'}',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 12),
              if (summary.sales.isEmpty)
                _EmptySalesCard(period: period)
              else
                ...summary.sales.map(
                  (sale) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _SaleCommissionTile(sale: sale),
                  ),
                ),
              const SizedBox(height: 12),
              Text(
                'Commission-only access. Ask your business admin to enable full '
                'dashboard login from User Management if you need POS access.',
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  height: 1.4,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContextBanner extends StatelessWidget {
  const _ContextBanner({this.agentName, this.businessName});

  final String? agentName;
  final String? businessName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _kAgentPurple.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _kAgentPurple,
            child: Icon(Icons.support_agent, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (agentName != null)
                  Text(
                    agentName!,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: const Color(0xFF111827),
                    ),
                  ),
                if (businessName != null)
                  Text(
                    businessName!,
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.selected,
    required this.onSelected,
  });

  final AgentCommissionPeriod selected;
  final ValueChanged<AgentCommissionPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AgentCommissionPeriod.values.map((p) {
        final isSelected = p == selected;
        return ChoiceChip(
          label: Text(_periodLabel(p)),
          selected: isSelected,
          onSelected: (_) => onSelected(p),
          labelStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : _kAccent,
            fontSize: 13,
          ),
          selectedColor: _kAccent,
          backgroundColor: Colors.white,
          side: BorderSide(
            color: isSelected ? _kAccent : Colors.grey[300]!,
          ),
        );
      }).toList(),
    );
  }

  static String _periodLabel(AgentCommissionPeriod p) {
    switch (p) {
      case AgentCommissionPeriod.today:
        return 'Today';
      case AgentCommissionPeriod.week:
        return 'This week';
      case AgentCommissionPeriod.month:
        return 'This month';
      case AgentCommissionPeriod.all:
        return 'All time';
    }
  }
}

class _SummaryCards extends StatelessWidget {
  const _SummaryCards({required this.summary});

  final AgentCommissionSummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'TOTAL COMMISSION',
            value: _formatRwf(summary.totalCommission),
            valueColor: _kAgentPurple,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MetricCard(
            label: 'SALES VOLUME',
            value: _formatRwf(summary.totalSales),
            valueColor: _kAccent,
          ),
        ),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaleCommissionTile extends StatelessWidget {
  const _SaleCommissionTile({required this.sale});

  final AgentCommissionSale sale;

  @override
  Widget build(BuildContext context) {
    final date = sale.createdAt;
    final dateLabel = date != null
        ? DateFormat('MMM d, yyyy · HH:mm').format(date.toLocal())
        : '—';
    final customer = (sale.customerName?.trim().isNotEmpty == true)
        ? sale.customerName!
        : 'Walk-in';
    final ref = sale.reference?.trim();
    final commissionLabel = formatSaleAgentCommissionLabel(
      commissionType: sale.commissionType,
      commissionValue: sale.commissionValue,
      resolvedAmount: sale.commissionAmount,
    );

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  customer,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                if (ref != null && ref.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    ref.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      color: Colors.grey[500],
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
                if (commissionLabel.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    commissionLabel,
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      color: _kAccent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatRwf(sale.commissionAmount ?? 0),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: _kAgentPurple,
                ),
              ),
              if (sale.subTotal != null && sale.subTotal! > 0)
                Text(
                  'Sale ${_formatRwf(sale.subTotal!)}',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptySalesCard extends StatelessWidget {
  const _EmptySalesCard({required this.period});

  final AgentCommissionPeriod period;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.receipt_long_outlined, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            'No attributed sales yet',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When cashiers assign you on a completed sale in Quick Selling, '
            'commission will appear here for ${_PeriodSelector._periodLabel(period).toLowerCase()}.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontSize: 14,
              height: 1.45,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(backgroundColor: _kAccent),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
