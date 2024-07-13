import 'package:flipper_dashboard/DataView.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerWidget {
  TransactionList({Key? key, this.showPluReportWidget = true})
      : super(key: key);
  final bool showPluReportWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionListProvider);
    final transactionItems = ref.watch(transactionItemListProvider);
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange['startDate'];
    final endDate = dateRange['endDate'];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 400,
          child: () {
            final transactionsData = transactions.asData?.value;
            final transactionItemsData = transactionItems.asData?.value;

            bool isDataEmpty = (transactionsData == null ||
                    transactionsData.isEmpty) &&
                (transactionItemsData == null || transactionItemsData.isEmpty);

            if (isDataEmpty) {
              return SizedBox.shrink();
            }

            return DataView(
              transactions: !showPluReportWidget ? transactionsData : null,
              transactionItems:
                  showPluReportWidget ? transactionItemsData : null,
              startDate: startDate ?? DateTime.now(),
              endDate: endDate ?? DateTime.now(),
              // workBookKey: _workBookKey,
              rowsPerPage: ref.read(rowsPerPageProvider),
              showPluReport: showPluReportWidget,
            );
          }(),
        ),
      ],
    );
  }
}
