import 'package:flipper_accounting/journal_entry_id.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('slugifyJournalIdPart', () {
    test('strips spaces and punctuation from the human entry reference', () {
      expect(slugifyJournalIdPart('Auto · JE-9536'), 'Auto_JE-9536');
      expect(slugifyJournalIdPart('JE-1047'), 'JE-1047');
      expect(slugifyJournalIdPart('  ·  '), 'je');
      expect(slugifyJournalIdPart(''), 'je');
    });

    test('caps the slug so the generated id stays short', () {
      expect(slugifyJournalIdPart('A' * 100).length, lessThanOrEqualTo(40));
    });
  });

  test('generateJournalEntryId only uses id-safe characters', () {
    final id = generateJournalEntryId(
      businessId: '11111111-2222-3333-4444-555555555555',
      entryRef: 'Auto · JE-9536',
      microsecondsSinceEpoch: 1758012345678,
    );

    expect(id, 'je_11111111-2222-3333-4444-555555555555_Auto_JE-9536_1758012345678');
    expect(RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(id), isTrue);
    expect(id.length, lessThan(128));
  });
}
