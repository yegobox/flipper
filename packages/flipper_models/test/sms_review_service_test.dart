import 'package:flipper_models/sms_review/sms_review_item.dart';
import 'package:flipper_models/sms_review/sms_review_service.dart';
import 'package:flipper_models/sms_review/sms_sale_match.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeStore implements SmsReviewStore {
  final statuses = <String, String>{};
  final extras = <String, Map<String, Object?>>{};
  final matched = <String, String>{};

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
  Future<void> matchBankLine(String bankLineId, String journalEntryId) async {
    matched[bankLineId] = journalEntryId;
  }
}

SmsReviewItem _item({
  String direction = 'debit',
  String? bankLineId = 'line-1',
  String paymentType = 'BANK TRANSFER',
  String kind = 'principal',
}) => SmsReviewItem.fromDitto({
  '_id': 'sms-1',
  'businessId': 'biz',
  'branchId': 'br',
  'kind': kind,
  'direction': direction,
  'amount': 2000,
  'fee': 20,
  'description': 'BK · to Jane DOE · FTCMTEST',
  'providerLabel': 'BK',
  'paymentType': paymentType,
  'bankAccountCode': '1020',
  'occurredAt': '2026-10-14T09:29:21',
  'lineDate': '2026-10-14',
  'status': 'pending_review',
  if (bankLineId != null) 'bankLineId': bankLineId,
});

void main() {
  late _FakeStore store;
  late List<SmsReviewItem> recorded;

  SmsReviewService service({bool fail = false}) {
    store = _FakeStore();
    recorded = [];
    return SmsReviewService(
      store: store,
      recordMovement:
          ({required item, required categoryId, required categoryName}) async {
            if (fail) throw StateError('offline');
            recorded.add(item);
            return 'txn-1';
          },
      journalEntryId: (b, t) => 'je_${b}_${t}_sale',
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

  test('ignore and transfer close the item without a movement', () async {
    final s = service();
    await s.ignore(_item());
    expect(store.statuses['sms-1'], SmsReviewItem.ignored);
    await s.markTransfer(_item());
    expect(store.statuses['sms-1'], SmsReviewItem.transfer);
    expect(recorded, isEmpty);
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
