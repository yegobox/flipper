import 'package:flipper_services/payment_methods.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('canonicalPaymentMethod', () {
    test('folds every MTN / MoMo spelling into MOBILE MONEY', () {
      for (final raw in [
        'MOBILE MONEY',
        'Mobile Money',
        'mobile_money',
        'MTN MOMO',
        'MTN MoMo',
        'MOMO',
        'Momo',
        'momo',
        'MTN',
        'MTN Mobile Money',
        ' mobile money ',
      ]) {
        expect(canonicalPaymentMethod(raw), kMobileMoney, reason: raw);
      }
    });

    test('keeps Airtel as its own tender', () {
      for (final raw in ['AIRTEL MONEY', 'Airtel Money', 'airtel']) {
        expect(canonicalPaymentMethod(raw), kAirtelMoney, reason: raw);
      }
    });

    test('passes other tenders through untouched', () {
      expect(canonicalPaymentMethod('CASH'), 'CASH');
      expect(canonicalPaymentMethod('Cash'), 'Cash');
      expect(canonicalPaymentMethod('DEBIT&CREDIT CARD'), 'DEBIT&CREDIT CARD');
      expect(canonicalPaymentMethod('CREDIT'), 'CREDIT');
      expect(canonicalPaymentMethod('BANK CHECK'), 'BANK CHECK');
      expect(canonicalPaymentMethod(' OTHER '), 'OTHER');
      // Whole words only: these merely contain MOBILE / MONEY / MTN letters.
      expect(
        canonicalPaymentMethod('MOBILE BANK TRANSFER'),
        'MOBILE BANK TRANSFER',
      );
      expect(canonicalPaymentMethod('Mobile Banking'), 'Mobile Banking');
      expect(canonicalPaymentMethod('MONEY ORDER'), 'MONEY ORDER');
    });

    test('null and blank stay blank', () {
      expect(canonicalPaymentMethod(null), '');
      expect(canonicalPaymentMethod('  '), '');
    });
  });

  test('rraPaymentTypeCode sends every mobile-money spelling as 06', () {
    for (final raw in ['MOBILE MONEY', 'MTN MOMO', 'Momo', 'AIRTEL MONEY']) {
      expect(rraPaymentTypeCode(raw), '06', reason: raw);
    }
    expect(rraPaymentTypeCode('Cash'), '01');
    expect(rraPaymentTypeCode('CREDIT'), '02');
    expect(rraPaymentTypeCode('CASH/CREDIT'), '03');
    expect(rraPaymentTypeCode('BANK CHECK'), '04');
    expect(rraPaymentTypeCode('DEBIT&CREDIT CARD'), '05');
    expect(rraPaymentTypeCode('OTHER'), '07');
    expect(rraPaymentTypeCode('MOBILE BANK TRANSFER'), '07');
    expect(rraPaymentTypeCode(null), '07');
  });

  test('isMobileMoneyTender', () {
    expect(isMobileMoneyTender('MTN MOMO'), isTrue);
    expect(isMobileMoneyTender('AIRTEL MONEY'), isTrue);
    expect(isMobileMoneyTender('Momo'), isTrue);
    expect(isMobileMoneyTender('CASH'), isFalse);
    expect(isMobileMoneyTender('DEBIT&CREDIT CARD'), isFalse);
    expect(isMobileMoneyTender(null), isFalse);
  });
}
