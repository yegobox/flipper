import 'package:flipper_models/countries_asset.dart';
import 'package:flutter_test/flutter_test.dart';

// Parser cases run anywhere. The bundle case needs the asset manifest, so run
// this file WITHOUT --no-test-assets:
//   flutter test test/countries_asset_test.dart
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('parseCountriesCsv', () {
    test('skips the header row and parses fields', () {
      final countries = parseCountriesCsv(
        'name,sort_order,code,description\n'
        'RWANDA,193,RW,"RWANDA"\n'
        'KENYA,116,KE,"KENYA"\n',
      );

      expect(countries.map((c) => c.code), ['RW', 'KE']);
      expect(countries.first.name, 'RWANDA');
      expect(countries.first.sortOrder, 193);
      expect(countries.first.description, 'RWANDA');
    });

    test('strips wrapping quotes and tolerates junk rows', () {
      final countries = parseCountriesCsv(
        'name,sort_order,code,description\n'
        '\n'
        'BROKEN ROW\n'
        'NO SORT ORDER,,XX,x\n'
        '"UNITED ARAB EMIRATES",3,AE,"UNITED ARAB EMIRATES"\n',
      );

      expect(countries, hasLength(1));
      expect(countries.single.name, 'UNITED ARAB EMIRATES');
      expect(countries.single.code, 'AE');
    });

    test('keeps the first row for a duplicated code', () {
      final countries = parseCountriesCsv(
        'name,sort_order,code,description\n'
        'RWANDA,193,RW,a\n'
        'RWANDA DUPLICATE,999,RW,b\n',
      );

      expect(countries, hasLength(1));
      expect(countries.single.name, 'RWANDA');
    });
  });

  group('countriesWithDefaultFirst', () {
    test('puts Rwanda first, then sorts the rest by name', () {
      final ordered = countriesWithDefaultFirst(
        parseCountriesCsv(
          'name,sort_order,code,description\n'
          'ZAMBIA,250,ZM,x\n'
          'ALBANIA,6,AL,x\n'
          'RWANDA,193,RW,x\n'
          'KENYA,116,KE,x\n',
        ),
      );

      // Both country pickers use the first entry as the default origin, so
      // Rwanda has to lead or products get filed under the wrong country.
      expect(ordered.map((c) => c.code), ['RW', 'AL', 'KE', 'ZM']);
    });

    test('leaves the list alone when Rwanda is absent', () {
      final ordered = countriesWithDefaultFirst(
        parseCountriesCsv(
          'name,sort_order,code,description\n'
          'ZAMBIA,250,ZM,x\n'
          'ALBANIA,6,AL,x\n',
        ),
      );

      expect(ordered.map((c) => c.code), ['AL', 'ZM']);
    });
  });

  group('bundled asset', () {
    test('loads and parses countries.csv from the package bundle', () async {
      final countries = await loadBundledCountries();

      expect(
        countries.length,
        greaterThan(200),
        reason: 'the CSV ships ~248 ISO countries',
      );

      final rwanda = countries.firstWhere((c) => c.code == 'RW');
      expect(rwanda.name, 'RWANDA');

      // Codes are unique, which is what the pickers key on.
      expect(
        countries.map((c) => c.code).toSet().length,
        equals(countries.length),
      );
    });
  });
}
