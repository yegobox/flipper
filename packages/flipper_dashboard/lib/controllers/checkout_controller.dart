import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_analytics/flipper_analytics.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart' as oldImplementationOfRiverpod;
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckoutController with AnalyticsTrackingMixin {
  final WidgetRef ref;
  final BuildContext context;

  CheckoutController({required this.ref, required this.context});

  @override
  ProductAnalytics get analytics => ProxyService.productAnalytics;

  Future<bool> handleCompleteTransaction({
    required ITransaction transaction,
    required bool immediateCompletion,
    required Function startCompleteTransactionFlow,
    required Function applyDiscount,
    required Function refreshTransactionItems,
    required TextEditingController discountController,
    required Future<void> Function(ITransaction transaction)
        afterCheckoutSaleCleanup,
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
    List<TransactionItem>? transactionItemsHint,
    double overrideAlreadyPaid = 0.0,
  }) async {
    final startTime = transaction.createdAt!;

    ProxyService.box.writeBool(key: 'transactionInProgress', value: true);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: true);

    if (discountController.text.isEmpty) {
      ProxyService.box.remove(key: 'discountRate');
    }

    try {
      await applyDiscount(transaction);

      Customer? attachedCustomerHint;
      final attachedCustomerId = transaction.customerId;
      if (attachedCustomerId != null && attachedCustomerId.isNotEmpty) {
        attachedCustomerHint = ref
            .read(
              oldImplementationOfRiverpod.attachedCustomerProvider(
                attachedCustomerId,
              ),
            )
            .asData
            ?.value;
      }

      final isWaitingForPayment = await startCompleteTransactionFlow(
        transactionId: transaction.id,
        transactionHint: transaction,
        transactionItemsHint: transactionItemsHint,
        immediateCompletion: immediateCompletion,
        onPaymentConfirmed: onPaymentConfirmed,
        onPaymentFailed: onPaymentFailed,
        attachedCustomerHint: attachedCustomerHint,
        overrideAlreadyPaid: overrideAlreadyPaid,
        completeTransaction: () async {
          ref.read(payButtonStateProvider.notifier).stopLoading();

          await afterCheckoutSaleCleanup(transaction);

          if (!kIsWeb &&
              (defaultTargetPlatform == TargetPlatform.iOS ||
                  defaultTargetPlatform == TargetPlatform.android) &&
              context.mounted &&
              Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
          }

          _handleTransactionCompletion(transaction, startTime);
        },
        paymentMethods: ref.watch(oldImplementationOfRiverpod.paymentMethodsProvider),
      );
      
      return isWaitingForPayment;
    } catch (e) {
      ProxyService.box.writeBool(key: 'transactionCompleting', value: false);
      ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
      ref.read(payButtonStateProvider.notifier).stopLoading();
      await refreshTransactionItems(transactionId: transaction.id);
      rethrow;
    }
  }

  void _handleTransactionCompletion(ITransaction transaction, DateTime startTime) {
    final endTime = DateTime.now().toUtc();
    final duration = endTime.difference(startTime).inSeconds;

    ProxyService.box.writeBool(key: 'transactionInProgress', value: false);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: false);
    
    trackTransactionCompleted(
      transactionId: transaction.id,
      branchId: transaction.branchId,
      businessId: ProxyService.box.getBusinessId(),
      createdAt: startTime.toIso8601String(),
      completedAt: endTime.toIso8601String(),
      durationSeconds: duration,
      source: 'checkout',
    );
  }
}
