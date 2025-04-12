import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionList extends StatefulHookConsumerWidget {
  TransactionList({Key? key, this.showDetailedReport = true}) : super(key: key);
  final bool showDetailedReport;

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

    // Select the appropriate provider based on showDetailed.
    final AsyncValue<List<dynamic>> dataProvider = showDetailed
        ? ref.watch(transactionItemListProvider)
        : ref.watch(transactionListProvider);

    // Refresh the data whenever showDetailed changes.
    ref.listen<bool>(toggleBooleanValueProvider, (previous, current) {
      if (current != previous) {
        if (widget.showDetailedReport) {
          ref.refresh(transactionItemListProvider);
        } else {
          ref.refresh(transactionListProvider);
        }
      }
    });
    // Conditionally cast the data based on the `showDetailed` flag.
    List<ITransaction>? transactions = !showDetailed && dataProvider.hasValue
        ? dataProvider.value!.cast<ITransaction>()
        : null; // Cast only when data is available.

    List<TransactionItem>? transactionItems =
        showDetailed && dataProvider.hasValue
            ? dataProvider.value!.cast<TransactionItem>()
            : null; // Cast only when data is available.

    return Container(
      child: dataProvider.when(
        data: (data) {
          if (data.isEmpty) {
            return Center(
              child: Column(
                children: [
                  datePicker(),
                  Text(
                    'No reports available, select Date for report',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }
          // Pass the conditionally cast data to the DataView.
          return DataView(
            transactions: transactions,
            transactionItems: transactionItems,
            startDate: startDate!,
            endDate: endDate!,
            rowsPerPage: ref.read(rowsPerPageProvider),
            showDetailedReport: showDetailed,
          );
        },
        loading: () => Column(
          children: [
            datePicker(),
            Center(
                child: Text(
              'Loading reports...', // More informative message
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            )),
          ],
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
