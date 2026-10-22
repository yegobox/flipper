import 'package:flipper_models/sms_review/sms_debt_match.dart';
import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStore implements SmsReviewStore {
  final statuses = <String, String>{};
  final extras = <String, Map<String, Object?>>{};
  final matched = <String, String?>{};

  @override
  Future<bool> claim(String id) async {
    if ((statuses[id] ?? SmsReviewItem.pending) != SmsReviewItem.pending) {
      return false;
    }
    statuses[id] = SmsReviewItem.confirming;
    return true;
  }

  @override
  Future<void> setStatus(
    String id,
    String status, {
    Map<String, Object?> extra = const {},
  }) async {
    statuses[id] = status;
    extras[id] = extra;
  }

  @override
  Future<void> matchBankLine(String bankLineId, String? journalEntryId) async {
    matched[bankLineId] = journalEntryId;
  }
}

/// Synthetic MoMo payment received.
SmsReviewItem _sms({
  String direction = 'credit',
  String kind = 'principal',
  int amount = 2000,
  String? name = 'Jane DOE',
  String? account = '****0123',
  String? bankLineId = 'line-1',
}) => SmsReviewItem.fromDitto({
  '_id': 'sms-1',
  'businessId': 'biz',
  'branchId': 'br',
  'kind': kind,
  'direction': direction,
  'amount': amount,
  'fee': 0,
  'description': 'MTN MoMo · from Jane DOE',
  'providerLabel': 'MTN MoMo',
  'paymentType': 'MTN MOMO',
  'bankAccountCode': '1030',
  'occurredAt': '2026-10-22T09:00:00',
  'status': 'pending_review',
  if (name != null) 'counterpartyName': name,
  if (account != null) 'counterpartyAccount': account,
  if (bankLineId != null) 'bankLineId': bankLineId,
});

SmsDebtCandidate _debt(
  String id, {
  double remaining = 5000,
  String? name,
  String? phone,
}) => SmsDebtCandidate(
  transactionId: id,
  remainingBalance: remaining,
  customerName: name,
  customerPhone: phone,
);

