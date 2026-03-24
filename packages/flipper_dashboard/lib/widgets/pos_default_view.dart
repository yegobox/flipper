import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart' as oldImplementationOfRiverpod;
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class PosDefaultView extends ConsumerWidget {
  final ITransaction transaction;
  final Widget quickSellingView;
  final Future<bool> Function(
    bool immediateCompletion, [
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  ]) onCompleteTransaction;
  final VoidCallback onTicketNavigation;

  const PosDefaultView({
    Key? key,
    required this.transaction,
    required this.quickSellingView,
    required this.onCompleteTransaction,
    required this.onTicketNavigation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branchAsync = ref.watch(activeBranchProvider);
    
    return branchAsync.when(
      data: (branch) {
        return FutureBuilder<bool>(
          future: ProxyService.strategy.isBranchEnableForPayment(
            currentBranchId: branch.id,
          ) as Future<bool>,
          builder: (context, snapshot) {
            final digitalPaymentEnabled = snapshot.data ?? false;
            
            return ViewModelBuilder<CoreViewModel>.reactive(
              viewModelBuilder: () => CoreViewModel(),
              builder: (context, model, child) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: quickSellingView,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PayableView(
                        transactionId: transaction.id,
                        mode: oldImplementationOfRiverpod.SellingMode.forSelling,
                        completeTransaction: onCompleteTransaction,
                        model: model,
                        ticketHandler: onTicketNavigation,
                        digitalPaymentEnabled: digitalPaymentEnabled,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
