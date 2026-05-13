import 'package:flipper_dashboard/cashbook.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('resolvedCashbookSelectedCategoryId', () {
    test('uses optimistic selection immediately when set', () {
      final categories = [
        Category(id: 'a', name: 'First', focused: true, active: true),
        Category(id: 'b', name: 'Second', focused: false, active: true),
      ];
      final optimistic = Category(id: 'b', name: 'Second', focused: false);

      expect(
        resolvedCashbookSelectedCategoryId(categories, optimistic),
        'b',
      );
    });

    test('falls back to focused active category when optimistic is null', () {
      final categories = [
        Category(id: 'x', name: 'Other', focused: false, active: true),
        Category(id: 'y', name: 'Chosen', focused: true, active: true),
      ];

      expect(
        resolvedCashbookSelectedCategoryId(categories, null),
        'y',
      );
    });

    test('ignores optimistic with empty id and uses focused row', () {
      final categories = [
        Category(id: 'y', name: 'Chosen', focused: true, active: true),
      ];
      final optimistic = Category(id: '', name: 'Bad');

      expect(
        resolvedCashbookSelectedCategoryId(categories, optimistic),
        'y',
      );
    });

    test('returns null when nothing focused and no valid optimistic', () {
      final categories = [
        Category(id: 'x', name: 'Other', focused: false, active: true),
      ];

      expect(resolvedCashbookSelectedCategoryId(categories, null), isNull);
    });
  });
}
