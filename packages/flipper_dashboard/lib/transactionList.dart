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
  int _currentPage = 0;
  int _totalCount = 0;

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

  // Export all data, not just current page
  Future<void> _exportAllData() async {
    final showDetailed = ref.read(toggleBooleanValueProvider);
    final dateRange = ref.read(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    if (startDate == null || endDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a date range first'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    try {
      // Show loading indicator
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                SizedBox(width: 16),
                Text('Fetching all data for export...'),
              ],
            ),
            duration: Duration(seconds: 30),
          ),
        );
      }

      // Fetch ALL data without pagination for export
      List<dynamic> allData;

      if (showDetailed) {
        // The provider is a StreamProvider<List<TransactionItem>>.
        // Riverpod already unwraps the stream; the `data` callback receives
        // the latest List<TransactionItem> directly — NOT a Stream.
        final asyncValue = ref.read(transactionItemListProvider);
        allData = asyncValue.when<List<dynamic>>(
          data: (items) => items.toList(),
          loading: () => throw Exception('Data is still loading, please try again'),
          error: (error, stack) => throw error,
        );
      } else {
        // Same for StreamProvider<List<ITransaction>>.
        final asyncValue = ref.read(
          transactionListProvider(
            forceRealData: !(ProxyService.box.enableDebug() ?? false),
          ),
        );
        allData = asyncValue.when<List<dynamic>>(
          data: (transactions) => transactions.toList(),
          loading: () => throw Exception('Data is still loading, please try again'),
          error: (error, stack) => throw error,
        );
      }

      // Dismiss loading snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
      }

      if (allData.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No data to export'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Create a temporary DataView with all data for export
      final tempDataViewKey = GlobalKey<DataViewState>();

      // Build the DataView widget (not displayed, just for export)
      final tempDataView = DataView(
        key: tempDataViewKey,
        transactions: showDetailed ? null : allData.cast<ITransaction>(),
        transactionItems: showDetailed ? allData.cast<TransactionItem>() : null,
        startDate: startDate,
        endDate: endDate,
        rowsPerPage: allData.length,
        showDetailedReport: showDetailed,
        showDetailed: showDetailed,
        workBookKey: workBookKey,
        forceEmpty: allData.isEmpty,
        disablePagination: true,
      );

      // Mount the widget temporarily in an overlay to trigger export
      final overlay = Overlay.of(context);
      late OverlayEntry overlayEntry;

      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          left: -10000, // Off-screen
          top: -10000,
          child: Material(
            child: SizedBox(width: 1, height: 1, child: tempDataView),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      // Wait for widget to build
      await Future.delayed(const Duration(milliseconds: 500));

      // Trigger export
      await tempDataViewKey.currentState?.triggerExport(headerTitle: "Report");

      // Remove overlay
      overlayEntry.remove();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Exported ${allData.length} records successfully'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  /// Debug method to verify current database strategy
  void _debugCurrentStrategy() {
    try {
      // This will help us verify that Capella is being used
      final strategy = ProxyService.strategy;
      print('🔍 Current database strategy: ${strategy.runtimeType}');
      
      // If we see 'Isar' or 'SQLite' in the type name, we know it's using local DB
      final strategyName = strategy.runtimeType.toString().toLowerCase();
      if (strategyName.contains('isar') || strategyName.contains('sqlite')) {
        print('⚠️ WARNING: Using local database - may cause locks!');
        print('💡 Consider forcing Capella strategy in main.dart');
      } else {
        print('✅ Using cloud database - no locks expected');
      }
    } catch (e) {
      print('⚠️ Could not determine database strategy: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    // Watch the toggle value and immediately refresh the appropriate provider when it changes
    final showDetailed = ref.watch(toggleBooleanValueProvider);
    final rowsPerPage = ref.watch(rowsPerPageProvider);

    // Debug: Log current strategy to verify Capella is being used
    _debugCurrentStrategy();

    // Calculate pagination parameters
    // TEMPORARILY DISABLED: Pagination not implemented in backend
    // final limit = rowsPerPage;
    // final offset = _currentPage * rowsPerPage;

    // Get total count for pagination
    // TEMPORARILY DISABLED: transactionItemCountProvider and transactionCountProvider are not implemented
    // final countAsync = showDetailed
    //     ? ref.watch(transactionItemCountProvider)
    //     : ref.watch(transactionCountProvider);

    // Update total count when available
    // countAsync.whenData((count) {
    //   if (_totalCount != count) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (mounted) {
    //         setState(() => _totalCount = count);
    //       }
    //     });
    //   }
    // });

    // Use a key to force rebuild when the toggle changes
    final AsyncValue<List<dynamic>> dataProvider;

    // Select and refresh the appropriate provider based on showDetailed
    if (showDetailed) {
      // For detailed view, use transactionItemListProvider
      dataProvider = ref.watch(
        transactionItemListProvider,
      );
    } else {
      // For summary view, use transactionListProvider with pagination
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
                    child: Column(
                      children: [
                        Expanded(
                          child: _buildContent(
                            dataProvider,
                            transactions,
                            transactionItems,
                            startDate,
                            endDate,
                            showDetailed,
                          ),
                        ),
                        if (dataProvider.hasValue &&
                            dataProvider.value!.isNotEmpty)
                          _buildPaginationControls(rowsPerPage),
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
              // Fetch ALL data for export, not just current page
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

  Widget _buildPaginationControls(int rowsPerPage) {
    final totalPages = (_totalCount / rowsPerPage).ceil();
    final currentPageDisplay = _currentPage + 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page $currentPageDisplay of $totalPages',
            style: TextStyle(color: Colors.grey[700], fontSize: 14),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.first_page),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage = 0)
                    : null,
                tooltip: 'First page',
              ),
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _currentPage > 0
                    ? () => setState(() => _currentPage--)
                    : null,
                tooltip: 'Previous page',
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage++)
                    : null,
                tooltip: 'Next page',
              ),
              IconButton(
                icon: const Icon(Icons.last_page),
                onPressed: _currentPage < totalPages - 1
                    ? () => setState(() => _currentPage = totalPages - 1)
                    : null,
                tooltip: 'Last page',
              ),
            ],
          ),
        ],
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
                ref.invalidate(transactionListProvider(forceRealData: !(ProxyService.box.enableDebug() ?? false)));
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
