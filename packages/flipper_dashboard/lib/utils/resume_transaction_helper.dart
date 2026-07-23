import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/view_models/mixins/riverpod_states.dart'
    as oldProvider;
import 'package:flipper_dashboard/providers/customer_phone_provider.dart';
import 'package:flipper_dashboard/providers/customer_provider.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flipper_models/helperModels/talker.dart';

class TransactionInitializationHelper {
  // Wrapper for full session resume
  static Future<void> initializeSession({
    required WidgetRef ref,
    required ITransaction transaction,
    bool replaceSession = true,
  }) async {
    await initializeCustomer(
      ref,
      transaction,
      replaceSession: replaceSession,
    );
    _initializePaymentWithRemainder(ref, transaction);
  }

  /// Seeds UI/box customer state from a ticket or pending sale.
  ///
  /// Till tickets often carry denormalized [ITransaction.customerName] /
  /// [ITransaction.customerPhone] without a [ITransaction.customerId]. Pay and
  /// receipt printing read [ProxyService.box] / providers first, so those must
  /// be overwritten from the ticket — leftover values from a prior sale must
  /// not win.
  ///
  /// Pass [replaceSession] only when switching into a different sale (resume /
  /// till collect / dedicated mobile checkout). Leaving it false preserves
  /// in-progress typed name/phone that has not been persisted to the
  /// transaction yet (e.g. SearchCustomer init while cashier is typing).
  static Future<Customer?> initializeCustomer(
    WidgetRef ref,
    ITransaction transaction, {
    bool replaceSession = false,
  }) async {
    final container = ref.container;
    // 1. Try to fetch live customer data if ID exists
    if (transaction.customerId != null) {
      try {
        final customer = await container.read(
          oldProvider.attachedCustomerProvider(transaction.customerId).future,
        );

        if (customer != null) {
          // Live customer is source of truth for TIN. Do not fall back to
          // denormalized transaction.customerTin — an edited customer with TIN
          // removed would otherwise keep prompting for a purchase code.
          final liveTin = _firstNonEmpty([customer.custTin]);
          await _applyCustomerToSession(
            container,
            name: _firstNonEmpty([
              customer.custNm,
              transaction.customerName,
            ]),
            phone: _firstNonEmpty([
              customer.telNo,
              transaction.customerPhone,
              transaction.currentSaleCustomerPhoneNumber,
            ]),
            tin: liveTin,
            replaceSession: replaceSession,
          );

          // Heal stale denormalized ticket fields so pay/purchase-code gates
          // that read transaction.customerTin see the live customer.
          final staleTin = _firstNonEmpty([transaction.customerTin]);
          final tinDiverged = liveTin != staleTin;
          final nameDiverged =
              _firstNonEmpty([customer.custNm]) !=
              _firstNonEmpty([transaction.customerName]);
          final phoneDiverged =
              _firstNonEmpty([customer.telNo]) !=
              _firstNonEmpty([
                transaction.customerPhone,
                transaction.currentSaleCustomerPhoneNumber,
              ]);
          if (tinDiverged || nameDiverged || phoneDiverged) {
            try {
              await ProxyService.getStrategy(Strategy.capella)
                  .assignCustomerToTransaction(
                customer: customer,
                transaction: transaction,
              );
            } catch (e) {
              talker.warning(
                'Failed to sync live customer onto resumed transaction: $e',
              );
            }
          }
          return customer;
        }
      } catch (e) {
        talker.warning('Failed to fetch live customer: $e');
      }
    }

    // Fallback / denormalized ticket fields (common for "send to till").
    final phone = _firstNonEmpty([
      transaction.customerPhone,
      transaction.currentSaleCustomerPhoneNumber,
    ]);
    await _applyCustomerToSession(
      container,
      name: _firstNonEmpty([transaction.customerName]),
      phone: phone,
      tin: _firstNonEmpty([transaction.customerTin]),
      replaceSession: replaceSession,
    );

    if (phone != null) {
      talker.info(
        'Resumed ticket: customer fields initialized '
        'transactionId=${transaction.id} '
        'hasPhone=true '
        'hasName=${_firstNonEmpty([transaction.customerName]) != null} '
        'hasTin=${_firstNonEmpty([transaction.customerTin]) != null} '
        'replaceSession=$replaceSession',
      );
    }

    return null;
  }

  /// First trimmed non-empty string; empty/`null` values do not win via `??`.
  static String? _firstNonEmpty(List<String?> values) {
    for (final v in values) {
      final t = v?.trim() ?? '';
      if (t.isNotEmpty) return t;
    }
    return null;
  }

  static Future<void> _applyCustomerToSession(
    ProviderContainer container, {
    String? name,
    String? phone,
    String? tin,
    bool replaceSession = false,
  }) async {
    final trimmedName = name?.trim();
    if (trimmedName != null && trimmedName.isNotEmpty) {
      await ProxyService.box.writeString(key: 'customerName', value: trimmedName);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          final controller = container.read(customerNameControllerProvider);
          if (controller.text != trimmedName) {
            controller.text = trimmedName;
          }
        } catch (_) {}
      });
    } else if (replaceSession) {
      await ProxyService.box.writeString(key: 'customerName', value: '');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          container.read(customerNameControllerProvider).clear();
        } catch (_) {}
      });
    }

    final trimmedPhone = phone?.trim();
    if (trimmedPhone != null && trimmedPhone.isNotEmpty) {
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: trimmedPhone,
      );
      // Write immediately so Pay before the next frame still sees the ticket phone.
      try {
        container.read(customerPhoneNumberProvider.notifier).state =
            trimmedPhone;
      } catch (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          container.read(customerPhoneNumberProvider.notifier).state =
              trimmedPhone;
        });
      }
    } else if (replaceSession) {
      await ProxyService.box.writeString(
        key: 'currentSaleCustomerPhoneNumber',
        value: '',
      );
      try {
        container.read(customerPhoneNumberProvider.notifier).state = null;
      } catch (_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          container.read(customerPhoneNumberProvider.notifier).state = null;
        });
      }
    }

    final trimmedTin = tin?.trim();
    if (trimmedTin != null && trimmedTin.isNotEmpty) {
      await ProxyService.box.writeString(key: 'customerTin', value: trimmedTin);
    } else if (replaceSession) {
      await ProxyService.box.remove(key: 'customerTin');
    }
  }

  static void _initializePaymentWithRemainder(
    WidgetRef ref,
    ITransaction transaction,
  ) {
    final container = ref.container;
    // Payment providers must not be written during widget mount.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _applyPaymentWithRemainder(container, transaction);
    });
  }

  static void _applyPaymentWithRemainder(
    ProviderContainer container,
    ITransaction transaction,
  ) {
    // Logic standardized to match shared behavior
    final total = transaction.subTotal ?? 0.0;
    final paid = transaction.cashReceived ?? 0.0;
    final remainder = total - paid;
    final displayRemainder = remainder > 0.01 ? remainder : 0.0;

    if (displayRemainder <= 0) return;

    final payments = container.read(oldProvider.paymentMethodsProvider);

    if (payments.isEmpty) {
      final controller = TextEditingController(
        text: displayRemainder.toString(),
      );
      container
          .read(oldProvider.paymentMethodsProvider.notifier)
          .addPaymentMethod(
            oldProvider.Payment(
              amount: displayRemainder,
              method: "Cash",
              controller: controller,
            ),
          );
    } else {
      final firstPayment = payments[0];
      // Sync logic matches the mixin's intent
      if (firstPayment.amount == 0 ||
          (firstPayment.amount - total).abs() < 0.01) {
        container
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
