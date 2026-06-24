import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_models/domain/party/supplier_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('supplierFromDraft maps PartyDraft to Supplier', () {
    final draft = PartyDraft(
      id: 'sup-1',
      name: 'Acme Ltd',
      phone: '0788123456',
      tin: '100012345',
      customerType: 'Business',
      branchId: 'branch-1',
      kind: PartyKind.supplier,
    );
    final supplier = supplierFromDraft(draft);
    expect(supplier.id, 'sup-1');
    expect(supplier.custNm, 'Acme Ltd');
    expect(supplier.custTin, '100012345');
    expect(supplier.telNo, '0788123456');
    expect(supplier.branchId, 'branch-1');
    expect(supplier.customerType, 'Business');
    expect(supplier.useYn, 'N');
  });

  test('supplierFromDraft omits empty tin', () {
    final draft = PartyDraft(
      name: 'Informal Vendor',
      phone: '',
      customerType: 'Business',
      branchId: 'branch-1',
      kind: PartyKind.supplier,
    );
    final supplier = supplierFromDraft(draft);
    expect(supplier.custTin, isNull);
    expect(supplier.telNo, isNull);
  });
}
