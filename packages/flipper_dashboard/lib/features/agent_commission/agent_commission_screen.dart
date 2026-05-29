import 'package:flipper_dashboard/features/agent_commission/agent_commission_admin_provider.dart';
import 'package:flipper_dashboard/features/agent_commission/agent_commission_payout_repository.dart';
import 'package:flipper_dashboard/features/agent_commission/agent_commission_provider.dart';
import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_payout.dart';
import 'package:flipper_dashboard/features/agent_commission/models/agent_commission_sale.dart';
import 'package:flipper_dashboard/providers/agent_commission_access_provider.dart';
import 'package:flipper_dashboard/utils/sale_agent_commission.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

const Color _kAccent = Color(0xFF243F96);
const Color _kAgentPurple = _kAccent;
const Color _kAgentGreen = Color(0xFF0F623F);
const Color _kInk = Color(0xFF111111);
const Color _kMuted = Color(0xFF85847D);
const Color _kLine = Color(0xFFE4E1D8);
const Color _kPageBg = Color(0xFFF7F6F1);

String _formatNumber(num value) =>
    NumberFormat.decimalPattern().format(value.round());

String _formatRwf(num value) => 'RWF ${_formatNumber(value)}';

/// Commission shell for agents and owner/admin payout management.
class AgentCommissionScreen extends ConsumerWidget {
  const AgentCommissionScreen({super.key, this.embeddedInDashboard = false});

  /// When true, shown inside [DashboardLayout] (no commission-only sign-out).
  final bool embeddedInDashboard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canManageAsync = ref.watch(canManageAgentCommissionProvider);
    final period = ref.watch(agentCommissionPeriodProvider);
    final commissionOnly = !embeddedInDashboard && isCommissionOnlySession();

    return canManageAsync.when(
      loading: () => Scaffold(
        backgroundColor: _kPageBg,
        body: _CommissionLoadingView(period: period),
      ),
      error: (_, __) => _AgentCommissionBody(
        embeddedInDashboard: embeddedInDashboard,
        commissionOnly: commissionOnly,
        canManage: false,
      ),
      data: (canManage) => _AgentCommissionBody(
        embeddedInDashboard: embeddedInDashboard,
        commissionOnly: commissionOnly,
        canManage: canManage,
      ),
    );
  }
}

class _CommissionDashboard extends StatelessWidget {
  const _CommissionDashboard({
    required this.summary,
    required this.balance,
    required this.period,
    required this.payouts,
    required this.showPayoutAction,
    required this.showSignOut,
    required this.onRefresh,
    required this.onPeriodSelected,
    this.agents,
    this.selectedAgentId,
    this.payoutsUnavailable = false,
    this.payoutHistoryExpanded = true,
    this.onAgentSelected,
    this.onRecordPayout,
    this.onPayoutHistoryToggle,
    this.onSignOut,
  });

