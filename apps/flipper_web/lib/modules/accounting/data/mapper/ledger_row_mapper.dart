import 'package:flipper_web/modules/accounting/data/accounting_models.dart';
import 'package:intl/intl.dart';

/// Maps Supabase / Ditto row maps ↔ accounting UI models.
class LedgerRowMapper {
  LedgerRowMapper._();

  static AccountType _accountType(String raw) => switch (raw) {
        'asset' => AccountType.asset,
        'liability' => AccountType.liability,
        'equity' => AccountType.equity,
        'income' => AccountType.income,
        'expense' => AccountType.expense,
        _ => AccountType.asset,
      };

  static String accountTypeToDb(AccountType t) => switch (t) {
        AccountType.asset => 'asset',
        AccountType.liability => 'liability',
        AccountType.equity => 'equity',
        AccountType.income => 'income',
        AccountType.expense => 'expense',
      };

  static AccountNormal _normal(String raw) =>
      raw == 'credit' ? AccountNormal.credit : AccountNormal.debit;

  static String normalToDb(AccountNormal n) =>
      n == AccountNormal.credit ? 'credit' : 'debit';

  static JournalStatus _status(String raw) => switch (raw) {
        'posted' => JournalStatus.posted,
        'pending' => JournalStatus.pending,
        _ => JournalStatus.draft,
      };

  static String statusToDb(JournalStatus s) => switch (s) {
        JournalStatus.posted => 'posted',
        JournalStatus.pending => 'pending',
        JournalStatus.draft => 'draft',
      };

  static int _int(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.round();
    return int.tryParse(v.toString()) ?? 0;
  }

  static String _str(Map<String, dynamic> row, String snake, String camel) =>
      (row[snake] ?? row[camel] ?? '').toString();

  static Account accountFromRow(Map<String, dynamic> row, {int balance = 0}) {
    return Account(
      code: _str(row, 'code', 'code'),
      name: _str(row, 'name', 'name'),
      type: _accountType(_str(row, 'account_type', 'accountType')),
      sub: _str(row, 'sub', 'sub'),
      normal: _normal(_str(row, 'normal', 'normal')),
      bal: balance,
      contra: row['is_contra'] == true || row['isContra'] == true,
      note: row['note'] as String?,
    );
  }

  static Map<String, dynamic> accountToRow(
    Account account, {
    required String businessId,
    String? id,
    int openingBalance = 0,
  }) {
    return {
      if (id != null) 'id': id,
      'business_id': businessId,
      'businessId': businessId,
      'code': account.code,
      'name': account.name,
      'account_type': accountTypeToDb(account.type),
      'accountType': accountTypeToDb(account.type),
      'sub': account.sub,
      'normal': normalToDb(account.normal),
      'is_contra': account.contra,
      'isContra': account.contra,
      'note': account.note,
      'opening_balance': openingBalance,
      'openingBalance': openingBalance,
      'is_active': true,
      'isActive': true,
    };
  }

  static JournalLine lineFromRow(Map<String, dynamic> row) => JournalLine(
        ac: _str(row, 'account_code', 'accountCode'),
        dr: _int(row['debit']),
        cr: _int(row['credit']),
      );

  static Map<String, dynamic> lineToRow({
    required String journalEntryId,
    required JournalLine line,
    String? id,
  }) {
    return {
      if (id != null) 'id': id,
      'journal_entry_id': journalEntryId,
      'journalEntryId': journalEntryId,
      'account_code': line.ac,
      'accountCode': line.ac,
      'debit': line.dr,
      'credit': line.cr,
    };
  }

  static JournalEntry entryFromRow(
    Map<String, dynamic> row,
    List<JournalLine> lines,
  ) {
    final entryNumber = _str(row, 'entry_number', 'entryNumber');
    final uuid = _str(row, 'id', 'id');
    return JournalEntry(
      id: entryNumber.isNotEmpty ? entryNumber : uuid,
      uuid: uuid.isNotEmpty ? uuid : null,
      date: _formatEntryDate(row['entry_date'] ?? row['entryDate']),
      memo: _str(row, 'memo', 'memo'),
      ref: _str(row, 'reference', 'reference'),
      status: _status(_str(row, 'status', 'status')),
      src: _str(row, 'source', 'source'),
      lines: lines,
    );
  }

