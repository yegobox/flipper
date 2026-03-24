import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/providers/pay_button_provider.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart' as oldImplementationOfRiverpod;
import 'package:flipper_services/posthog_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CheckoutController {
  final WidgetRef ref;
  final BuildContext context;

  CheckoutController({required this.ref, required this.context});

  Future<bool> handleCompleteTransaction({
    required ITransaction transaction,
    required bool immediateCompletion,
    required Function startCompleteTransactionFlow,
    required Function applyDiscount,
    required Function refreshTransactionItems,
    required TextEditingController discountController,
    Function? onPaymentConfirmed,
    Function(String)? onPaymentFailed,
  }) async {
    final startTime = transaction.createdAt!;

    ProxyService.box.writeBool(key: 'transactionInProgress', value: true);
    ProxyService.box.writeBool(key: 'transactionCompleting', value: true);

    if (discountController.text.isEmpty) {
      ProxyService.box.remove(key: 'discountRate');
    }

    try {
      await applyDiscount(transaction);
      
      final isWaitingForPayment = await startCompleteTransactionFlow(
        transactionId: transaction.id,
        immediateCompletion: immediateCompletion,
        onPaymentConfirmed: onPaymentConfirmed,
        onPaymentFailed: onPaymentFailed,
        completeTransaction: () {
          ref.read(payButtonStateProvider.notifier).stopLoading();

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
    
    PosthogService.instance.capture(
      'transaction_completed',
      properties: {
        'transaction_id': transaction.id,
        'branch_id': transaction.branchId!,
        'business_id': ProxyService.box.getBusinessId()!,
        'created_at': startTime.toIso8601String(),
        'completed_at': endTime.toIso8601String(),
        'duration_seconds': duration,
        'source': 'checkout',
      },
    );
  }
}
