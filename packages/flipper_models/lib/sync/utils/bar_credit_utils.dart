import 'package:supabase_models/brick/models/transaction.model.dart';

/// Marks a loan that started as a bar tab. The note is the only trace left of
/// the table once the loan has freed it.
const kBarCreditNotePrefix = 'Bar · ';

/// Below this a balance is rounding, not a debt.
const kBarCreditBalanceEpsilon = 0.01;

/// The note a bar tab carries once it is on credit: `Bar · T4 · Opened by Ana`.
String barCreditNote({String? tableName, required String opened}) {
  final table = (tableName ?? '').trim();
  return [
    'Bar',
    if (table.isNotEmpty) table,
    if (opened.isNotEmpty) opened,
  ].join(' · ');
}

/// Whether [loan] was put on credit from Bar Mode rather than the POS.
bool barCreditIsFromBar(ITransaction loan) {
  final note = loan.note ?? '';
  return note == 'Bar' || note.startsWith(kBarCreditNotePrefix);
}

/// What the customer still owes on [loan].
double barCreditBalance(ITransaction loan) {
  final stored = loan.remainingBalance;
  final balance = stored != null
      ? stored.toDouble()
      : (loan.subTotal ?? 0) - (loan.cashReceived ?? 0);
  return balance < 0 ? 0 : balance;
}

/// A loan with money still owed on it.
bool barCreditIsOpen(ITransaction loan) =>
    loan.isLoan == true && barCreditBalance(loan) > kBarCreditBalanceEpsilon;

/// Past its due date (a loan with no due date is never overdue).
bool barCreditIsOverdue(ITransaction loan, {DateTime? now}) {
  final due = loan.dueDate;
  if (due == null) return false;
  return due.isBefore((now ?? DateTime.now()).toUtc());
}

/// Overdue first, then soonest due, then oldest: the order a cashier chases
/// debts in. Loans without a due date go last.
List<ITransaction> sortBarCreditTabs(
  List<ITransaction> loans, {
  DateTime? now,
}) {
  final at = now ?? DateTime.now();
  final sorted = [...loans];
  sorted.sort((a, b) {
    final overdueA = barCreditIsOverdue(a, now: at);
    final overdueB = barCreditIsOverdue(b, now: at);
    if (overdueA != overdueB) return overdueA ? -1 : 1;
    final dueA = a.dueDate;
    final dueB = b.dueDate;
    if (dueA != null && dueB != null && dueA != dueB) {
      return dueA.compareTo(dueB);
    }
    if ((dueA == null) != (dueB == null)) return dueA == null ? 1 : -1;
    final createdA = a.createdAt ?? at;
    final createdB = b.createdAt ?? at;
    return createdA.compareTo(createdB);
  });
  return sorted;
}

/// Who owes [loan], for the list row.
String barCreditDebtorName(ITransaction loan) {
  for (final name in [loan.customerName, loan.ticketName]) {
    final trimmed = name?.trim() ?? '';
    if (trimmed.isNotEmpty) return trimmed;
  }
  return '';
}

/// Case-insensitive match on the debtor's name or phone digits.
bool barCreditMatchesSearch(ITransaction loan, String query) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return true;
  final name = barCreditDebtorName(loan).toLowerCase();
  if (name.contains(q)) return true;
  final digits = q.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return false;
  final phone = (loan.customerPhone ?? '').replaceAll(RegExp(r'\D'), '');
  return phone.contains(digits);
}

/// A due date picked from the calendar, as the last moment of that local day
/// in UTC. The picker returns local midnight, which would make a loan due
/// today overdue at once.
DateTime barCreditDueEndOfDay(DateTime picked) =>
    DateTime(picked.year, picked.month, picked.day, 23, 59, 59).toUtc();

/// An installment above what the stored loan still owes: another till took
/// a payment after the collect sheet opened.
class BarCreditOverpaid implements Exception {
  const BarCreditOverpaid(this.balance);

  /// What is still owed.
  final double balance;

  @override
  String toString() => 'Only $balance is still owed';
}
