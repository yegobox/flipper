import 'package:flipper_models/sync/utils/transaction_item_flag_filters.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('transactionItemFlagFilters', () {
    test('a ticket read treats unset flags as their defaults', () {
      final f = transactionItemFlagFilters(
        active: true,
        doneWithTransaction: false,
        pinnedToTransaction: true,
      );
      expect(f.conditions, [
        'COALESCE(active, true) = :active',
        'COALESCE(doneWithTransaction, false) = :doneWithTransaction',
      ]);
      expect(f.arguments, {'active': true, 'doneWithTransaction': false});
    });

    test('branch-wide reads keep strict equality', () {
      final f = transactionItemFlagFilters(
        active: true,
        doneWithTransaction: false,
        pinnedToTransaction: false,
      );
      expect(f.conditions, [
        'active = :active',
        'doneWithTransaction = :doneWithTransaction',
      ]);
      expect(f.arguments, {'active': true, 'doneWithTransaction': false});
    });

    test('non-default values stay strict even on a ticket read', () {
      final f = transactionItemFlagFilters(
        active: false,
        doneWithTransaction: true,
        pinnedToTransaction: true,
      );
      expect(f.conditions, [
        'active = :active',
        'doneWithTransaction = :doneWithTransaction',
      ]);
      expect(f.arguments, {'active': false, 'doneWithTransaction': true});
    });

    test('no flags asked for, no conditions added', () {
      final f = transactionItemFlagFilters(pinnedToTransaction: true);
      expect(f.conditions, isEmpty);
      expect(f.arguments, isEmpty);
    });
  });
}