  final AgentCommissionSummary summary;
  final AgentCommissionBalance balance;
  final AgentCommissionPeriod period;
  final List<Tenant>? agents;
  final String? selectedAgentId;
  final List<AgentCommissionPayout> payouts;
  final bool payoutsUnavailable;
  final bool payoutHistoryExpanded;
  final bool showPayoutAction;
  final bool showSignOut;
  final VoidCallback onRefresh;
  final ValueChanged<AgentCommissionPeriod> onPeriodSelected;
  final ValueChanged<String>? onAgentSelected;
  final VoidCallback? onRecordPayout;
  final VoidCallback? onPayoutHistoryToggle;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;
    final monthLabel = _periodContextLabel(period);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            isWide ? 56 : 16,
            isWide ? 24 : 16,
            isWide ? 56 : 16,
            32,
          ),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DashboardHeader(
                      summary: summary,
                      agents: agents,
                      selectedAgentId: selectedAgentId,
                      showSignOut: showSignOut,
                      onAgentSelected: onAgentSelected,
                      onRefresh: onRefresh,
                      onSignOut: onSignOut,
                    ),
                    const SizedBox(height: 32),
                    _FiltersRow(
                      period: period,
                      monthLabel: monthLabel,
                      isWide: isWide,
                      onPeriodSelected: onPeriodSelected,
                    ),
                    const SizedBox(height: 24),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 8,
                            child: _EarnedCard(
                              balance: balance,
                              monthLabel: monthLabel,
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            flex: 5,
                            child: _PayoutCard(
                              balance: balance,
                              showPayoutAction: showPayoutAction,
                              onRecordPayout: onRecordPayout,
                            ),
                          ),
                        ],
                      )
                    else ...[
                      _EarnedCard(balance: balance, monthLabel: monthLabel),
                      const SizedBox(height: 12),
                      _PayoutCard(
                        balance: balance,
                        showPayoutAction: showPayoutAction,
                        onRecordPayout: onRecordPayout,
                      ),
                    ],
                    if (payoutsUnavailable) ...[
                      const SizedBox(height: 12),
                      _WarningNotice(
                        message:
                            'Payout history could not be loaded. Earned commission from sales is still shown. Run Supabase migration agent_commission_payouts if payouts fail to save.',
                      ),
                    ],
                    const SizedBox(height: 36),
                    _AttributedSalesSection(
                      summary: summary,
                      period: period,
                      paidAmount: balance.paid,
                      isWide: isWide,
                    ),
                    if (payouts.isNotEmpty) ...[
                      const SizedBox(height: 36),
                      _RecentPayoutsSection(
                        payouts: payouts,
                        expanded: payoutHistoryExpanded,
                        onToggle: onPayoutHistoryToggle,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CommissionLoadingView extends StatelessWidget {
  const _CommissionLoadingView({
    required this.period,
    this.agents,
    this.selectedAgentId,
  });

  final AgentCommissionPeriod period;
  final List<Tenant>? agents;
  final String? selectedAgentId;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 900;
    final monthLabel = _periodContextLabel(period);

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverPadding(
          padding: EdgeInsets.fromLTRB(
            isWide ? 56 : 16,
            isWide ? 24 : 16,
            isWide ? 56 : 16,
            32,
          ),
          sliver: SliverToBoxAdapter(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DashboardHeader(
                      summary: const AgentCommissionSummary(sales: []),
                      agents: agents,
                      selectedAgentId: selectedAgentId,
                      showSignOut: false,
                      onRefresh: () {},
                    ),
                    const SizedBox(height: 32),
                    _FiltersRow(
                      period: period,
                      monthLabel: monthLabel,
                      isWide: isWide,
                      onPeriodSelected: (_) {},
                    ),
                    const SizedBox(height: 24),
                    LinearProgressIndicator(
                      minHeight: 3,
                      color: _kAccent,
                      backgroundColor: _kLine,
                    ),
                    const SizedBox(height: 20),
                    if (isWide)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Expanded(flex: 8, child: _LoadingCard()),
                          SizedBox(width: 20),
                          Expanded(flex: 5, child: _LoadingCard()),
                        ],
                      )
                    else ...const [
                      _LoadingCard(),
                      SizedBox(height: 12),
                      _LoadingCard(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonLine(width: 180),
          const SizedBox(height: 28),
          _SkeletonLine(width: 260, height: 44),
          const SizedBox(height: 56),
          _SkeletonLine(width: double.infinity, height: 11),
          const SizedBox(height: 18),
          _SkeletonLine(width: 220),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.width, this.height = 16});

  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: _kLine.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.summary,
    required this.showSignOut,
    required this.onRefresh,
    this.agents,
    this.selectedAgentId,
    this.onAgentSelected,
    this.onSignOut,
  });

  final AgentCommissionSummary summary;
  final List<Tenant>? agents;
  final String? selectedAgentId;
  final bool showSignOut;
  final VoidCallback onRefresh;
  final ValueChanged<String>? onAgentSelected;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final pickerAgents = agents;
    final hasPicker =
        pickerAgents != null &&
        pickerAgents.isNotEmpty &&
        selectedAgentId != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        final stack = constraints.maxWidth < 820;
        final title = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Eyebrow('TEAM  ·  COMMISSIONS'),
            const SizedBox(height: 10),
            Text(
              'Agent commissions',
              style: GoogleFonts.outfit(
                fontSize: stack ? 34 : 42,
                height: 1,
                fontWeight: FontWeight.w800,
                color: _kInk,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Track what each sales agent has earned, what you’ve paid, and what’s still owed.',
              style: GoogleFonts.outfit(
                fontSize: 18,
                height: 1.25,
                color: const Color(0xFF56554F),
              ),
            ),
          ],
        );
        final actions = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Refresh',
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh, color: _kMuted),
            ),
            if (showSignOut)
              TextButton(
                onPressed: onSignOut,
                child: Text(
                  'Sign out',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    color: _kAccent,
                  ),
                ),
              ),
            if (hasPicker) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: stack ? constraints.maxWidth : 380,
                child: _AgentPicker(
                  agents: pickerAgents,
                  selectedUserId: selectedAgentId!,
                  onSelected: onAgentSelected ?? (_) {},
                ),
              ),
            ] else if (summary.agentName != null ||
                summary.businessName != null) ...[
              const SizedBox(width: 8),
              _AgentIdentityCard(
                name: summary.agentName ?? 'Agent',
                subtitle: summary.businessName,
              ),
            ],
          ],
        );

        if (stack) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [title, const SizedBox(height: 18), actions],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: title),
            const SizedBox(width: 24),
            actions,
          ],
        );
      },
    );
  }
}

