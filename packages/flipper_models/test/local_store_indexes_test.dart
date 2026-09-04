import 'package:flipper_models/sync/utils/local_store_indexes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('every statement is a safe, idempotent CREATE INDEX', () {
    for (final statement in localStoreIndexStatements()) {
      expect(statement, startsWith('CREATE INDEX IF NOT EXISTS '));
      expect(statement, contains(' ON '));
      expect(RegExp(r'\([a-zA-Z]+\)$').hasMatch(statement), isTrue,
          reason: 'one field per index — composite needs SDK 5.1.0: $statement');
    }
  });

  test('covers the fields a cart write filters on', () {
    final statements = localStoreIndexStatements().join('\n');

    expect(statements, contains('ON transaction_items (transactionId)'));
    expect(statements, contains('ON transaction_items (variantId)'));
    expect(statements, contains('ON transactions (branchId)'));
    expect(statements, contains('ON transactions (status)'));
    expect(statements, contains('ON transactions (createdAt)'));
  });

  test('index names are unique per collection and field', () {
    final names = [
      for (final s in localStoreIndexStatements())
        RegExp(r'IF NOT EXISTS (\w+) ON').firstMatch(s)!.group(1)!,
    ];

    expect(names.toSet().length, names.length);
  });

  test('a collection is never indexed on the same field twice', () {
    for (final entry in kLocalStoreIndexedFields.entries) {
      expect(entry.value.toSet().length, entry.value.length,
          reason: '${entry.key} repeats a field');
    }
  });
}
