// ignore_for_file: unused_result

import 'dart:async';

import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/widgets/momo_transaction_form.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/cache/utility_cash_variant_cache.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:intl/intl.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:stacked_services/stacked_services.dart';

/// Cash Book UI tokens aligned with product mock (shell, greens, beige surfaces).
abstract final class _CashbookColors {
  static const Color pageBg = Color(0xFFF7F6F0);
  static const Color primaryGreen = Color(0xFF22C55E);
  static const Color mintAmountBg = Color(0xFFE8F8EF);
  static const Color beigeField = Color(0xFFF5F4EE);
  static const Color beigeInactive = Color(0xFFEDEADF);
  static const Color labelMuted = Color(0xFF6B7280);

  /// Recent-transactions card (design spec)
  static const Color designBlue = Color(0xFF2563EB);
  static const Color cashInGreen = Color(0xFF1B5E20);
  static const Color cashInSurface = Color(0xFFE8F5E9);
  static const Color cashOutRed = Color(0xFFB71C1C);
  static const Color cashOutSurface = Color(0xFFFFEBEE);
  static const Color rowHighlight = Color(0xFFFAF8F3);
  static const Color chipBorder = Color(0xFFE5E7EB);
}

enum _RecentTxFilter { all, cashIn, cashOut, momo }

class Cashbook extends StatefulHookConsumerWidget {
  const Cashbook({Key? key, required this.isBigScreen}) : super(key: key);
  final bool isBigScreen;

  @override
  CashbookState createState() => CashbookState();
}

class CashbookState extends ConsumerState<Cashbook> with DateCoreWidget {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  /// Track if MoMo transaction form is active
  bool _isMomoMode = false;
  String _momoTransactionType = TransactionType.cashIn;

