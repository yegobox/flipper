import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/local_mode_tax_guard.dart';
import 'package:flipper_models/services/payment_verification_service.dart';
import 'package:flipper_models/tax_api.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTaxApi extends Mock implements TaxApi {}

class _FakeVariant extends Fake implements Variant {}

/// Local mode (offline on this device, free forever) must bypass the paywall
/// and EBM — and with the flag off, both must behave exactly as before.
void main() {
  setUpAll(() => registerFallbackValue(_FakeVariant()));
  tearDown(() => LocalMode.debugSet(false));

  group('PaymentVerificationService.verifyPaymentStatus', () {
    test('local mode is always active, with no plan lookup', () async {
      LocalMode.debugSet(true);
      final response = await PaymentVerificationService().verifyPaymentStatus();
      expect(response.result, PaymentVerificationResult.active);
    });

    test('full sync still checks the plan', () async {
      LocalMode.debugSet(false);
      // No strategy is registered here, so the real lookup fails — proving the
      // bypass was not taken.
      final response = await PaymentVerificationService().verifyPaymentStatus();
      expect(response.result, isNot(PaymentVerificationResult.active));
    });
  });

  group('LocalModeTaxGuard', () {
    late _MockTaxApi inner;
    late LocalModeTaxGuard guard;

    setUp(() {
      inner = _MockTaxApi();
      guard = LocalModeTaxGuard(inner);
    });

    test('local mode never reaches the tax server', () async {
      LocalMode.debugSet(true);
      final variant = _FakeVariant();

      final saved = await guard.saveItem(variation: variant, URI: 'http://x/');
      expect(saved.resultCd, LocalModeTaxGuard.unavailableCode);
      expect(
        await guard.stockIn(json: const {}, URI: 'http://x/', sarTyCd: '02'),
        isFalse,
      );
      expect(await guard.taxConfigs(branchId: 'b1'), isEmpty);
      expect(await guard.fetchNotices(URI: 'http://x/'), isEmpty);
      verifyZeroInteractions(inner);
    });

    test('full sync delegates every call unchanged', () async {
      LocalMode.debugSet(false);
      final variant = _FakeVariant();
      final ok = RwApiResponse(resultCd: '000', resultMsg: 'ok');
      when(
        () => inner.saveItem(variation: variant, URI: 'http://x/'),
      ).thenAnswer((_) async => ok);

      final saved = await guard.saveItem(variation: variant, URI: 'http://x/');

      expect(saved, same(ok));
      verify(() => inner.saveItem(variation: variant, URI: 'http://x/'));
    });
  });
}
