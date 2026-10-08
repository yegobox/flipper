import 'package:flipper_dashboard/cashbook_form_rules.dart';
import 'package:flutter_test/flutter_test.dart';

typedef _Cat = ({String id, String name});

String _id(_Cat c) => c.id;
String _name(_Cat c) => c.name;

void main() {
  group('initialCashbookPaymentMethod', () {
    test('defaults to cash with no history', () {
      expect(initialCashbookPaymentMethod(null), cashbookMethodCash);
    });

    test('remembers MoMo and Airtel', () {
      expect(initialCashbookPaymentMethod('MTN MOMO'), cashbookMethodMtn);
      expect(
        initialCashbookPaymentMethod('AIRTEL MONEY'),
        cashbookMethodAirtel,
      );
    });

    test('ignores a stale value from POS checkout', () {
      expect(initialCashbookPaymentMethod('CREDIT'), cashbookMethodCash);
    });
  });

  group('initialCashbookCategoryId', () {
    test('preselects the last used category when it still exists', () {
      expect(initialCashbookCategoryId(['a', 'b'], 'b'), 'b');
    });

    test('selects nothing when the last category was deleted', () {
      expect(initialCashbookCategoryId(['a'], 'gone'), isNull);
    });

    test('selects nothing on first use', () {
      expect(initialCashbookCategoryId(['a'], null), isNull);
      expect(initialCashbookCategoryId(['a'], ''), isNull);
    });
  });

  test('last category is remembered per direction', () {
    expect(
      cashbookLastCategoryKey(isIncome: true),
      isNot(cashbookLastCategoryKey(isIncome: false)),
    );
  });

  group('orderCashbookCategories', () {
    const cats = <_Cat>[
      (id: '1', name: 'transport'),
      (id: '2', name: 'Rent'),
      (id: '3', name: '  '),
      (id: '4', name: 'Airtime'),
    ];

    test('lists every named category alphabetically', () {
      final out = orderCashbookCategories(cats, id: _id, name: _name);
      expect(out.map((c) => c.id), ['4', '2', '1']);
    });

    test('puts the selected category first', () {
      final out = orderCashbookCategories(
        cats,
        id: _id,
        name: _name,
        selectedId: '1',
      );
      expect(out.map((c) => c.id), ['1', '4', '2']);
    });
  });

  test('findCashbookCategoryByName matches ignoring case and spaces', () {
    const cats = <_Cat>[(id: '1', name: 'Transport')];
    expect(
      findCashbookCategoryByName(cats, ' transport ', name: _name)?.id,
      '1',
    );
    expect(findCashbookCategoryByName(cats, 'Rent', name: _name), isNull);
    expect(findCashbookCategoryByName(cats, '   ', name: _name), isNull);
  });

  group('cashbookCategorySuggestions', () {
    test('offers direction-specific names', () {
      expect(
        cashbookCategorySuggestions(isIncome: false, existingNames: const []),
        contains('Transport'),
      );
      expect(
        cashbookCategorySuggestions(isIncome: true, existingNames: const []),
        contains('Sales'),
      );
    });

    test('hides names the branch already has', () {
      final out = cashbookCategorySuggestions(
        isIncome: false,
        existingNames: const [' transport', 'RENT'],
      );
      expect(out, isNot(contains('Transport')));
      expect(out, isNot(contains('Rent')));
      expect(out, contains('Salaries'));
    });
  });

  group('resolveCashbookSelectedCategory', () {
    const loaded = <_Cat>[(id: '1', name: 'Rent')];
    const created = (id: 'new', name: 'Fuel');

    test('uses the loaded category when the stream has it', () {
      expect(
        resolveCashbookSelectedCategory<_Cat>(
          selectedId: '1',
          loaded: loaded,
          createdHere: created,
          id: _id,
        ),
        loaded.first,
      );
    });

    test('falls back to a just-created category the stream lacks', () {
      expect(
        resolveCashbookSelectedCategory<_Cat>(
          selectedId: 'new',
          loaded: loaded,
          createdHere: created,
          id: _id,
        ),
        created,
      );
    });

    test('returns null with no selection or a vanished one', () {
      expect(
        resolveCashbookSelectedCategory<_Cat>(
          selectedId: null,
          loaded: loaded,
          createdHere: created,
          id: _id,
        ),
        isNull,
      );
      expect(
        resolveCashbookSelectedCategory<_Cat>(
          selectedId: 'gone',
          loaded: loaded,
          createdHere: created,
          id: _id,
        ),
        isNull,
      );
    });
  });

  group('classifyCashbookEntry', () {
    test('cash book receipt types win over the category name', () {
      expect(
        classifyCashbookEntry(
          receiptType: 'Cash Out',
          transactionType: 'Transport',
          isIncome: false,
        ),
        CashbookEntryKind.cashOut,
      );
      expect(
        classifyCashbookEntry(
          receiptType: 'Cash In',
          transactionType: 'Owner deposit',
          isIncome: true,
        ),
        CashbookEntryKind.cashIn,
      );
    });

    test('POS sales are sales', () {
      expect(
        classifyCashbookEntry(
          receiptType: null,
          transactionType: 'Sale',
          isIncome: true,
        ),
        CashbookEntryKind.sale,
      );
    });

    test('falls back to the direction when no receipt type is set', () {
      expect(
        classifyCashbookEntry(
          receiptType: null,
          transactionType: 'Cash Out',
          isIncome: false,
        ),
        CashbookEntryKind.cashOut,
      );
      expect(
        classifyCashbookEntry(
          receiptType: null,
          transactionType: 'Rent',
          isIncome: false,
        ),
        CashbookEntryKind.cashOut,
      );
    });
  });

  group('cashbookRowLabels', () {
    test('cash out shows its category beneath the label', () {
      final l = cashbookRowLabels(
        kind: CashbookEntryKind.cashOut,
        transactionType: 'Transport',
      );
      expect(l.title, 'Cash out');
      expect(l.detail, 'Transport');
    });

    test('the note follows the category', () {
      final l = cashbookRowLabels(
        kind: CashbookEntryKind.cashOut,
        transactionType: 'Transport',
        note: '  Moto to supplier ',
      );
      expect(l.detail, 'Transport · Moto to supplier');
    });

    test('a movement without a category says so', () {
      expect(
        cashbookRowLabels(
          kind: CashbookEntryKind.cashOut,
          transactionType: 'Cash Out',
        ).detail,
        'No category',
      );
      expect(
        cashbookRowLabels(
          kind: CashbookEntryKind.cashIn,
          transactionType: null,
        ).detail,
        'No category',
      );
    });

    test('sales are labelled Sale, never with a category', () {
      final l = cashbookRowLabels(
        kind: CashbookEntryKind.sale,
        transactionType: 'Sale',
      );
      expect(l.title, 'Sale');
      expect(l.detail, 'Point of sale');
    });
  });

  test('cashbookCategoryName is null without a real category', () {
    expect(cashbookCategoryName(' Rent '), 'Rent');
    expect(cashbookCategoryName('Cash In'), isNull);
    expect(cashbookCategoryName('cash out'), isNull);
    expect(cashbookCategoryName('  '), isNull);
    expect(cashbookCategoryName(null), isNull);
  });

  test('cashbookCategoryLabel', () {
    expect(cashbookCategoryLabel('Rent'), 'Rent');
    expect(cashbookCategoryLabel('cash out'), 'No category');
    expect(cashbookCategoryLabel(null), 'No category');
  });

  test('cashbookMethodBadge marks only mobile money', () {
    expect(cashbookMethodBadge('CASH'), isNull);
    expect(cashbookMethodBadge(null), isNull);
    expect(cashbookMethodBadge('MTN MOMO'), 'MoMo');
    expect(cashbookMethodBadge('AIRTEL MONEY'), 'Airtel');
  });

  group('cashbookDayLabel', () {
    final now = DateTime(2026, 10, 5, 0, 30);

    test('today and yesterday by calendar day, not 24h', () {
      expect(cashbookDayLabel(DateTime(2026, 10, 5, 0, 1), now), 'Today');
      expect(cashbookDayLabel(DateTime(2026, 10, 4, 23, 59), now), 'Yesterday');
    });

    test('yesterday stays yesterday across a DST change', () {
      // US spring-forward is 2026-03-08: local midnights there are 23h apart.
      // Meaningful when run with TZ set to a DST zone; harmless in UTC.
      expect(
        cashbookDayLabel(DateTime(2026, 3, 8, 12), DateTime(2026, 3, 9, 0, 30)),
        'Yesterday',
      );
    });

    test(
      'older days show a short date, with the year only when it differs',
      () {
        expect(cashbookDayLabel(DateTime(2026, 10, 1), now), 'Thu, Oct 1');
        expect(
          cashbookDayLabel(DateTime(2025, 12, 31), now),
          'Wed, Dec 31, 2025',
        );
      },
    );
  });

  test('groupCashbookByDay orders days newest first and keeps row order', () {
    final items = [
      DateTime(2026, 10, 5, 9),
      DateTime(2026, 10, 3, 18),
      DateTime(2026, 10, 5, 8),
      DateTime(2026, 10, 3, 7),
    ];
    final groups = groupCashbookByDay(items, at: (d) => d);
    expect(groups.map((g) => g.day), [
      DateTime(2026, 10, 5),
      DateTime(2026, 10, 3),
    ]);
    expect(groups.first.items, [
      DateTime(2026, 10, 5, 9),
      DateTime(2026, 10, 5, 8),
    ]);
  });

  test('cashbookTotals counts sales and cash in as money in', () {
    final t = cashbookTotals(const [
      (kind: CashbookEntryKind.sale, amount: 3000),
      (kind: CashbookEntryKind.cashIn, amount: 500),
      (kind: CashbookEntryKind.cashOut, amount: 1200),
    ]);
    expect(t.moneyIn, 3500);
    expect(t.moneyOut, 1200);
    expect(t.net, 2300);
  });
}
