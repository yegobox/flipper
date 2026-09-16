import 'package:flipper_models/helperModels/signup_countries.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('the table itself', () {
    test('covers the world, not the handful signup started with', () {
      expect(kSignupCountries.length, greaterThan(200));
      for (final name in ['Rwanda', 'Japan', 'Brazil', 'Iceland', 'Fiji']) {
        expect(signupCountryByName(name), isNotNull, reason: name);
      }
    });

    test('has no duplicate names or ISO codes', () {
      final names = kSignupCountries.map((c) => c.name).toSet();
      final codes = kSignupCountries.map((c) => c.iso2).toSet();
      expect(names.length, kSignupCountries.length);
      expect(codes.length, kSignupCountries.length);
    });

    test('every entry carries a + dial code and a 3-letter currency', () {
      for (final country in kSignupCountries) {
        expect(country.dialCode, startsWith('+'), reason: country.name);
        expect(country.dialCode.length, greaterThan(1), reason: country.name);
        expect(country.currency.length, 3, reason: country.name);
      }
    });

    test('is sorted, so a picker can render it as-is', () {
      // Alphabetical the way a reader expects: an accent does not send a
      // country to the end of the list.
      String fold(String name) => name
          .toLowerCase()
          .replaceAll(RegExp('[àáâãä]'), 'a')
          .replaceAll(RegExp('[èéêë]'), 'e')
          .replaceAll(RegExp('[ìíîï]'), 'i')
          .replaceAll(RegExp('[òóôõö]'), 'o')
          .replaceAll(RegExp('[ùúûü]'), 'u')
          .replaceAll('ç', 'c');
      final sorted = [...kSignupCountryNames]
        ..sort((a, b) => fold(a).compareTo(fold(b)));
      expect(kSignupCountryNames, sorted);
    });
  });

  group('lookup', () {
    test('falls back to Rwanda for a country it does not know', () {
      expect(signupDialCodeFor('Atlantis'), kDefaultSignupDialCode);
      expect(signupCurrencyFor('Atlantis'), kDefaultSignupCurrency);
      expect(signupCurrencyFor(null), kDefaultSignupCurrency);
    });

    test('currency follows the country', () {
      expect(signupCurrencyFor('Rwanda'), 'RWF');
      expect(signupCurrencyFor('Kenya'), 'KES');
      expect(signupCurrencyFor('Germany'), 'EUR');
      expect(signupCurrencyFor('Japan'), 'JPY');
    });

    test('resolves names stored before this table existed', () {
      // The checkout dial-code map this replaced stored DRC under its own name.
      expect(signupDialCodeFor('DRC'), '+243');
      expect(signupDialCodeFor('Congo'), '+243');
      expect(signupDialCodeFor('USA'), '+1');
      expect(signupDialCodeFor('Ivory Coast'), '+225');
      expect(signupDialCodeFor('rwanda'), '+250');
    });

    test('resolves an ISO code, which is what some rows store', () {
      // SignupViewModel.setCountry is called with 'RW', not 'Rwanda'.
      expect(signupCurrencyFor('RW'), 'RWF');
      expect(signupDialCodeFor('gb'), '+44');
      expect(signupCountryByIso2('jp')?.name, 'Japan');
      // Not a two-letter code, so it stays unknown rather than half-matching.
      expect(signupCountryByName('Zz'), isNull);
    });

    test('matches the longest dial code, not the first', () {
      // +1 and +1268 are both in the table.
      expect(matchLeadingDialCode('+1268464123'), '+1268');
      expect(matchLeadingDialCode('+12125550100'), '+1');
      expect(matchLeadingDialCode('783054874'), isNull);
    });
  });

  group('searchSignupCountries', () {
    test('an empty query offers everything, in picker order', () {
      expect(searchSignupCountries('  '), kSignupCountryNames);
    });

    test('prefix matches come before contains matches', () {
      final results = searchSignupCountries('ind');
      expect(results.first, 'India');
      expect(results, contains('Indonesia'));
    });

    test('an ISO code finds its country, first', () {
      expect(searchSignupCountries('jp').first, 'Japan');
      expect(searchSignupCountries('GB').first, 'United Kingdom');
    });

    test('an alias finds its country — nothing else would', () {
      // 'USA' shares no prefix with 'United States', so the plain name search
      // these pickers started with offered nothing at all.
      expect(searchSignupCountries('USA').first, 'United States');
      expect(searchSignupCountries('uk').first, 'United Kingdom');
      expect(searchSignupCountries('DRC'), ['Congo - Kinshasa']);
      expect(searchSignupCountries('ivory coast'), ["Côte d'Ivoire"]);
    });

    test('a resolved country is not offered twice', () {
      final results = searchSignupCountries('rw');
      expect(results.where((c) => c == 'Rwanda').length, 1);
    });

    test('never offers a country outside the caller\'s own list', () {
      const offered = ['Rwanda', 'Kenya', 'Uganda'];
      expect(searchSignupCountries('USA', within: offered), isEmpty);
      expect(searchSignupCountries('ken', within: offered), ['Kenya']);
    });

    test('a query that matches nothing comes back empty', () {
      expect(searchSignupCountries('zzzz'), isEmpty);
    });
  });

  group('isPlausiblePhoneNumber', () {
    test('accepts national numbers of the lengths countries actually use', () {
      expect(isPlausiblePhoneNumber('783054874', country: 'Rwanda'), isTrue);
      expect(isPlausiblePhoneNumber('0783054874', country: 'Rwanda'), isTrue);
      // Eight digits in Norway, seven in Iceland — both used to be rejected by
      // the nine-digit rule signup applied to everyone.
      expect(isPlausiblePhoneNumber('40612345', country: 'Norway'), isTrue);
      expect(isPlausiblePhoneNumber('6112345', country: 'Iceland'), isTrue);
      expect(
        isPlausiblePhoneNumber('7911123456', country: 'United Kingdom'),
        isTrue,
      );
    });

    test('accepts a number that already carries a dial code', () {
      expect(isPlausiblePhoneNumber('+250 783 054 874'), isTrue);
      expect(isPlausiblePhoneNumber('+81 90-1234-5678'), isTrue);
    });

    test('rejects an unknown dial code', () {
      expect(isPlausiblePhoneNumber('+999123456789'), isFalse);
    });

    test('rejects letters instead of counting round them', () {
      // Stripping non-digits first made this nine digits, so it passed — and
      // the normalizer keeps letters, so `+250abc0788123456` went to the API.
      expect(isPlausiblePhoneNumber('abc0788123456', country: 'Rwanda'),
          isFalse);
      expect(isPlausiblePhoneNumber('0788123456 (work)', country: 'Rwanda'),
          isFalse);
      expect(isPlausiblePhoneNumber('user@example.com', country: 'Rwanda'),
          isFalse);
      // The separators people do type stay welcome.
      expect(isPlausiblePhoneNumber('(078) 812-3456', country: 'Rwanda'),
          isTrue);
    });

    test('rejects too short and beyond E.164', () {
      expect(isPlausiblePhoneNumber('123', country: 'Rwanda'), isFalse);
      expect(isPlausiblePhoneNumber('', country: 'Rwanda'), isFalse);
      expect(
        isPlausiblePhoneNumber('+2507830548741234567', country: 'Rwanda'),
        isFalse,
      );
    });
  });
}
