// ignore_for_file: unused_result

import 'package:flipper_dashboard/data_view_reports/DataView.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/providers/date_range_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/realm_model_export.dart';
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
    // Only watch the provider we need based on showPluReportWidget
    final dataProvider = showDetailed
        ? ref.watch(transactionItemListProvider)
        : ref.watch(transactionListProvider);

    // Force refresh of the appropriate provider when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showDetailedReport) {
        ref.refresh(transactionItemListProvider);
      } else {
        ref.refresh(transactionListProvider);
      }
    });

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

          // If it is Detailed, we get gross profit as we sum up the qty * price
          return DataView(
            transactions: !showDetailed ? data as List<ITransaction> : null,
            transactionItems:
                showDetailed ? data as List<TransactionItem> : null,
            startDate: startDate!,
            endDate: endDate!,
            rowsPerPage: ref.read(rowsPerPageProvider),
            showDetailedReport: ref.watch(toggleBooleanValueProvider),
          );
        },
        loading: () => Column(
          children: [
            datePicker(),
            Center(
                child: Text(
              'No reports available',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            )),
          ],
        ),
        error: (error, stackTrace) => Center(child: Text('Error: $stackTrace')),
      ),
    );
  }
}
