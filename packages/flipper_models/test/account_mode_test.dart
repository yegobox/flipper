import 'dart:convert';

import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/account_mode/account_mode_client.dart';
import 'package:flipper_models/account_mode/account_mode_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:supabase_models/brick/repository/storage.dart';

class _MemBox extends Fake implements LocalStorage {
  _MemBox({this.businessId});

  final Map<String, String> values = {};
  String? businessId;

  @override
  String? getBusinessId() => businessId;

  @override
  String? readString({required String key}) => values[key];

  @override
  Future<void> writeString({
    required String key,
    required String value,
  }) async => values[key] = value;

  @override
  dynamic remove({required String key}) => values.remove(key);
}

AccountModeStore _store(
  _MemBox box, {
  Map<String, dynamic>? doc,
  required http.Client http,
}) => AccountModeStore(
  box: () => box,
  readDittoDoc: (_) async => doc,
  client: AccountModeClient(
    baseUrl: () async => 'https://connector.test',
    httpClient: http,
  ),
);

http.Client _never() => MockClient((_) async {
  fail('no network expected');
});

void main() {
  group('parseAccountMode', () {
    test('only an exact personal is personal', () {
      expect(parseAccountMode('personal'), AccountMode.personal);
      expect(parseAccountMode(' personal '), AccountMode.personal);
      for (final v in [null, '', 'business', 'Personal', 2, true, {}]) {
        expect(parseAccountMode(v), AccountMode.business, reason: '$v');
      }
    });
  });

  group('cache', () {
    test('round-trips per business and survives corruption', () {
      final raw = withCachedAccountMode(null, 'b1', AccountMode.personal);
      expect(cachedAccountMode(raw, 'b1'), AccountMode.personal);
      expect(cachedAccountMode(raw, 'b2'), isNull);
      final both = withCachedAccountMode(raw, 'b2', AccountMode.business);
      expect(cachedAccountMode(both, 'b1'), AccountMode.personal);
      expect(cachedAccountMode(both, 'b2'), AccountMode.business);
      expect(cachedAccountMode('{not json', 'b1'), isNull);
    });

    test('reads the older plain-string form', () {
      final entry = cachedAccountModeEntry('{"b1":"personal"}', 'b1')!;
      expect(entry.mode, AccountMode.personal);
      expect(entry.changedAt, isNull);
    });

    test('keeps the server time', () {
      final at = DateTime.utc(2026, 10, 22, 8);
      final raw = withCachedAccountMode(
        null,
        'b1',
        AccountMode.business,
        changedAt: at,
      );
      expect(cachedAccountModeEntry(raw, 'b1')!.changedAt, at);
    });
  });

  group('localAccountMode precedence', () {
    test('the server doc wins over a pending signup and the cache', () {
      expect(
        localAccountMode(
          dittoDoc: {'mode': 'business'},
          pending: 'personal',
          cached: const CachedAccountMode(AccountMode.personal),
        ),
        AccountMode.business,
      );
    });
    test('a pending personal signup wins over the cache', () {
      expect(
        localAccountMode(
          dittoDoc: null,
          pending: 'personal',
          cached: const CachedAccountMode(AccountMode.business),
        ),
        AccountMode.personal,
      );
    });
    test('right after a switch the newer cache beats the stale doc', () {
      final docAt = DateTime.utc(2026, 10, 22, 8);
      expect(
        localAccountMode(
          dittoDoc: {'mode': 'personal', 'changedAt': docAt.toIso8601String()},
          pending: null,
          cached: CachedAccountMode(
            AccountMode.business,
            changedAt: docAt.add(const Duration(seconds: 5)),
          ),
        ),
        AccountMode.business,
      );
    });

    test('once the doc catches up it wins again', () {
      final at = DateTime.utc(2026, 10, 22, 8);
      for (final docAt in [at, at.add(const Duration(minutes: 1))]) {
        expect(
          localAccountMode(
            dittoDoc: {
              'mode': 'personal',
              'changedAt': docAt.toIso8601String(),
            },
            pending: null,
            cached: CachedAccountMode(AccountMode.business, changedAt: at),
          ),
          AccountMode.personal,
        );
      }
    });

    test('nothing known is null (callers treat it as business)', () {
      expect(
        localAccountMode(dittoDoc: null, pending: null, cached: null),
        isNull,
      );
    });
  });

  group('AccountModeStore', () {
    test('a business account with no doc and no cache is never personal '
        'locally, and needs no network', () async {
      final box = _MemBox(businessId: 'shop');
      final store = _store(box, http: _never());
      expect(await store.isPersonalLocal(), isFalse);
      expect(store.cachedMode(), isNull);
    });

    test('the Ditto doc is cached for the next cold start', () async {
      final box = _MemBox(businessId: 'me');
      final store = _store(box, doc: {'mode': 'personal'}, http: _never());
      expect(await store.isPersonalLocal(), isTrue);
      await Future<void>.delayed(Duration.zero);
      expect(store.cachedMode(), AccountMode.personal);
    });

    test('resolve asks the server once per business per session', () async {
      var calls = 0;
      final box = _MemBox(businessId: 'me');
      final store = _store(
        box,
        http: MockClient((req) async {
          calls++;
          expect(req.method, 'GET');
          expect(req.url.path, '/api/account-mode');
          return http.Response(jsonEncode({'mode': 'personal'}), 200);
        }),
      );
      expect(await store.resolve(), AccountMode.personal);
      // Cached now: answered locally.
      expect(await store.resolve(), AccountMode.personal);
      expect(calls, 1);
    });

    test(
      'a failed lookup is business and is not retried this session',
      () async {
        var calls = 0;
        final box = _MemBox(businessId: 'shop');
        final store = _store(
          box,
          http: MockClient((_) async {
            calls++;
            return http.Response('{"error":"down"}', 503);
          }),
        );
        expect(await store.resolve(), AccountMode.business);
        expect(await store.resolve(), AccountMode.business);
        expect(calls, 1);
        expect(store.cachedMode(), isNull);
      },
    );

    test('a pending personal signup is personal until confirmed', () async {
      final box = _MemBox(businessId: 'me');
      var posted = <String, dynamic>{};
      final store = _store(
        box,
        http: MockClient((req) async {
          posted = jsonDecode(req.body) as Map<String, dynamic>;
          return http.Response(jsonEncode({'mode': 'personal'}), 200);
        }),
      );
      await store.markPendingPersonal();
      expect(await store.isPersonalLocal(), isTrue);
      expect(store.hasPending, isTrue);

      await store.confirmPending();
      expect(posted, {'mode': 'personal'});
      expect(store.hasPending, isFalse);
      expect(store.cachedMode(), AccountMode.personal);
    });

    test('a refused switch leaves the device unchanged', () async {
      final box = _MemBox(businessId: 'shop');
      final store = _store(
        box,
        http: MockClient(
          (_) async => http.Response('{"error":"try again later"}', 503),
        ),
      );
      await expectLater(
        store.switchTo(AccountMode.personal),
        throwsA(isA<AccountModeException>()),
      );
      expect(store.cachedMode(), isNull);
      expect(await store.isPersonalLocal(), isFalse);
    });

    test('a switch the server did not take is an error', () async {
      final box = _MemBox(businessId: 'shop');
      final store = _store(
        box,
        http: MockClient(
          (_) async => http.Response(jsonEncode({'mode': 'business'}), 200),
        ),
      );
      await expectLater(
        store.switchTo(AccountMode.personal),
        throwsA(isA<AccountModeException>()),
      );
      expect(store.cachedMode(), isNull);
    });

    test(
      'switching back to business clears personal everywhere local',
      () async {
        final box = _MemBox(businessId: 'me');
        final store = _store(
          box,
          http: MockClient(
            (_) async => http.Response(
              jsonEncode({
                'mode': 'business',
                'changed_at': '2026-10-21T10:00:00Z',
              }),
              200,
            ),
          ),
        );
        await store.markPendingPersonal();
        final result = await store.switchTo(AccountMode.business);
        expect(result.mode, AccountMode.business);
        expect(result.changedAt, DateTime.utc(2026, 10, 21, 10));
        expect(store.hasPending, isFalse);
        expect(store.cachedMode(), AccountMode.business);
      },
    );

    test(
      'a switch takes effect at once, even before the doc syncs back',
      () async {
        final box = _MemBox(businessId: 'me');
        // The device still holds the doc from before the switch.
        final staleDoc = {
          'mode': 'personal',
          'changedAt': '2026-10-22T08:00:00Z',
        };
        final store = _store(
          box,
          doc: staleDoc,
          http: MockClient(
            (_) async => http.Response(
              jsonEncode({
                'mode': 'business',
                'changed_at': '2026-10-22T08:05:00Z',
              }),
              200,
            ),
          ),
        );
        expect(await store.isPersonalLocal(), isTrue);
        await store.switchTo(AccountMode.business);
        expect(await store.isPersonalLocal(), isFalse);
        expect(store.cachedMode(), AccountMode.business);
        // Reading the stale doc again must not overwrite the newer cache.
        await store.localMode();
        await Future<void>.delayed(Duration.zero);
        expect(store.cachedMode(), AccountMode.business);
      },
    );

    test('no active business is never personal', () async {
      final store = _store(_MemBox(), http: _never());
      expect(await store.isPersonalLocal(), isFalse);
      expect(await store.resolve(), AccountMode.business);
    });
  });
}
