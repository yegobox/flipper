import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/repository/local_storage.dart';

// flutter test test/payment_type_prefs_test.dart --dart-define=FLUTTER_TEST_ENV=true
void main() {
  late SharedPreferenceStorage box;

  setUp(() async {
    box = SharedPreferenceStorage();
    await box.initializePreferences();
    await box.clear();
  });

  tearDown(() async {
    await box.clear();
    box.dispose();
  });

  test('a method saved under an old spelling reads back canonical', () async {
    expect(box.paymentType(), isNull);

    await box.writeString(key: 'paymentType', value: 'MTN MOMO');
    expect(box.paymentType(), 'MOBILE MONEY');

    // Anything that is not mobile money comes back as saved.
    await box.writeString(key: 'paymentType', value: 'Cash');
    expect(box.paymentType(), 'Cash');
  });

  test('paymentMethodCode files every mobile-money spelling as 06', () {
    expect(box.paymentMethodCode('MTN MOMO'), '06');
    expect(box.paymentMethodCode('AIRTEL MONEY'), '06');
    expect(box.paymentMethodCode('CASH'), '01');
    // A bank transfer that merely starts with MOBILE is not mobile money.
    expect(box.paymentMethodCode('MOBILE BANK TRANSFER'), '07');
  });
}
