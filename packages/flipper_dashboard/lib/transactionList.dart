import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

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
  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange.startDate;
    final endDate = dateRange.endDate;
    final showDetailed = ref.watch(toggleBooleanValueProvider);

    // Select the appropriate provider based on showDetailed
    final AsyncValue<List<dynamic>> dataProvider = showDetailed
        ? ref.watch(transactionItemListProvider)
        : ref.watch(transactionListProvider);

    // Refresh the data whenever showDetailed changes
    ref.listen<bool>(toggleBooleanValueProvider, (previous, current) {
      if (current != previous) {
        if (widget.showDetailedReport) {
          // ignore: unused_result
          ref.refresh(transactionItemListProvider);
        } else {
          // ignore: unused_result
          ref.refresh(transactionListProvider);
        }
      }
    });

    // Conditionally cast the data based on the `showDetailed` flag
    List<ITransaction>? transactions = !showDetailed && dataProvider.hasValue
        ? dataProvider.value!.cast<ITransaction>()
        : null;

    List<TransactionItem>? transactionItems =
        showDetailed && dataProvider.hasValue
            ? dataProvider.value!.cast<TransactionItem>()
            : null;

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
                ref.read(toggleBooleanValueProvider.notifier).toggleReport();
              }
            },
          ),
          _buildSwitchOption(
            'Summary',
            !showDetailed,
            () {
              if (showDetailed) {
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
                    color: Colors.black.withOpacity(0.05),
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
          return _buildEmptyState();
        }

        return DataView(
          transactions: transactions,
          transactionItems: transactionItems,
          startDate: startDate!,
          endDate: endDate!,
          rowsPerPage: ref.read(rowsPerPageProvider),
          showDetailedReport: showDetailed,
        );
      },
      loading: () => _buildLoadingState(),
      error: (error, stackTrace) => _buildErrorState(error),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No reports available',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select a date range to view transaction reports',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
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
