import 'package:flipper_web/modules/accounting/data/accounting_v3_models.dart';
import 'package:flipper_web/modules/accounting/data/mapper/document_row_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('document round-trip preserves lines and status', () {
    const doc = AccountingDocument(
      id: 'INV-1',
      who: 'Karake Retail',
      date: '1 Jun 2026',
      due: '15 Jun 2026',
      status: DocStatus.sent,
      lines: [DocLine(desc: 'Oil', qty: 2, price: 10000)],
    );
    final row = DocumentRowMapper.documentToRow(
      businessId: 'biz-1',
      kind: DocKind.invoice,
      doc: doc,
      id: 'doc-uuid',
    );
    final back = DocumentRowMapper.documentFromRow(row);
    expect(back.id, 'INV-1');
    expect(back.who, 'Karake Retail');
    expect(back.status, DocStatus.sent);
    expect(back.lines.single.desc, 'Oil');
    expect(back.lines.single.qty, 2);
    expect(back.lines.single.price, 10000);
  });

  test('contact round-trip preserves fields', () {
    const contact = AccountingContact(
      id: 'C-1',
      name: 'Karake Retail',
      contact: 'Jean',
      phone: '+250 788',
      email: 'a@b.rw',
      tin: '123',
      since: 'Jun 2026',
      terms: 'Net 30',
      balance: 0,
    );
    final row = DocumentRowMapper.contactToRow(
      businessId: 'biz-1',
      isCustomer: true,
      contact: contact,
      id: 'contact-uuid',
    );
    final back = DocumentRowMapper.contactFromRow(row);
    expect(back.name, 'Karake Retail');
    expect(back.contact, 'Jean');
    expect(back.terms, 'Net 30');
  });
}
