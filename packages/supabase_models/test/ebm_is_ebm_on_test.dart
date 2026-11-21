import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/ebm.model.dart';

// flutter test test/ebm_is_ebm_on_test.dart
//
// EBM on and VAT-registered are separate switches: RRA puts taxpayers on EBM
// who are not VAT-registered, and their VSDC accepts only tax code D.

Ebm _ebm({bool? vatEnabled = false, bool? ebmEnabled}) => Ebm(
      bhfId: '01',
      tinNumber: 108754813,
      dvcSrlNo: 'dvc',
      businessId: 'biz',
      branchId: 'b1',
      mrc: 'mrc',
      vatEnabled: vatEnabled,
      ebmEnabled: ebmEnabled,
    );

void main() {
  group('Ebm.isEbmOn', () {
    test('without ebmEnabled it follows vatEnabled, as before', () {
      expect(_ebm(vatEnabled: true).isEbmOn, isTrue);
      expect(_ebm(vatEnabled: false).isEbmOn, isFalse);
      expect(_ebm(vatEnabled: null).isEbmOn, isFalse);
    });

    test('EBM on without VAT registration', () {
      final ebm = _ebm(vatEnabled: false, ebmEnabled: true);
      expect(ebm.ebmEnabled, isTrue);
      expect(ebm.isEbmOn, isTrue);
      expect(ebm.vatEnabled, isFalse);
    });

    test('ebmEnabled false turns EBM off even when VAT is on', () {
      expect(_ebm(vatEnabled: true, ebmEnabled: false).isEbmOn, isFalse);
    });

    test('the default constructor leaves ebmEnabled unset', () {
      expect(_ebm().ebmEnabled, isNull);
    });
  });
}
