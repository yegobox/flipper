import 'package:flipper_accounting/accounting_models.dart';
import 'package:flipper_accounting/ledger_row_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('an SMS Bridge line keeps its id, source and ISO date', () {
    // Shape written by data-connector/src/sms/writer.rs.
    final line = LedgerRowMapper.bankLineFromRow({
      '_id': 'sms-line-1',
      'id': 'sms-line-1',
      'businessId': 'biz',
      'bankAccountCode': '1030',
      'lineDate': '2026-10-14',
      'description': 'MTN MoMo · from Jane DOE · 10000000001',
      'amount': 5000,
      'source': 'sms',
    });
    expect(line.id, 'sms-line-1');
    expect(line.isFromSms, isTrue);
    expect(line.isoDate, '2026-10-14');
    expect(line.date, 'Oct 14');
    expect(line.amt, 5000);
    expect(line.matched, isFalse);
  });

  test('a statement line has no source and copyWith keeps identity', () {
    final line = LedgerRowMapper.bankLineFromRow({
      'id': 'stmt-1',
      'line_date': '2026-10-14T00:00:00',
      'description': 'POS deposit',
      'amount': -200,
      'matched_journal_entry_id': 'je_1',
      'matched_entry_number': 'JE-1',
    });
    expect(line.isFromSms, isFalse);
    expect(line.matched, isTrue);
    final rematched = line.copyWith(matched: true, je: 'JE-2');
    expect(rematched.id, 'stmt-1');
    expect(rematched.isoDate, '2026-10-14');
    expect(rematched.je, 'JE-2');
  });

  test('BankLine stays constructible without the new fields', () {
    const line = BankLine(date: 'Oct 1', desc: 'x', amt: 1, matched: false);
    expect(line.id, isNull);
    expect(line.source, isNull);
  });
}
