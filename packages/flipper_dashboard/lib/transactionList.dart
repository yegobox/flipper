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
  }) : super(key: key);

  final bool showDetailedReport;
  final bool hideHeader;

  @override
  TransactionListState createState() => TransactionListState();
}

class TransactionListState extends ConsumerState<TransactionList>
    with WidgetsBindingObserver, DateCoreWidget {
  // Use a late initialized key to ensure it's created fresh when needed
  late GlobalKey<SfDataGridState> workBookKey;

  @override
  void initState() {
    super.initState();
    // Initialize the key
    workBookKey = GlobalKey<SfDataGridState>();
  }

  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;

    // Watch the toggle value and immediately refresh the appropriate provider when it changes
    final showDetailed = ref.watch(toggleBooleanValueProvider);

    ref.listen<bool>(toggleBooleanValueProvider, (previous, next) {
      if (previous != next) {
        if (next) {
          ref.invalidate(transactionItemListProvider);
        } else {
          ref.invalidate(transactionListProvider(
              forceRealData: !(ProxyService.box.enableDebug() ?? false)));
        }
      }
    });

    // Use a key to force rebuild when the toggle changes
    final AsyncValue<List<dynamic>> dataProvider;

    // Select and refresh the appropriate provider based on showDetailed
    if (showDetailed) {
      // For detailed view, use transactionItemListProvider
      dataProvider = ref.watch(transactionItemListProvider);
    } else {
      // For summary view, use transactionListProvider
      dataProvider = ref.watch(transactionListProvider(
          forceRealData: !(ProxyService.box.enableDebug() ?? false)));
    }

    // Conditionally cast the data based on the `showDetailed` flag
    List<ITransaction>? transactions;
    List<TransactionItem>? transactionItems;

    if (dataProvider.hasValue && dataProvider.value!.isNotEmpty) {
      try {
        if (!showDetailed) {
          transactions = dataProvider.value!.cast<ITransaction>();
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
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // New card for date range and Change Date button
              if (!widget.hideHeader)
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.blue[700], size: 22),
                        const SizedBox(width: 10),
                        Text(
                          startDate != null && endDate != null
                              ? '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}'
                              : 'Select date range',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        OutlinedButton.icon(
                          icon: Icon(Icons.edit_calendar, size: 18),
                          label: Text('Change Date'),
                          onPressed: () {
                            // TODO: Show date range picker
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              if (!widget.hideHeader)
                Align(
                  alignment: Alignment.centerLeft,
                  child: _buildReportTypeSwitch(showDetailed),
                ),
              const SizedBox(height: 8),
              if (!widget.hideHeader)
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search transactions...',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 12),
                        ),
                        style: TextStyle(fontSize: 16),
                        onChanged: (value) {
                          // TODO: Implement search/filter logic
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Tooltip(
                      message: 'Export as CSV',
                      child: IconButton(
                        icon: Icon(Icons.download_rounded),
                        onPressed: () {
                          // TODO: Implement export
                        },
                      ),
                    ),
                    Tooltip(
                      message: 'Print',
                      child: IconButton(
                        icon: Icon(Icons.print),
                        onPressed: () {
                          // TODO: Implement print
                        },
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 8),
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
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportTypeSwitch(bool showDetailed) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildSwitchOption(
            'Detailed',
            showDetailed,
            () {
              if (!showDetailed) {
                // Toggle the report and immediately invalidate both providers
                ref.read(toggleBooleanValueProvider.notifier).toggleReport();
              }
            },
          ),
          _buildSwitchOption(
            'Summary',
            !showDetailed,
            () {
              if (showDetailed) {
                // Toggle the report and immediately invalidate both providers
                ref.read(toggleBooleanValueProvider.notifier).toggleReport();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchOption(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.blue : Colors.grey[700],
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
          return Center(
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
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
        }

        final validStartDate =
            startDate ?? DateTime.now().subtract(const Duration(days: 7));
        final validEndDate = endDate ?? DateTime.now();

        return DataView(
          key: ValueKey(showDetailed),
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
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading reports...',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(Object error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 60,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
