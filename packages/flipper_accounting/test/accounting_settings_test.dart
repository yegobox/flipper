import 'package:flipper_accounting/accounting_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

void main() {
  const biz = 'biz';

  test('missing document reads as not registered', () async {
    final settings = await AccountingSettingsStore(
      InMemoryAccountingStore(),
    ).read(biz);
    expect(settings.vatRegistered, isFalse);
    expect(settings.vatRegisteredChangedAt, isNull);
  });

  test('saving keeps the seeded defaults in the same document', () async {
    final store = InMemoryAccountingStore();
    // What data-connector seeds (bootstrap::settings_doc).
    await store.upsertPartyDoc('accounting_settings', 'as_$biz', {
      'businessId': biz,
      'defaultVatRate': 0.18,
      'vatPayableCode': '2100',
    });
    await AccountingSettingsStore(store).setVatRegistered(
      businessId: biz,
      registered: true,
      now: DateTime.utc(2026, 11, 20, 8),
    );
    final doc = store.doc('accounting_settings', 'as_$biz')!;
    expect(doc['vatPayableCode'], '2100');
    expect(doc['vatRegistered'], isTrue);
    final read = await AccountingSettingsStore(store).read(biz);
    expect(read.vatRegistered, isTrue);
    expect(read.vatRegisteredChangedAt, DateTime.utc(2026, 11, 20, 8));
  });

  test('purchase VAT is capitalized only without EBM and unregistered', () {
    const off = AccountingSettings();
    const on = AccountingSettings(vatRegistered: true);
    expect(
      capitalizesPurchaseVat(branchVatEnabled: false, settings: off),
      isTrue,
    );
    expect(
      capitalizesPurchaseVat(branchVatEnabled: false, settings: on),
      isFalse,
    );
    expect(
      capitalizesPurchaseVat(branchVatEnabled: true, settings: off),
      isFalse,
    );
    expect(
      capitalizesPurchaseVat(branchVatEnabled: true, settings: on),
      isFalse,
    );
  });
}
