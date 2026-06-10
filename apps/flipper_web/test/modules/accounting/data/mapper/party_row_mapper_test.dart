import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flipper_web/modules/accounting/data/mapper/party_row_mapper.dart';
import 'package:flipper_web/modules/accounting/data/party_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final supabaseRow = {
    'id': 'p-1',
    'cust_nm': 'Karake Retail',
    'email': 'a@b.rw',
    'tel_no': '0788123456',
    'adrs': 'Kigali',
    'branch_id': 'branch-1',
    'updated_at': '2026-06-10T12:00:00.000Z',
    'cust_no': '788123456',
    'cust_tin': '123456789',
    'regr_nm': '11111',
    'regr_id': '22222',
    'modr_nm': '33333',
    'modr_id': '44444',
    'ebm_synced': true,
    'bhf_id': '00',
    'use_yn': 'N',
    'customer_type': 'Business',
  };

  final dittoRow = {
    '_id': 'p-1',
    'id': 'p-1',
    'custNm': 'Karake Retail',
    'email': 'a@b.rw',
    'telNo': '0788123456',
    'adrs': 'Kigali',
    'branchId': 'branch-1',
    'updatedAt': '2026-06-10T12:00:00.000Z',
    'custNo': '788123456',
    'custTin': '123456789',
    'regrNm': '11111',
    'regrId': '22222',
    'modrNm': '33333',
    'modrId': '44444',
    'ebmSynced': true,
    'bhfId': '00',
    'useYn': 'N',
    'customerType': 'Business',
  };

  group('PartyRowMapper.partyFromRow', () {
    test('reads snake_case (Supabase) rows', () {
      final p = PartyRowMapper.partyFromRow(supabaseRow);
      expect(p.id, 'p-1');
      expect(p.name, 'Karake Retail');
      expect(p.phone, '0788123456');
      expect(p.tin, '123456789');
      expect(p.branchId, 'branch-1');
      expect(p.custNo, '788123456');
      expect(p.regrNm, '11111');
      expect(p.ebmSynced, isTrue);
    });

    test('reads camelCase (Ditto) rows', () {
      final p = PartyRowMapper.partyFromRow(dittoRow);
      expect(p.id, 'p-1');
      expect(p.name, 'Karake Retail');
      expect(p.custNo, '788123456');
      expect(p.modrId, '44444');
    });

    test('round-trips losslessly (RRA fields preserved on edit)', () {
      final p = PartyRowMapper.partyFromRow(supabaseRow);
      final edited = p.copyWith(name: 'Karake Retail Group');

      final ditto = PartyRowMapper.toDittoRow(edited);
      expect(ditto['custNm'], 'Karake Retail Group');
      expect(ditto['regrNm'], '11111'); // preserved, not regenerated
      expect(ditto['ebmSynced'], isTrue);

      final supa = PartyRowMapper.toSupabaseRow(edited);
      expect(supa['cust_nm'], 'Karake Retail Group');
      expect(supa['modr_id'], '44444');
    });
  });

  group('Party.fromDraft', () {
    test('write maps equal the shared PartyDraft row shapes', () {
      final draft = PartyDraft(
        id: 'fixed',
        name: 'New Shop',
        phone: '0788000111',
        email: 's@x.rw',
        tin: '123456789',
        customerType: 'Business',
        branchId: 'branch-1',
        updatedAt: DateTime.utc(2026, 6, 10),
        randomFiveDigits: () => '55555',
      );
      final party = Party.fromDraft(draft);
      expect(PartyRowMapper.toDittoRow(party), draft.toDittoRow());
      expect(PartyRowMapper.toSupabaseRow(party), draft.toSupabaseRow());
    });

    test('supplier kind maps to the suppliers store', () {
      final draft = PartyDraft(
        name: 'Vendor',
        phone: '0788000222',
        customerType: 'Business',
        branchId: 'b',
        kind: PartyKind.supplier,
      );
      expect(Party.fromDraft(draft).kind.storeName, 'suppliers');
    });
  });
}
