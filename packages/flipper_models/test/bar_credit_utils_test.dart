import 'package:flipper_models/sync/utils/bar_credit_utils.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

// flutter test test/bar_credit_utils_test.dart

final _now = DateTime.utc(2026, 10, 26, 12);

ITransaction _loan(
  String id, {
  DateTime? due,
  num? remaining,
  num subTotal = 3000,
  double cashReceived = 0,
  String? note,
  String? customerName,
  String? customerPhone,
  DateTime? createdAt,
}) {
  return ITransaction(
    id: id,
    branchId: 'b1',
    status: 'parked',
    transactionType: 'Sale',
    paymentType: 'CREDIT',
    subTotal: subTotal.toDouble(),
    cashReceived: cashReceived,
    customerChangeDue: 0,
    isIncome: true,
    isExpense: false,
    agentId: 'c1',
    isLoan: true,
    dueDate: due,
    remainingBalance: remaining,
    note: note,
    customerName: customerName,
    customerPhone: customerPhone,
    createdAt: createdAt ?? _now,
    updatedAt: _now,
    lastTouched: _now,
  );
}

void main() {
  test('the note keeps the table and opener', () {
    expect(
      barCreditNote(tableName: 'T4', opened: 'Opened by Ana'),
      'Bar · T4 · Opened by Ana',
    );
    expect(barCreditNote(tableName: null, opened: ''), 'Bar');
  });

  test('only bar loans are marked as from the bar', () {
    expect(barCreditIsFromBar(_loan('a', note: 'Bar · T4 · x')), isTrue);
    expect(barCreditIsFromBar(_loan('b', note: 'Bar')), isTrue);
    expect(barCreditIsFromBar(_loan('c', note: 'Barbara owes')), isFalse);
    expect(barCreditIsFromBar(_loan('d')), isFalse);
  });

  test('a paid-up loan is no longer open', () {
    expect(barCreditIsOpen(_loan('a', remaining: 3000)), isTrue);
    expect(barCreditIsOpen(_loan('b', remaining: 0)), isFalse);
    expect(barCreditIsOpen(_loan('c', remaining: 0.004)), isFalse);
  });

  test('the balance falls back to total minus paid', () {
    final loan = _loan('a', cashReceived: 1000)..remainingBalance = null;
    expect(barCreditBalance(loan), 2000);
  });

  test('overdue first, then soonest due, undated last', () {
    final sorted = sortBarCreditTabs([
      _loan('undated'),
      _loan('later', due: _now.add(const Duration(days: 10))),
      _loan('overdue', due: _now.subtract(const Duration(days: 1))),
      _loan('soon', due: _now.add(const Duration(days: 2))),
    ], now: _now);
    expect(sorted.map((t) => t.id), ['overdue', 'soon', 'later', 'undated']);
  });

  test('search matches the name or the phone digits', () {
    final loan = _loan(
      'a',
      customerName: 'Aline Uwase',
      customerPhone: '0788 123 456',
    );
    expect(barCreditMatchesSearch(loan, 'aline'), isTrue);
    expect(barCreditMatchesSearch(loan, '788123'), isTrue);
    expect(barCreditMatchesSearch(loan, 'jean'), isFalse);
    expect(barCreditMatchesSearch(loan, ''), isTrue);
  });

  test('a picked due date lasts to the end of that day', () {
    final due = barCreditDueEndOfDay(DateTime(2026, 11, 9));
    expect(due.isUtc, isTrue);
    expect(due.toLocal(), DateTime(2026, 11, 9, 23, 59, 59));
    // Due today is not overdue yet.
    final today = DateTime.now();
    final loan = _loan('l1', due: barCreditDueEndOfDay(today));
    expect(barCreditIsOverdue(loan, now: today), isFalse);
  });

  test('an overpayment says what is still owed', () {
    expect(
      const BarCreditOverpaid(2000).toString(),
      'Only 2000.0 is still owed',
    );
  });
}