  static Map<String, dynamic> entryToRow({
    required String businessId,
    required JournalEntry entry,
    String? id,
    String? transactionId,
    String? journalId,
  }) {
    return {
      if (id != null) 'id': id,
      'business_id': businessId,
      'businessId': businessId,
      if (journalId != null) 'journal_id': journalId,
      if (journalId != null) 'journalId': journalId,
      'entry_number': entry.id,
      'entryNumber': entry.id,
      'reference': entry.ref,
      'memo': entry.memo,
      'entry_date': _parseEntryDateToIso(entry.date),
      'entryDate': _parseEntryDateToIso(entry.date),
      'status': statusToDb(entry.status),
      'source': entry.src,
      if (transactionId != null) 'transaction_id': transactionId,
      if (transactionId != null) 'transactionId': transactionId,
    };
  }

  static BankLine bankLineFromRow(Map<String, dynamic> row) {
    final matchedId = row['matched_journal_entry_id'] ?? row['matchedJournalEntryId'];
    return BankLine(
      date: _formatEntryDate(row['line_date'] ?? row['lineDate']),
      desc: _str(row, 'description', 'description'),
      amt: _int(row['amount']),
      matched: matchedId != null && matchedId.toString().isNotEmpty,
      je: row['matched_entry_number'] as String?,
    );
  }

  static Map<String, dynamic> bankLineToRow({
    required String businessId,
    required BankLine line,
    String bankAccountCode = '1020',
    String? id,
    String? matchedJournalEntryId,
    String? matchedEntryNumber,
  }) {
    return {
      if (id != null) 'id': id,
      'business_id': businessId,
      'businessId': businessId,
      'bank_account_code': bankAccountCode,
      'bankAccountCode': bankAccountCode,
      'line_date': _parseEntryDateToIso(line.date),
      'lineDate': _parseEntryDateToIso(line.date),
      'description': line.desc,
      'amount': line.amt,
      if (matchedJournalEntryId != null)
        'matched_journal_entry_id': matchedJournalEntryId,
      if (matchedJournalEntryId != null)
        'matchedJournalEntryId': matchedJournalEntryId,
      if (matchedEntryNumber != null) 'matched_entry_number': matchedEntryNumber,
    };
  }

  static VatInfo? settingsToVat(
    Map<String, dynamic>? settings, {
    required int outputVat,
    required int inputVat,
    required String dueDateLabel,
  }) {
    if (settings == null && outputVat == 0 && inputVat == 0) return null;
    final rate = (settings?['default_vat_rate'] ?? settings?['defaultVatRate'] ?? 0.18);
    final rateNum = rate is num ? rate.toDouble() : double.tryParse('$rate') ?? 0.18;
    return VatInfo(
      rate: rateNum,
      outputVat: outputVat,
      inputVat: inputVat,
      dueDate: dueDateLabel,
    );
  }

  static String _formatEntryDate(dynamic raw) {
    if (raw == null) return '';
    if (raw is String) {
      final dt = DateTime.tryParse(raw);
      if (dt != null) {
        const months = [
          '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
          'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
        ];
        return '${months[dt.month]} ${dt.day}';
      }
      return raw;
    }
    if (raw is DateTime) {
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      return '${months[raw.month]} ${raw.day}';
    }
    return raw.toString();
  }

  static String _parseEntryDateToIso(String label) {
    final trimmed = label.trim();
    if (trimmed.isEmpty) {
      return _dateOnlyIso(DateTime.now());
    }

    final iso = DateTime.tryParse(trimmed);
    if (iso != null) {
      return _dateOnlyIso(iso);
    }

    for (final pattern in ['d MMM y', 'MMM d y', 'MMM d', 'd MMM']) {
      try {
        return _dateOnlyIso(DateFormat(pattern).parse(trimmed));
      } catch (_) {
        continue;
      }
    }

    final now = DateTime.now();
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final dayFirst = int.tryParse(parts[0]);
      if (dayFirst != null) {
        final month = _monthNumber(parts[1]) ?? now.month;
        final year =
            parts.length >= 3 ? (int.tryParse(parts[2]) ?? now.year) : now.year;
        return _dateOnlyIso(DateTime(year, month, dayFirst));
      }

      final month = _monthNumber(parts[0]) ?? now.month;
      final day = int.tryParse(parts[1]) ?? now.day;
      final year =
          parts.length >= 3 ? (int.tryParse(parts[2]) ?? now.year) : now.year;
      return _dateOnlyIso(DateTime(year, month, day));
    }

    return _dateOnlyIso(now);
  }

  static String _dateOnlyIso(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day).toIso8601String();
  }

  static int? _monthNumber(String token) {
    const months = {
      'jan': 1,
      'feb': 2,
      'mar': 3,
      'apr': 4,
      'may': 5,
      'jun': 6,
      'jul': 7,
      'aug': 8,
      'sep': 9,
      'oct': 10,
      'nov': 11,
      'dec': 12,
    };
    final lower = token.toLowerCase();
    if (lower.length >= 3) {
      return months[lower.substring(0, 3)];
    }
    return months[lower];
  }
}
