import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:flipper_web/modules/accounting/data/bank_rec_matching.dart';
import 'package:flipper_web/modules/accounting/data/services/bank_statement_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('bankRecJournalDateRange uses statement period with buffer', () {
    const meta = ParsedStatement(
      periodStart: '2026-05-01',
      periodEnd: '2026-06-10',
    );
    final (start, end) = bankRecJournalDateRange(meta);
    expect(start, DateTime(2026, 4, 1));
    expect(end, DateTime(2026, 7, 10));
  });

  test('correctStatementYear fixes AI year drift', () {
    final now = DateTime(2026, 6, 10);
    expect(
      correctStatementYear(DateTime(2024, 5, 1), now),
      DateTime(2026, 5, 1),
    );
    expect(
      correctStatementYear(DateTime(2025, 12, 1), now),
      DateTime(2025, 12, 1),
    );
  });

  test('findBankMatchCandidates prefers bank then liquid fallbacks', () {
    const line = BankLine(
      date: 'May 7',
      desc: 'Transfer',
      amt: 7000,
      matched: false,
    );
    final journal = [
      JournalEntry(
        id: 'JE-BANK',
        date: 'May 7',
        memo: 'Bank sale',
        ref: 'r1',
        status: JournalStatus.posted,
        src: 'POS',
        lines: [
          JournalLine(ac: '1020', dr: 7000),
          JournalLine(ac: '4010', cr: 7000),
        ],
      ),
      JournalEntry(
        id: 'JE-MOMO',
        date: 'May 7',
        memo: 'MoMo sale',
        ref: 'r2',
        status: JournalStatus.posted,
        src: 'POS',
        lines: [
          JournalLine(ac: '1030', dr: 7000),
          JournalLine(ac: '4010', cr: 7000),
        ],
      ),
    ];

    final bankMatch = findBankMatchCandidates(journal: journal, line: line);
    expect(bankMatch, hasLength(1));
    expect(bankMatch.first.entry.id, 'JE-BANK');
    expect(bankMatch.first.accountCode, '1020');

    final momoOnly = findBankMatchCandidates(
      journal: [journal[1]],
      line: line,
    );
    expect(momoOnly.single.accountCode, '1030');
  });
}
