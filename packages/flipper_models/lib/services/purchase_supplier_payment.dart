import 'package:flipper_accounting/audit_trail_recorder.dart';
import 'package:flipper_accounting/bill_payments.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/services/pos_purchase_journal_poster.dart';
import 'package:flipper_models/services/purchase_approval_deps.dart';
import 'package:flipper_models/services/purchase_expense_recorder.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// Ledger accounts a supplier can be paid from.
const String supplierPaidFromCash = '1010';
const String supplierPaidFromBank = '1020';
const String supplierPaidFromMomo = '1030';

/// An approved purchase's bill and what is still owed on it.
class PurchaseBill {
  const PurchaseBill({required this.docId, required this.balance});

  /// Ditto `_id` of the bill in `accounting_documents`.
  final String docId;
  final BillBalance balance;
}

/// Paying the supplier of a purchase bought on credit (or partly on credit).
///
/// Each payment goes against the purchase's bill (Dr Accounts Payable /
/// Cr the account paid from) and shows with the other expenses as a
/// cash-out, so a credit purchase reaches the expenses when it is paid.
abstract final class PurchaseSupplierPayment {
  /// The purchase's bill, or null while it is a draft (purchase not yet
  /// approved) or when the purchase has none (RRA purchases).
  static Future<PurchaseBill?> billFor(String purchaseId) async {
    final ditto = DittoService.instance;
    if (!ditto.isReady()) return null;
    final rows = await ditto.queryCollection(
      'accounting_documents',
      'SELECT * FROM accounting_documents WHERE purchase_id = :purchaseId',
      {'purchaseId': purchaseId},
    );
    if (rows.isEmpty) return null;
    final bill = rows.first;
    if (bill['status'] == 'draft') return null;
    final docId = '${bill['_id'] ?? bill['id']}';
    // From the payments themselves, not the cached fields: a payment synced
    // in from another device may not have refreshed them yet.
    final payments = await BillPaymentPoster(ditto).paymentsFor(docId);
    return PurchaseBill(
      docId: docId,
      balance: BillBalance.from(
        total: num.tryParse('${bill['total']}')?.round() ?? 0,
        paidUpfront: num.tryParse('${bill['paid_upfront']}')?.round() ?? 0,
        payments: payments,
      ),
    );
  }

  /// Pays [amount] of [bill] from [accountCode] and returns the new balance.
  /// Cash also comes out of the open shift's expected cash. Throws when the
  /// payment cannot be recorded.
  static Future<BillBalance> pay({
    required Purchase purchase,
    required PurchaseBill bill,
    required int amount,
    required String accountCode,
    required PurchaseApprovalDeps deps,
  }) async {
    if (amount <= 0 || amount > bill.balance.balance) {
      throw ArgumentError.value(
        amount,
        'amount',
        'must be between 1 and ${bill.balance.balance}',
      );
    }
    final businessId = deps.businessId;
    if (businessId == null || businessId.isEmpty) {
      throw StateError('No active business');
    }
    final ditto = DittoService.instance;
    final branchId = purchase.branchId ?? deps.branchId;
    final after =
        await BillPaymentPoster(
          ditto,
          audit: AuditTrailRecorder(ditto),
        ).recordPayment(
          businessId: businessId,
          billDocId: bill.docId,
          amount: amount,
          paymentAccount: accountCode,
          accounts: await PosPurchaseJournalPoster.chartOfAccounts(
            ditto,
            businessId,
          ),
          fallbackTotal: purchase.totAmt.round(),
          paidBy: deps.userId,
          cashOut: branchId == null
              ? null
              : BillPaymentCashOut(branchId: branchId, agentId: deps.userId),
        );
    final userId = deps.userId;
    if (accountCode == supplierPaidFromCash && userId != null) {
      await PurchaseExpenseRecorder.takeFromShiftCash(
        userId: userId,
        amount: amount.toDouble(),
      );
    }
    return after;
  }
}