void main() {
  test('reads an open credit sale from Ditto', () {
    final d = SmsDebtCandidate.fromDitto({
      '_id': 'txn-1',
      'remainingBalance': 3000,
      'customerName': ' Jane DOE ',
      'customerPhone': '250780000123',
      'createdAt': '2026-10-20T10:00:00',
    });
    expect(d.transactionId, 'txn-1');
    expect(d.remainingBalance, 3000);
    expect(d.customerName, 'Jane DOE');
    expect(d.phoneHint, '****0123');
    expect(d.createdAt, DateTime(2026, 10, 20, 10));

    final bare = SmsDebtCandidate.fromDitto({
      'id': 'txn-2',
      'customerName': '',
    });
    expect(bare.remainingBalance, 0);
    expect(bare.customerName, isNull);
    expect(bare.phoneHint, isNull);
    expect(SmsDebtCandidate.fromDitto({}).transactionId, '');
  });

  test('the payer\'s number and name pick the debt, phone first', () {
    final debts = [
      _debt('name-only', name: 'Jane Mukamana', phone: '0788999999'),
      _debt('phone-only', name: 'J. M.', phone: '0780000123'),
      _debt('both', name: 'Jane Doe', phone: '+250 780 000 123'),
      _debt('stranger', name: 'Eric', phone: '0788111111'),
      // Owes less than the SMS paid, nothing left, or no id.
      _debt('small', remaining: 1000, name: 'Jane', phone: '0780000123'),
      _debt('cleared', remaining: 0, name: 'Jane', phone: '0780000123'),
      _debt('', name: 'Jane', phone: '0780000123'),
    ];
    expect(smsMatchingDebts(_sms(), debts).map((d) => d.transactionId), [
      'both',
      'phone-only',
      'name-only',
    ]);
  });

  test('an exact payoff ranks first among equals', () {
    final debts = [
      _debt('more', remaining: 9000, name: 'Jane'),
      _debt('exact', remaining: 2000, name: 'Jane'),
    ];
    expect(smsMatchingDebts(_sms(), debts).first.transactionId, 'exact');
  });

  test('money out, charges, and an unknown payer match nothing', () {
    final debts = [_debt('d', name: 'Jane', phone: '0780000123')];
    expect(smsMatchingDebts(_sms(direction: 'debit'), debts), isEmpty);
    expect(smsMatchingDebts(_sms(kind: 'fee'), debts), isEmpty);
    expect(smsMatchingDebts(_sms(name: null, account: null), debts), isEmpty);
    expect(smsCanSettleDebt(_sms()), isTrue);
  });

  test('a repayment is an installment, and the last one closes the loan', () {
    final part = applySmsRepayment(
      cashReceived: 1000,
      remaining: 5000,
      amount: 2000,
    );
    expect(part, (cashReceived: 3000.0, remaining: 3000.0, stillLoan: true));
    final last = applySmsRepayment(
      cashReceived: 3000,
      remaining: 3000,
      amount: 3000,
    );
    expect(last, (cashReceived: 6000.0, remaining: 0.0, stillLoan: false));
  });

  test('the repayment entry id is the connector\'s', () {
    final at = DateTime.utc(2026, 10, 22, 7);
    expect(
      smsLoanPaymentEntryId('biz', 'txn-1', at),
      'je_biz_txn-1_pay_${at.millisecondsSinceEpoch}',
    );
  });

  group('settleDebt', () {
    late _FakeStore store;
    late List<(String, String)> recorded;

    SmsReviewService service({SmsDebtRepaymentRecorder? recorder}) {
      store = _FakeStore();
      recorded = [];
      return SmsReviewService(
        store: store,
        recordMovement:
            ({required item, required categoryId, required categoryName}) =>
                throw UnimplementedError(),
        journalEntryId: (b, t) => 'je_${b}_${t}_sale',
        postTransfer:
            ({required entryId, required item, required otherAccountCode}) =>
                throw UnimplementedError(),
        voidTransfer: ({required entryId, required item}) =>
            throw UnimplementedError(),
        recordRepayment:
            recorder ??
            ({required item, required debt}) async {
              recorded.add((item.id, debt.transactionId));
              return (
                transactionId: debt.transactionId,
                remaining: 3000.0,
                journalEntryId: 'je_biz_${debt.transactionId}_pay_1',
              );
            },
        clock: () => DateTime.utc(2026, 10, 22, 12),
      );
    }

    test('records once, closes the SMS and matches the bank line', () async {
      final s = service();
      final settled = await s.settleDebt(_sms(), _debt('txn-1'));
      expect(settled?.remaining, 3000);
      expect(recorded, [('sms-1', 'txn-1')]);
      expect(store.statuses['sms-1'], SmsReviewItem.matched);
      expect(store.extras['sms-1']?['transactionId'], 'txn-1');
      expect(store.extras['sms-1']?['settledDebt'], isTrue);
      expect(store.matched, {'line-1': 'je_biz_txn-1_pay_1'});

      // Another till got there first: nothing more is recorded.
      expect(await s.settleDebt(_sms(), _debt('txn-1')), isNull);
      expect(recorded, hasLength(1));
    });

    test('without a bank line nothing is matched', () async {
      final s = service();
      await s.settleDebt(_sms(bankLineId: null), _debt('txn-1'));
      expect(store.matched, isEmpty);
    });

    test('a failed repayment puts the SMS back for review', () async {
      final s = service(
        recorder: ({required item, required debt}) =>
            throw StateError('debt closed'),
      );
      await expectLater(
        s.settleDebt(_sms(), _debt('txn-1')),
        throwsA(isA<StateError>()),
      );
      expect(store.statuses['sms-1'], SmsReviewItem.pending);
    });

    test('is refused where repayments are not wired', () async {
      final s = SmsReviewService(
        store: _FakeStore(),
        recordMovement:
            ({required item, required categoryId, required categoryName}) =>
                throw UnimplementedError(),
        journalEntryId: (b, t) => '',
        postTransfer:
            ({required entryId, required item, required otherAccountCode}) =>
                throw UnimplementedError(),
        voidTransfer: ({required entryId, required item}) =>
            throw UnimplementedError(),
      );
      expect(
        () => s.settleDebt(_sms(), _debt('txn-1')),
        throwsA(isA<StateError>()),
      );
    });
  });
}