class _FiltersRow extends StatelessWidget {
  const _FiltersRow({
    required this.period,
    required this.monthLabel,
    required this.isWide,
    required this.onPeriodSelected,
  });

  final AgentCommissionPeriod period;
  final String monthLabel;
  final bool isWide;
  final ValueChanged<AgentCommissionPeriod> onPeriodSelected;

  @override
  Widget build(BuildContext context) {
    final selector = _PeriodSelector(
      selected: period,
      onSelected: onPeriodSelected,
    );
    final month = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.calendar_today_outlined, size: 16, color: _kMuted),
        const SizedBox(width: 8),
        Text(
          monthLabel,
          style: GoogleFonts.outfit(fontSize: 17, color: _kMuted),
        ),
      ],
    );

    if (!isWide) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [selector, const SizedBox(height: 14), month],
      );
    }

    return Row(children: [selector, const Spacer(), month]);
  }
}

class _EarnedCard extends StatelessWidget {
  const _EarnedCard({required this.balance, required this.monthLabel});

  final AgentCommissionBalance balance;
  final String monthLabel;

  @override
  Widget build(BuildContext context) {
    final earned = balance.earned;
    final paidPct = earned <= 0 ? 0.0 : (balance.paid / earned).clamp(0.0, 1.0);
    final duePct = earned <= 0 ? 1.0 : 1.0 - paidPct;

    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Eyebrow('COMMISSION EARNED'),
                    const SizedBox(height: 18),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 10,
                      children: [
                        Text(
                          'RWF',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: _kMuted,
                          ),
                        ),
                        Text(
                          _formatNumber(earned),
                          style: GoogleFonts.outfit(
                            fontSize: 54,
                            height: 0.95,
                            fontWeight: FontWeight.w800,
                            color: _kInk,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _Pill(label: monthLabel),
            ],
          ),
          const SizedBox(height: 52),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 11,
              child: Row(
                children: [
                  if (paidPct > 0)
                    Expanded(
                      flex: (paidPct * 1000).round(),
                      child: Container(color: const Color(0xFF575851)),
                    ),
                  Expanded(
                    flex: (duePct * 1000).round().clamp(1, 1000),
                    child: Container(color: _kAccent),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 22,
            runSpacing: 8,
            children: [
              _LegendDot(
                color: const Color(0xFF575851),
                label: 'Paid out · ${(paidPct * 100).round()} %',
              ),
              _LegendDot(
                color: _kAccent,
                label: 'Balance due · ${(duePct * 100).round()} %',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PayoutCard extends StatelessWidget {
  const _PayoutCard({
    required this.balance,
    required this.showPayoutAction,
    this.onRecordPayout,
  });

  final AgentCommissionBalance balance;
  final bool showPayoutAction;
  final VoidCallback? onRecordPayout;

  @override
  Widget build(BuildContext context) {
    final settled = balance.balance <= 0;
    return _Surface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _IconEyebrow(icon: Icons.check, label: 'PAID OUT'),
          const SizedBox(height: 18),
          Text(
            _formatRwf(balance.paid),
            style: GoogleFonts.outfit(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: _kInk,
            ),
          ),
          const SizedBox(height: 26),
          const Divider(color: _kLine, height: 1),
          const SizedBox(height: 26),
          const _IconEyebrow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'BALANCE DUE',
          ),
          const SizedBox(height: 18),
          Text(
            _formatRwf(balance.balance),
            style: GoogleFonts.outfit(
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: _kAccent,
            ),
          ),
          const SizedBox(height: 18),
          if (showPayoutAction)
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRecordPayout,
                style: FilledButton.styleFrom(
                  backgroundColor: _kAccent,
                  disabledBackgroundColor: Colors.transparent,
                  disabledForegroundColor: _kMuted,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: settled
                        ? const BorderSide(color: _kLine)
                        : BorderSide.none,
                  ),
                ),
                icon: Icon(
                  settled
                      ? Icons.account_balance_wallet_outlined
                      : Icons.wallet_outlined,
                  size: 20,
                ),
                label: Text(
                  settled ? 'All settled' : 'Record payout',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AttributedSalesSection extends StatelessWidget {
  const _AttributedSalesSection({
    required this.summary,
    required this.period,
    required this.paidAmount,
    required this.isWide,
  });

  final AgentCommissionSummary summary;
  final AgentCommissionPeriod period;
  final num paidAmount;
  final bool isWide;

  @override
  Widget build(BuildContext context) {
    final paidSaleIds = _paidSaleIds(summary.sales, paidAmount);
    final pendingCount = summary.sales
        .where((sale) => !paidSaleIds.contains(sale.id))
        .length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _Eyebrow('ATTRIBUTED SALES'),
            if (summary.saleCount > 0) ...[
              const SizedBox(width: 10),
              _CountBubble(summary.saleCount.toString()),
            ],
            const Spacer(),
            if (summary.saleCount > 0) ...[
              _LegendDot(color: _kAccent, label: '$pendingCount pending'),
              const SizedBox(width: 18),
              OutlinedButton.icon(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: _kInk,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: _kLine),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.print_outlined, size: 19),
                label: Text(
                  'Export',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        if (summary.sales.isEmpty)
          _EmptySalesCard(period: period)
        else if (isWide)
          _SalesTable(sales: summary.sales, paidSaleIds: paidSaleIds)
        else
          ...summary.sales.map(
            (sale) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _SaleCommissionTile(
                sale: sale,
                paid: paidSaleIds.contains(sale.id),
              ),
            ),
          ),
      ],
    );
  }

  static Set<String> _paidSaleIds(List<AgentCommissionSale> sales, num paid) {
    if (paid <= 0) return const {};
    var covered = paid;
    final ids = <String>{};
    for (final sale in sales.reversed) {
      final amount = sale.commissionAmount ?? 0;
      if (amount <= 0) continue;
      if (covered >= amount) {
        ids.add(sale.id);
        covered -= amount;
      } else {
        break;
      }
    }
    return ids;
  }
}

class _SalesTable extends StatelessWidget {
  const _SalesTable({required this.sales, required this.paidSaleIds});

  final List<AgentCommissionSale> sales;
  final Set<String> paidSaleIds;

  @override
  Widget build(BuildContext context) {
    return _Surface(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _TableHeader(),
          ...sales.map(
            (sale) =>
                _SaleTableRow(sale: sale, paid: paidSaleIds.contains(sale.id)),
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kLine)),
      ),
      child: Row(
        children: const [
          _TableHeadCell('DATE', flex: 12),
          _TableHeadCell('RECEIPT', flex: 23),
          _TableHeadCell('CASHIER', flex: 22),
          _TableHeadCell('SALE TOTAL', flex: 15, alignEnd: true),
          _TableHeadCell('RATE', flex: 10, alignEnd: true),
          _TableHeadCell('COMMISSION', flex: 18, alignEnd: true),
          _TableHeadCell('STATUS', flex: 14),
        ],
      ),
    );
  }
}

class _TableHeadCell extends StatelessWidget {
  const _TableHeadCell(this.label, {required this.flex, this.alignEnd = false});

  final String label;
  final int flex;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        textAlign: alignEnd ? TextAlign.end : TextAlign.start,
        style: GoogleFonts.outfit(
          fontSize: 14,
          letterSpacing: 1.8,
          fontWeight: FontWeight.w700,
          color: _kMuted,
        ),
      ),
    );
  }
}

class _SaleTableRow extends StatelessWidget {
  const _SaleTableRow({required this.sale, required this.paid});

