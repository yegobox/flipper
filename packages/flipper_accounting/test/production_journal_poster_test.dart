import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/production_journal_poster.dart';
import 'package:flipper_accounting/statutory_accounts.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

// flutter test test/production_journal_poster_test.dart
//
// Goods made without a recipe were never valued: their ingredients and labour
// stayed in expenses while their sale took cost out of stock, so 1200 drifted
// negative. Each batch now moves qty × cost into stock (Dr 1200 / Cr 5020).

ProductionOutputRecord _batch({
  String id = 'out-1',
  double qty = 10,
  double unitCost = 150,
}) => ProductionOutputRecord(
  outputId: id,
  productName: 'Bread',
  qty: qty,
  unitCost: unitCost,
  recordedAt: DateTime(2026, 11, 23, 10),
);

void main() {
  test('5020 is a contra cost-of-sales account in the seed', () {
    final account = seedAccount(productionCostAbsorbedCode)!;
    expect(account.type, AccountType.expense);
    expect(account.sub, 'Cost of sales');
    expect(account.normal, AccountNormal.credit);
    expect(account.contra, isTrue);
  });

  group('plan', () {
    test('a batch moves qty × cost into stock out of expenses', () {
      final plan = ProductionJournalPoster.plan(
        businessId: 'biz',
        outputs: [_batch(qty: 2.5, unitCost: 101)],
      );
      final p = plan.single;
      expect(p.entryId, 'je_biz_prodout_out-1');
      expect(p.ref, 'PRD-out-1');
      expect(p.memo, 'Production: Bread');
      expect(p.lines.map((l) => (l.ac, l.dr, l.cr)), [
        ('1200', 253, 0),
        ('5020', 0, 253),
      ]);
    });

    test('a batch with no cost or no quantity posts nothing', () {
      expect(
        ProductionJournalPoster.plan(
          businessId: 'biz',
          outputs: [
            _batch(unitCost: 0),
            _batch(id: 'out-2', qty: 0),
          ],
        ),
        isEmpty,
      );
    });

    test('a long output id is cut to eight characters in the ref', () {
      final plan = ProductionJournalPoster.plan(
        businessId: 'biz',
        outputs: [_batch(id: 'abcdef123456')],
      );
      expect(plan.single.ref, 'PRD-abcdef12');
    });
  });

  group('sync', () {
    test('posts each batch once, however often it runs', () async {
      final store = InMemoryAccountingStore();
      final poster = ProductionJournalPoster(store);

      Future<int> run() => poster.sync(
        businessId: 'biz',
        outputs: [
          _batch(),
          _batch(id: 'out-2', qty: 4),
        ],
      );

      expect(await run(), 2);
      expect(await run(), 0);
      final entries = store.all('journal_entries');
      expect(entries, hasLength(2));
      for (final e in entries) {
        expect(e['status'], 'posted');
      }
      // 14 loaves at 150 = 2,100 moved into stock, out of costs.
      expect(store.creditBalance('5020'), 2100);
      expect(store.creditBalance('1200'), -2100);
    });

    test('nothing to post reads nothing', () async {
      final store = InMemoryAccountingStore();
      expect(
        await ProductionJournalPoster(
          store,
        ).sync(businessId: 'biz', outputs: [_batch(unitCost: 0)]),
        0,
      );
      expect(
        await ProductionJournalPoster(
          store,
        ).sync(businessId: '', outputs: [_batch()]),
        0,
      );
      expect(store.all('journal_entries'), isEmpty);
    });
  });
}
