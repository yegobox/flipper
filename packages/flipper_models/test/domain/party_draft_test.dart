import 'package:flipper_models/domain/party/customer_factory.dart';
import 'package:flipper_models/domain/party/party_draft.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/customer.model.dart';

void main() {
  final fixedTime = DateTime.utc(2026, 6, 10, 12);
  String fixedRandom() => '12345';

  PartyDraft draft({String? tin, String phone = '0788123456'}) => PartyDraft(
        id: 'fixed-id',
        name: 'Kigali Traders',
        phone: phone,
        email: 'shop@example.com',
        tin: tin,
        customerType: 'Business',
        branchId: 'branch-uuid',
        bhfId: '00',
        updatedAt: fixedTime,
        randomFiveDigits: fixedRandom,
      );

  group('PartyDraft legacy semantics (golden)', () {
    test('custTin falls back to phone ONLY when tin is null', () {
      expect(draft(tin: null).custTin, '0788123456');
      // Empty string passes through — matches legacy `tinNumber ?? phone`
      // with the POS form submitting '' for a blank TIN field.
      expect(draft(tin: '').custTin, '');
      expect(draft(tin: '123456789').custTin, '123456789');
    });

    test('custNo strips leading zero from phone (never from tin)', () {
      expect(draft(tin: '123456789').custNo, '788123456');
      expect(draft(phone: '788123456').custNo, '788123456');
    });

    test('customerFromDraft equals legacy Customer construction', () {
      final d = draft(tin: '123456789');
      final fromDraft = customerFromDraft(d).toFlipperJson();

      // Legacy construction exactly as CoreViewModel.addCustomer wrote it
      // before the refactor (custNo arg is ignored by the constructor).
      final legacy = Customer(
        id: 'fixed-id',
        custNm: 'Kigali Traders',
        custTin: '123456789',
        email: 'shop@example.com',
        telNo: '0788123456',
        updatedAt: fixedTime,
        branchId: 'branch-uuid',
        custNo: '123456789',
        regrNm: '12345',
        modrId: '12345',
        regrId: '12345',
        ebmSynced: false,
        modrNm: '12345',
        bhfId: '00',
        useYn: 'N',
        customerType: 'Business',
      ).toFlipperJson();

      expect(fromDraft, legacy);
    });

    test('toDittoRow matches generated DittoAdapter document shape', () {
      final row = draft(tin: '123456789').toDittoRow();
      expect(row, {
        '_id': 'fixed-id',
        'id': 'fixed-id',
        'custNm': 'Kigali Traders',
        'email': 'shop@example.com',
        'telNo': '0788123456',
        'adrs': null,
        'branchId': 'branch-uuid',
        'updatedAt': fixedTime.toIso8601String(),
        'custNo': '788123456',
        'custTin': '123456789',
        'regrNm': '12345',
        'regrId': '12345',
        'modrNm': '12345',
        'modrId': '12345',
        'ebmSynced': false,
        'bhfId': '00',
        'useYn': 'N',
        'customerType': 'Business',
      });
    });

    test('toSupabaseRow matches Brick adapter column names', () {
      final row = draft(tin: '123456789').toSupabaseRow();
      expect(row, {
        'id': 'fixed-id',
        'cust_nm': 'Kigali Traders',
        'email': 'shop@example.com',
        'tel_no': '0788123456',
        'adrs': null,
        'branch_id': 'branch-uuid',
        'updated_at': fixedTime.toIso8601String(),
        'cust_no': '788123456',
        'cust_tin': '123456789',
        'regr_nm': '12345',
        'regr_id': '12345',
        'modr_nm': '12345',
        'modr_id': '12345',
        'ebm_synced': false,
        'bhf_id': '00',
        'use_yn': 'N',
        'customer_type': 'Business',
      });
    });

    test('generates uuid id and utc timestamp by default', () {
      final d = PartyDraft(
        name: 'X',
        phone: '0788000000',
        customerType: 'Individual',
        branchId: 'b',
      );
      expect(d.id, isNotEmpty);
      expect(d.updatedAt.isUtc, isTrue);
      expect(d.bhfId, '00');
      // RRA fields are 5-digit strings.
      for (final v in [d.regrNm, d.regrId, d.modrNm, d.modrId]) {
        expect(v.length, 5);
        expect(int.tryParse(v), isNotNull);
      }
    });

    test('PartyKind maps to store names', () {
      expect(PartyKind.customer.storeName, 'customers');
      expect(PartyKind.supplier.storeName, 'suppliers');
    });
  });
}
