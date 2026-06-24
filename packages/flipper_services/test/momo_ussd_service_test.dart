import 'package:flipper_services/momo_ussd_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MomoUssdService', () {
    group('generatePhonePaymentCode', () {
      test('generates correct code for valid input', () {
        final code =
            MomoUssdService.generatePhonePaymentCode('0788123456', 5000);
        expect(code, '*182*1*1*0788123456*5000#');
      });

      test('handles phone number with country code', () {
        final code =
            MomoUssdService.generatePhonePaymentCode('+250788123456', 100);
        expect(code, '*182*1*1*0788123456*100#');
      });

      test('handles phone number without leading zero', () {
        final code = MomoUssdService.generatePhonePaymentCode('788123456', 500);
        expect(code, '*182*1*1*0788123456*500#');
      });

      test('formats amount correctly (removes decimals if whole number)', () {
        final code =
            MomoUssdService.generatePhonePaymentCode('0788123456', 5000.0);
        expect(code, '*182*1*1*0788123456*5000#');
      });
    });

    group('generateMomoCodePayment', () {
      test('generates correct code for valid input', () {
        final code = MomoUssdService.generateMomoCodePayment('123456', 5000);
        expect(code, '*182*8*1*123456*5000#');
      });

      test('trims whitespace from code', () {
        final code =
            MomoUssdService.generateMomoCodePayment('  123456  ', 5000);
        expect(code, '*182*8*1*123456*5000#');
      });
    });

    group('isValidPhoneNumber', () {
      test('returns true for valid MTN numbers', () {
        expect(MomoUssdService.isValidPhoneNumber('0788123456'), isTrue);
        expect(MomoUssdService.isValidPhoneNumber('0791234567'), isTrue);
      });

      test('returns true for valid Airtel numbers', () {
        expect(MomoUssdService.isValidPhoneNumber('0731234567'), isTrue);
        expect(MomoUssdService.isValidPhoneNumber('0721234567'), isTrue);
      });

      test('returns true for formats with country code', () {
        expect(MomoUssdService.isValidPhoneNumber('+250788123456'), isTrue);
        expect(MomoUssdService.isValidPhoneNumber('250788123456'), isTrue);
      });

      test('returns false for invalid length', () {
        expect(
            MomoUssdService.isValidPhoneNumber('078812345'), isFalse); // Short
        expect(
            MomoUssdService.isValidPhoneNumber('07881234567'), isFalse); // Long
      });

      test('returns false for unknown prefix', () {
        expect(MomoUssdService.isValidPhoneNumber('0751234567'), isFalse);
      });

      test('returns false for non-numeric', () {
        expect(MomoUssdService.isValidPhoneNumber('abc'), isFalse);
      });
    });

    group('isValidMomoCode', () {
      test('returns true for 6 digit code', () {
        expect(MomoUssdService.isValidMomoCode('123456'), isTrue);
      });

      test('returns true for 10 digit code', () {
        expect(MomoUssdService.isValidMomoCode('1234567890'), isTrue);
      });

      test('returns false for short code', () {
        expect(MomoUssdService.isValidMomoCode('12345'), isFalse);
      });

      test('returns false for long code', () {
        expect(MomoUssdService.isValidMomoCode('12345678901'), isFalse);
      });

      test('returns false for non-numeric', () {
        expect(MomoUssdService.isValidMomoCode('12345a'), isFalse);
      });
    });

    group('formatting', () {
      test('rounding logic for non-whole numbers', () {
        // The service implements: return amount.toStringAsFixed(0) for non-whole numbers
        // standard rounding: 5000.5 -> 5001, 5000.4 -> 5000

        // This test documents the behavior. If business logic requires floor/ceil, it should be changed.
        final code1 =
            MomoUssdService.generatePhonePaymentCode('0788123456', 5000.5);
        expect(code1, contains('*5001#'));

        final code2 =
            MomoUssdService.generatePhonePaymentCode('0788123456', 5000.4);
        expect(code2, contains('*5000#'));
      });
    });
  });
}
