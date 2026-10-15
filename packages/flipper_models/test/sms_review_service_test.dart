import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_models/sms_review/sms_sale_match.dart';
import 'package:flipper_models/sms_review/sms_transfer.dart';
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

SmsReviewItem _item({
  String id = 'sms-1',
  String direction = 'debit',
  String? bankLineId = 'line-1',
  String paymentType = 'BANK TRANSFER',
  String kind = 'principal',
  String bankAccountCode = '1020',
  String providerLabel = 'BK',
  int amount = 2000,
  String occurredAt = '2026-10-14T09:29:21',
}) => SmsReviewItem.fromDitto({
  '_id': id,
  'businessId': 'biz',
  'branchId': 'br',
  'kind': kind,
  'direction': direction,
  'amount': amount,
  'fee': 20,
  'description': 'BK · to Jane DOE · FTCMTEST',
  'providerLabel': providerLabel,
  'paymentType': paymentType,
  'bankAccountCode': bankAccountCode,
  'occurredAt': occurredAt,
  'lineDate': '2026-10-14',
  'status': 'pending_review',
  if (bankLineId != null) 'bankLineId': bankLineId,
});

void main() {
  late _FakeStore store;
  late List<SmsReviewItem> recorded;
  late List<(String, String)> posted;
  late List<String> voided;

  SmsReviewService service({bool fail = false}) {
    store = _FakeStore();
    recorded = [];
    posted = [];
    voided = [];
    return SmsReviewService(
      store: store,
      recordMovement:
          ({required item, required categoryId, required categoryName}) async {
            if (fail) throw StateError('offline');
            recorded.add(item);
            return 'txn-1';
          },
      journalEntryId: (b, t) => 'je_${b}_${t}_sale',
      postTransfer:
          ({required entryId, required item, required otherAccountCode}) async {
            if (fail) throw StateError('offline');
            posted.add((entryId, otherAccountCode));
          },
      voidTransfer: ({required entryId, required item}) async =>
          voided.add(entryId),
      clock: () => DateTime.utc(2026, 10, 14, 12),
    );
  }

  test('reads a connector doc', () {
    final item = _item();
    expect(item.isIncome, isFalse);
    expect(item.movementName, 'Cash Out');
    expect(item.amount, 2000);
    expect(item.occurredAtDate, DateTime(2026, 10, 14, 9, 29, 21));
    expect(_item(direction: 'credit').movementName, 'Cash In');
  });

  test('confirm records once and matches the bank line to its entry', () async {
    final s = service();
    final txn = await s.confirm(_item(), categoryId: 'cat-1');

    expect(txn, 'txn-1');
    expect(recorded, hasLength(1));
    expect(store.statuses['sms-1'], SmsReviewItem.confirmed);
    expect(store.extras['sms-1']?['transactionId'], 'txn-1');
    expect(store.extras['sms-1']?['categoryId'], 'cat-1');
    expect(store.matched, {'line-1': 'je_biz_txn-1_sale'});
  });

  test('a second confirm of the same item records nothing', () async {
    final s = service();
    await s.confirm(_item());
    expect(await s.confirm(_item()), isNull);
    expect(recorded, hasLength(1));
  });

  test('a failed movement puts the item back for a retry', () async {
    final s = service(fail: true);
    await expectLater(s.confirm(_item()), throwsStateError);
    expect(store.statuses['sms-1'], SmsReviewItem.pending);
    expect(store.matched, isEmpty);
  });

  test('without a bank line there is nothing to match', () async {
    final s = service();
    await s.confirm(_item(bankLineId: null));
    expect(store.matched, isEmpty);
  });

  test(
    'ignore closes the item without a movement, and reopen undoes it',
    () async {
      final s = service();
      await s.ignore(_item());
      expect(store.statuses['sms-1'], SmsReviewItem.ignored);
      expect(recorded, isEmpty);

      await s.reopen(_item());
      expect(store.statuses['sms-1'], SmsReviewItem.pending);
      expect(store.matched, {'line-1': null});
    },
  );

  group('transfer between own accounts', () {
    final bankOut = _item();
    final momoIn = _item(
      id: 'sms-2',
      direction: 'credit',
      bankLineId: 'line-2',
      bankAccountCode: kSmsMobileMoneyAccount,
      providerLabel: 'MTN MoMo',
      occurredAt: '2026-10-14T09:31:00',
    );

    test('posts one entry, matches the line, records no movement', () async {
      final s = service();
      final result = await s.recordTransfer(
        bankOut,
        otherAccountCode: kSmsMobileMoneyAccount,
      );

      expect(result?.entryId, 'je_smsxfer_sms-1');
      expect(result?.pairedWith, isNull);
      expect(posted, [('je_smsxfer_sms-1', kSmsMobileMoneyAccount)]);
      expect(recorded, isEmpty);
      expect(store.statuses['sms-1'], SmsReviewItem.transfer);
      expect(store.extras['sms-1']?['otherAccountCode'], '1030');
      expect(store.matched, {'line-1': 'je_smsxfer_sms-1'});
    });

    test('closes the other account\'s SMS against the same entry', () async {
      final s = service();
      final result = await s.recordTransfer(
        bankOut,
        otherAccountCode: kSmsMobileMoneyAccount,
        counterpart: momoIn,
      );

      expect(result?.pairedWith, momoIn);
      expect(posted, hasLength(1));
      expect(store.statuses['sms-2'], SmsReviewItem.transfer);
      expect(store.extras['sms-2']?['otherAccountCode'], '1020');
      expect(store.matched, {
        'line-1': 'je_smsxfer_sms-1',
        'line-2': 'je_smsxfer_sms-1',
      });
    });

    test('a counterpart on another account than chosen stays open', () async {
      final s = service();
      final result = await s.recordTransfer(
        bankOut,
        otherAccountCode: kSmsCashAccount,
        counterpart: momoIn,
      );
      expect(result?.pairedWith, isNull);
      expect(store.statuses['sms-2'], isNull);
    });

    test('a lost claim posts nothing', () async {
      final s = service();
      await s.ignore(bankOut);
      expect(await s.recordTransfer(bankOut, otherAccountCode: '1030'), isNull);
      expect(posted, isEmpty);
      expect(store.statuses['sms-1'], SmsReviewItem.ignored);
    });

    test('a failed post puts the item back for a retry', () async {
      final s = service(fail: true);
      await expectLater(
        s.recordTransfer(bankOut, otherAccountCode: '1030'),
        throwsStateError,
      );
      expect(store.statuses['sms-1'], SmsReviewItem.pending);
      expect(store.matched, isEmpty);
    });

    test('undo voids the entry and reopens both SMS', () async {
      final s = service();
      final result = await s.recordTransfer(
        bankOut,
        otherAccountCode: kSmsMobileMoneyAccount,
        counterpart: momoIn,
      );
      await s.undoTransfer(result!, bankOut);

      expect(voided, ['je_smsxfer_sms-1']);
      expect(store.statuses['sms-1'], SmsReviewItem.pending);
      expect(store.statuses['sms-2'], SmsReviewItem.pending);
      expect(store.extras['sms-1']?['journalEntryId'], isNull);
      expect(store.matched, {'line-1': null, 'line-2': null});
    });

    test('the entry moves money out of the SMS account into the other', () {
      final entry = smsTransferEntry(bankOut, kSmsMobileMoneyAccount);
      expect(entry.status, JournalStatus.posted);
      expect(entry.memo, 'Transfer · BK to Mobile Money');
      expect(entry.date, '2026-10-14');
      expect(entry.ref, startsWith('XFER-'));
      expect(
        [for (final l in entry.lines) (l.ac, l.dr, l.cr)],
        [('1030', 2000, 0), ('1020', 0, 2000)],
      );

      final moneyIn = smsTransferEntry(momoIn, kSmsBankAccount);
      expect(moneyIn.memo, 'Transfer · MTN MoMo from Bank');
      expect(
        [for (final l in moneyIn.lines) (l.ac, l.dr, l.cr)],
        [('1030', 2000, 0), ('1020', 0, 2000)],
      );

      final undone = smsTransferEntry(
        bankOut,
        kSmsCashAccount,
        status: JournalStatus.draft,
      );
      expect(undone.lines, isEmpty);
    });

    test('targets leave out the SMS\'s own account', () {
      expect(smsTransferTargets(bankOut), ['1010', '1030']);
      expect(smsTransferTargets(momoIn), ['1010', '1020']);
    });

    test('the counterpart is the nearest opposite move on another account', () {
      final later = _item(
        id: 'sms-3',
        direction: 'credit',
        bankAccountCode: kSmsMobileMoneyAccount,
        occurredAt: '2026-10-14T15:00:00',
      );
      expect(
        findTransferCounterpart(bankOut, [
          bankOut,
          later,
          momoIn,
          // Same direction, other amount, same account, a day too late, fee.
          _item(id: 'a', bankAccountCode: '1030'),
          _item(
            id: 'b',
            direction: 'credit',
            bankAccountCode: '1030',
            amount: 5,
          ),
          _item(id: 'c', direction: 'credit'),
          _item(
            id: 'd',
            direction: 'credit',
            bankAccountCode: '1030',
            occurredAt: '2026-10-16T09:29:21',
          ),
          _item(
            id: 'e',
            direction: 'credit',
            bankAccountCode: '1030',
            kind: 'fee',
          ),
        ]),
        momoIn,
      );
      expect(findTransferCounterpart(bankOut, [bankOut]), isNull);
    });
  });

  test('linking to a sale records nothing and matches the sale', () async {
    final s = service();
    expect(await s.linkToSale(_item(direction: 'credit'), 'sale-9'), isTrue);

    expect(recorded, isEmpty);
    expect(store.statuses['sms-1'], SmsReviewItem.matched);
    expect(store.extras['sms-1']?['transactionId'], 'sale-9');
    expect(store.matched, {'line-1': 'je_biz_sale-9_sale'});
  });

  test('a link that loses the claim writes nothing', () async {
    final s = service();
    await s.ignore(_item());
    expect(await s.linkToSale(_item(direction: 'credit'), 'sale-9'), isFalse);
    expect(store.statuses['sms-1'], SmsReviewItem.ignored);
    expect(store.matched, isEmpty);
  });

  group('smsMatchingSales', () {
    final momoIn = _item(direction: 'credit', paymentType: 'MOBILE MONEY');
    final at = DateTime(2026, 10, 14, 9, 29, 21);

    SmsSaleCandidate sale(
      String id, {
      double amount = 2000,
      String paymentType = 'MTN MOMO',
      Duration offset = Duration.zero,
      String? receiptType,
      bool isExpense = false,
    }) => SmsSaleCandidate(
      transactionId: id,
      amount: amount,
      paymentType: paymentType,
      createdAt: at.add(offset),
      receiptType: receiptType,
      isExpense: isExpense,
    );

    test('offers same-amount, same-tender sales nearest first', () {
      final found = smsMatchingSales(momoIn, [
        sale('far', offset: const Duration(minutes: -90)),
        sale('near', offset: const Duration(minutes: 5)),
      ]);
      expect(found.map((c) => c.transactionId), ['near', 'far']);
    });

    test('skips other amounts, tenders, times, movements and linked sales', () {
      final found = smsMatchingSales(
        momoIn,
        [
          sale('amount', amount: 2500),
          sale('cash', paymentType: 'CASH'),
          sale('late', offset: const Duration(hours: 3)),
          sale('movement', receiptType: 'Cash In'),
          sale('expense', isExpense: true),
          sale('linked'),
        ],
        linkedTransactionIds: {'linked'},
      );
      expect(found, isEmpty);
    });

    test('money out and charges never match a sale', () {
      final sales = [sale('s1', paymentType: 'BANK TRANSFER')];
      expect(smsMatchingSales(_item(), sales), isEmpty);
      expect(
        smsMatchingSales(_item(direction: 'credit', kind: 'fee'), sales),
        isEmpty,
      );
    });
  });
}