  final AgentCommissionSale sale;
  final bool paid;

  @override
  Widget build(BuildContext context) {
    final date = sale.createdAt?.toLocal();
    final dateLabel = date != null ? DateFormat('MMM d').format(date) : '—';
    final timeLabel = date != null ? DateFormat('h:mm a').format(date) : '';
    final ref = sale.reference?.trim().isNotEmpty == true
        ? sale.reference!.trim().toUpperCase()
        : sale.id.toUpperCase();
    final customer = sale.customerName?.trim().isNotEmpty == true
        ? sale.customerName!.trim()
        : 'Walk-in';
    final rate = _commissionRateLabel(sale);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kLine)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 12,
            child: _TwoLineCell(primary: dateLabel, secondary: timeLabel),
          ),
          Expanded(
            flex: 23,
            child: _TwoLineCell(primary: ref, secondary: customer),
          ),
          Expanded(flex: 22, child: _CashierCell()),
          Expanded(
            flex: 15,
            child: _MonoAmount(value: _formatNumber(sale.subTotal ?? 0)),
          ),
          Expanded(
            flex: 10,
            child: Text(
              rate,
              textAlign: TextAlign.end,
              style: GoogleFonts.outfit(fontSize: 17, color: _kInk),
            ),
          ),
          Expanded(
            flex: 18,
            child: _MonoAmount(
              value: '+${_formatNumber(sale.commissionAmount ?? 0)}',
              color: _kAccent,
            ),
          ),
          Expanded(
            flex: 14,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _StatusPill(paid: paid),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentPayoutsSection extends StatelessWidget {
  const _RecentPayoutsSection({
    required this.payouts,
    required this.expanded,
    this.onToggle,
  });

  final List<AgentCommissionPayout> payouts;
  final bool expanded;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          child: Row(
            children: [
              const _Eyebrow('RECENT PAYOUTS'),
              const Spacer(),
              if (onToggle != null)
                Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                  color: _kMuted,
                ),
            ],
          ),
        ),
        if (expanded) ...[
          const SizedBox(height: 8),
          _Surface(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                ...payouts.map((payout) => _PayoutHistoryTile(payout: payout)),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _Surface extends StatelessWidget {
  const _Surface({
    required this.child,
    this.padding = const EdgeInsets.all(26),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kLine),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.outfit(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 2.6,
        color: _kMuted,
      ),
    );
  }
}

class _IconEyebrow extends StatelessWidget {
  const _IconEyebrow({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: _kMuted),
        const SizedBox(width: 8),
        _Eyebrow(label),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _kLine),
        color: _kPageBg,
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(fontSize: 15, color: const Color(0xFF56554F)),
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
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: const Color(0xFF56554F),
          ),
        ),
      ],
    );
  }
}