  _RecentTxFilter _recentTxFilter = _RecentTxFilter.all;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final bid = ProxyService.box.getBranchId();
      if (bid != null && bid.isNotEmpty) {
        unawaited(UtilityCashVariantCache.prefetch(ProxyService.strategy, bid));
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => CoreViewModel(),
      builder: (context, model, child) {
        return Scaffold(
          backgroundColor: widget.isBigScreen
              ? _CashbookColors.pageBg
              : Colors.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final shell = DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(
                      widget.isBigScreen ? 22 : 0,
                    ),
                    border: widget.isBigScreen
                        ? Border.all(color: Colors.grey.shade300)
                        : Border(
                            bottom: BorderSide(color: Colors.grey.shade200),
                          ),
                    boxShadow: widget.isBigScreen
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : const [],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      widget.isBigScreen ? 22 : 0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildCashbookHeader(),
                        Expanded(child: _buildShellBody(model)),
                      ],
                    ),
                  ),
                );

                if (widget.isBigScreen) {
                  return Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 560,
                          maxHeight: constraints.maxHeight - 48,
                        ),
                        child: shell,
                      ),
                    ),
                  );
                }

                return SizedBox(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: shell,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildCashbookHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 14, 8, 10),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _headerRoundIconButton(
                icon: Icons.close,
                iconColor: Colors.grey.shade700,
                borderColor: Colors.grey.shade400,
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
              const Expanded(child: SizedBox()),
              _headerRoundIconButton(
                icon: Icons.calendar_today_rounded,
                iconColor: Colors.blue.shade600,
                borderColor: Colors.blue.shade300,
                onPressed: handleDateTimePicker,
                tooltip: 'Select Date',
              ),
            ],
          ),
          IgnorePointer(
            child: Text(
              'Cash Book',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerRoundIconButton({
    required IconData icon,
    required Color iconColor,
    required Color borderColor,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: borderColor, width: 1.5),
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: iconColor, size: 22),
          ),
        ),
      ),
    );
  }

  Widget _buildShellBody(CoreViewModel model) {
    return Column(
      children: [
        Expanded(child: _buildMainContent(model)),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMainContent(CoreViewModel model) {
    if (_isMomoMode) {
      return _buildMomoTransactionContent(model);
    }
    return model.newTransactionPressed
        ? _buildTransactionForm(model)
        : _buildTransactionList(model);
  }

  Widget _buildMomoTransactionContent(CoreViewModel model) {
    return MomoTransactionForm(
      transactionType: _momoTransactionType,
      coreViewModel: model,
      onCancel: () {
        setState(() {
          _isMomoMode = false;
        });
      },
      onComplete: () {
        setState(() {
          _isMomoMode = false;
        });
      },
    );
  }

  Widget _buildTransactionList(CoreViewModel model) {
    final transactionData = ref.watch(dashboardTransactionsProvider);
    final dateRange = ref.watch(dateRangeProvider);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: transactionData.when(
              data: (all) => _buildRecentTransactionsCard(
                allTransactions: all,
                dateRange: dateRange,
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    e.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ),
              ),
            ),
          ),
          _buildActionButtons(model),
        ],
      ),
    );
  }

  /// When the global range is “today only”, show the last 30 calendar days (design default).
  ({DateTime start, DateTime end}) _effectiveTransactionWindow(
    DateRangeModel range,
  ) {
    final s = range.startDate!;
    final e = range.endDate!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDay = DateTime(s.year, s.month, s.day);
    final endDay = DateTime(e.year, e.month, e.day);
    final singleDay = startDay == endDay;
    final isToday =
        startDay.year == today.year &&
        startDay.month == today.month &&
        startDay.day == today.day;

    if (singleDay && isToday) {
      final start30 = today.subtract(const Duration(days: 29));
      final endToday = DateTime(today.year, today.month, today.day, 23, 59, 59);
      return (start: start30, end: endToday);
    }
    return (start: s, end: DateTime(e.year, e.month, e.day, 23, 59, 59));
  }

  String _recentTxPeriodSubtitle(({DateTime start, DateTime end}) window) {
    final start = window.start;
    final end = window.end;
    final startDay = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    final days = endDay.difference(startDay).inDays;
    if (days >= 26 && days <= 31) {
      return 'Last 30 days';
    }
    if (startDay == endDay) {
      return DateFormat('MMM d, yyyy').format(startDay);
    }
    return '${DateFormat('MMM d').format(startDay)} – ${DateFormat('MMM d, yyyy').format(endDay)}';
  }

  bool _isMomoTransaction(ITransaction t) {
    final p = (t.paymentType ?? '').toUpperCase();
    if (p.contains('MOMO') ||
        p.contains('MOBILE MONEY') ||
        p.contains('AIRTEL')) {
      return true;
    }
    return t.status == WAITING_MOMO_COMPLETE;
  }

  List<ITransaction> _filterByDateWindow(
    List<ITransaction> value,
    ({DateTime start, DateTime end}) window,
  ) {
    final startDate = window.start;
    final endDate = window.end;
    return value.where((trans) {
      final d = trans.lastTouched;
      if (d == null) return false;
      return (d.isAtSameMomentAs(startDate) || d.isAfter(startDate)) &&
          (d.isAtSameMomentAs(endDate) || d.isBefore(endDate));
    }).toList()..sort((a, b) {
      final ta = a.lastTouched ?? DateTime.fromMillisecondsSinceEpoch(0);
      final tb = b.lastTouched ?? DateTime.fromMillisecondsSinceEpoch(0);
      return tb.compareTo(ta);
    });
  }

  List<ITransaction> _applyChipFilter(
    List<ITransaction> list,
    _RecentTxFilter filter,
  ) {
    switch (filter) {
      case _RecentTxFilter.all:
        return list;
      case _RecentTxFilter.cashIn:
        return list.where((t) => t.isIncome == true).toList();
      case _RecentTxFilter.cashOut:
        return list.where((t) => t.isIncome == false).toList();
      case _RecentTxFilter.momo:
        return list.where(_isMomoTransaction).toList();
    }
  }

  String _transactionRowTitle(ITransaction t) {
    final raw = (t.transactionType ?? '').trim();
    if (raw.isEmpty) {
      return 'Transaction';
    }
    // Category names are stored as plain text; avoid over-formatting acronyms.
    if (raw.length <= 40 && !RegExp(r'[a-z][A-Z]').hasMatch(raw)) {
      return raw.toUpperCase();
    }
    return raw
        .replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m[1]} ${m[2]}')
        .toUpperCase();
  }

  Widget _buildRecentTransactionsCard({
    required List<ITransaction> allTransactions,
    required DateRangeModel dateRange,
  }) {
    final window = _effectiveTransactionWindow(dateRange);
    final byDate = _filterByDateWindow(allTransactions, window);
    final filtered = _applyChipFilter(byDate, _recentTxFilter);

    final subtitle = _recentTxPeriodSubtitle(window);
    final currency = ProxyService.box.defaultCurrency();

    if (byDate.isEmpty) {
      return _buildRecentTxEmptyState(subtitle: subtitle);
    }

    if (filtered.isEmpty) {
      return _buildRecentTxEmptyFilterState(
        subtitle: subtitle,
        periodLabel: subtitle,
      );
    }

    final sumIn = filtered
        .where((t) => t.isIncome == true)
        .fold<double>(0, (s, t) => s + (t.subTotal ?? 0));
    final sumOut = filtered
        .where((t) => t.isIncome == false)
        .fold<double>(0, (s, t) => s + (t.subTotal ?? 0));

    return SizedBox.expand(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: _CashbookColors.chipBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRecentTxHeader(count: filtered.length, subtitle: subtitle),
            Divider(height: 1, color: Colors.grey.shade200),
            _buildRecentTxFilterChips(),
            Divider(height: 1, color: Colors.grey.shade200),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  return _buildRecentTxRow(
                    transaction: filtered[index],
                    currency: currency,
                    highlight: index == 0,
                    showBottomBorder: index < filtered.length - 1,
                  );
                },
              ),
            ),
            Divider(height: 1, color: Colors.grey.shade200),
            _buildRecentTxFooter(
              currency: currency,
              sumIn: sumIn,
              sumOut: sumOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTxHeader({required int count, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _CashbookColors.designBlue,
              borderRadius: BorderRadius.circular(0),
            ),
            child: const Icon(
              Icons.credit_card_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent transactions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey.shade900,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _CashbookColors.chipBorder),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: _CashbookColors.designBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade900,
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

  Widget _buildRecentTxFilterChips() {
    Widget chip(String label, _RecentTxFilter value) {
      final selected = _recentTxFilter == value;
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              onTap: () => setState(() => _recentTxFilter = value),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: selected
                        ? Colors.grey.shade400
                        : _CashbookColors.chipBorder,
                  ),
                  color: selected ? Colors.grey.shade50 : Colors.white,
                ),
                alignment: Alignment.center,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.grey.shade900,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          chip('All', _RecentTxFilter.all),
          chip('Cash in', _RecentTxFilter.cashIn),
          chip('Cash out', _RecentTxFilter.cashOut),
          chip('MoMo', _RecentTxFilter.momo),
        ],
      ),
    );
  }

  Widget _buildRecentTxRow({
    required ITransaction transaction,
    required String currency,
    required bool highlight,
    required bool showBottomBorder,
  }) {
    final routerService = locator<RouterService>();
    final isIncome = transaction.isIncome ?? true;
    final rawAmount = transaction.subTotal ?? 0;
    final formatted = NumberFormat('#,###').format(rawAmount);
    final dt = transaction.lastTouched ?? DateTime.now();

    final Color iconBg = isIncome
        ? _CashbookColors.cashInSurface
        : _CashbookColors.cashOutSurface;
    final Color iconFg = isIncome
        ? _CashbookColors.cashInGreen
        : _CashbookColors.cashOutRed;
    final Color amountColor = iconFg;

    final badgeBg = iconBg;
    final badgeFg = iconFg;
    final badgeLabel = isIncome ? 'Cash in' : 'Cash out';

    return SizedBox(
      width: double.infinity,
      child: Material(
        color: highlight ? _CashbookColors.rowHighlight : Colors.white,
        child: InkWell(
          onTap: () => routerService.navigateTo(
            TransactionDetailRoute(transaction: transaction),
          ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: showBottomBorder
                ? BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade200),
                    ),
                  )
                : null,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isIncome
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: iconFg,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _transactionRowTitle(transaction),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade900,
                            height: 1.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${DateFormat('MMM d, yyyy').format(dt)} · ${DateFormat('HH:mm').format(dt)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerRight,
                        child: Text(
                          '${isIncome ? '+' : '-'}$formatted $currency',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: amountColor,
                            height: 1.1,
                          ),
                          maxLines: 1,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: badgeBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          child: Text(
                            badgeLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: badgeFg,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: Colors.grey.shade400,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTxFooter({
    required String currency,
    required double sumIn,
    required double sumOut,
  }) {
    final fmt = NumberFormat('#,###');
    final (
      String leftLabel,
      String rightText,
      Color amountColor,
    ) = switch (_recentTxFilter) {
      _RecentTxFilter.cashOut => (
        'Total out',
        '-${fmt.format(sumOut)} $currency',
        _CashbookColors.cashOutRed,
      ),
      _RecentTxFilter.momo => () {
        final net = sumIn - sumOut;
        return (
          'MoMo net',
          '${net >= 0 ? '+' : '-'}${fmt.format(net.abs())} $currency',
          net >= 0 ? _CashbookColors.cashInGreen : _CashbookColors.cashOutRed,
        );
      }(),
      _RecentTxFilter.all || _RecentTxFilter.cashIn => (
        'Total in',
        '+${fmt.format(sumIn)} $currency',
        _CashbookColors.cashInGreen,
      ),
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  leftLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    rightText,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                      height: 1.1,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: _CashbookColors.designBlue,
              padding: const EdgeInsets.only(left: 12, top: 0),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              alignment: Alignment.topRight,
            ),
            onPressed: () =>
                locator<RouterService>().navigateTo(const TransactionsRoute()),
            child: const Text(
              'View all',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTxEmptyState({required String subtitle}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _CashbookColors.chipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRecentTxHeader(count: 0, subtitle: subtitle),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.all(28),
              child: Center(
                child: Text(
                  'Your transactions will appear here once you start adding them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTxEmptyFilterState({
    required String subtitle,
    required String periodLabel,
  }) {
    final msg = switch (_recentTxFilter) {
      _RecentTxFilter.cashIn => 'No cash in transactions for $periodLabel.',
      _RecentTxFilter.cashOut => 'No cash out transactions for $periodLabel.',
      _RecentTxFilter.momo => 'No MoMo transactions for $periodLabel.',
      _RecentTxFilter.all => 'No transactions for $periodLabel.',
    };
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _CashbookColors.chipBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRecentTxHeader(count: 0, subtitle: subtitle),
          Divider(height: 1, color: Colors.grey.shade200),
          _buildRecentTxFilterChips(),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          _buildTransactionButton(
            text: '↑ ${TransactionType.cashIn}',
            color: _CashbookColors.primaryGreen,
            onPressed: () =>
                _showPaymentMethodSelector(model, TransactionType.cashIn),
          ),
          _buildTransactionButton(
            text: '↓ ${TransactionType.cashOut}',
            color: const Color(0xFFFF0331),
            onPressed: () =>
                _showPaymentMethodSelector(model, TransactionType.cashOut),
          ),
        ],
      ),
    );
  }

  void _showPaymentMethodSelector(CoreViewModel model, String transactionType) {
    final isIncome = transactionType == TransactionType.cashIn;
    final color = isIncome
        ? _CashbookColors.primaryGreen
        : const Color(0xFFFF0331);

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Payment Method',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(Icons.money, color: color),
                ),
                title: const Text('Cash'),
                subtitle: const Text('Regular cash transaction'),
                onTap: () {
                  Navigator.pop(context);
                  _startNewTransaction(model, transactionType);
                },
              ),
              const Divider(),
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Icon(Icons.phone_android, color: color),
                ),
                title: const Text('MoMo/Airtel'),
                subtitle: const Text('Mobile money transaction'),
                onTap: () {
                  Navigator.pop(context);
                  _startMomoTransaction(transactionType);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startMomoTransaction(String transactionType) {
    setState(() {
      _isMomoMode = true;
      _momoTransactionType = transactionType;
    });
    HapticFeedback.lightImpact();
  }

  Widget _buildTransactionButton({
    required String text,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: FlipperButton(
          text: text,
          color: color,
          width: double.infinity,
          height: 52,
          radius: 12,
          textColor: Colors.white,
          onPressed: onPressed,
        ),
      ),
    );
  }

  void _startNewTransaction(CoreViewModel model, String transactionType) {
    _amountController.clear();
    _descriptionController.clear();

    ref.read(keypadProvider.notifier).reset();

    model.newTransactionPressed = true;
    model.newTransactionType = transactionType;
    model.notifyListeners();
  }

  void _syncKeypadFromAmount(String value) {
    if (value.isNotEmpty && double.tryParse(value) != null) {
      ref.read(keypadProvider.notifier).addKey(value);
    }
  }

  void _adjustAmount(double delta) {
    final text = _amountController.text.trim();
    final cur = double.tryParse(text) ?? 0;
    final next = cur + delta;
    final formatted = next == next.roundToDouble()
        ? next.toInt().toString()
        : next.toStringAsFixed(2);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    _syncKeypadFromAmount(formatted);
  }

  void _clearAmountField() {
    _amountController.clear();
    ref.read(keypadProvider.notifier).reset();
  }

  Widget _buildTransactionForm(CoreViewModel model) {
    final isIncome = model.newTransactionType == TransactionType.cashIn;
    final currency = ProxyService.box.defaultCurrency();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildCashTypeSegment(model),
                    const SizedBox(height: 18),
                    _buildAmountSection(currency),
                    const SizedBox(height: 20),
                    Text(
                      isIncome ? 'CASH IN FOR' : 'CASH OUT FOR',
                      style: _captionLabelStyle(context),
                    ),
                    const SizedBox(height: 10),
                    _buildCategoryGrid(model),
                    const SizedBox(height: 18),
                    Text('DESCRIPTION', style: _captionLabelStyle(context)),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: 'Optional note...',
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                        filled: true,
                        fillColor: _CashbookColors.beigeField,
                        contentPadding: const EdgeInsets.all(16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: _CashbookColors.primaryGreen,
                            width: 1.5,
                          ),
                        ),
                      ),
                      maxLines: 4,
                      minLines: 3,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildFormFooter(model),
          ],
        ),
      ),
    );
  }

  TextStyle _captionLabelStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelSmall!.copyWith(
      letterSpacing: 1.1,
      fontWeight: FontWeight.w600,
      color: _CashbookColors.labelMuted,
      fontSize: 11,
    );
  }

  Widget _buildCashTypeSegment(CoreViewModel model) {
    final selected = <String>{model.newTransactionType};
    return SegmentedButton<String>(
      segments: const [
        ButtonSegment<String>(
          value: TransactionType.cashIn,
          label: Text('Cash In'),
        ),
        ButtonSegment<String>(
          value: TransactionType.cashOut,
          label: Text('Cash Out'),
        ),
      ],
      emptySelectionAllowed: false,
      selected: selected,
      onSelectionChanged: (Set<String> next) {
        if (next.isEmpty) return;
        model.newTransactionType = next.first;
        model.notifyListeners();
      },
      style: SegmentedButton.styleFrom(
        selectedForegroundColor: Colors.white,
        selectedBackgroundColor: _CashbookColors.primaryGreen,
        foregroundColor: Colors.grey.shade800,
        backgroundColor: _CashbookColors.beigeInactive,
        side: BorderSide(color: Colors.grey.shade300),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  Widget _buildAmountSection(String currency) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _CashbookColors.mintAmountBg,
            _CashbookColors.mintAmountBg.withValues(alpha: 0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _CashbookColors.primaryGreen.withValues(alpha: 0.25),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AMOUNT',
              style: Theme.of(context).textTheme.labelSmall!.copyWith(
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
                color: _CashbookColors.primaryGreen,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    currency,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: _CashbookColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}'),
                      ),
                    ],
                    autofocus: true,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF166534),
                      letterSpacing: -0.5,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: '0',
                      hintStyle: TextStyle(color: Color(0x33166534)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid amount';
                      }
                      if (double.parse(value) <= 0) {
                        return 'Amount must be greater than zero';
                      }
                      return null;
                    },
                    onChanged: _syncKeypadFromAmount,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _amountChip('+50', () => _adjustAmount(50)),
                _amountChip('+100', () => _adjustAmount(100)),
                _amountChip('+500', () => _adjustAmount(500)),
                _amountChip('Clear', _clearAmountField),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _amountChip(String label, VoidCallback onTap) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF166534),
        side: BorderSide(
          color: _CashbookColors.primaryGreen.withValues(alpha: 0.45),
        ),
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(label),
    );
  }

  List<Category> _sortedCategoriesForGrid(List<Category> all) {
    final active = all.where((c) => c.active ?? false).toList();
    active.sort((a, b) {
      final af = a.focused ? 0 : 1;
      final bf = b.focused ? 0 : 1;
      if (af != bf) return af.compareTo(bf);
      return (a.name ?? '').compareTo(b.name ?? '');
    });
    return active.take(3).toList();
  }

  String? _resolvedSelectedCategoryId(List<Category> categories) {
    final optimistic = ref.watch(optimisticFocusedCategoryProvider);
    if (optimistic != null && optimistic.id.isNotEmpty) {
      return optimistic.id;
    }
    try {
      final focused = categories.firstWhere(
        (c) => c.focused && (c.active ?? false),
      );
      return focused.id;
    } catch (_) {
      return null;
    }
  }

  IconData _categorySlotIcon(int index) {
    switch (index) {
      case 0:
        return Icons.person_outline_rounded;
      case 1:
        return Icons.business_center_outlined;
      default:
        return Icons.layers_outlined;
    }
  }

  Widget _buildCategoryGrid(CoreViewModel model) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      data: (list) {
        final tiles = _sortedCategoriesForGrid(list);
        final selectedId = _resolvedSelectedCategoryId(list);

        return LayoutBuilder(
          builder: (context, constraints) {
            final spacing = 10.0;
            final cellWidth = (constraints.maxWidth - spacing) / 2;
            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: [
                ...List.generate(tiles.length, (i) {
                  final c = tiles[i];
                  final sel = selectedId != null && selectedId == c.id;
                  return SizedBox(
                    width: cellWidth,
                    child: _categoryChoiceTile(
                      label: c.name ?? '',
                      icon: _categorySlotIcon(i),
                      selected: sel,
                      onTap: () => _onCategoryTap(model, c),
                    ),
                  );
                }),
                SizedBox(
                  width: cellWidth,
                  child: _addCategoryTile(onTap: _openCategoriesForTransaction),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      error: (e, _) => Text('Categories error: $e'),
    );
  }

  Widget _categoryChoiceTile({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: selected
                ? _CashbookColors.mintAmountBg
                : _CashbookColors.beigeInactive,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected
                  ? _CashbookColors.primaryGreen
                  : Colors.grey.shade300,
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: selected
                    ? const Color(0xFF166534)
                    : Colors.grey.shade700,
                size: 26,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: selected
                      ? const Color(0xFF166534)
                      : Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addCategoryTile({required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: CustomPaint(
          painter: _DashedRoundedBorderPainter(
            color: Colors.grey.shade400,
            radius: 14,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, color: Colors.grey.shade600, size: 26),
                const SizedBox(height: 8),
                Text(
                  'Add new',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onCategoryTap(CoreViewModel model, Category category) async {
    final ok = await model.updateCategoryCore(category: category);
    if (!mounted || !ok) return;
    ref.read(optimisticFocusedCategoryProvider.notifier).setFocused(category);
    ref.invalidate(categoryProvider);
    final bid = ProxyService.box.getBranchId();
    if (bid != null) {
      ref.invalidate(categoriesProvider(branchId: bid));
    }
    setState(() {});
  }

  Future<void> _openCategoriesForTransaction() async {
    final routerService = locator<RouterService>();
    await routerService.navigateTo(
      ListCategoriesRoute(modeOfOperation: 'transaction'),
    );
    if (!mounted) return;
    ref.invalidate(categoryProvider);
    final bid = ProxyService.box.getBranchId();
    if (bid != null) {
      ref.invalidate(categoriesProvider(branchId: bid));
    }
  }

  Widget _buildFormFooter(CoreViewModel model) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _cancelTransaction(model),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.grey.shade900,
              backgroundColor: _CashbookColors.beigeField,
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey.shade300),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: model.isBusy
                ? null
                : () => _handleSaveTransaction(model, 'N/A'),
            style: ElevatedButton.styleFrom(
              backgroundColor: _CashbookColors.primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: model.isBusy
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_rounded, color: Colors.white, size: 22),
                      SizedBox(width: 8),
                      Text('Save Entry'),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _cancelTransaction(CoreViewModel model) {
    model.newTransactionPressed = false;
    model.notifyListeners();
  }

  Future<void> _handleSaveTransaction(
    CoreViewModel model,
    String countryCode,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final amount = double.parse(_amountController.text);
    final isIncome = model.newTransactionType == TransactionType.cashIn;
    final transactionType = model.newTransactionType;

    final String branchId = ProxyService.box.getBranchId()!;
    // Transaction list + pending streams use SQLite (ProxyService.strategy).
    // Saving via Capella/Ditto-only would not show in those providers.
    final Category? category = await ProxyService.strategy.activeCategory(
      branchId: branchId,
    );

    if (category == null) {
      showWarningNotification(context, 'Please select a category first');
      return;
    }

    final String bhfId = (await ProxyService.box.bhfId()) ?? '00';

    try {
      model.setBusy(true);
      ref.read(keypadProvider.notifier).reset();
      ref.read(keypadProvider.notifier).addKey(_amountController.text);

      talker.info('Starting transaction save with amount: $amount');
      talker.info('Transaction type: $transactionType, isIncome: $isIncome');

      final saveResult = await _saveTransaction(
        countryCode: countryCode,
        bhfId: bhfId,
        model: model,
        paymentType: ProxyService.box.paymentType() ?? 'Cash',
        cashReceived: amount,
        discount: 0,
        isIncome: isIncome,
        transactionType: transactionType,
        category: category,
        note: _descriptionController.text,
      );

      if (saveResult == null) {
        return;
      }

      model.newTransactionPressed = false;
      model.notifyListeners();

      showSuccessNotification(
        context,
        '${isIncome ? 'Cash in' : 'Cash out'} transaction saved successfully',
      );

      final String tid = saveResult.transactionId;
      final bool wasIncome = saveResult.isIncome;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) {
          return;
        }
        ref.refresh(transactionItemsProvider(transactionId: tid));
        ref.refresh(pendingTransactionStreamProvider(isExpense: !wasIncome));
        SchedulerBinding.instance.scheduleTask(() {
          if (context.mounted) {
            ref.invalidate(dashboardTransactionsProvider);
          }
        }, Priority.idle);
      });
    } catch (e) {
      talker.error('Error saving transaction: $e');
      showErrorNotification(context, 'Error: ${e.toString()}');
    } finally {
      model.setBusy(false);
    }
  }

  /// Returns `null` if no pending transaction could be created.
  Future<({String transactionId, bool isIncome})?> _saveTransaction({
    required CoreViewModel model,
    required String paymentType,
    required double cashReceived,
    required int discount,
    required bool isIncome,
    required String transactionType,
    required String countryCode,
    required String bhfId,
    required Category category,
    String? note,
  }) async {
    try {
      final strategy = ProxyService.strategy;

      String? branchId = ProxyService.box.getBranchId();
      if (branchId == null || branchId.isEmpty) {
        throw Exception('Branch ID is null or empty');
      }

      talker.info('Starting completeCashMovement with amount: $cashReceived');
      talker.info('Transaction type: $transactionType, isIncome: $isIncome');

      HapticFeedback.lightImpact();

      final updatedTransaction = await strategy.completeCashMovement(
        branchId: branchId,
        bhfId: bhfId,
        cashReceived: cashReceived,
        isIncome: isIncome,
        utilityVariantName: transactionType,
        paymentType: paymentType,
        discount: discount.toDouble(),
        countryCode: countryCode,
        isProformaMode: ProxyService.box.isProformaMode(),
        isTrainingMode: ProxyService.box.isTrainingMode(),
        transactionTypeForRecord: category.name ?? TransactionType.sale,
        categoryId: category.id.toString(),
        note: note,
      );

      talker.info(
        'Transaction save completed successfully: ${updatedTransaction.id}',
      );

      return (
        transactionId: updatedTransaction.id,
        isIncome: isIncome,
      );
    } catch (e, s) {
      talker.error('Error in _saveTransaction: $e');
      talker.error(s);
      rethrow;
    }
  }
}

/// Draws a dashed rounded rectangle behind [child] content.
final class _DashedRoundedBorderPainter extends CustomPainter {
  _DashedRoundedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rect);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    const dashLen = 5.0;
    const gap = 4.0;
    for (final metric in path.computeMetrics()) {
      double dist = 0;
      while (dist < metric.length) {
        final next = (dist + dashLen).clamp(0.0, metric.length);
        final extract = metric.extractPath(dist, next);
        canvas.drawPath(extract, paint);
        dist = next + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRoundedBorderPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
