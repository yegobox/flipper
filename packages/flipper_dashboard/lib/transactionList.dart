import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_dashboard/providers/transaction_report_filters_provider.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/transaction_payment_sums.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:intl/intl.dart';
import 'package:flipper_dashboard/transaction_report_mock_cashiers.dart';
import 'package:flipper_dashboard/widgets/sales_by_cashier_chart.dart';
import 'package:flipper_dashboard/widgets/transaction_report_kpi_strip.dart';

class TransactionList extends StatefulHookConsumerWidget {
  TransactionList({
    Key? key,
    this.showDetailedReport = true,
    this.hideHeader = false,
    this.showSearch = true,
  }) : super(key: key);

  final bool showDetailedReport;
  final bool hideHeader;
  final bool showSearch;

  @override
  TransactionListState createState() => TransactionListState();
}

/// Primary actions / selection (shared Transaction Reports mock).
const Color _kReportPrimary = Color(0xFF2563EB);

BoxDecoration _reportChromeCardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: const Color(0xFFE5E7EB)),
    boxShadow: [
      const BoxShadow(
        color: Color(0x08000000),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
  );
}

class TransactionListState extends ConsumerState<TransactionList>
    with WidgetsBindingObserver, DateCoreWidget {
  // Use a late initialized key to ensure it's created fresh when needed
  late GlobalKey<SfDataGridState> workBookKey;
  late GlobalKey<DataViewState> dataViewKey;
  final TextEditingController _searchController = TextEditingController();
  bool _isExporting = false;

  @override
  void initState() {
    super.initState();
    // Initialize the keys
    workBookKey = GlobalKey<SfDataGridState>();
    dataViewKey = GlobalKey<DataViewState>();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static final DateFormat _rangeFmt = DateFormat('dd/MM/yyyy');

  String _formatRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) return 'Select a date range';
    return '${_rangeFmt.format(startDate)} — ${_rangeFmt.format(endDate)}';
  }

  // Export using the already-mounted DataView on screen
  Future<void> _exportAllData() async {
    print('🔵 EXPORT BUTTON: _exportAllData called');
    final dateRange = ref.read(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    if (startDate == null || endDate == null) {
      print('🔴 EXPORT BUTTON: No date range selected');
      if (mounted) {
        showWarningNotification(
          context,
          'Please select a date range first',
        );
      }
      return;
    }

    print('🔵 EXPORT BUTTON: Date range selected, checking dataViewKey...');
    print('🔵 EXPORT BUTTON: dataViewKey.currentState = ${dataViewKey.currentState}');
    
    try {
      if (dataViewKey.currentState == null) {
        // DataView not yet mounted (e.g. no data / still loading)
        print('🔴 EXPORT BUTTON: DataView not mounted');
        if (mounted) {
          showWarningNotification(
            context,
            'No data to export. Please wait for data to load.',
          );
        }
        return;
      }
      // Call triggerExport directly on the already-mounted DataView.
      // This avoids creating a second overlay widget (which would open new
      // Ditto live queries and slow the export down).
      print('🔵 EXPORT BUTTON: Calling triggerExport...');
      
      // Delay so the UI has time to show the loading spinner state
      await Future.delayed(const Duration(milliseconds: 100));

      final forceRealData = !(ProxyService.box.enableDebug() ?? false);
      final snapAsync =
          ref.read(filteredTransactionReportSnapshotProvider(forceRealData));
      final snap = snapAsync.asData?.value;
      if (snap == null) {
        if (mounted) {
          showWarningNotification(
            context,
            'Report data is still loading. Please try again in a moment.',
          );
        }
        return;
      }
      final allowedIds = snap.transactions.map((t) => t.id.toString()).toSet();

      await dataViewKey.currentState!.triggerExport(
        headerTitle: 'Report',
        filteredSummaryTransactions: snap.transactions,
        filteredPaymentSumsByTransactionId: snap.paymentSumsByTransactionId,
        allowedTransactionIds: allowedIds,
      );
      print('🔵 EXPORT BUTTON: triggerExport completed');
    } catch (e) {
      print('🔴 EXPORT BUTTON: Error caught: $e');
      if (mounted) {
        showErrorNotification(
          context,
          'Export failed: ${e.toString()}',
          duration: const Duration(seconds: 5),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    final showDetailed = ref.watch(toggleBooleanValueProvider);
    final rowsPerPage = ref.watch(rowsPerPageProvider);
    final filters = ref.watch(transactionReportFiltersProvider);
    final forceRealData = !(ProxyService.box.enableDebug() ?? false);

    final baseSnapAsync =
        ref.watch(transactionReportSnapshotProvider(forceRealData: forceRealData));

    final filteredSnapAsync =
        ref.watch(filteredTransactionReportSnapshotProvider(forceRealData));

    final transactions = filteredSnapAsync.asData?.value.transactions;
    final paymentSumsForGrid =
        filteredSnapAsync.asData?.value.paymentSumsByTransactionId;

    final AsyncValue<List<TransactionItem>> itemsAsync =
        ref.watch(filteredTransactionItemListProvider(forceRealData));
    final transactionItems = itemsAsync.asData?.value;

    final AsyncValue<List<dynamic>> dataProvider = switch (showDetailed) {
      true => switch (itemsAsync) {
          AsyncData(:final value) =>
            AsyncValue<List<dynamic>>.data(value.cast<dynamic>()),
          AsyncError(:final error, :final stackTrace) =>
            AsyncValue<List<dynamic>>.error(error, stackTrace),
          _ => const AsyncValue<List<dynamic>>.loading(),
        },
      false => switch (filteredSnapAsync) {
          AsyncData(:final value) => AsyncValue<List<dynamic>>.data(
              value.transactions.cast<dynamic>(),
            ),
          AsyncError(:final error, :final stackTrace) =>
            AsyncValue<List<dynamic>>.error(error, stackTrace),
          _ => const AsyncValue<List<dynamic>>.loading(),
        }
    };

    return _buildReportScaffold(
      context,
      startDate,
      endDate,
      showDetailed,
      rowsPerPage,
      dataProvider,
      transactions,
      transactionItems,
      paymentSumsForGrid,
      filters: filters,
      baseTransactions: baseSnapAsync.asData?.value.transactions,
    );
  }

  Widget _buildReportScaffold(
    BuildContext context,
    DateTime? startDate,
    DateTime? endDate,
    bool showDetailed,
    int rowsPerPage,
    AsyncValue<List<dynamic>> dataProvider,
    List<ITransaction>? transactions,
    List<TransactionItem>? transactionItems,
    Map<String, TransactionPaymentSums>? paymentSumsForGrid,
    {required TransactionReportFilters filters,
    required List<ITransaction>? baseTransactions,}
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final horizontalPadding = isDesktop ? 24.0 : 12.0;

        final kpiStart =
            startDate ?? DateTime.now().subtract(const Duration(days: 7));
        final kpiEnd = endDate ?? DateTime.now();

        return Container(
          decoration: const BoxDecoration(color: Color(0xFFF2F4F7)),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!widget.hideHeader) ...[
                  _buildTopHeader(context, startDate, endDate, isDesktop),
                  const SizedBox(height: 16),
                  TransactionReportKpiStrip(
                    transactions: transactions ?? const <ITransaction>[],
                    transactionItems: transactionItems,
                    paymentSumsByTransactionId: paymentSumsForGrid,
                    startDate: kpiStart,
                    endDate: kpiEnd,
                    showDetailed: showDetailed,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    decoration: _reportChromeCardDecoration(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: _buildFiltersRow(
                      showDetailed,
                      isDesktop,
                      filters,
                      baseTransactions ?? transactions,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    decoration: _reportChromeCardDecoration(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: _buildCashierChipsRow(
                      isDesktop,
                      baseTransactions ?? transactions,
                      filters,
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (widget.showSearch && widget.hideHeader) ...[
                  _buildSearchAndActions(isDesktop, filters),
                  const SizedBox(height: 16),
                ],
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildContent(
                            dataProvider,
                            transactions,
                            transactionItems,
                            paymentSumsForGrid,
                            startDate,
                            endDate,
                            showDetailed,
                            filters,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    DateTime? startDate,
    DateTime? endDate,
    bool isDesktop,
  ) {
    final rangeText = _formatRange(startDate, endDate);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Transaction Reports',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: const Color(0xFF111827),
                      fontSize: 22,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 18,
                      color: Colors.grey.shade700,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      rangeText,
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.file_download_outlined,
          tooltip: 'Export',
          onTap: () async {
            setState(() => _isExporting = true);
            try {
              await _exportAllData();
            } finally {
              if (mounted) setState(() => _isExporting = false);
            }
          },
          isLoading: _isExporting,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.print_outlined,
          tooltip: 'Print',
          onTap: () {
            // TODO: Implement
          },
        ),
        const SizedBox(width: 12),
        FilledButton.icon(
          onPressed: handleDateTimePicker,
          icon: const Icon(Icons.date_range_outlined, size: 18),
          label: const Text('Change Date'),
          style: FilledButton.styleFrom(
            backgroundColor: _kReportPrimary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }

  Widget _buildFiltersRow(
    bool showDetailed,
    bool isDesktop,
    TransactionReportFilters filters,
    List<ITransaction>? baseTransactions,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _buildSearchAndActions(
                  isDesktop,
                  filters,
                  embeddedInToolbar: true,
                ),
              ),
              const SizedBox(width: 12),
              _buildDropdownFilter(
                label: 'All statuses',
                value: (filters.status == null || filters.status!.isEmpty)
                    ? null
                    : filters.status,
                options: () {
                  final txs = baseTransactions ?? const <ITransaction>[];
                  final set = txs
                      .map((t) => t.status)
                      .whereType<String>()
                      .where((s) => s.isNotEmpty)
                      .toSet()
                      .toList()
                    ..sort();
                  return set;
                }(),
                onChanged: (v) => ref
                    .read(transactionReportFiltersProvider.notifier)
                    .setStatus(v),
              ),
              const SizedBox(width: 12),
              _buildDropdownFilter(
                label: 'All types',
                value: (filters.transactionType == null ||
                        filters.transactionType!.isEmpty)
                    ? null
                    : filters.transactionType,
                options: () {
                  final txs = baseTransactions ?? const <ITransaction>[];
                  final set = txs
                      .map((t) => t.receiptType)
                      .whereType<String>()
                      .where((s) => s.isNotEmpty)
                      .toSet()
                      .toList()
                    ..sort();
                  return set;
                }(),
                onChanged: (v) => ref
                    .read(transactionReportFiltersProvider.notifier)
                    .setTransactionType(v),
              ),
              const SizedBox(width: 12),
              _buildDropdownFilter<TransactionReportPaymentFilter>(
                label: 'All payments',
                value: filters.payment == TransactionReportPaymentFilter.all
                    ? null
                    : filters.payment,
                options: const [
                  TransactionReportPaymentFilter.byHand,
                  TransactionReportPaymentFilter.credit,
                ],
                itemLabel: (p) => p == TransactionReportPaymentFilter.byHand
                    ? 'By hand'
                    : 'Credit',
                onChanged: (v) => ref
                    .read(transactionReportFiltersProvider.notifier)
                    .setPayment(v ?? TransactionReportPaymentFilter.all),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        _buildReportTypeSwitch(showDetailed),
        const SizedBox(width: 10),
        _buildViewModeButtons(filters),
      ],
    );
  }

  Widget _buildViewModeButtons(TransactionReportFilters filters) {
    Widget iconBtn(TransactionReportViewMode mode, IconData icon) {
      final selected = filters.viewMode == mode;
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => ref
            .read(transactionReportFiltersProvider.notifier)
            .setViewMode(mode),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: selected ? _kReportPrimary : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selected ? _kReportPrimary : const Color(0xFFE5E7EB),
            ),
          ),
          child: Icon(
            icon,
            size: 18,
            color: selected ? Colors.white : Colors.grey.shade600,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconBtn(TransactionReportViewMode.chart, Icons.bar_chart_outlined),
        const SizedBox(width: 8),
        iconBtn(TransactionReportViewMode.table, Icons.table_rows_outlined),
      ],
    );
  }

  Widget _buildDropdownFilter<T>({
    required String label,
    required T? value,
    required List<T> options,
    required ValueChanged<T?> onChanged,
    String Function(T)? itemLabel,
  }) {
    final text = itemLabel ?? (T v) => v.toString();
    return SizedBox(
      width: 150,
      child: DropdownButtonFormField<T>(
        isExpanded: true,
        value: value,
        items: [
          DropdownMenuItem<T>(
            value: null,
            child: Text(label, overflow: TextOverflow.ellipsis),
          ),
          for (final opt in options)
            DropdownMenuItem<T>(
              value: opt,
              child: Text(text(opt), overflow: TextOverflow.ellipsis),
            ),
        ],
        onChanged: onChanged,
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndActions(
    bool isDesktop,
    TransactionReportFilters filters, {
    bool embeddedInToolbar = false,
  }) {
    final field = TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search receipt number...',
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
        prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
        suffixIcon: filters.receiptQuery.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.close_rounded, size: 20),
                onPressed: () {
                  _searchController.clear();
                  ref
                      .read(transactionReportFiltersProvider.notifier)
                      .clearReceiptQuery();
                },
              )
            : null,
        border: embeddedInToolbar
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              )
            : InputBorder.none,
        enabledBorder: embeddedInToolbar
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
              )
            : InputBorder.none,
        focusedBorder: embeddedInToolbar
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: _kReportPrimary, width: 1.2),
              )
            : InputBorder.none,
        filled: embeddedInToolbar,
        fillColor: embeddedInToolbar ? const Color(0xFFF9FAFB) : null,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
        isDense: true,
      ),
      onChanged: (value) => ref
          .read(transactionReportFiltersProvider.notifier)
          .setReceiptQuery(value),
    );

    if (embeddedInToolbar) {
      return Row(
        children: [
          Expanded(child: field),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: field,
          ),
        ),
      ],
    );
  }

  /// Design-mock cashier chips: padded pill, soft fill when selected, no FilterChip overlap.
  Widget _reportCashierFilterChip({
    required bool selected,
    required String title,
    required String initials,
    required Color avatarBg,
    required VoidCallback onTap,
  }) {
    const radius = BorderRadius.all(Radius.circular(999));
    return Semantics(
      button: true,
      selected: selected,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.fromLTRB(4, 6, 14, 6),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFFEFF6FF) : Colors.white,
              borderRadius: radius,
              border: Border.all(
                color: selected ? _kReportPrimary : const Color(0xFFD1D5DB),
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: avatarBg,
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 13,
                    color: const Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCashierChipsRow(
    bool isDesktop,
    List<ITransaction>? transactions,
    TransactionReportFilters filters,
  ) {
    final allSelected = filters.cashierAgentId == null ||
        filters.cashierAgentId!.isEmpty;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'CASHIER',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Colors.grey.shade600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _reportCashierFilterChip(
                  selected: allSelected,
                  title: 'All',
                  initials: 'AL',
                  avatarBg: _kReportPrimary,
                  onTap: () => ref
                      .read(transactionReportFiltersProvider.notifier)
                      .setCashierAgentId(null),
                ),
                for (final c in kTransactionReportMockCashiers)
                  _reportCashierFilterChip(
                    selected: filters.cashierAgentId == c.filterId,
                    title: c.displayName,
                    initials: c.initials,
                    avatarBg: c.avatarColor,
                    onTap: () => ref
                        .read(transactionReportFiltersProvider.notifier)
                        .setCashierAgentId(c.filterId),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        TextButton(
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () =>
              ref.read(transactionReportFiltersProvider.notifier).setCashierAgentId(null),
          child: Text(
            'Clear',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
    bool isLoading = false,
  }) {
    return Tooltip(
      message: tooltip,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isLoading ? null : onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 44,
            height: 44,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Icon(icon, size: 22, color: Colors.grey.shade600),
          ),
        ),
      ),
    );
  }

  Widget _buildReportTypeSwitch(bool showDetailed) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSwitchOption('Summarized', !showDetailed, () {
            if (showDetailed) {
              ref.read(toggleBooleanValueProvider.notifier).toggleReport();
            }
          }),
          _buildSwitchOption('Detailed', showDetailed, () {
            if (!showDetailed) {
              ref.read(toggleBooleanValueProvider.notifier).toggleReport();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? _kReportPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    AsyncValue<List<dynamic>> dataProvider,
    List<ITransaction>? transactions,
    List<TransactionItem>? transactionItems,
    Map<String, TransactionPaymentSums>? paymentSumsByTransactionId,
    DateTime? startDate,
    DateTime? endDate,
    bool showDetailed,
    TransactionReportFilters filters,
  ) {
    return dataProvider.when(
      data: (data) {
        if (data.isEmpty) {
          return Column(
            children: [
              if (widget.hideHeader)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildReportTypeSwitch(showDetailed),
                ),
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No transactions found for the selected period.',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        }

        final validStartDate =
            startDate ?? DateTime.now().subtract(const Duration(days: 7));
        final validEndDate = endDate ?? DateTime.now();

        if (filters.viewMode == TransactionReportViewMode.chart) {
          return SalesByCashierChart(
            transactions: transactions ?? const <ITransaction>[],
            paymentSumsByTransactionId: paymentSumsByTransactionId,
          );
        }

        return DataView(
          key: dataViewKey,
          transactions: transactions,
          transactionItems: transactionItems,
          paymentSumsByTransactionId: paymentSumsByTransactionId,
          startDate: validStartDate,
          endDate: validEndDate,
          rowsPerPage: ref.read(rowsPerPageProvider),
          showDetailedReport: showDetailed,
          showDetailed: showDetailed,
          showActionsRow: false,
          showKpiStrip: false,
          contentPadding: EdgeInsets.zero,
          workBookKey: workBookKey,
          forceEmpty: data.isEmpty,
          disablePagination: true, // Disable internal pagination
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(error),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
            child: const CircularProgressIndicator(strokeWidth: 3),
          ),
          const SizedBox(height: 24),
          Text(
            'Preparing your reports...',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This might take a moment depending on your data',
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Invalidate providers to retry
                ref.invalidate(transactionItemListProvider);
                ref.invalidate(
                  transactionReportSnapshotProvider(
                    forceRealData: !(ProxyService.box.enableDebug() ?? false),
                  ),
                );
                ref.invalidate(
                  transactionListProvider(
                    forceRealData: !(ProxyService.box.enableDebug() ?? false),
                  ),
                );
              },
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
