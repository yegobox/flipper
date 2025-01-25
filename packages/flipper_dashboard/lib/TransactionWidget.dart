import 'package:flipper_dashboard/tickets.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TransactionWidget extends ConsumerWidget {
  const TransactionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchId = ProxyService.box.getBranchId() ?? 0;

    return ref.watch(
      pendingTransactionProvider((
        mode: TransactionType.sale,
        isExpense: false,
        branchId: branchId,
      )).select((value) => value.when(
            data: (transaction) {
              return Expanded(
                child: TicketsList(
                  showAppBar: false,
                  transaction: transaction,
                ),
              ).shouldSeeTheApp(ref, AppFeature.Tickets);
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
