import 'package:flipper_dashboard/DataView.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionList extends ConsumerWidget {
  const TransactionList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(transactionListProvider);

    return data.when(
      data: (transactionData) => Container(
        width: 150,
        height: 800,
        child: DataView(
          transactions: transactionData,
        ),
      ),
      loading: () => Padding(
        padding: const EdgeInsets.only(top: 28.0),
        child:
            const Center(child: Text("Please select a date to query report")),
      ),
      error: (error, stackTrace) => Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(child: Text('Errors: $error'))
        ],
      ),
    );
  }
}
