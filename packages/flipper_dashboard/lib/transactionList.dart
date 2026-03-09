import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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

class TransactionListState extends ConsumerState<TransactionList>
    with WidgetsBindingObserver, DateCoreWidget {
  // Use a late initialized key to ensure it's created fresh when needed
  late GlobalKey<SfDataGridState> workBookKey;
  late GlobalKey<DataViewState> dataViewKey;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
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

  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    // Watch the toggle value and immediately refresh the appropriate provider when it changes
    final showDetailed = ref.watch(toggleBooleanValueProvider);

    // Use a key to force rebuild when the toggle changes
    final AsyncValue<List<dynamic>> dataProvider;

    // Select and refresh the appropriate provider based on showDetailed
    if (showDetailed) {
      // For detailed view, use transactionItemListProvider
      dataProvider = ref.watch(transactionItemListProvider);
    } else {
      // For summary view, use transactionListProvider
      dataProvider = ref.watch(
        transactionListProvider(
          forceRealData: !(ProxyService.box.enableDebug() ?? false),
        ),
      );
    }

    // Conditionally cast the data based on the `showDetailed` flag
    List<ITransaction>? transactions;
    List<TransactionItem>? transactionItems;

    if (dataProvider.hasValue && dataProvider.value!.isNotEmpty) {
      try {
        if (!showDetailed) {
          var allTransactions = dataProvider.value!.cast<ITransaction>();
          // Filter transactions by search query
          if (_searchQuery.isNotEmpty) {
            transactions = allTransactions.where((transaction) {
              final receiptNumber = transaction.receiptNumber?.toString() ?? '';

              return receiptNumber.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              );
            }).toList();
          } else {
            transactions = allTransactions;
          }
        } else {
          transactionItems = dataProvider.value!.cast<TransactionItem>();
        }
      } catch (e) {
        // Handle casting error gracefully
        print("Error casting data: $e");
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;
        final horizontalPadding = isDesktop ? 24.0 : 12.0;

        return Container(
          decoration: BoxDecoration(color: Colors.grey[50]),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 16.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!widget.hideHeader) ...[
                  _buildHeader(context, startDate, endDate, isDesktop),
                  const SizedBox(height: 20),
                  _buildControlsRow(showDetailed, isDesktop),
                  const SizedBox(height: 16),
                ],
                if (widget.showSearch && widget.hideHeader) ...[
                  _buildSearchAndActions(isDesktop),
                  const SizedBox(height: 16),
                ],
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: _buildContent(
                      dataProvider,
                      transactions,
                      transactionItems,
                      startDate,
                      endDate,
                      showDetailed,
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

  Widget _buildHeader(
    BuildContext context,
    DateTime? startDate,
    DateTime? endDate,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[700]!, Colors.blue[900]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transaction Reports',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  startDate != null && endDate != null
                      ? '${startDate.day}/${startDate.month}/${startDate.year} — ${endDate.day}/${endDate.month}/${endDate.year}'
                      : 'Select a period to view reports',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (isDesktop) ...[
            const SizedBox(width: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.date_range_rounded, size: 20),
              label: const Text('Change Period'),
              onPressed: handleDateTimePicker,
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ).copyWith(
                    overlayColor: WidgetStateProperty.all(
                      Colors.blue.withValues(alpha: 0.05),
                    ),
                  ),
            ),
          ] else
            IconButton(
              icon: const Icon(Icons.date_range_rounded, color: Colors.white),
              onPressed: handleDateTimePicker,
            ),
        ],
      ),
    );
  }

  Widget _buildControlsRow(bool showDetailed, bool isDesktop) {
    return Row(
      children: [
        _buildReportTypeSwitch(showDetailed),
        const SizedBox(width: 20),
        if (isDesktop)
          Expanded(child: _buildSearchAndActions(isDesktop))
        else
          const Spacer(),
      ],
    );
  }

  Widget _buildSearchAndActions(bool isDesktop) {
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
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search receipt number...',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                prefixIcon: Icon(Icons.search_rounded, color: Colors.grey[400]),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close_rounded, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _buildActionButton(
          icon: Icons.file_download_outlined,
          tooltip: 'Export CSV',
          onTap: () async {
            setState(() => _isExporting = true);
            try {
              await dataViewKey.currentState?.triggerExport(
                headerTitle: "Report",
              );
            } finally {
              if (mounted) setState(() => _isExporting = false);
            }
          },
          isLoading: _isExporting,
        ),
        const SizedBox(width: 8),
        _buildActionButton(
          icon: Icons.print_outlined,
          tooltip: 'Print Report',
          onTap: () {
            // TODO: Implement
          },
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
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: CircularProgressIndicator(strokeWidth: 2.5),
                  )
                : Icon(icon, size: 22, color: Colors.blueGrey[700]),
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
          _buildSwitchOption('Detailed', showDetailed, () {
            if (!showDetailed) {
              ref.read(toggleBooleanValueProvider.notifier).toggleReport();
            }
          }),
          _buildSwitchOption('Summary', !showDetailed, () {
            if (showDetailed) {
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
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? Colors.blue[800] : Colors.grey[600],
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
    DateTime? startDate,
    DateTime? endDate,
    bool showDetailed,
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

        return DataView(
          key: dataViewKey,
          transactions: transactions,
          transactionItems: transactionItems,
          startDate: validStartDate,
          endDate: validEndDate,
          rowsPerPage: ref.read(rowsPerPageProvider),
          showDetailedReport: showDetailed,
          showDetailed: showDetailed,
          workBookKey: workBookKey,
          forceEmpty: data.isEmpty,
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
                ref.invalidate(transactionListProvider);
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
