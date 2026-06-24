import 'package:flipper_models/domain/party/party_validation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('validatePartyName', () {
    test('requires a value with type-specific message', () {
      expect(validatePartyName(null, isBusiness: true),
          'Business name is required');
      expect(validatePartyName('  ', isBusiness: true),
          'Business name is required');
      expect(validatePartyName(null, isBusiness: false), 'Name is required');
      expect(validatePartyName('', isBusiness: false), 'Name is required');
    });

    test('accepts non-empty names', () {
      expect(validatePartyName('Kigali Traders', isBusiness: true), isNull);
      expect(validatePartyName('Jean', isBusiness: false), isNull);
    });
  });

  group('validatePartyPhone', () {
    test('requires a value', () {
      expect(validatePartyPhone(null), 'Phone number is required');
      expect(validatePartyPhone('  '), 'Phone number is required');
    });

    test('accepts any non-empty value', () {
      expect(validatePartyPhone('0788123456'), isNull);
    });
  });

  group('validatePartyEmail', () {
    test('is optional', () {
      expect(validatePartyEmail(null), isNull);
      expect(validatePartyEmail(''), isNull);
    });

    test('rejects malformed addresses', () {
      expect(
          validatePartyEmail('not-an-email'), 'Please enter a valid email address');
    });

    test('accepts valid addresses', () {
      expect(validatePartyEmail('jean@example.com'), isNull);
    });
  });

  group('validatePartyTin', () {
    test('is optional', () {
      expect(validatePartyTin(null), isNull);
      expect(validatePartyTin(''), isNull);
      expect(validatePartyTin('   '), isNull);
    });

    test('rejects non-digits', () {
      expect(validatePartyTin('12345678a'), 'TIN should contain only digits');
    });

    test('rejects wrong length', () {
      expect(validatePartyTin('12345678'), 'TIN must be 9 digits');
      expect(validatePartyTin('1234567890'), 'TIN must be 9 digits');
    });

    test('accepts exactly 9 digits', () {
      expect(validatePartyTin('123456789'), isNull);
      expect(validatePartyTin(' 123456789 '), isNull);
    });
  });

  group('normalizeCustNo', () {
    test('strips a single leading zero', () {
      expect(normalizeCustNo('0788123456'), '788123456');
    });

    test('passes through numbers without leading zero', () {
      expect(normalizeCustNo('788123456'), '788123456');
      expect(normalizeCustNo('+250788123456'), '+250788123456');
    });

    test('handles null', () {
      expect(normalizeCustNo(null), isNull);
    });
  });
}
