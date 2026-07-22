import 'dart:async';

import 'package:flipper_dashboard/payable_view.dart';
import 'package:flipper_dashboard/providers/checkout_cart_mode_provider.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart' as tv_talk;
import 'package:flipper_models/providers/active_branch_provider.dart';
import 'package:flipper_models/providers/cached_pending_cart_transaction_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/park_transaction_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldImplementationOfRiverpod;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked/stacked.dart';

class PosDefaultView extends ConsumerStatefulWidget {
  /// When null (pending transaction stream still loading), the cart column
  /// still shows [quickSellingView] but the pay/ticket footer is a loading
  /// placeholder — no [PayableView] with an empty transaction id.
  final ITransaction? transaction;
  final Widget quickSellingView;
  final Future<bool> Function(
    bool immediateCompletion, [
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  ])
  onCompleteTransaction;
  final VoidCallback onTicketNavigation;

  const PosDefaultView({
    Key? key,
    required this.transaction,
    required this.quickSellingView,
    required this.onCompleteTransaction,
    required this.onTicketNavigation,
  }) : super(key: key);

  @override
  ConsumerState<PosDefaultView> createState() => _PosDefaultViewState();
}

class _PosDefaultViewState extends ConsumerState<PosDefaultView> {
  bool _sendToTillBusy = false;

  String _ticketDisplayRef(ITransaction ticket) {
    final r = ticket.reference?.trim();
    if (r != null && r.isNotEmpty) return r.toUpperCase();
    final id = ticket.id;
    if (id.length >= 6) return id.substring(0, 6).toUpperCase();
    return id.toUpperCase();
  }

  Future<void> _sendCartToTill(ITransaction transaction) async {
    if (_sendToTillBusy) return;
    final items = ref.read(posCartDisplayItemsProvider);
    if (items.isEmpty) return;

    final hasCustomerId = (transaction.customerId ?? '').trim().isNotEmpty;
    final hasCustomerName = (transaction.customerName ?? '').trim().isNotEmpty;
    final hasCustomerPhone =
        (transaction.customerPhone ?? '').trim().isNotEmpty;
    if (!hasCustomerId && !hasCustomerName && !hasCustomerPhone) {
      showErrorNotification(
        context,
        'Save a customer name or phone number on this ticket before sending it to the till.',
      );
      return;
    }

    setState(() => _sendToTillBusy = true);
    final displayRef = _ticketDisplayRef(transaction);
    try {
      await ref.read(parkTransactionProvider.notifier).park(
            ticketName: 'Till · $displayRef',
            ticketNote: 'Sent to till for payment',
            transaction: transaction,
            customerId: transaction.customerId,
          );

      ref.read(suppressedCartTransactionIdProvider.notifier).state =
          transaction.id;
      ref
          .read(optimisticCartProvider.notifier)
          .clearForTransaction(transaction.id);
      clearCachedPendingCartTransactionWidget(
        ref,
        isExpense: false,
      );
      ref.invalidate(
        transactionItemsStreamProvider(
          transactionId: transaction.id,
          branchId: ProxyService.box.getBranchId() ?? '0',
        ),
      );
      ref.invalidate(pendingTransactionStreamProvider(isExpense: false));

      if (mounted) {
        showSuccessNotification(
          context,
          'Sent to till — Ticket #$displayRef',
        );
      }
    } catch (e, st) {
      tv_talk.talker.error('Desktop send to till failed: $e', st);
      if (mounted) {
        showErrorNotification(
          context,
          'Failed to send to till: $e',
        );
      }
    } finally {
      if (mounted) setState(() => _sendToTillBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final branchAsync = ref.watch(activeBranchProvider);
    final isTransfer =
        ref.watch(checkoutCartModeProvider) == CheckoutCartMode.transfer;
    final isOrdering = ProxyService.box.isOrdering() ?? false;
    final canCollectPayment = ref.watch(canCollectPosPaymentProvider);
    final cartHasItems = ref.watch(
      posCartDisplayItemsProvider.select((l) => l.isNotEmpty),
    );

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
                final txn = widget.transaction;
                // Transfer CTAs live inside QuickSellingView — hide Pay/Tickets.
                final showPayBar = !isTransfer && !isOrdering;
                return Column(
                  children: [
                    // Clip so a tall cart/payment form cannot paint over Pay.
                    Expanded(
                      child: ClipRect(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 8.0),
                          child: widget.quickSellingView,
                        ),
                      ),
                    ),
                    if (showPayBar)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: txn == null
                            ? _transactionFooterLoadingPlaceholder(context)
                            : PayableView(
                                transactionId: txn.id,
                                mode: oldImplementationOfRiverpod
                                    .SellingMode.forSelling,
                                completeTransaction:
                                    widget.onCompleteTransaction,
                                model: model,
                                ticketHandler: widget.onTicketNavigation,
                                digitalPaymentEnabled: digitalPaymentEnabled,
                                canCollectPayment: canCollectPayment,
                                cartHasItems: cartHasItems,
                                sendToTillBusy: _sendToTillBusy,
                                sendToTill: () {
                                  unawaited(_sendCartToTill(txn));
                                },
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
