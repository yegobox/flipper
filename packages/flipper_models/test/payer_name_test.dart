import 'package:flipper_models/helperModels/payer_name.dart';
import 'package:test/test.dart';

void main() {
  group('paymentMethodSupportsPayerName', () {
    test('accepts the mobile-money and bank tenders', () {
      for (final method in const [
        'MOBILE MONEY',
        'MTN MOMO',
        'AIRTEL MONEY',
        'BANK CHECK',
        'DEBIT&CREDIT CARD',
      ]) {
        expect(paymentMethodSupportsPayerName(method), isTrue, reason: method);
      }
    });

    test('rejects cash and credit so those rows are unchanged', () {
      expect(paymentMethodSupportsPayerName('CASH'), isFalse);
      expect(paymentMethodSupportsPayerName('CREDIT'), isFalse);
      expect(paymentMethodSupportsPayerName('CASH/CREDIT'), isFalse);
      expect(paymentMethodSupportsPayerName('OTHER'), isFalse);
    });

    test('is case and whitespace insensitive', () {
      expect(paymentMethodSupportsPayerName(' mtn momo '), isTrue);
      expect(paymentMethodSupportsPayerName('Mobile Money'), isTrue);
    });

    test('null is not payer-capable', () {
      expect(paymentMethodSupportsPayerName(null), isFalse);
    });
  });

  group('normalizedPayerName', () {
    test('trims a real name', () {
      expect(normalizedPayerName('  Jean Uwase '), 'Jean Uwase');
    });

    test('collapses blank input to null so nothing empty is persisted', () {
      expect(normalizedPayerName(null), isNull);
      expect(normalizedPayerName(''), isNull);
      expect(normalizedPayerName('   '), isNull);
    });
  });
}