class _CountBubble extends StatelessWidget {
  const _CountBubble(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _kInk,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 13,
        ),
      ),
    );
  }
}

class _WarningNotice extends StatelessWidget {
  const _WarningNotice({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Text(
        message,
        style: GoogleFonts.outfit(
          fontSize: 12,
          height: 1.4,
          color: Colors.amber.shade900,
        ),
      ),
    );
  }
}

class _TwoLineCell extends StatelessWidget {
  const _TwoLineCell({required this.primary, required this.secondary});

  final String primary;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          primary,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.outfit(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: _kInk,
          ),
        ),
        if (secondary.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            secondary,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.outfit(fontSize: 15, color: _kMuted),
          ),
        ],
      ],
    );
  }
}

class _CashierCell extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Cashier',
          style: GoogleFonts.outfit(
            fontSize: 16,
            color: const Color(0xFF56554F),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF2FA),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(
            'POS',
            style: GoogleFonts.outfit(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _kAccent,
            ),
          ),
        ),
      ],
    );
  }
}

class _MonoAmount extends StatelessWidget {
  const _MonoAmount({required this.value, this.color = _kInk});

  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      textAlign: TextAlign.end,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: color,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.paid});

  final bool paid;

  @override
  Widget build(BuildContext context) {
    final color = paid ? _kMuted : const Color(0xFFB56B1A);
    final bg = paid ? Colors.white : const Color(0xFFFFF4E2);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: paid ? _kLine : const Color(0xFFF6E2C5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            paid ? Icons.check : Icons.hourglass_empty,
            size: 15,
            color: color,
          ),
          const SizedBox(width: 6),
          Text(
            paid ? 'Paid' : 'Pending',
            style: GoogleFonts.outfit(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _AgentIdentityCard extends StatelessWidget {
  const _AgentIdentityCard({required this.name, this.subtitle});

  final String name;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 280),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kLine),
      ),
      child: Row(
        children: [
          _Avatar(name: name),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _kInk,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(fontSize: 14, color: _kMuted),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initials = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    return CircleAvatar(
      radius: 24,
      backgroundColor: _kAgentGreen,
      child: Text(
        initials.isEmpty ? 'A' : initials,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 17,
        ),
      ),
    );
  }
}

