import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldProvider;
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/helperModels/talker.dart';

class TransactionInitializationHelper {
  // Wrapper for full session resume
  static Future<void> initializeSession({
    required WidgetRef ref,
    required ITransaction transaction,
  }) async {
    await initializeCustomer(ref, transaction);
    _initializePaymentWithRemainder(ref, transaction);
  }

  // Generic Customer Initialization - REUSED LOGIC
  static Future<Customer?> initializeCustomer(
    WidgetRef ref,
    ITransaction transaction,
  ) async {
    // 1. Try to fetch live customer data if ID exists
    if (transaction.customerId != null) {
      try {
        final customer = await ref.read(
          oldProvider.attachedCustomerProvider(transaction.customerId).future,
        );

        if (customer != null) {
          // Centralized Global State Update
          // 1. Update Riverpod
          if (customer.telNo != null) {
            ref.read(customerPhoneNumberProvider.notifier).state =
                customer.telNo;
            ProxyService.box.writeString(
              key: 'currentSaleCustomerPhoneNumber',
              value: customer.telNo!,
            );
          }

          // 2. Update Box (Name, TIN) - needed for SearchCustomer
          if (customer.custNm != null) {
            ProxyService.box.writeString(
              key: 'customerName',
              value: customer.custNm!,
            );
          }
          if (customer.custTin != null) {
            ProxyService.box.writeString(
              key: 'customerTin',
              value: customer.custTin!,
            );
          }

          talker.info(
            'Initialized live customer: ${customer.custNm}, Phone: ${customer.telNo}',
          );
          return customer;
        }
      } catch (e) {
        talker.warning('Failed to fetch live customer: $e');
      }
    }

    // Fallback logic for basic resume (if fetch failed or no ID)
    final currentPhone = ref.read(customerPhoneNumberProvider);
    String? phoneToUse = transaction.customerPhone;

    if ((currentPhone == null || currentPhone.isEmpty) &&
        phoneToUse != null &&
        phoneToUse.isNotEmpty) {
      // Initialize the provider
      ref.read(customerPhoneNumberProvider.notifier).state = phoneToUse;

      // Also ensure the ProxyService box has it
      ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: phoneToUse,
      );

      talker.info(
        'Resumed ticket: fallback initialized customer phone $phoneToUse',
      );
    }

    return null;
  }

  static void _initializePaymentWithRemainder(
    WidgetRef ref,
    ITransaction transaction,
  ) {
    // Logic standardized to match shared behavior
    final total = transaction.subTotal ?? 0.0;
    final paid = transaction.cashReceived ?? 0.0;
    final remainder = total - paid;
    final displayRemainder = remainder > 0.01 ? remainder : 0.0;

    if (displayRemainder <= 0) return;

    final payments = ref.read(oldProvider.paymentMethodsProvider);

    if (payments.isEmpty) {
      ref
          .read(oldProvider.paymentMethodsProvider.notifier)
          .addPaymentMethod(
            oldProvider.Payment(
              amount: displayRemainder,
              method: "Cash",
              controller: TextEditingController(
                text: displayRemainder.toString(),
              ),
            ),
          );
    } else {
      final firstPayment = payments[0];
      // Sync logic matches the mixin's intent
      if (firstPayment.amount == 0 ||
          (firstPayment.amount - total).abs() < 0.01) {
        ref
            .read(oldProvider.paymentMethodsProvider.notifier)
            .updatePaymentMethod(
              0,
              oldProvider.Payment(
                amount: displayRemainder,
                method: firstPayment.method,
                id: firstPayment.id,
                controller: firstPayment.controller,
              ),
              transactionId: transaction.id,
            );

        if (firstPayment.controller.text.isEmpty ||
            double.tryParse(firstPayment.controller.text) == total) {
          firstPayment.controller.text = displayRemainder.toString();
        }
      }
    }
  }
}
