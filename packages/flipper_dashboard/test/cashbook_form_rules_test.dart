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
}