String _periodContextLabel(AgentCommissionPeriod period) {
  final now = DateTime.now();
  switch (period) {
    case AgentCommissionPeriod.today:
      return DateFormat('MMM d, yyyy').format(now);
    case AgentCommissionPeriod.week:
      return 'Last 7 days';
    case AgentCommissionPeriod.month:
      return DateFormat('MMMM yyyy').format(now);
    case AgentCommissionPeriod.all:
      return 'All time';
  }
}

String _commissionRateLabel(AgentCommissionSale sale) {
  if (sale.commissionType ==
      saleAgentCommissionTypeToDb(SaleAgentCommissionType.percent)) {
    final value = sale.commissionValue ?? 0;
    return '${value.round()}%';
  }
  if (sale.commissionType ==
      saleAgentCommissionTypeToDb(SaleAgentCommissionType.fixed)) {
    return _formatRwf(sale.commissionValue ?? sale.commissionAmount ?? 0);
  }
  final label = formatSaleAgentCommissionLabel(
    commissionType: sale.commissionType,
    commissionValue: sale.commissionValue,
    resolvedAmount: sale.commissionAmount,
  );
  return label.isEmpty ? '—' : label;
}

class _AgentCommissionBody extends ConsumerWidget {
  const _AgentCommissionBody({
    required this.embeddedInDashboard,
    required this.commissionOnly,
    required this.canManage,
  });

  final bool embeddedInDashboard;
  final bool commissionOnly;
  final bool canManage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (canManage) {
      return _AdminCommissionShell(
        embeddedInDashboard: embeddedInDashboard,
        commissionOnly: commissionOnly,
      );
    }
    return _AgentCommissionShell(
      embeddedInDashboard: embeddedInDashboard,
      commissionOnly: commissionOnly,
    );
  }
}

class _AgentCommissionShell extends ConsumerWidget {
  const _AgentCommissionShell({
    required this.embeddedInDashboard,
    required this.commissionOnly,
  });

  final bool embeddedInDashboard;
  final bool commissionOnly;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(agentCommissionPeriodProvider);
    final summaryAsync = ref.watch(agentCommissionSummaryProvider);

