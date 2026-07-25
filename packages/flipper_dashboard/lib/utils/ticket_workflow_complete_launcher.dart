import 'dart:async';

import 'package:flipper_dashboard/TextEditingControllersMixin.dart';
import 'package:flipper_dashboard/providers/customer_provider.dart';
import 'package:flipper_dashboard/controllers/checkout_controller.dart';
import 'package:flipper_dashboard/mixins/previewCart.dart';
import 'package:flipper_dashboard/mixins/transaction_computation_mixin.dart';
import 'package:flipper_dashboard/refresh.dart';
import 'package:flipper_dashboard/utils/customer_pay_gate.dart';
import 'package:flipper_dashboard/utils/resume_transaction_helper.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/pos_cart_display_provider.dart';
import 'package:flipper_models/providers/pos_payment_role_provider.dart';
import 'package:flipper_models/providers/tickets_provider.dart';
import 'package:flipper_models/providers/transaction_items_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_models/services/resume_transaction_service.dart';
import 'package:flipper_models/view_models/mixins/_transaction.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_ui/snack_bar_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Runs the same sale-completion path as [QuickSellingView] Pay
/// ([startCompleteTransactionFlow] via [CheckoutController]) for a ticket
/// opened from the Tickets list when Ticket Review + Handover workflow is on.
Future<void> runTicketWorkflowCompleteFromList(
  BuildContext context,
  WidgetRef ref,
  ITransaction ticket,
) async {
  await Navigator.of(context, rootNavigator: true).push<void>(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => _TicketWorkflowCompleteHost(ticket: ticket),
    ),
  );
}

class _TicketWorkflowCompleteHost extends ConsumerStatefulWidget {
  const _TicketWorkflowCompleteHost({required this.ticket});

  final ITransaction ticket;

  @override
  ConsumerState<_TicketWorkflowCompleteHost> createState() =>
      _TicketWorkflowCompleteHostState();
}

class _TicketWorkflowCompleteHostState
    extends ConsumerState<_TicketWorkflowCompleteHost>
    with
        TextEditingControllersMixin,
        TransactionMixinOld,
        PreviewCartMixin,
        TransactionComputationMixin,
        Refresh {
  var _started = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _started) return;
      _started = true;
      unawaited(_run());
    });
  }

  Future<void> _run() async {
    final ticket = widget.ticket;
    try {
      final branchId = ProxyService.box.getBranchId() ?? ticket.branchId ?? '';
      final agentId = ProxyService.box.getUserId();
      if (branchId.isEmpty || agentId == null || agentId.isEmpty) {
        throw Exception('Missing branch or agent for completion');
      }

      await ResumeTransactionService.resume(
        ticket: ticket,
        branchId: branchId,
        agentId: agentId,
      );

      await TransactionInitializationHelper.initializeCustomer(
        ref,
        ticket,
        replaceSession: true,
      );
      primePosCartForTransactionWidget(
        ref,
        isExpense: false,
        transaction: ticket,
      );

      final seedItems = await ProxyService.getStrategy(Strategy.capella)
          .transactionItems(
        transactionId: ticket.id,
        branchId: branchId,
        active: true,
      );

      ref.read(settlingTillTicketProvider.notifier).state = SettlingTillTicket(
        transactionId: ticket.id,
        displayRef: _ticketDisplayRef(ticket),
        creatorName: 'Staff',
        createdAt: ticket.createdAt ?? DateTime.now(),
        branchId: branchId,
        ticketName: ticket.ticketName,
        ticketNote: ticket.note,
        seedItems: seedItems,
      );

      await TransactionInitializationHelper.initializeSession(
        ref: ref,
        transaction: ticket,
      );

      final alreadyPaid = await fetchNonCreditPaid(ticket.id);
      final total = ticket.subTotal ?? 0.0;
      updatePaymentRemainder(
        ref: ref,
        transaction: ticket,
        total: total,
        overrideAlreadyPaid: alreadyPaid,
        receivedAmountController: receivedAmountController,
        lastAutoSetAmount: 0,
      );

      Customer? attachedCustomerHint;
      final customerId = ticket.customerId;
      if (customerId != null && customerId.isNotEmpty) {
        attachedCustomerHint =
            ref.read(attachedCustomerProvider(customerId)).asData?.value;
      }

      final customerError = missingCustomerDetailsForPay(
        transaction: ticket,
        attachedCustomer: attachedCustomerHint,
        typedName: ref.read(customerNameControllerProvider).text,
        typedPhone: customerPhoneNumberController.text,
        pleaseEnterCustomerName: 'Please enter a customer name before completing.',
        phoneRequiredWhenTinMissing:
            'A customer phone number is required when no TIN is on file.',
      );
      if (customerError != null) {
        throw Exception(customerError);
      }

      final transactionItemsHint =
          ref.read(optimisticCartProvider.notifier).hasPendingFor(ticket.id)
              ? null
              : seedItems;

      final controller = CheckoutController(ref: ref, context: context);
      await controller.handleCompleteTransaction(
        transaction: ticket,
        immediateCompletion: false,
        startCompleteTransactionFlow: startCompleteTransactionFlow,
        applyDiscount: applyDiscount,
        refreshTransactionItems: refreshTransactionItems,
        discountController: discountController,
        transactionItemsHint: transactionItemsHint,
        overrideAlreadyPaid: alreadyPaid,
        afterCheckoutSaleCleanup: _afterCheckoutSaleCleanup,
      );

      if (!mounted) return;
      ref.invalidate(ticketsStreamProvider);
      showCustomSnackBarUtil(
        context,
        'Ticket completed',
        backgroundColor: Colors.green,
      );
      Navigator.of(context).pop();
    } catch (e, st) {
      talker.error('Ticket workflow complete failed: $e', st);
      if (mounted) {
        final message = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
        showCustomSnackBarUtil(
          context,
          message.isEmpty ? 'Failed to complete ticket' : message,
          backgroundColor: Colors.red,
        );
        Navigator.of(context).pop();
      }
    } finally {
      ref.read(settlingTillTicketProvider.notifier).state = null;
    }
  }

  Future<void> _afterCheckoutSaleCleanup(ITransaction transaction) async {
    ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);

    final branchId = ProxyService.box.getBranchId() ?? '0';
    ref.invalidate(
      transactionItemsStreamProvider(
        transactionId: transaction.id,
        branchId: branchId,
      ),
    );
    ref.invalidate(
      pendingTransactionStreamProvider(
        isExpense: ProxyService.box.isOrdering() ?? false,
      ),
    );
    ref
        .read(optimisticCartProvider.notifier)
        .clearForTransaction(transaction.id);
    ref.invalidate(ticketsStreamProvider);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  SizedBox(
                    width: 36,
                    height: 36,
                    child: CircularProgressIndicator(strokeWidth: 3),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Completing ticket…',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

String _ticketDisplayRef(ITransaction ticket) {
  final r = ticket.reference?.trim();
  if (r != null && r.isNotEmpty) return r.toUpperCase();
  if (ticket.id.length >= 6) {
    return ticket.id.substring(0, 6).toUpperCase();
  }
  return ticket.id.toUpperCase();
}
