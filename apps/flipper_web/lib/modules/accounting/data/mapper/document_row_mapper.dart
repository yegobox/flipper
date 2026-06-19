import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';

class DocumentRowMapper {
  DocumentRowMapper._();

  static String _str(Map<String, dynamic> row, String snake, String camel) =>
      (row[snake] ?? row[camel] ?? '').toString();

  static DocStatus _status(String raw) => switch (raw) {
    'sent' => DocStatus.sent,
    'paid' => DocStatus.paid,
    'overdue' => DocStatus.overdue,
    _ => DocStatus.draft,
  };

  static String statusToDb(DocStatus s) => switch (s) {
    DocStatus.sent => 'sent',
    DocStatus.paid => 'paid',
    DocStatus.overdue => 'overdue',
    DocStatus.draft => 'draft',
  };

  static String kindToDb(DocKind k) => k == DocKind.bill ? 'bill' : 'invoice';

  static List<DocLine> _linesFromJson(dynamic raw) {
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map)
          DocLine(
            desc: (item['desc'] ?? '').toString(),
            qty: num.tryParse('${item['qty']}') ?? 0,
            price: num.tryParse('${item['price']}') ?? 0,
          ),
    ];
  }

  static List<Map<String, dynamic>> linesToJson(List<DocLine> lines) => [
    for (final l in lines) {'desc': l.desc, 'qty': l.qty, 'price': l.price},
  ];

  static AccountingDocument documentFromRow(Map<String, dynamic> row) {
    return AccountingDocument(
      uuid: (row['id'] ?? row['_id'])?.toString(),
      id: _str(row, 'doc_number', 'docNumber'),
      who: _str(row, 'party_name', 'partyName'),
      date: _str(row, 'issue_date', 'issueDate'),
      due: _str(row, 'due_date', 'dueDate'),
      status: _status(_str(row, 'status', 'status')),
      lines: _linesFromJson(row['lines']),
    );
  }

  static Map<String, dynamic> documentToRow({
    required String businessId,
    required DocKind kind,
    required AccountingDocument doc,
    String? id,
  }) {
    return {
      if (id != null) 'id': id,
      'business_id': businessId,
      'businessId': businessId,
      'doc_kind': kindToDb(kind),
      'docKind': kindToDb(kind),
      'doc_number': doc.id,
      'docNumber': doc.id,
      'party_name': doc.who,
      'partyName': doc.who,
      'issue_date': doc.date,
      'issueDate': doc.date,
      'due_date': doc.due,
      'dueDate': doc.due,
      'status': statusToDb(doc.status),
      'lines': linesToJson(doc.lines),
    };
  }

  static AccountingContact contactFromRow(Map<String, dynamic> row) {
    final partyId = (row['party_id'] ?? row['partyId'])?.toString();
    return AccountingContact(
      uuid: (row['id'] ?? row['_id'])?.toString(),
      id: _str(row, 'local_id', 'localId').isNotEmpty
          ? _str(row, 'local_id', 'localId')
          : (row['id'] ?? row['_id'] ?? '').toString(),
      name: _str(row, 'name', 'name'),
      contact: _str(row, 'contact_name', 'contactName'),
      phone: _str(row, 'phone', 'phone'),
      email: _str(row, 'email', 'email'),
      tin: _str(row, 'tin', 'tin'),
      since: _str(row, 'since_label', 'sinceLabel'),
      terms: _str(row, 'terms', 'terms'),
      balance: 0,
      partyId: partyId == null || partyId.isEmpty ? null : partyId,
    );
  }

  static RecurringSchedule recurringScheduleFromRow(Map<String, dynamic> row) {
    return RecurringSchedule(
      uuid: (row['id'] ?? row['_id'])?.toString(),
      id: _str(row, 'local_id', 'localId').isNotEmpty
          ? _str(row, 'local_id', 'localId')
          : (row['id'] ?? row['_id'] ?? '').toString(),
      name: _str(row, 'name', 'name'),
      freq: _str(row, 'freq', 'freq'),
      day: _str(row, 'day_label', 'dayLabel'),
      next: _str(row, 'next_run', 'nextRun'),
      amount: int.tryParse('${row['amount']}') ?? 0,
      debitCode: _str(row, 'debit_code', 'debitCode'),
      creditCode: _str(row, 'credit_code', 'creditCode'),
      iconName: _str(row, 'icon_name', 'iconName').isNotEmpty
          ? _str(row, 'icon_name', 'iconName')
          : 'Refresh',
      active: row['active'] == true || row['active'] == 'true',
    );
  }

  static Map<String, dynamic> recurringScheduleToRow({
    required String businessId,
    required RecurringSchedule schedule,
    String? id,
  }) {
    return {
      if (id != null) 'id': id,
      'business_id': businessId,
      'businessId': businessId,
      'local_id': schedule.id,
      'localId': schedule.id,
      'name': schedule.name,
      'freq': schedule.freq,
      'day_label': schedule.day,
      'dayLabel': schedule.day,
      'next_run': schedule.next,
      'nextRun': schedule.next,
      'amount': schedule.amount,
      'debit_code': schedule.debitCode,
      'debitCode': schedule.debitCode,
      'credit_code': schedule.creditCode,
      'creditCode': schedule.creditCode,
      'icon_name': schedule.iconName,
      'iconName': schedule.iconName,
      'active': schedule.active,
    };
  }

  static Map<String, dynamic> contactToRow({
    required String businessId,
    required bool isCustomer,
    required AccountingContact contact,
    String? id,
  }) {
    return {
      if (id != null) 'id': id,
      'business_id': businessId,
      'businessId': businessId,
      'contact_kind': isCustomer ? 'customer' : 'supplier',
      'contactKind': isCustomer ? 'customer' : 'supplier',
      'local_id': contact.id,
      'localId': contact.id,
      'name': contact.name,
      'contact_name': contact.contact,
      'contactName': contact.contact,
      'phone': contact.phone,
      'email': contact.email,
      'tin': contact.tin,
      'since_label': contact.since,
      'sinceLabel': contact.since,
      'terms': contact.terms,
      if (contact.partyId != null) 'party_id': contact.partyId,
      if (contact.partyId != null) 'partyId': contact.partyId,
    };
  }
}
