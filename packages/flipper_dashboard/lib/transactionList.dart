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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your export to Excel logic here
              },
              child: Text('Export to Excel'),
            ),
            SizedBox(width: 10), // Add some space between the buttons
            ElevatedButton(
              onPressed: () {
                // Add your print logic here
              },
              child: Text('Print'),
            ),
          ],
        ),
        Container(
          height: 300, // Adjust this value as needed
          child: DataTable(
            columns: const <DataColumn>[
              DataColumn(
                label: Text('Reference',
                    style: TextStyle(fontStyle: FontStyle.normal)),
              ),
              DataColumn(
                label:
                    Text('Type', style: TextStyle(fontStyle: FontStyle.normal)),
              ),
              DataColumn(
                label: Text('Total',
                    style: TextStyle(fontStyle: FontStyle.normal)),
              ),
            ],
            rows: _buildDataRows(ITransactionList),
          ),
        ),
      ],
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
