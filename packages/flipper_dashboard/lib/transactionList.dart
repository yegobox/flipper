import 'package:flipper_dashboard/view_data.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ITransactionList = ref.watch(transactionListProvider);

    if (!ITransactionList.hasValue) {
      return Center(child: Text('No data for selected date range'));
    }

    // return Center(child: Text('here'));

    return Container(
      width: 150,
      height: 800,
      child: ViewData(
        employees: ITransactionList.asData?.value ?? [],
      ),
    );
  }

  List<DataRow> _buildDataRows(
      AsyncValue<List<ITransaction>> ITransactionList) {
    return ITransactionList.when(
      data: (data) {
        return data.map<DataRow>((transaction) {
          return DataRow(
            cells: <DataCell>[
              DataCell(Text(transaction.reference)),
              DataCell(Text(transaction.receiptType ?? "-")),
              DataCell(Text(transaction.subTotal.toString())),
            ],
          );
        }).toList();
      },
      error: (error, stackTrace) => [
        DataRow(cells: [DataCell(Text("Error"))])
      ],
      loading: () => [
        DataRow(cells: [DataCell(Text("Loading"))])
      ],
    );
  }
}
