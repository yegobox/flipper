import 'package:flipper_models/sync/capella/reference_data_ditto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/all_models.dart';

void main() {
  group('colour Ditto mapping', () {
    test('round-trips every persisted field', () {
      final touched = DateTime.utc(2026, 8, 8, 9, 30);
      final deleted = DateTime.utc(2026, 8, 9);
      final color = PColor(
        id: 'colour-1',
        name: 'Emerald',
        branchId: 'branch-7',
        active: true,
        lastTouched: touched,
        deletedAt: deleted,
      );

      final back = colorFromDittoDoc(colorToDittoDoc(color));

      expect(back.id, 'colour-1');
      expect(back.name, 'Emerald');
      expect(back.branchId, 'branch-7');
      expect(back.active, isTrue);
      expect(back.lastTouched, touched);
      expect(back.deletedAt, deleted);
    });

    test('writes _id alongside id so ON ID CONFLICT can match', () {
      final doc = colorToDittoDoc(PColor(id: 'c9', active: false));
      expect(doc['_id'], 'c9');
      expect(doc['id'], 'c9');
    });

    test('falls back to _id when the doc has no id field', () {
      final back = colorFromDittoDoc({'_id': 'c9', 'active': false});
      expect(back.id, 'c9');
    });

    test('reads active written as a string or number', () {
      expect(colorFromDittoDoc({'_id': 'a', 'active': 'true'}).active, isTrue);
      expect(colorFromDittoDoc({'_id': 'b', 'active': 1}).active, isTrue);
      expect(colorFromDittoDoc({'_id': 'c', 'active': 0}).active, isFalse);
      expect(colorFromDittoDoc({'_id': 'd'}).active, isFalse);
    });
  });

  group('unit Ditto mapping', () {
    test('round-trips every persisted field', () {
      final touched = DateTime.utc(2026, 8, 8, 9, 30);
      final unit = IUnit(
        id: 'unit-1',
        branchId: 'branch-7',
        name: 'Kg',
        value: 'kg',
        active: true,
        code: 'KG',
        description: 'Kilogram',
        lastTouched: touched,
        createdAt: '2026-08-01',
      );

      final back = unitFromDittoDoc(unitToDittoDoc(unit));

      expect(back.id, 'unit-1');
      expect(back.branchId, 'branch-7');
      expect(back.name, 'Kg');
      expect(back.value, 'kg');
      expect(back.active, isTrue);
      expect(back.code, 'KG');
      expect(back.description, 'Kilogram');
      expect(back.lastTouched, touched);
      expect(back.createdAt, '2026-08-01');
    });

    test('keeps active null when absent, so it is distinct from false', () {
      expect(unitFromDittoDoc({'_id': 'u1'}).active, isNull);
      expect(unitFromDittoDoc({'_id': 'u2', 'active': false}).active, isFalse);
    });

    test('tolerates a malformed date instead of throwing', () {
      final back = unitFromDittoDoc({'_id': 'u3', 'lastTouched': 'not-a-date'});
      expect(back.lastTouched, isNull);
    });
  });

  // Supabase columns are snake_case, Ditto docs carry the Dart camelCase names.
  // Getting that boundary wrong yields silent zeros/empties rather than errors,
  // so both directions are pinned here.
  group('country mapping', () {
    test('reads a snake_case Supabase row', () {
      final country = countryFromSupabaseRow({
        'id': 'rw',
        'code': 'RW',
        'sort_order': 3,
        'name': 'Rwanda',
        'description': 'East Africa',
      });

      expect(country.id, 'rw');
      expect(country.code, 'RW');
      expect(country.sortOrder, 3);
      expect(country.name, 'Rwanda');
      expect(country.description, 'East Africa');
    });

    test('sort_order arriving as a string still parses', () {
      expect(
        countryFromSupabaseRow({'id': 'a', 'sort_order': '7'}).sortOrder,
        7,
      );
    });

    test('missing sort_order defaults to 0 rather than throwing', () {
      expect(countryFromSupabaseRow({'id': 'a'}).sortOrder, 0);
    });

    test('round-trips through a Ditto doc', () {
      final original = countryFromSupabaseRow({
        'id': 'rw',
        'code': 'RW',
        'sort_order': 3,
        'name': 'Rwanda',
        'description': 'East Africa',
      });
      final back = countryFromDittoDoc(countryToDittoDoc(original));

      expect(back.id, 'rw');
      expect(back.code, 'RW');
      expect(back.sortOrder, 3);
      expect(back.name, 'Rwanda');
      expect(back.description, 'East Africa');
    });

    test('_id is the Supabase row id, so seeding is idempotent', () {
      final doc = countryToDittoDoc(countryFromSupabaseRow({'id': 'rw'}));
      expect(doc['_id'], 'rw');
      expect(doc['_id'], doc['id']);
    });
  });

  group('finance provider mapping', () {
    test('reads a snake_case Supabase row', () {
      final provider = financeProviderFromSupabaseRow({
        'id': 'fp1',
        'name': 'Acme Credit',
        'interest_rate': 12.5,
        'suppliers_that_accept_this_finance_facility': 's1,s2',
      });

      expect(provider.id, 'fp1');
      expect(provider.name, 'Acme Credit');
      expect(provider.interestRate, 12.5);
      expect(provider.suppliersThatAcceptThisFinanceFacility, 's1,s2');
    });

    test('interest_rate arriving as a string still parses', () {
      expect(
        financeProviderFromSupabaseRow({'id': 'a', 'interest_rate': '9.25'})
            .interestRate,
        9.25,
      );
    });

    test('round-trips through a Ditto doc', () {
      final original = financeProviderFromSupabaseRow({
        'id': 'fp1',
        'name': 'Acme Credit',
        'interest_rate': 12.5,
        'suppliers_that_accept_this_finance_facility': 's1,s2',
      });
      final back =
          financeProviderFromDittoDoc(financeProviderToDittoDoc(original));

      expect(back.id, 'fp1');
      expect(back.name, 'Acme Credit');
      expect(back.interestRate, 12.5);
      expect(back.suppliersThatAcceptThisFinanceFacility, 's1,s2');
    });

    test('absent supplier list becomes empty, never null', () {
      expect(
        financeProviderFromSupabaseRow({'id': 'a'})
            .suppliersThatAcceptThisFinanceFacility,
        '',
      );
    });
  });
}
