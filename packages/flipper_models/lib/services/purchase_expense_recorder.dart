import 'package:flipper_accounting/accounting_transaction_semantics.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/sync/shift_operations.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// What an approved purchase paid on the spot, by RRA payment code: the whole
/// total for cash, bank, card, MoMo and other; the "paid now" part of
/// Cash/Credit (`03`); nothing for Credit (`02`) until the supplier is paid.
double purchaseAmountPaidNow({
  required String pmtTyCd,
  required double total,
  double paidUpfront = 0,
}) {
  if (total <= 0) return 0;
  switch (pmtTyCd) {
    case '02':
      return 0;
    case '03':
      return paidUpfront.clamp(0, total).toDouble();
    default:
      return total;
  }
}

/// POS payment-type label for a purchase's RRA payment code (the same labels
/// cash-outs carry, so the ledger maps them to cash / bank / MoMo).
String purchasePaymentTypeLabel(String pmtTyCd) => switch (pmtTyCd) {
  '04' => 'BANK CHECK',
  '05' => 'DEBIT&CREDIT CARD',
  '06' => 'MOBILE MONEY',
  '07' => 'OTHER',
  _ => 'CASH',
};

/// Whether the amount paid now left the till in cash.
bool purchasePaidInCash(String pmtTyCd) => pmtTyCd == '01' || pmtTyCd == '03';

/// One expense row per purchase: approving again finds it instead of adding
/// a second one. Never the purchase id itself (the ledger looks entries up by
/// transaction id, and the purchase's entry uses that).
String purchaseExpenseTransactionId(String purchaseId) =>
    'purchase_exp_$purchaseId';

/// Puts an approved supplier purchase into the expenses, like a Cashbook
/// cash-out: a completed `isExpense` transaction for what was paid now, and
/// for cash, the open shift's expected cash goes down.
///
/// The row is marked [purchaseExpenseReceiptType] so neither ledger poster
/// books it: the purchase already posted Dr Inventory/VAT, Cr cash/AP.
abstract final class PurchaseExpenseRecorder {
  /// Never throws: the purchase is approved either way.
  static Future<void> record({
    required Purchase purchase,
    required PurchaseApprovalDeps deps,
    double paidUpfront = 0,
  }) async {
    try {
      final amount = purchaseAmountPaidNow(
        pmtTyCd: purchase.pmtTyCd,
        total: purchase.totAmt.toDouble(),
        paidUpfront: paidUpfront,
      );
      if (amount <= 0) return;
      final branchId = purchase.branchId ?? deps.branchId;
      final userId = deps.userId;
      final ditto = DittoService.instance.dittoInstance;
      if (branchId == null || ditto == null) return;

      final id = purchaseExpenseTransactionId(purchase.id);
      final existing = await ditto.store.execute(
        'SELECT * FROM transactions WHERE _id = :id',
        arguments: {'id': id},
      );
      if (existing.items.isNotEmpty) return;

      final now = DateTime.now().toUtc();
      final supplier = purchase.spplrNm.trim().isEmpty
          ? 'Supplier'
          : purchase.spplrNm.trim();
      final transaction = ITransaction(
        id: id,
        branchId: branchId,
        status: COMPLETE,
        transactionType: 'Supplier purchase',
        paymentType: purchasePaymentTypeLabel(purchase.pmtTyCd),
        subTotal: amount,
        cashReceived: amount,
        customerChangeDue: 0,
        remainingBalance: 0,
        receiptType: purchaseExpenseReceiptType,
        isIncome: false,
        isExpense: true,
        isOriginalTransaction: true,
        agentId: userId,
        customerName: supplier,
        note: 'Purchase from $supplier · invoice ${purchase.spplrInvcNo}',
        reference: 'BILL-${purchase.spplrInvcNo}',
        createdAt: now,
        updatedAt: now,
        lastTouched: now,
      );
      await deps.capella.addTransaction(transaction: transaction);

      if (purchasePaidInCash(purchase.pmtTyCd) && userId != null) {
        await _takeFromShiftCash(userId: userId, amount: amount);
      }
    } catch (e, s) {
      talker.error('[PurchaseExpenseRecorder] failed: $e', s);
    }
  }

  /// Same change a cash-out makes in `collectPayment`: cash sales and the
  /// expected drawer cash go down by [amount].
  static Future<void> _takeFromShiftCash({
    required String userId,
    required double amount,
  }) async {
    final shiftOps = ShiftOperations();
    final shift = await shiftOps.getCurrentShift(userId: userId);
    if (shift == null) return;
    final cashSales = (shift.cashSales ?? 0) - amount;
    await shiftOps.saveShift(
      shift.copyWith(
        cashSales: cashSales,
        expectedCash: shift.openingBalance + cashSales,
      ),
    );
  }

  /// The "paid now" part of a Cash/Credit purchase, as recorded on its bill
  /// (approval from the purchases list does not have the form's terms).
  static Future<double> paidUpfrontFromBill(String purchaseId) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return 0;
    final result = await ditto.store.execute(
      'SELECT * FROM accounting_documents WHERE purchase_id = :purchaseId',
      arguments: {'purchaseId': purchaseId},
    );
    for (final item in result.items) {
      final v = num.tryParse('${item.value['paid_upfront']}');
      if (v != null) return v.toDouble();
    }
    return 0;
  }
}
