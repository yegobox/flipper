import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/sync/capella/mixins/bar_mixin.dart';
import 'package:flipper_models/sync/utils/bar_credit_utils.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/locator.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:talker/talker.dart';

import 'support/fake_ditto.dart';

// flutter test test/bar_mixin_test.dart

const _branch = 'branch-1';

/// Exercises [CapellaBarMixin] against an in-memory store.
class _BarSync with CapellaBarMixin {
  _BarSync(this.fake);

  final FakeDitto fake;

  @override
  dynamic get dittoHandle => fake;

  /// Never reached: [dittoHandle] is overridden above.
  @override
  DittoService get dittoService =>
      throw UnimplementedError('tests go through dittoHandle');

  @override
  final Talker talker = Talker();
}

/// Minimal box: opening a tab only asks for the default payment type and the
/// sale mode its receipt type comes from.
class _FakeBox extends Mock implements LocalStorage {
  @override
  String? getBranchId() => _branch;
  @override
  String? getBusinessId() => 'biz1';
  @override
  String? paymentType() => 'Cash';
  @override
  bool isProformaMode() => false;
  @override
  bool isTrainingMode() => false;
}

const _table = BarTable(
  id: 'table-1',
  branchId: _branch,
  zoneId: 'zone-1',
  zoneName: 'Terrace',
  name: 'T1',
  seats: 4,
);

