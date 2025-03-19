import 'package:flipper_dashboard/tickets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/realm_model_export.dart';

import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionWidget extends ConsumerWidget {
  const TransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(
      pendingTransactionStreamProvider(isExpense: false)
          .select((value) => value.when(
                data: (transaction) {
                  return Expanded(
                    child: TicketsList(
                      showAppBar: false,
                      transaction: transaction,
                    ),
                  ).shouldSeeTheApp(ref, featureName: AppFeature.Tickets);
                },
                error: (error, stackTrace) {
                  return Center(child: Text('Error: $error'));
                },
                loading: () {
                  return const Center(child: CircularProgressIndicator());
                },
              )),
    );
  }
}
