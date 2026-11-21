import 'package:flipper_accounting/accounting_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/in_memory_accounting_store.dart';

class _NotReadyStore extends InMemoryAccountingStore {
  @override
  bool isReady() => false;
}

class _FailingReadStore extends InMemoryAccountingStore {
  @override
  Future<List<Map<String, dynamic>>> queryCollection(
    String collection,
    String query,
    Map<String, dynamic> args,
  ) async => throw StateError('ditto closed');
}

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

  test(
    'a setting that cannot be saved fails instead of passing silently',
    () async {
      final store = _NotReadyStore();
      await expectLater(
        AccountingSettingsStore(
          store,
        ).setVatRegistered(businessId: biz, registered: true),
        throwsStateError,
      );
      await expectLater(
        AccountingSettingsStore(
          InMemoryAccountingStore(),
        ).setVatRegistered(businessId: '', registered: true),
        throwsStateError,
      );
      expect(store.doc('accounting_settings', 'as_$biz'), isNull);
    },
  );

  group('recordEbmVatType', () {
    test('keeps RRA\'s VAT type beside the seeded defaults', () async {
      final store = InMemoryAccountingStore();
      await store.upsertPartyDoc('accounting_settings', 'as_$biz', {
        'businessId': biz,
        'vatPayableCode': '2100',
      });
      final saved = await AccountingSettingsStore(store).recordEbmVatType(
        businessId: biz,
        vatTyCd: '1',
        tin: '999909695',
        bhfId: '00',
        now: DateTime.utc(2026, 11, 21, 9),
      );
      expect(saved, isTrue);
      final doc = store.doc('accounting_settings', 'as_$biz')!;
      expect(doc['vatPayableCode'], '2100');
      expect(doc['ebmVatTyCdTin'], '999909695');
      expect(doc['ebmVatTyCdBhfId'], '00');
      final read = await AccountingSettingsStore(store).read(biz);
      expect(read.ebmVatTyCd, '1');
      expect(read.ebmVatTyCdAt, DateTime.utc(2026, 11, 21, 9));
      // Recorded only: it does not make the business VAT-registered.
      expect(read.vatRegistered, isFalse);
    });

    test(
      'nothing to record, or nowhere to record it: no write, no throw',
      () async {
        final store = InMemoryAccountingStore();
        final settings = AccountingSettingsStore(store);
        expect(
          await settings.recordEbmVatType(
            businessId: biz,
            vatTyCd: null,
            tin: '1',
            bhfId: '00',
          ),
          isFalse,
        );
        expect(
          await settings.recordEbmVatType(
            businessId: '',
            vatTyCd: '1',
            tin: '1',
            bhfId: '00',
          ),
          isFalse,
        );
        expect(
          await AccountingSettingsStore(_NotReadyStore()).recordEbmVatType(
            businessId: biz,
            vatTyCd: '1',
            tin: '1',
            bhfId: '00',
          ),
          isFalse,
        );
        expect(store.doc('accounting_settings', 'as_$biz'), isNull);
      },
    );
  });

  group('resolvePurchaseVatIsCost', () {
    Future<bool> resolve(bool? ebm, InMemoryAccountingStore store) =>
        resolvePurchaseVatIsCost(
          businessHasVatEbm: ebm,
          store: AccountingSettingsStore(store),
          businessId: biz,
        );

    test('no EBM and not registered: the VAT is stock cost', () async {
      expect(await resolve(false, InMemoryAccountingStore()), isTrue);
    });

    test('registered in Books: the VAT is reclaimable', () async {
      final store = InMemoryAccountingStore();
      await AccountingSettingsStore(
        store,
      ).setVatRegistered(businessId: biz, registered: true);
      expect(await resolve(false, store), isFalse);
    });

    test('unknown EBM state keeps VAT on 2100', () async {
      expect(await resolve(null, InMemoryAccountingStore()), isFalse);
    });

    test('a settings read that fails keeps VAT on 2100', () async {
      expect(await resolve(false, _FailingReadStore()), isFalse);
    });
  });

  test('purchase VAT is capitalized only without EBM and unregistered', () {
    const off = AccountingSettings();
    const on = AccountingSettings(vatRegistered: true);
    expect(
      capitalizesPurchaseVat(businessHasVatEbm: false, settings: off),
      isTrue,
    );
    expect(
      capitalizesPurchaseVat(businessHasVatEbm: false, settings: on),
      isFalse,
    );
    expect(
      capitalizesPurchaseVat(businessHasVatEbm: true, settings: off),
      isFalse,
    );
    expect(
      capitalizesPurchaseVat(businessHasVatEbm: true, settings: on),
      isFalse,
    );
  });
}