void main() {
  late FakeDitto ditto;
  late _BarSync sync;

  setUp(() async {
    await getIt.reset();
    getIt.registerSingleton<LocalStorage>(_FakeBox());
    ITransactionDittoAdapter.instance.overrideBranchIdProvider(() => _branch);
    ITransactionDittoAdapter.instance.overrideBusinessIdProvider(() => 'biz1');
    ditto = FakeDitto();
    sync = _BarSync(ditto);
  });

  tearDown(() async {
    ITransactionDittoAdapter.instance.resetOverrides();
    await getIt.reset();
  });

  group('Transaction Report fields', () {
    test(
      'an open tab carries a receipt type and a local report date',
      () async {
        final tab = await sync.openBarTab(
          branchId: _branch,
          table: _table,
          cashierTenantId: 'c1',
          cashierName: 'Richie',
        );

        final stored = ditto.store.collections['transactions']![tab.id]!;
        // Regression: a null receiptType crashed the Z/X report and left the
        // report's Type column blank for every bar tab.
        expect(stored['receiptType'], TransactionReceptType.NS);
        // Report windows are local wall clock compared as strings; a UTC stamp
        // files the hours after midnight under the previous day.
        expect(stored['createdAt'] as String, isNot(endsWith('Z')));
      },
    );

    test(
      'a settled tab is reported on the day it is paid, with its lines',
      () async {
        final tab = await sync.openBarTab(
          branchId: _branch,
          table: _table,
          cashierTenantId: 'c1',
          cashierName: 'Richie',
        );

        // A tab opened before midnight, with a round ordered then too.
        const lastNight = '2026-01-10T22:30:00.000';
        ditto.store.collections['transactions']![tab.id]!['createdAt'] =
            lastNight;
        ditto.store.seed('transaction_items', {
          '_id': 'line-1',
          'id': 'line-1',
          'transactionId': tab.id,
          'branchId': _branch,
          'name': 'Beer',
          'qty': 2,
          'price': 1500,
          'variantId': 'v1',
          'active': true,
          'doneWithTransaction': false,
          'createdAt': lastNight,
        });

        final open = await sync.barTabForTableById(tab.id);
        final before = DateTime.now();
        final settled = await sync.settleBarTab(
          transaction: open!,
          lines: await sync.barTabLines(transactionId: tab.id),
          paymentType: 'Cash',
          cashReceived: 3000,
          customerChangeDue: 0,
        );

        expect(settled.status, COMPLETE);
        expect(settled.createdAt!.isUtc, isFalse);
        expect(settled.createdAt!.isBefore(before), isFalse);

        final stored = ditto.store.collections['transactions']![tab.id]!;
        expect(stored['createdAt'], settled.createdAt!.toIso8601String());

        final line = ditto.store.collections['transaction_items']!['line-1']!;
        expect(line['createdAt'], settled.createdAt!.toIso8601String());
      },
    );

    test(
      'a failed line re-stamp leaves the tab open, not half-settled',
      () async {
        final tab = await sync.openBarTab(
          branchId: _branch,
          table: _table,
          cashierTenantId: 'c1',
          cashierName: 'Richie',
        );
        ditto.store.seed('transaction_items', {
          '_id': 'line-1',
          'id': 'line-1',
          'transactionId': tab.id,
          'branchId': _branch,
          'name': 'Beer',
          'qty': 2,
          'price': 1500,
          'variantId': 'v1',
        });

        final open = await sync.barTabForTableById(tab.id);
        final seenStatuses = <Object?>[];
        ditto.store.registerObserver(
          'SELECT * FROM transactions WHERE _id = :id OR id = :id',
          arguments: {'id': tab.id},
          onChange: (r) =>
              seenStatuses.addAll(r.items.map((i) => i.value['status'])),
        );
        ditto.store.failOn = 'UPDATE transaction_items';
        await expectLater(
          sync.settleBarTab(
            transaction: open!,
            lines: await sync.barTabLines(transactionId: tab.id),
            paymentType: 'Cash',
            cashReceived: 3000,
            customerChangeDue: 0,
          ),
          throwsStateError,
        );

        // Still parked on its table, so the cashier can simply settle again.
        final stored = ditto.store.collections['transactions']![tab.id]!;
        expect(stored['status'], PARKED);
        expect(stored['tableId'], _table.id);

        // And no observer ever saw the rolled-back completion.
        await Future<void>.delayed(Duration.zero);
        expect(seenStatuses, isNot(contains(COMPLETE)));
      },
    );
  });

  group('Credit', () {
    /// A tab on [_table] with two beers (RWF 3,000) logged on it.
    Future<ITransaction> beerTab() async {
      final tab = await sync.openBarTab(
        branchId: _branch,
        table: _table,
        cashierTenantId: 'c1',
        cashierName: 'Richie',
      );
      ditto.store.seed('transaction_items', {
        '_id': 'line-1',
        'id': 'line-1',
        'transactionId': tab.id,
        'branchId': _branch,
        'name': 'Beer',
        'qty': 2,
        'price': 1500,
        'variantId': 'v1',
        'active': true,
        'doneWithTransaction': false,
      });
      // The UI holds the tab as it was when the table opened: subTotal 0.
      return tab;
    }

    Future<ITransaction> putOnCredit(ITransaction tab) async =>
        sync.parkBarTabAsLoan(
          transaction: tab,
          lines: await sync.barTabLines(transactionId: tab.id),
          customerId: 'cust-1',
          customerName: 'Aline',
          customerPhone: '788000000',
          dueDate: DateTime.utc(2026, 11, 9),
        );

    test('a tab on credit is a parked loan for the full bill', () async {
      final tab = await beerTab();
      await putOnCredit(tab);

      final stored = ditto.store.collections['transactions']![tab.id]!;
      expect(stored['status'], PARKED);
      expect(stored['isLoan'], isTrue);
      expect(stored['customerId'], 'cust-1');
      expect(stored['ticketName'], 'Aline');
      expect(stored['paymentType'], 'CREDIT');
      expect(stored['dueDate'], startsWith('2026-11-09'));
      expect(stored['subTotal'], 3000);
      expect(stored['originalLoanAmount'], 3000);
      expect(stored['remainingBalance'], 3000);
      expect(stored['cashReceived'], 0);
      // The receivable the connector books splits VAT out of revenue.
      expect(stored['taxAmount'] as num, greaterThan(0));
      expect(stored['note'], 'Bar · T1 · Opened by Richie');
    });

    test('the table frees up and the loan joins the credit list', () async {
      final tab = await beerTab();
      await putOnCredit(tab);

      final stored = ditto.store.collections['transactions']![tab.id]!;
      expect(stored['tableId'], isNull);
      expect(
        await sync.barTabForTable(branchId: _branch, tableId: _table.id),
        isNull,
      );
      expect(await sync.barTabsStream(branchId: _branch).first, isEmpty);

      final credit = await sync.barCreditTabsStream(branchId: _branch).first;
      expect(credit.map((t) => t.id), [tab.id]);
    });

    test('an empty tab cannot go on credit', () async {
      final tab = await sync.openBarTab(
        branchId: _branch,
        table: _table,
        cashierTenantId: 'c1',
        cashierName: 'Richie',
      );
      await expectLater(
        sync.parkBarTabAsLoan(
          transaction: tab,
          lines: const [],
          customerId: 'cust-1',
          customerName: 'Aline',
          dueDate: DateTime.utc(2026, 11, 9),
        ),
        throwsStateError,
      );
      final stored = ditto.store.collections['transactions']![tab.id]!;
      expect(stored['isLoan'], isNot(isTrue));
      expect(stored['tableId'], _table.id);
    });

    test('a part payment leaves the rest owed', () async {
      final loan = await putOnCredit(await beerTab());

      final after = await sync.collectBarCreditPayment(
        transaction: loan,
        payments: const [
          PaymentLineForSaleCompletion(amount: 1000, method: 'Cash'),
        ],
      );

      final stored = ditto.store.collections['transactions']![loan.id]!;
      expect(stored['status'], PARKED);
      expect(stored['isLoan'], isTrue);
      expect(stored['cashReceived'], 1000);
      expect(stored['remainingBalance'], 2000);
      // Still a credit sale until the last of it comes in.
      expect(stored['paymentType'], 'CREDIT');
      expect(after.remainingBalance, 2000);
      final credit = await sync.barCreditTabsStream(branchId: _branch).first;
      expect(credit.map((t) => t.id), [loan.id]);
    });

    test('the last installment completes the sale', () async {
      final loan = await putOnCredit(await beerTab());
      final part = await sync.collectBarCreditPayment(
        transaction: loan,
        payments: const [
          PaymentLineForSaleCompletion(amount: 1000, method: 'Cash'),
        ],
      );

      await sync.collectBarCreditPayment(
        transaction: part,
        payments: const [
          PaymentLineForSaleCompletion(amount: 2000, method: 'MOBILE MONEY'),
        ],
      );

      final stored = ditto.store.collections['transactions']![loan.id]!;
      expect(stored['status'], COMPLETE);
      expect(stored['isLoan'], isFalse);
      expect(stored['cashReceived'], 3000);
      expect(stored['remainingBalance'], 0);
      expect(stored['paymentType'], 'MOBILE MONEY');
      expect(await sync.barCreditTabsStream(branchId: _branch).first, isEmpty);

      // Reported on the day it was paid off, lines and all, in local time.
      final paidOff = stored['createdAt'] as String;
      expect(paidOff, isNot(endsWith('Z')));
      final line = ditto.store.collections['transaction_items']!['line-1']!;
      expect(line['createdAt'], paidOff);
    });

    List<Map<String, dynamic>> paymentRows(String loanId) => [
      ...?ditto.store.collections['transaction_payment_records']?.values.where(
        (r) => r['transactionId'] == loanId,
      ),
    ];

    test('each installment writes its payment row with the loan', () async {
      final loan = await putOnCredit(await beerTab());
      await sync.collectBarCreditPayment(
        transaction: loan,
        payments: const [
          PaymentLineForSaleCompletion(amount: 1000, method: 'Cash'),
        ],
      );

      final rows = paymentRows(loan.id);
      expect(rows, hasLength(1));
      expect(rows.single['amount'], 1000);
      expect(rows.single['paymentMethod'], 'Cash');
    });

    test('a failed payment row leaves the loan as it was', () async {
      final loan = await putOnCredit(await beerTab());
      ditto.store.failOn = 'INSERT INTO transaction_payment_records';

      await expectLater(
        sync.collectBarCreditPayment(
          transaction: loan,
          payments: const [
            PaymentLineForSaleCompletion(amount: 1000, method: 'Cash'),
          ],
        ),
        throwsStateError,
      );

      final stored = ditto.store.collections['transactions']![loan.id]!;
      expect(stored['remainingBalance'], 3000);
      expect(stored['cashReceived'], 0);
      expect(paymentRows(loan.id), isEmpty);
    });

    /// Two tills hold the same loan: the second one's copy is stale.
    test(
      'an installment counts on top of payments another till took',
      () async {
        final loan = await putOnCredit(await beerTab());
        await sync.collectBarCreditPayment(
          transaction: loan,
          payments: const [
            PaymentLineForSaleCompletion(amount: 1000, method: 'Cash'),
          ],
        );

        final after = await sync.collectBarCreditPayment(
          transaction: loan,
          payments: const [
            PaymentLineForSaleCompletion(amount: 500, method: 'Cash'),
          ],
        );

        final stored = ditto.store.collections['transactions']![loan.id]!;
        expect(stored['cashReceived'], 1500);
        expect(stored['remainingBalance'], 1500);
        expect(after.remainingBalance, 1500);
        expect(paymentRows(loan.id), hasLength(2));
      },
    );

    test('more than is still owed is refused', () async {
      final loan = await putOnCredit(await beerTab());
      await sync.collectBarCreditPayment(
        transaction: loan,
        payments: const [
          PaymentLineForSaleCompletion(amount: 1000, method: 'Cash'),
        ],
      );

      // The stale copy still says 3,000 is owed; only 2,000 is.
      await expectLater(
        sync.collectBarCreditPayment(
          transaction: loan,
          payments: const [
            PaymentLineForSaleCompletion(amount: 2500, method: 'Cash'),
          ],
        ),
        throwsA(
          isA<BarCreditOverpaid>().having((e) => e.balance, 'balance', 2000),
        ),
      );

      final stored = ditto.store.collections['transactions']![loan.id]!;
      expect(stored['remainingBalance'], 2000);
      expect(stored['status'], PARKED);
      expect(paymentRows(loan.id), hasLength(1));
    });

    test('a paid-off or missing loan takes no payment', () async {
      final loan = await putOnCredit(await beerTab());
      await sync.collectBarCreditPayment(
        transaction: loan,
        payments: const [
          PaymentLineForSaleCompletion(amount: 3000, method: 'Cash'),
        ],
      );
      const more = [PaymentLineForSaleCompletion(amount: 100, method: 'Cash')];

      await expectLater(
        sync.collectBarCreditPayment(transaction: loan, payments: more),
        throwsStateError,
      );
      ditto.store.collections['transactions']!.remove(loan.id);
      await expectLater(
        sync.collectBarCreditPayment(transaction: loan, payments: more),
        throwsStateError,
      );
      expect(paymentRows(loan.id), hasLength(1));
    });
  });
}
