import 'package:flipper_payments/flipper_payments.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    setPaymentsApiBaseUrlOverride(null);
    setPaymentsBaseUrlResolver(null);
    resetPaymentsApiBaseUrlCache();
  });

  group('base URL resolution', () {
    test('falls back to the shared host when no host registers a resolver', () async {
      // What flipper_hr and flipper_web get. Before this package they pointed
      // at data-connector.yegobox.com while Books used prod.api.yegobox.com.
      expect(await paymentsApiBaseUrl(), kPaymentsApiBaseUrl);
    });

    test('prefers the host resolver over the default', () async {
      setPaymentsBaseUrlResolver(() async => 'https://branch.example.com/');
      expect(await paymentsApiBaseUrl(), 'https://branch.example.com');
    });

    test('a resolver returning null falls through rather than failing', () async {
      setPaymentsBaseUrlResolver(() async => null);
      expect(await paymentsApiBaseUrl(), kPaymentsApiBaseUrl);
    });

    test('a throwing resolver never blocks a payment', () async {
      // The EBM lookup reads a local replica and can fail offline. A payment
      // must still go out, to the default host.
      setPaymentsBaseUrlResolver(() async => throw StateError('no replica'));
      expect(await paymentsApiBaseUrl(), kPaymentsApiBaseUrl);
    });

    test('the override wins over a registered resolver', () async {
      setPaymentsBaseUrlResolver(() async => 'https://branch.example.com');
      setPaymentsApiBaseUrlOverride(kPaymentsApiLocalBaseUrl);
      expect(await paymentsApiBaseUrl(), kPaymentsApiLocalBaseUrl);
    });

    test('the cache is dropped when the branch changes', () async {
      var host = 'https://one.example.com';
      setPaymentsBaseUrlResolver(() async => host);
      expect(await paymentsApiBaseUrl(), 'https://one.example.com');

      host = 'https://two.example.com';
      expect(await paymentsApiBaseUrl(), 'https://one.example.com',
          reason: 'cached until the branch changes');

      resetPaymentsApiBaseUrlCache();
      expect(await paymentsApiBaseUrl(), 'https://two.example.com');
    });

    test('never returns a trailing slash, so callers can concatenate paths', () async {
      setPaymentsApiBaseUrlOverride('https://host.example.com/');
      expect(await paymentsApiBaseUrl(), 'https://host.example.com');
    });
  });

  group('MSISDN handling', () {
    test('canonicalises the three Rwandan spellings to one payer', () {
      // Mandates are matched by MSISDN: three spellings of one number would
      // look like three payers who each need their own consent.
      for (final spelling in ['0788123456', '788123456', '+250788123456']) {
        expect(MomoMsisdn.toPartyId(spelling), '250788123456');
      }
    });

    test('lets a non-Rwandan mobile through as digits', () {
      expect(MomoMsisdn.toPartyId('+254712345678'), '254712345678');
    });

    test('refuses what can never be dialled', () {
      expect(MomoMsisdn.toPartyId('12345'), isNull);
      expect(MomoMsisdn.toPartyId(''), isNull);
    });

    test('masks to the last three digits for logs', () {
      expect(MomoMsisdn.masked('+250788123456'), '…456');
    });
  });

  group('payment rail', () {
    test('reads stored payment_method values, defaulting to MoMo', () {
      expect(PaymentRail.fromWire('DODO'), PaymentRail.card);
      expect(PaymentRail.fromWire('MTNMOMO'), PaymentRail.mtnMomo);
      // Legacy Paystack rows and nulls: MoMo is the rail every plan is on.
      expect(PaymentRail.fromWire('CARD'), PaymentRail.mtnMomo);
      expect(PaymentRail.fromWire(null), PaymentRail.mtnMomo);
    });

    test('round-trips through the wire value', () {
      for (final rail in PaymentRail.values) {
        expect(PaymentRail.fromWire(rail.wireValue), rail);
      }
    });
  });
}
