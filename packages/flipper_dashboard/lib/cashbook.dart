// ignore_for_file: unused_result

import 'package:flipper_localize/flipper_localize.dart';
import 'dart:async';

import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/cashbook_form_rules.dart';
import 'package:flipper_dashboard/widgets/cashbook_list_view.dart';
import 'package:flipper_dashboard/widgets/cashbook_new_category_sheet.dart';
import 'package:flipper_dashboard/widgets/dashboard_quick_access_svgs.dart';
import 'package:flipper_dashboard/widgets/transaction_detail_svgs.dart';
import 'package:flipper_dashboard/features/personal_goals/personal_goals_providers.dart';
import 'package:flipper_models/providers/category_provider.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:flutter/material.dart';
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

  static const Color cashInGreen = Color(0xFF1B5E20);
  static const Color cashInSurface = Color(0xFFE8F5E9);
  static const Color cashOutRed = Color(0xFFB71C1C);
  static const Color cashOutSurface = Color(0xFFFFEBEE);
}

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

  /// Form-local choices for the entry being recorded. Never written to the
  /// shared category `focused`/`active` flags.
  String? _selectedCategoryId;

  /// Category made via "+ New" on this screen. [categoryProvider] is
  /// refreshed asynchronously, so a quick Save can run before the stream
  /// carries it; the save lookup falls back to this copy.
  Category? _createdCategory;
  String _paymentMethod = cashbookMethodCash;

  /// Seeds [_selectedCategoryId] once categories load for a new entry.
  bool _categorySeedPending = false;

  CashbookListFilter _listFilter = CashbookListFilter.all;

  bool _personalGoalCashInIntentApplied = false;

  /// Root scope; safe after this State is disposed (unlike [ref]).
  ProviderContainer? _providerContainer;

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    _providerContainer ??= ProviderScope.containerOf(context);
  }

  @override
  void dispose() {
    final container = _providerContainer;
    if (container != null) {
      // Notifier updates are not allowed during dispose (same constraint as build);
      // popping this route runs dispose while the tree may still be settling.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        container.read(personalGoalCashInIntentProvider.notifier).clear();
      });
    }
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CoreViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => CoreViewModel(),
      onViewModelReady: (model) {
        final pgIntent = ref.read(personalGoalCashInIntentProvider);
        if (pgIntent == null || _personalGoalCashInIntentApplied) return;
        _personalGoalCashInIntentApplied = true;
        // Apply before the first [builder] paint so we don't flash the tx list.
        // Keypad reset is deferred slightly to avoid Riverpod "modify during build"
        // if this runs in the same scheduling turn as ancestor layout.
        _startNewTransaction(
          model,
          TransactionType.cashIn,
          deferKeypadReset: true,
        );
        _descriptionController.text = 'Personal goal: ${pgIntent.goalName}';
      },
      builder: (context, model, child) {
        return PopScope(
          canPop: !model.newTransactionPressed,
          onPopInvokedWithResult: (didPop, _) {
            if (didPop) return;
            if (model.newTransactionPressed) {
              _cancelTransaction(model);
            }
          },
          child: Scaffold(
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
                          _buildCashbookHeader(model),
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
          ),
        );
      },
    );
  }

  void _onCashbookClosePressed(CoreViewModel model) {
    if (model.newTransactionPressed) {
      _cancelTransaction(model);
      return;
    }
    if (!context.mounted) return;
    Navigator.of(context).maybePop();
  }

  Widget _buildCashbookHeader(CoreViewModel model) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Row(
        children: [
          _HeaderIconButton(
            tooltip: model.newTransactionPressed
                ? context.flipperL10n.back
                : context.flipperL10n.close,
            onPressed: () => _onCashbookClosePressed(model),
            child: model.newTransactionPressed
                ? TransactionDetailSvgs.icon(
                    TransactionDetailSvgs.chevronLeft(),
                    size: 22,
                    color: CashbookListTokens.ink,
                  )
                : DashboardQuickAccessSvgs.assetIcon(
                    DashboardQuickAccessSvgs.x,
                    size: 20,
                    color: CashbookListTokens.ink,
                  ),
          ),
          Expanded(
            child: Text(
              context.flipperL10n.cashbookTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 19,
                color: CashbookListTokens.ink,
                letterSpacing: -0.2,
              ),
            ),
          ),
          // Keeps the title centred while the form hides the date picker.
          Visibility(
            visible: !model.newTransactionPressed,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: _HeaderIconButton(
              tooltip: context.flipperL10n.cashbookSelectDates,
              onPressed: handleDateTimePicker,
              child: DashboardQuickAccessSvgs.assetIcon(
                DashboardQuickAccessSvgs.calendar,
                size: 20,
                color: CashbookListTokens.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShellBody(CoreViewModel model) {
    return _buildMainContent(model);
  }

  Widget _buildMainContent(CoreViewModel model) {
    return model.newTransactionPressed
        ? _buildTransactionForm(model)
        : _buildTransactionList(model);
  }

  Widget _buildTransactionList(CoreViewModel model) {
    final transactionData = ref.watch(cashbookRecentTransactionsProvider);
    final dateRange = ref.watch(dateRangeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: transactionData.when(
            data: (all) => _buildList(all, dateRange),
            loading: () => const ColoredBox(
              color: CashbookListTokens.page,
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
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
        CashbookActionBar(
          onCashIn: () => _startNewTransaction(model, TransactionType.cashIn),
          onCashOut: () => _startNewTransaction(model, TransactionType.cashOut),
        ),
      ],
    );
  }

  Widget _buildList(List<ITransaction> all, DateRangeModel dateRange) {
    final window = _effectiveTransactionWindow(dateRange);
    final inWindow = _filterByDateWindow(all, window);
    final byId = {for (final t in inWindow) t.id: t};

    return CashbookListView(
      entries: [for (final t in inWindow) _toListEntry(t)],
      filter: _listFilter,
      onFilterChanged: (f) => setState(() => _listFilter = f),
      currency: ProxyService.box.defaultCurrency(),
      periodLabel: _recentTxPeriodSubtitle(window),
      onPickPeriod: handleDateTimePicker,
      onViewAll: () => locator<RouterService>().navigateTo(TransactionsRoute()),
      onRefresh: () async {
        ref.invalidate(cashbookRecentTransactionsProvider);
      },
      onEntryTap: (id) {
        final t = byId[id];
        if (t == null) return;
        locator<RouterService>().navigateTo(
          TransactionDetailRoute(transaction: t),
        );
      },
    );
  }

  CashbookListEntry _toListEntry(ITransaction t) {
    final kind = classifyCashbookEntry(
      receiptType: t.receiptType,
      transactionType: t.transactionType,
      isIncome: t.isIncome,
    );
    final labels = cashbookRowLabels(
      kind: kind,
      transactionType: t.transactionType,
      note: t.note,
    );
    return CashbookListEntry(
      id: t.id,
      kind: kind,
      title: labels.title,
      detail: labels.detail,
      amount: (t.subTotal ?? 0).toDouble(),
      at: (_transactionWindowInstant(t) ?? DateTime.now()).toLocal(),
      methodBadge: cashbookMethodBadge(t.paymentType),
      isMobileMoney: _isMomoTransaction(t),
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

  /// Prefer [lastTouched]; fall back so Capella-completed rows still match the UI window.
  DateTime? _transactionWindowInstant(ITransaction t) {
    return t.lastTouched ?? t.updatedAt ?? t.createdAt;
  }

  List<ITransaction> _filterByDateWindow(
    List<ITransaction> value,
    ({DateTime start, DateTime end}) window,
  ) {
    final startDate = window.start;
    final endDate = window.end;
    return value.where((trans) {
      final d = _transactionWindowInstant(trans);
      if (d == null) return false;
      return (d.isAtSameMomentAs(startDate) || d.isAfter(startDate)) &&
          (d.isAtSameMomentAs(endDate) || d.isBefore(endDate));
    }).toList()..sort((a, b) {
      final ta =
          _transactionWindowInstant(a) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final tb =
          _transactionWindowInstant(b) ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return tb.compareTo(ta);
    });
  }

  void _startNewTransaction(
    CoreViewModel model,
    String transactionType, {
    bool deferKeypadReset = false,
  }) {
    _amountController.clear();
    _descriptionController.clear();
    _paymentMethod = initialCashbookPaymentMethod(
      ProxyService.box.readString(key: cashbookLastPaymentMethodKey),
    );
    _selectedCategoryId = null;
    _categorySeedPending = true;
    HapticFeedback.lightImpact();

    void resetKeypad() {
      ref.read(keypadProvider.notifier).reset();
    }

    if (deferKeypadReset) {
      scheduleMicrotask(() {
        if (!mounted) return;
        resetKeypad();
      });
    } else {
      resetKeypad();
    }

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
                    _buildEntryTypeHeader(isIncome),
                    const SizedBox(height: 14),
                    _buildAmountSection(currency),
                    const SizedBox(height: 20),
                    Text(
                      (isIncome
                              ? context.flipperL10n.cashbookReceivedAs
                              : context.flipperL10n.cashbookPaidWith)
                          .toUpperCase(),
                      style: _captionLabelStyle(context),
                    ),
                    const SizedBox(height: 10),
                    _buildPaymentMethodChips(),
                    const SizedBox(height: 20),
                    Text(
                      isIncome
                          ? 'CASH IN FOR (OPTIONAL)'
                          : 'CASH OUT FOR (OPTIONAL)',
                      style: _captionLabelStyle(context),
                    ),
                    const SizedBox(height: 10),
                    _buildCategoryChips(isIncome),
                    const SizedBox(height: 18),
                    Text(
                      context.flipperL10n.cashbookNote.toUpperCase(),
                      style: _captionLabelStyle(context),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        hintText: context.flipperL10n.cashbookOptionalNoteHint,
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

  /// The Cash In / Cash Out button already chose the direction; show it
  /// instead of offering a toggle that could flip it by accident.
  Widget _buildEntryTypeHeader(bool isIncome) {
    final color = isIncome
        ? _CashbookColors.cashInGreen
        : _CashbookColors.cashOutRed;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isIncome
            ? _CashbookColors.cashInSurface
            : _CashbookColors.cashOutSurface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              isIncome
                  ? context.flipperL10n.cashbookMoneyIn
                  : context.flipperL10n.cashbookMoneyOut,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: color,
              ),
            ),
          ),
        ],
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
              context.flipperL10n.amount.toUpperCase(),
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
                        return context.flipperL10n.pleaseEnterAnAmount;
                      }
                      if (double.tryParse(value) == null) {
                        return context.flipperL10n.cashbookEnterValidAmount;
                      }
                      if (double.parse(value) <= 0) {
                        return context.flipperL10n.cashbookAmountPositive;
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
                _amountChip(context.flipperL10n.clear, _clearAmountField),
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

  Widget _buildPaymentMethodChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final m in cashbookPaymentMethods)
          _choiceChip(
            label: m.label,
            icon: m.value == cashbookMethodCash
                ? Icons.payments_outlined
                : Icons.phone_android_rounded,
            selected: _paymentMethod == m.value,
            onTap: () => setState(() => _paymentMethod = m.value),
          ),
      ],
    );
  }

  Widget _buildCategoryChips(bool isIncome) {
    final categoriesAsync = ref.watch(categoryProvider);

    return categoriesAsync.when(
      data: (list) {
        if (_categorySeedPending) {
          _categorySeedPending = false;
          _selectedCategoryId = initialCashbookCategoryId(
            list.map((c) => c.id),
            ProxyService.box.readString(
              key: cashbookLastCategoryKey(isIncome: isIncome),
            ),
          );
        }
        final ordered = orderCashbookCategories<Category>(
          list,
          id: (c) => c.id,
          name: (c) => c.name ?? '',
          selectedId: _selectedCategoryId,
        );

        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in ordered)
              _choiceChip(
                label: c.name ?? '',
                selected: c.id == _selectedCategoryId,
                // Tapping the selected chip clears it: the category is optional.
                onTap: () => setState(
                  () => _selectedCategoryId = c.id == _selectedCategoryId
                      ? null
                      : c.id,
                ),
              ),
            ActionChip(
              avatar: Icon(Icons.add, size: 18, color: Colors.grey.shade700),
              label: Text(context.flipperL10n.cashbookNewEntry),
              onPressed: () => _createCategoryInline(list, isIncome),
              backgroundColor: Colors.white,
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(12),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      ),
      error: (e, _) => Text('Categories error: $e'),
    );
  }

  Widget _choiceChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    final fg = selected ? const Color(0xFF166534) : Colors.grey.shade800;
    return ChoiceChip(
      avatar: icon == null ? null : Icon(icon, size: 18, color: fg),
      label: Text(label),
      selected: selected,
      showCheckmark: icon == null,
      onSelected: (_) {
        HapticFeedback.selectionClick();
        onTap();
      },
      labelStyle: TextStyle(fontWeight: FontWeight.w600, color: fg),
      selectedColor: _CashbookColors.mintAmountBg,
      backgroundColor: _CashbookColors.beigeInactive,
      side: BorderSide(
        color: selected ? _CashbookColors.primaryGreen : Colors.grey.shade300,
        width: selected ? 1.5 : 1,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  /// Adds a category without leaving the form and selects it.
  Future<void> _createCategoryInline(
    List<Category> existing,
    bool isIncome,
  ) async {
    final selectedId = await showCashbookNewCategorySheet(
      context: context,
      isIncome: isIncome,
      existing: [for (final c in existing) (id: c.id, name: c.name ?? '')],
      onCreate: _addCategory,
    );
    if (!mounted || selectedId == null) return;
    setState(() => _selectedCategoryId = selectedId);
  }

  /// Persists a new category and returns its id. Throws on failure so the
  /// sheet can show the error in place.
  Future<String> _addCategory(String name) async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) throw StateError('No active branch');
    final now = DateTime.now().toUtc();
    final draft = Category(
      name: name,
      branchId: branchId,
      active: true,
      focused: false,
    );
    try {
      await ProxyService.strategy.addCategory(
        id: draft.id,
        name: name,
        branchId: branchId,
        active: true,
        focused: false,
        lastTouched: now,
        createdAt: now,
        deletedAt: null,
      );
    } catch (e) {
      talker.error('Cash book: create category failed: $e');
      rethrow;
    }
    _createdCategory = draft;
    ref.invalidate(categoryProvider);
    return draft.id;
  }

  Widget _buildFormFooter(CoreViewModel model) {
    final isIncome = model.newTransactionType == TransactionType.cashIn;
    final accent = isIncome ? CashbookListTokens.gain : CashbookListTokens.loss;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    );
    final textStyle = Theme.of(
      context,
    ).textTheme.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w700);
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () => _cancelTransaction(model),
              style: OutlinedButton.styleFrom(
                foregroundColor: CashbookListTokens.ink,
                side: const BorderSide(
                  color: CashbookListTokens.line,
                  width: 1.5,
                ),
                shape: shape,
                textStyle: textStyle,
              ),
              child: Text(context.flipperL10n.cancel),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 56,
            child: FilledButton(
              onPressed: model.isBusy
                  ? null
                  : () => _handleSaveTransaction(model, 'N/A'),
              style: FilledButton.styleFrom(
                backgroundColor: accent,
                disabledBackgroundColor: accent.withValues(alpha: 0.6),
                foregroundColor: Colors.white,
                shape: shape,
                textStyle: textStyle,
              ),
              child: model.isBusy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      isIncome
                          ? context.flipperL10n.cashbookSaveCashIn
                          : context.flipperL10n.cashbookSaveCashOut,
                    ),
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
    final selectedId = _selectedCategoryId;
    final category = resolveCashbookSelectedCategory<Category>(
      selectedId: selectedId,
      loaded: ref.read(categoryProvider).value ?? const <Category>[],
      createdHere: _createdCategory,
      id: (c) => c.id,
    );
    final paymentMethod = _paymentMethod;

    final String bhfId = (await ProxyService.box.bhfId()) ?? '00';

    try {
      model.setBusy(true);
      ref.read(keypadProvider.notifier).reset();
      ref.read(keypadProvider.notifier).addKey(_amountController.text);

      talker.info('Starting transaction save with amount: $amount');
      talker.info('Transaction type: $transactionType, isIncome: $isIncome');

      final hasPersonalGoalCashInIntent =
          ref.read(personalGoalCashInIntentProvider) != null;

      HapticFeedback.lightImpact();

      final saveResult = await _saveTransaction(
        countryCode: countryCode,
        bhfId: bhfId,
        model: model,
        paymentType: paymentMethod,
        cashReceived: amount,
        discount: 0,
        isIncome: isIncome,
        transactionType: transactionType,
        category: category,
        note: _descriptionController.text,
        skipPersonalGoalAutoSweep: hasPersonalGoalCashInIntent,
      );

      if (saveResult == null) {
        return;
      }

      unawaited(
        ProxyService.box.writeString(
          key: cashbookLastPaymentMethodKey,
          value: paymentMethod,
        ),
      );
      if (category != null) {
        unawaited(
          ProxyService.box.writeString(
            key: cashbookLastCategoryKey(isIncome: isIncome),
            value: category.id,
          ),
        );
      } else {
        ProxyService.box.remove(
          key: cashbookLastCategoryKey(isIncome: isIncome),
        );
      }

      final pgIntentBefore = ref.read(personalGoalCashInIntentProvider);
      var popAfterPersonalGoalCashIn = false;
      if (pgIntentBefore != null && isIncome) {
        try {
          await ref
              .read(personalGoalsDataSourceProvider)
              .addToGoalSavedAmount(
                goalId: pgIntentBefore.goalId,
                branchId: branchId,
                amount: amount,
                transactionId: saveResult.transactionId,
              );
          ref.read(personalGoalCashInIntentProvider.notifier).clear();
          ref.invalidate(personalGoalsStreamProvider(branchId));
          popAfterPersonalGoalCashIn = true;
        } catch (e, s) {
          talker.error('Personal goal contribution failed: $e\n$s');
        }
      }

      model.newTransactionPressed = false;
      model.notifyListeners();

      showSuccessNotification(
        context,
        isIncome
            ? context.flipperL10n.cashbookCashInSaved
            : context.flipperL10n.cashbookCashOutSaved,
      );

      final String tid = saveResult.transactionId;
      final bool wasIncome = saveResult.isIncome;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final container = _providerContainer;
        if (container == null) {
          return;
        }
        container.refresh(transactionItemsProvider(transactionId: tid));
        container.refresh(
          pendingTransactionStreamProvider(isExpense: !wasIncome),
        );
        // Re-subscribe the home dashboard so the movement shows at once rather
        // than whenever its Ditto observer next fires.
        container.invalidate(dashboardGaugeSnapshotProvider);
        container.invalidate(cashbookRecentTransactionsProvider);
        container.invalidate(transactionsScreenTransactionsProvider);
        if (popAfterPersonalGoalCashIn &&
            context.mounted &&
            Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
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
    required Category? category,
    String? note,
    bool skipPersonalGoalAutoSweep = false,
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
        // No category: the record is titled by its direction.
        transactionTypeForRecord: category?.name ?? transactionType,
        categoryId: category?.id,
        note: note,
        skipPersonalGoalAutoSweep: skipPersonalGoalAutoSweep,
      );

      talker.info(
        'Transaction save completed successfully: ${updatedTransaction.id}',
      );

      return (transactionId: updatedTransaction.id, isIncome: isIncome);
    } catch (e, s) {
      talker.error('Error in _saveTransaction: $e');
      talker.error(s);
      rethrow;
    }
  }
}

/// 40px round header button holding an SVG icon.
class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.child,
    required this.onPressed,
    required this.tooltip,
  });

  final Widget child;
  final VoidCallback onPressed;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: Material(
        color: const Color(0xFFF3F4F6),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(width: 40, height: 40, child: Center(child: child)),
        ),
      ),
    );
  }
}
