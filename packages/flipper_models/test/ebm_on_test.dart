import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/sync/utils/branch_transfer_rra.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/ebm.model.dart';

/// EBM on and VAT-registered are separate: RRA puts taxpayers on EBM who are
/// not VAT-registered, and their VSDC accepts only tax code D.
void main() {
  Ebm ebm({bool? vatEnabled, bool? ebmEnabled}) => Ebm(
    bhfId: '01',
    tinNumber: 108754813,
    dvcSrlNo: 'dvc',
    businessId: 'biz',
    branchId: 'b1',
    mrc: 'mrc',
    vatEnabled: vatEnabled,
    ebmEnabled: ebmEnabled,
  );

  group('Ebm.isEbmOn', () {
    test('unset ebmEnabled follows vatEnabled, as before', () {
      expect(ebm(vatEnabled: true).isEbmOn, isTrue);
      expect(ebm(vatEnabled: false).isEbmOn, isFalse);
      expect(ebm().isEbmOn, isFalse);
    });

    test('EBM on without VAT registration', () {
      final e = ebm(vatEnabled: false, ebmEnabled: true);
      expect(e.isEbmOn, isTrue);
      expect(e.vatEnabled, isFalse);
    });

    test('ebmEnabled false turns EBM off even with VAT on', () {
      expect(ebm(vatEnabled: true, ebmEnabled: false).isEbmOn, isFalse);
    });
  });

  group('ebmOnFromDoc', () {
    test('reads Ditto camelCase', () {
      expect(ebmOnFromDoc({'vatEnabled': false, 'ebmEnabled': true}), isTrue);
      expect(ebmOnFromDoc({'vatEnabled': true, 'ebmEnabled': false}), isFalse);
    });

    test('reads Supabase snake_case', () {
      expect(ebmOnFromDoc({'vat_enabled': false, 'ebm_enabled': true}), isTrue);
    });

    test('falls back to VAT when ebmEnabled is missing or null', () {
      expect(ebmOnFromDoc({'vatEnabled': true}), isTrue);
      expect(ebmOnFromDoc({'vatEnabled': true, 'ebmEnabled': null}), isTrue);
      expect(ebmOnFromDoc({'vat_enabled': false}), isFalse);
      expect(ebmOnFromDoc({}), isFalse);
    });
  });

  group('destinationBranchRequiresTransferRra', () {
    test('an EBM branch without VAT still reports transfers', () {
      expect(
        destinationBranchRequiresTransferRra(
          ebm(vatEnabled: false, ebmEnabled: true),
        ),
        isTrue,
      );
    });

    test('no EBM, no transfer reporting', () {
      expect(destinationBranchRequiresTransferRra(null), isFalse);
      expect(
        destinationBranchRequiresTransferRra(ebm(vatEnabled: false)),
        isFalse,
      );
    });
  });

  test('tax codes still follow VAT, not EBM', () {
    final e = ebm(vatEnabled: false, ebmEnabled: true);
    expect(defaultTaxTyCdForVat(e.vatEnabled == true), 'D');
  });
}
