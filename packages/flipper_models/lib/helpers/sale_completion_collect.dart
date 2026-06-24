import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

/// Synchronous in-memory payment fields before [markTransactionAsCompleted] (no Ditto/SQLite).
void applySalePaymentFieldsInMemory({
  required ITransaction transaction,
  required double tenderAmount,
  required String paymentType,
  required String customerName,
  required String countryCode,
  List<TransactionItem>? preloadedLineItems,
}) {
  final items = preloadedLineItems ?? const <TransactionItem>[];
  transaction.taxAmount = items.fold<double>(
    0,
    (sum, item) => sum + (item.taxAmt?.toDouble() ?? 0),
  );

  final computedSubTotal = items.isEmpty
      ? tenderAmount
      : items.fold<double>(
          0,
          (sum, item) => sum + item.price.toDouble() * item.qty.toDouble(),
        );
  transaction.subTotal = computedSubTotal;
  transaction.numberOfItems = items.length;
  transaction.discountAmount = items.fold<double>(
    0,
    (sum, item) => sum + (item.dcAmt?.toDouble() ?? 0),
  );

  if (transaction.isLoan == true) {
    transaction.originalLoanAmount ??= computedSubTotal;
    final totalPaidSoFar = (transaction.cashReceived ?? 0.0) + tenderAmount;
    transaction.cashReceived = totalPaidSoFar;
    transaction.remainingBalance = computedSubTotal - totalPaidSoFar;
    transaction.lastPaymentDate = DateTime.now().toUtc();
    transaction.lastPaymentAmount = tenderAmount;
  } else {
    transaction.cashReceived = (transaction.cashReceived ?? 0) + tenderAmount;
    transaction.remainingBalance =
        computedSubTotal - (transaction.cashReceived ?? 0.0);
  }

  transaction.transactionType =
      transaction.transactionType ?? TransactionType.sale;
  transaction.isIncome = true;
  transaction.isExpense = false;
  transaction.paymentType = ProxyService.box.paymentType() ?? paymentType;
  transaction.customerChangeDue =
      tenderAmount - (transaction.subTotal ?? 0);

  final resolvedPhone =
      ProxyService.box.currentSaleCustomerPhoneNumber();
  if (countryCode.isNotEmpty &&
      countryCode != 'N/A' &&
      resolvedPhone != null &&
      resolvedPhone.isNotEmpty) {
    transaction.currentSaleCustomerPhoneNumber =
        countryCode + resolvedPhone;
  }
  transaction.customerPhone = resolvedPhone;
  transaction.customerName =
      ProxyService.box.customerName() ?? customerName;
}

/// Shift totals + personal-goal sweep after the Pay UI (avoids SQLite lock on hot path).
void scheduleDeferredSaleCollectSideEffects({
  required ITransaction transaction,
  required String branchId,
  required String bhfId,
  required List<TransactionItem> items,
  required String? completionStatus,
  required bool isProformaMode,
  required bool isTrainingMode,
}) {
  unawaited(
    Future<void>.delayed(const Duration(milliseconds: 1200), () async {
      final sw = Stopwatch()..start();
      try {
        await ProxyService.getStrategy(Strategy.capella).collectPayment(
          branchId: branchId,
          bhfId: bhfId,
          isProformaMode: isProformaMode,
          isTrainingMode: isTrainingMode,
          countryCode: 'N/A',
          cashReceived: 0,
          transaction: transaction,
          paymentType: transaction.paymentType ?? 'CASH',
          discount: 0,
          transactionType: transaction.transactionType ?? TransactionType.sale,
          categoryId: transaction.categoryId,
          isIncome: true,
          preloadedLineItems: items,
          skipTransactionPersist: true,
          skipCashMutation: true,
          completionStatus: completionStatus,
        );
      } catch (e, s) {
        talker.warning(
          'Deferred sale collect side effects failed: $e\n$s',
        );
      }
      talker.debug(
        '[sale_completion_timing] deferred_collect_side_effects_ms='
        '${sw.elapsedMilliseconds}',
      );
    }),
  );
}
