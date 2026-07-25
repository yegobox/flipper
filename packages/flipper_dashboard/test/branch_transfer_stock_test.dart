import 'package:flipper_dashboard/utils/branch_transfer_stock.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('isAuthenticCapellaStock', () {
    test('rejects null and empty-branch placeholders from getStockById miss', () {
      expect(isAuthenticCapellaStock(null), isFalse);
      expect(
        isAuthenticCapellaStock(
          Stock(
            id: 'missing',
            branchId: '',
            currentStock: 0,
          ),
        ),
        isFalse,
      );
    });

    test('accepts stock rows with a real branchId', () {
      expect(
        isAuthenticCapellaStock(
          Stock(
            id: 's1',
            branchId: 'branch-a',
            currentStock: 50,
          ),
        ),
        isTrue,
      );
      expect(
        isAuthenticCapellaStock(
          Stock(
            id: 's2',
            branchId: 'branch-a',
            currentStock: 0,
          ),
        ),
        isTrue,
      );
    });
  });

  group('onHandFromStock', () {
    test('uses currentStock only for authentic Capella rows', () {
      expect(
        onHandFromStock(
          Stock(id: 's1', branchId: 'b1', currentStock: 50),
        ),
        50,
      );
      expect(
        onHandFromStock(
          Stock(id: 'phantom', branchId: '', currentStock: 0),
          qtyFallback: 50,
        ),
        50,
      );
      expect(
        onHandFromStock(
          Stock(id: 'phantom', branchId: '', currentStock: 0),
        ),
        0,
      );
    });
  });

  group('destinationTaxTyCd', () {
    test('VAT source -> non-VAT destination collapses to D', () {
      expect(
        destinationTaxTyCd(sourceTaxTyCd: 'B', destVatEnabled: false),
        'D',
      );
    });

    test('non-VAT source -> VAT destination defaults to standard B', () {
      expect(
        destinationTaxTyCd(sourceTaxTyCd: 'D', destVatEnabled: true),
        'B',
      );
    });

    test('preserves existing VAT-regime codes for a VAT destination', () {
      expect(destinationTaxTyCd(sourceTaxTyCd: 'A', destVatEnabled: true), 'A');
      expect(destinationTaxTyCd(sourceTaxTyCd: 'C', destVatEnabled: true), 'C');
      expect(destinationTaxTyCd(sourceTaxTyCd: 'B', destVatEnabled: true), 'B');
    });

    test('preserves regulated F/TT regardless of VAT regime', () {
      expect(destinationTaxTyCd(sourceTaxTyCd: 'F', destVatEnabled: false), 'F');
      expect(
        destinationTaxTyCd(sourceTaxTyCd: 'TT', destVatEnabled: true),
        'TT',
      );
    });

    test('null / blank / lowercase source is normalized', () {
      expect(destinationTaxTyCd(sourceTaxTyCd: null, destVatEnabled: true), 'B');
      expect(destinationTaxTyCd(sourceTaxTyCd: '', destVatEnabled: false), 'D');
      expect(destinationTaxTyCd(sourceTaxTyCd: 'b', destVatEnabled: true), 'B');
    });
  });

  group('destinationTaxPercentage', () {
    test('standard-rated B is 18', () {
      expect(destinationTaxPercentage(taxTyCd: 'B'), 18.0);
    });

    test('exempt/zero-rated/non-VAT are 0', () {
      expect(destinationTaxPercentage(taxTyCd: 'A'), 0.0);
      expect(destinationTaxPercentage(taxTyCd: 'C'), 0.0);
      expect(destinationTaxPercentage(taxTyCd: 'D'), 0.0);
    });

    test('regulated F/TT keep the source rate', () {
      expect(destinationTaxPercentage(taxTyCd: 'F', fallback: 8), 8.0);
      expect(destinationTaxPercentage(taxTyCd: 'TT', fallback: null), isNull);
    });
  });

  group('destinationTransferStockId', () {
    test('is stable per destination variant id', () {
      expect(
        destinationTransferStockId('892ef0f7-b0c7-4132-bc02-5b6cd2060154'),
        '892ef0f7-b0c7-4132-bc02-5b6cd2060154-transfer-stock',
      );
    });
  });

  group('prepareDestinationVariantForPosCatalog', () {
    test('clears import/purchase workflow flags copied from source', () {
      final variant = Variant(
        id: 'v1',
        name: 'Pain coupe',
        branchId: 'dest',
        imptItemSttsCd: '2',
        pchsSttsCd: '01',
      );
      prepareDestinationVariantForPosCatalog(variant);
      expect(variant.imptItemSttsCd, isNull);
      expect(variant.pchsSttsCd, isNull);
    });
  });

  group('variantPassesPosCatalogFilters', () {
    test('non-VAT destination accepts D and rejects import-blocked statuses', () {
      final ok = Variant(
        id: 'v1',
        name: 'Pain coupe',
        branchId: 'dest',
        taxTyCd: 'D',
      );
      final hiddenImport = Variant(
        id: 'v2',
        name: 'Pain coupe',
        branchId: 'dest',
        taxTyCd: 'D',
        imptItemSttsCd: '2',
      );
      expect(variantPassesPosCatalogFilters(ok, destVatEnabled: false), isTrue);
      expect(
        variantPassesPosCatalogFilters(hiddenImport, destVatEnabled: false),
        isFalse,
      );
    });

    test('VAT destination rejects non-VAT tax code D', () {
      final variant = Variant(
        id: 'v1',
        name: 'Pain coupe',
        branchId: 'dest',
        taxTyCd: 'D',
      );
      expect(
        variantPassesPosCatalogFilters(variant, destVatEnabled: true),
        isFalse,
      );
    });
  });
}
