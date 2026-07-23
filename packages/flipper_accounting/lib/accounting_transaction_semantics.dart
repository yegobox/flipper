/// Flipper POS transaction status + field semantics for the Books module.
///
/// POS stores lowercase statuses (`completed`, `parked`) per
/// `flipper_services/constants.dart`. Reports and data-connector use the same
/// values. Books must accept both legacy uppercase fixtures and live data.
library;

/// Status after a finalized sale (fully paid or parked as loan/credit).
const accountingSaleStatusCompleted = 'completed';
const accountingSaleStatusParked = 'parked';

const _completedSaleStatuses = {
  accountingSaleStatusCompleted,
  'complete', // legacy alias
  // Ticket Review + Handover workflow (opt-in, `flipper_services/constants.dart`
  // PENDING_REVIEW / AWAITING_HANDOVER): payment/tax signing already happened
  // at the same moment it does for a normal sale — only the ticket's
  // visibility in the POS Tickets list is deferred until reviewed/handed
  // over. Revenue must still be recognized at payment time, not deferred.
  'pendingreview',
  'awaitinghandover',
};

/// Normalizes [raw] to lowercase trimmed string (empty when null).
String accountingTxnStatus(dynamic raw) =>
    raw?.toString().trim().toLowerCase() ?? '';

/// True when [txn] is a finalized POS sale/expense row Books should include.
///
/// `parked` is ambiguous in the POS: it is both a held ticket (cart saved to
/// finish later — NOT a sale) and a credit sale awaiting payment. Only the
/// loan form is an accounting event; recognizing plain held tickets would
/// post revenue and cash that were never earned or received.
bool isAccountingRecognizedTransaction(Map<String, dynamic> txn) {
  final sub = _amount(txn, 'sub_total', 'subTotal');
  if (sub <= 0) return false;
  final status = accountingTxnStatus(txn['status']);
  if (_completedSaleStatuses.contains(status)) return true;
  if (status == accountingSaleStatusParked) return isAccountingLoan(txn);
  return false;
}

bool isAccountingExpense(Map<String, dynamic> txn) =>
    txn['is_expense'] == true || txn['isExpense'] == true;

bool isAccountingLoan(Map<String, dynamic> txn) =>
    txn['is_loan'] == true || txn['isLoan'] == true;

int accountingRemainingBalance(Map<String, dynamic> txn) =>
    _amount(txn, 'remaining_balance', 'remainingBalance');

int accountingSubTotal(Map<String, dynamic> txn) =>
    _amount(txn, 'sub_total', 'subTotal');

int accountingTaxAmount(Map<String, dynamic> txn) =>
    _amount(txn, 'tax_amount', 'taxAmount');

/// Open receivable: loan/credit sale with an outstanding balance.
bool isOpenReceivable(Map<String, dynamic> txn) {
  if (isAccountingExpense(txn)) return false;
  if (!isAccountingRecognizedTransaction(txn)) return false;
  if (!isAccountingLoan(txn)) return false;
  return accountingRemainingBalance(txn) > 0;
}

/// Open payable: expense with unpaid vendor balance.
bool isOpenPayable(Map<String, dynamic> txn) {
  if (!isAccountingExpense(txn)) return false;
  if (!isAccountingRecognizedTransaction(txn)) return false;
  return accountingRemainingBalance(txn) > 0;
}

/// Cash/collected portion of a sale (accrual: subtotal minus open balance).
int accountingCollectedAmount(Map<String, dynamic> txn) {
  final sub = accountingSubTotal(txn);
  if (sub <= 0) return 0;
  if (!isAccountingLoan(txn)) return sub;
  final remaining = accountingRemainingBalance(txn);
  if (remaining <= 0) return sub;
  return (sub - remaining).clamp(0, sub);
}

/// Liquid account code for the collected portion (1010/1020/1030).
String accountingLiquidAccountCode(Map<String, dynamic> txn) {
  final payType =
      (txn['payment_type'] ?? txn['paymentType'] ?? 'CASH').toString();
  final p = payType.toLowerCase();
  // CREDIT tender does not map to a liquid account — caller uses AR instead.
  if (p.contains('credit') || p.contains('loan')) return '1010';
  if (p.contains('momo') || p.contains('mobile')) return '1030';
  if (p.contains('bank') || p.contains('card') || p.contains('transfer')) {
    return '1020';
  }
  return '1010';
}

int _amount(Map<String, dynamic> row, String snake, String camel) {
  final v = row[snake] ?? row[camel];
  if (v == null) return 0;
  if (v is num) return v.round();
  return int.tryParse(v.toString()) ?? 0;
}
