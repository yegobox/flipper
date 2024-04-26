import 'package:flipper_dashboard/PaginatedDataView.dart';
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
      data: (value) => Container(
        width: 150,
        height: 800,
        child: PaginatedDataView(
          transactions: value,
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
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
