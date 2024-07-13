import 'package:flipper_dashboard/DataView.dart';
import 'package:flipper_models/realm/schemas.dart';
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
    final dateRange = ref.watch(dateRangeProvider);
    final startDate = dateRange['startDate'];
    final endDate = dateRange['endDate'];

    // Only watch the provider we need based on showPluReportWidget
    final dataProvider = showPluReportWidget
        ? ref.watch(transactionItemListProvider)
        : ref.watch(transactionListProvider);

    // Force refresh of the appropriate provider when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showPluReportWidget) {
        ref.refresh(transactionItemListProvider);
      } else {
        ref.refresh(transactionListProvider);
      }
    });

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 400,
          child: dataProvider.when(
            data: (data) {
              if (data.isEmpty) {
                return Text('No reports available',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ));
              }

              return DataView(
                transactions:
                    !showPluReportWidget ? data as List<ITransaction> : null,
                transactionItems:
                    showPluReportWidget ? data as List<TransactionItem> : null,
                startDate: startDate ?? DateTime.now(),
                endDate: endDate ?? DateTime.now(),
                rowsPerPage: ref.read(rowsPerPageProvider),
                showPluReport: showPluReportWidget,
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Text('Error: $error'),
          ),
        ),
      ],
    );
  }
}
