import 'package:flipper_dashboard/DataView.dart';
import 'package:flipper_dashboard/DateCoreWidget.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionList extends StatefulHookConsumerWidget {
  TransactionList({Key? key, this.showPluReportWidget = true})
      : super(key: key);
  final bool showPluReportWidget;

  @override
  TransactionListState createState() => TransactionListState();
}

class TransactionListState extends ConsumerState<TransactionList>
    with WidgetsBindingObserver, DateCoreWidget {
  @override
  Widget build(BuildContext context) {
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange['startDate'];
    final endDate = dateRange['endDate'];

    // Only watch the provider we need based on showPluReportWidget
    final dataProvider = widget.showPluReportWidget
        ? ref.watch(transactionItemListProvider)
        : ref.watch(transactionListProvider);

    // Force refresh of the appropriate provider when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showPluReportWidget) {
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
              child: Text(
                'No reports available',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
            );
          }

          // If it is PLU report, we get gross profit as we sum up the qty * price
          return DataView(
            transactions:
                !widget.showPluReportWidget ? data as List<ITransaction> : null,
            transactionItems: widget.showPluReportWidget
                ? data as List<TransactionItem>
                : null,
            startDate: startDate!,
            endDate: endDate!,
            rowsPerPage: ref.read(rowsPerPageProvider),
            showPluReport: widget.showPluReportWidget,
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
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