    return PopScope(
      canPop: !commissionOnly,
      child: Scaffold(
        backgroundColor: _kPageBg,
        body: summaryAsync.when(
          loading: () => _CommissionLoadingView(period: period),
          error: (e, _) => _ErrorBody(
            message: 'Could not load commission data.',
            onRetry: () => ref.invalidate(agentCommissionSummaryProvider),
          ),
          data: (summary) => RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(agentCommissionSummaryProvider);
              await ref.read(agentCommissionSummaryProvider.future);
            },
            child: _CommissionDashboard(
              summary: summary,
              balance: AgentCommissionBalance(
                earned: summary.totalCommission,
                paid: 0,
              ),
              period: period,
              payouts: const [],
              showPayoutAction: false,
              showSignOut: commissionOnly,
              onRefresh: () => ref.invalidate(agentCommissionSummaryProvider),
              onPeriodSelected: (p) {
                ref.read(agentCommissionPeriodProvider.notifier).setPeriod(p);
              },
              onSignOut: commissionOnly
                  ? () async {
                      await setCommissionOnlySession(false);
                      await ProxyService.strategy.logOut();
                      if (context.mounted) {
                        locator<RouterService>().clearStackAndShow(
                          LoginRoute(),
                        );
                      }
                    }
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminCommissionShell extends ConsumerStatefulWidget {
  const _AdminCommissionShell({
    required this.embeddedInDashboard,
    required this.commissionOnly,
  });

  final bool embeddedInDashboard;
  final bool commissionOnly;

  @override
  ConsumerState<_AdminCommissionShell> createState() =>
      _AdminCommissionShellState();
}

class _AdminCommissionShellState extends ConsumerState<_AdminCommissionShell> {
  bool _payoutHistoryExpanded = false;

  @override
  Widget build(BuildContext context) {
    final period = ref.watch(agentCommissionPeriodProvider);
    final adminAsync = ref.watch(agentCommissionAdminSummaryProvider);
    final agentsAsync = ref.watch(commissionAgentPickerProvider);

    return PopScope(
      canPop: !widget.commissionOnly,
      child: Scaffold(
        backgroundColor: _kPageBg,
        body: agentsAsync.when(
          loading: () => _CommissionLoadingView(period: period),
          error: (_, __) => const _ErrorBody(
            message: 'Could not load agents.',
            onRetry: null,
          ),
          data: (agents) {
            if (agents.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No agents found. Add agents in User Management first.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.outfit(color: Colors.grey[700]),
                  ),
                ),
              );
            }

            return adminAsync.when(
              loading: () => _CommissionLoadingView(
                period: period,
                agents: agents,
                selectedAgentId:
                    ref.watch(selectedCommissionAgentIdProvider) ??
                    agents.first.userId,
              ),
              error: (e, _) => _ErrorBody(
                message: 'Could not load commission data.',
                onRetry: () =>
                    ref.invalidate(agentCommissionAdminSummaryProvider),
              ),
              data: (admin) {
                if (admin == null) {
                  return const Center(
                    child: Text(
                      'You do not have permission to manage payouts.',
                    ),
                  );
                }

                final selectedId =
                    ref.watch(selectedCommissionAgentIdProvider) ??
                    admin.agentUserId;

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(agentCommissionAdminSummaryProvider);
                    await ref.read(agentCommissionAdminSummaryProvider.future);
                  },
                  child: _CommissionDashboard(
                    summary: admin.summary,
                    balance: admin.balance,
                    period: period,
                    agents: agents,
                    selectedAgentId: selectedId,
                    payouts: admin.payouts,
                    payoutsUnavailable: admin.payoutsUnavailable,
                    payoutHistoryExpanded: _payoutHistoryExpanded,
                    showSignOut: widget.commissionOnly,
                    showPayoutAction: true,
                    onPayoutHistoryToggle: () => setState(
                      () => _payoutHistoryExpanded = !_payoutHistoryExpanded,
                    ),
                    onRefresh: () {
                      ref.invalidate(agentCommissionAdminSummaryProvider);
                      ref.invalidate(agentCommissionSummaryProvider);
                    },
                    onRecordPayout: admin.balance.balance <= 0
                        ? null
                        : () => _showRecordPayoutDialog(
                            context,
                            admin: admin,
                            period: period,
                          ),
                    onPeriodSelected: (p) {
                      ref
                          .read(agentCommissionPeriodProvider.notifier)
                          .setPeriod(p);
                    },
                    onAgentSelected: (id) {
                      ref
                              .read(selectedCommissionAgentIdProvider.notifier)
                              .state =
                          id;
                    },
                    onSignOut: widget.commissionOnly
                        ? () async {
                            await setCommissionOnlySession(false);
                            await ProxyService.strategy.logOut();
                            if (context.mounted) {
                              locator<RouterService>().clearStackAndShow(
                                LoginRoute(),
                              );
                            }
                          }
                        : null,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _showRecordPayoutDialog(
    BuildContext context, {
    required AgentCommissionAdminSummary admin,
    required AgentCommissionPeriod period,
  }) async {
    final amountController = TextEditingController(
      text: admin.balance.balance.round().toString(),
    );
    final noteController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Record payout',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
        ),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                admin.summary.agentName ?? 'Agent',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w600,
                  color: _kAgentPurple,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Balance due: ${_formatRwf(admin.balance.balance)}',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Amount (RWF)',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = num.tryParse(v?.trim() ?? '');
                  if (n == null || n <= 0) return 'Enter a valid amount';
                  if (n > admin.balance.balance) {
                    return 'Cannot exceed balance (${admin.balance.balance.round()} RWF)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: noteController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Note (optional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(ctx, true);
              }
            },
            style: FilledButton.styleFrom(backgroundColor: _kAccent),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    final amount = num.parse(amountController.text.trim());
    try {
      final repo = ref.read(agentCommissionPayoutRepositoryProvider);
      await repo.insertPayout(
        agentUserId: admin.agentUserId,
        amount: amount,
        note: noteController.text,
        period: period,
      );
      ref.invalidate(agentCommissionAdminSummaryProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payout of ${_formatRwf(amount)} recorded.')),
        );
      }
    } on AgentCommissionPayoutException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not record payout. Check your connection.'),
          ),
        );
      }
    }
  }
}

class _AgentPicker extends StatelessWidget {
  const _AgentPicker({
    required this.agents,
    required this.selectedUserId,
    required this.onSelected,
  });

