import 'dart:async';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';

/// Parks a sale on **Capella (Ditto)** only — no Brick/repository paths.
class ParkTransactionService {
  static Future<void> park({
    required String ticketName,
    required String ticketNote,
    required ITransaction transaction,
    String? customerId,
  }) async {
    talker.info(
      'park (Capella) ticketName=$ticketName customerId=$customerId txn=${transaction.id}',
    );

    if (ticketName.trim().isEmpty) return;

    final capella = ProxyService.getStrategy(Strategy.capella);
    final branchId = transaction.branchId ?? ProxyService.box.getBranchId()!;

    // Reconcile payments only when cashReceived was never set — avoids an extra
    // Ditto round-trip on the common checkout park path.
    if (transaction.cashReceived == null) {
      try {
        final totalRecordsAmount = await capella.getTotalPaidForTransaction(
          transactionId: transaction.id,
          branchId: branchId,
          excludePaymentMethod: 'CREDIT',
        );
        if (totalRecordsAmount != null) {
          transaction.cashReceived = totalRecordsAmount;
        }
      } catch (e) {
        talker.error('park: cashReceived reconcile failed, continuing: $e');
      }
    }

    if (customerId != null) {
      final otherParked = (await capella.transactions(
        customerId: customerId,
        status: PARKED,
        branchId: branchId,
        isExpense: false,
      ))
          .where((t) => t.id != transaction.id)
          .toList();

      if (otherParked.isNotEmpty) {
        await capella.mergeTransactions(
          from: transaction,
          to: otherParked.first,
        );
        // Fresh pending cart can be created after the sheet closes.
        unawaited(
          capella.manageTransaction(
            branchId: branchId,
            transactionType: SALE,
            isExpense: false,
          ),
        );
        return;
      }
    }

    final existingSubTotal = transaction.subTotal;
    final double subTotal;
    if (existingSubTotal != null && existingSubTotal > 0) {
      subTotal = existingSubTotal;
    } else {
      final items = await capella.transactionItems(
        transactionId: transaction.id,
      );
      subTotal = items.fold<double>(
        0.0,
        (sum, item) => sum + (item.price * item.qty),
      );
    }

    await capella.updateTransaction(
      transaction: transaction,
      status: PARKED,
      note: ticketNote,
      ticketName: ticketName.trim(),
      customerId: customerId,
      isLoan: transaction.isLoan,
      subTotal: subTotal,
      updatedAt: DateTime.now().toUtc(),
      deferEnsureNextPendingCart: true,
    );
  }
}
