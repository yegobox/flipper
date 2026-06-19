import 'package:flipper_dashboard/features/config/tax_config_logic.dart';
import 'package:test/test.dart';

void main() {
  const baseline = TaxConfigSnapshot(
    serverUrl: 'http://localhost:8080/rra1/',
    dataConnectorUrlOrNull: 'http://127.0.0.1:8084',
    bhfId: '00',
    mrc: 'YEGO2015122',
    vatEnabled: false,
  );

  group('trimTaxConfigUrl', () {
    test('trims whitespace', () {
      expect(trimTaxConfigUrl('  abc  '), 'abc');
      expect(trimTaxConfigUrl(null), '');
    });

    test('preserves trailing slash on tax URL', () {
      expect(trimTaxConfigUrl('http://x/ '), 'http://x/');
    });
  });

  group('normalizeOptionalConnectorUrl', () {
    test('maps empty / whitespace to null', () {
      expect(normalizeOptionalConnectorUrl(null), null);
      expect(normalizeOptionalConnectorUrl(''), null);
      expect(normalizeOptionalConnectorUrl('   '), null);
    });

    test('preserves slashes on connector URL', () {
      expect(
        normalizeOptionalConnectorUrl('http://127.0.0.1:8084/'),
        'http://127.0.0.1:8084/',
      );
    });
  });

  group('TaxConfigSnapshot.fromInputs', () {
    test('empty data connector yields null canonical', () {
      final s = TaxConfigSnapshot.fromInputs(
        serverUrl: ' http://a/ ',
        dataConnectorUrl: '  ',
        bhfId: '00',
        mrc: 'YEGO2015122',
        vatEnabled: false,
      );
      expect(s.serverUrl, 'http://a/');
      expect(s.dataConnectorUrlOrNull, isNull);
    });
  });

  group('taxConfigHasChanges', () {
    test('false when identical', () {
      expect(taxConfigHasChanges(baseline, baseline), false);
    });

    test('true when only data connector changes', () {
      final next = baseline.copyWith(
        dataConnectorUrlOrNull: 'http://localhost:8084/',
      );
      expect(taxConfigHasChanges(baseline, next), true);
    });

    test('true when only server URL changes', () {
      final next = baseline.copyWith(serverUrl: 'http://other/');
      expect(taxConfigHasChanges(baseline, next), true);
    });

    test('true when only bhfId or mrc changes', () {
      expect(
        taxConfigHasChanges(baseline, baseline.copyWith(bhfId: '01')),
        true,
      );
      expect(
        taxConfigHasChanges(baseline, baseline.copyWith(mrc: 'ABCDEFGHIJK')),
        true,
      );
    });

    test('false when only trim on tax URL with slash', () {
      final fromForm = TaxConfigSnapshot.fromInputs(
        serverUrl: 'http://localhost:8080/rra1/ ',
        dataConnectorUrl: 'http://127.0.0.1:8084',
        bhfId: '00',
        mrc: 'YEGO2015122',
        vatEnabled: false,
      );
      expect(taxConfigHasChanges(baseline, fromForm), false);
    });

    test('false when empty vs null data connector — equivalent', () {
      const a = TaxConfigSnapshot(
        serverUrl: 'http://localhost:8080/rra1/',
        dataConnectorUrlOrNull: null,
        bhfId: '00',
        mrc: 'YEGO2015122',
        vatEnabled: false,
      );
      final b = TaxConfigSnapshot.fromInputs(
        serverUrl: 'http://localhost:8080/rra1/',
        dataConnectorUrl: '',
        bhfId: '00',
        mrc: 'YEGO2015122',
        vatEnabled: false,
      );
      expect(taxConfigHasChanges(a, b), false);
    });
  });
}

extension on TaxConfigSnapshot {
  TaxConfigSnapshot copyWith({
    String? serverUrl,
    String? dataConnectorUrlOrNull,
    String? bhfId,
    String? mrc,
    bool? vatEnabled,
  }) {
    return TaxConfigSnapshot(
      serverUrl: serverUrl ?? this.serverUrl,
      dataConnectorUrlOrNull:
          dataConnectorUrlOrNull ?? this.dataConnectorUrlOrNull,
      bhfId: bhfId ?? this.bhfId,
      mrc: mrc ?? this.mrc,
      vatEnabled: vatEnabled ?? this.vatEnabled,
    );
  }
}