  final List<Tenant> agents;
  final String selectedUserId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final selectableAgents = agents
        .where((t) => t.userId != null && t.userId!.isNotEmpty)
        .toList();
    if (selectableAgents.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kLine),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectableAgents.any((t) => t.userId == selectedUserId)
              ? selectedUserId
              : selectableAgents.first.userId,
          icon: const Icon(Icons.keyboard_arrow_down, color: _kMuted),
          selectedItemBuilder: (_) => selectableAgents.map((t) {
            final name = tenantDisplayName(t);
            final phone = (t.phoneNumber ?? t.email ?? '').trim();
            return Row(
              children: [
                _Avatar(name: name),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: _kInk,
                        ),
                      ),
                      Text(
                        phone.isEmpty ? 'Commission agent' : phone,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.outfit(fontSize: 14, color: _kMuted),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
          items: selectableAgents.map((t) {
            return DropdownMenuItem(
              value: t.userId,
              child: Text(
                tenantDisplayName(t),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  color: _kInk,
                ),
              ),
            );
          }).toList(),
          onChanged: (id) {
            if (id != null) onSelected(id);
          },
        ),
      ),
    );
  }
}

class _PayoutHistoryTile extends StatelessWidget {
  const _PayoutHistoryTile({required this.payout});

  final AgentCommissionPayout payout;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('MMM d, yyyy').format(payout.paidAt.toLocal());
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: _kLine)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.wallet_outlined, color: _kAccent),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatRwf(payout.amount),
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: _kInk,
                    ),
                  ),
                  Text(
                    [
                      dateLabel,
                      if (payout.note != null && payout.note!.trim().isNotEmpty)
                        payout.note!.trim(),
                    ].join(' · '),
                    style: GoogleFonts.outfit(fontSize: 15, color: _kMuted),
                  ),
                ],
              ),
            ),
            Text(
              'by Owner',
              style: GoogleFonts.outfit(fontSize: 15, color: _kMuted),
            ),
            const SizedBox(width: 28),
            const Icon(Icons.print_outlined, color: Color(0xFF56554F)),
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected, required this.onSelected});

  final AgentCommissionPeriod selected;
  final ValueChanged<AgentCommissionPeriod> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kLine),
      ),
      child: Wrap(
        spacing: 2,
        runSpacing: 2,
        children: AgentCommissionPeriod.values.map((p) {
          final isSelected = p == selected;
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => onSelected(p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 1),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                _periodLabel(p),
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  color: isSelected ? _kInk : const Color(0xFF56554F),
                  fontSize: 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
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

class _SaleCommissionTile extends StatelessWidget {
  const _SaleCommissionTile({required this.sale, this.paid = false});

  final AgentCommissionSale sale;
  final bool paid;

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
              const SizedBox(height: 8),
              _StatusPill(paid: paid),
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
            'When cashiers assign an agent on a completed sale in Quick Selling, '
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
  const _ErrorBody({required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: onRetry,
                style: FilledButton.styleFrom(backgroundColor: _kAccent),
                child: const Text('Retry'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
