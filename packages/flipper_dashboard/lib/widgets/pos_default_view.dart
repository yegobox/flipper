import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart' as oldImplementationOfRiverpod;
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class PosDefaultView extends ConsumerWidget {
  /// When null (pending transaction stream still loading), the cart column
  /// still shows [quickSellingView] but the pay/ticket footer is a loading
  /// placeholder — no [PayableView] with an empty transaction id.
  final ITransaction? transaction;
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
                final txn = transaction;
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
                        child: quickSellingView,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: txn == null
                          ? _transactionFooterLoadingPlaceholder(context)
                          : PayableView(
                              transactionId: txn.id,
                              mode: oldImplementationOfRiverpod
                                  .SellingMode.forSelling,
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

  /// Matches [PayableView] outer padding and approximate footer height so the
  /// layout does not jump when the pending transaction becomes available.
  static Widget _transactionFooterLoadingPlaceholder(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(19.0, 0, 19.0, 30.5),
      child: SizedBox(
        height: 138,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Preparing checkout...',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
