// Books' ledger sync and change feed against a real local Ditto store in
// DQL_STRICT_MODE, as production runs. `flutter test` has no Ditto native
// library, so the store tests skip unless LIBDITTOFFI_PATH points at one, e.g.
//
//   LIBDITTOFFI_PATH=<app>/macos/Pods/DittoFlutter/DittoCore.xcframework/\
//     macos-arm64_x86_64/DittoCore.framework/DittoCore \
//     flutter test test/core/accounting_ledger_ditto_test.dart
import 'dart:io';

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/utils/local_store_indexes.dart';
import 'package:flipper_web/core/ditto/accounting_cloud_sync.dart';
import 'package:flipper_web/services/ditto_mixins/accounting_mixin.dart';
import 'package:flipper_web/services/ditto_mixins/ditto_core_mixin.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class _FakePaths extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  _FakePaths(this.dir);
  final String dir;
  @override
  Future<String?> getApplicationDocumentsPath() async => dir;
  @override
  Future<String?> getApplicationSupportPath() async => dir;
  @override
  Future<String?> getTemporaryPath() async => dir;
}

/// The accounting store alone, without DittoService's sync setup.
class _AccountingStore extends DittoCore with AccountingMixin {}

// Ditto, Sync and Store are final classes, so the code under test takes
// them as `dynamic`; these fakes stand in where no native library is loaded
// (CI).

class _FakeSubscription {
  _FakeSubscription({this.failCancel = false});
  final bool failCancel;
  var cancelled = false;
  void cancel() {
    if (failCancel) throw StateError('ditto closed');
    cancelled = true;
    _ops.add('cancel');
  }
}

/// Subscription cancels and evictions, in the order they ran.
final _ops = <String>[];

class _FakeSync {
  final registered = <String, _FakeSubscription>{};

  /// Every registerSubscription call, repeats included.
  var registrations = 0;

  /// Registering a query containing this throws.
  String? failOn;
  var failCancel = false;

  _FakeSubscription registerSubscription(
    String dql, {
    Map<String, dynamic> arguments = const {},
  }) {
    registrations++;
    if (failOn != null && dql.contains(failOn!)) {
      throw StateError('not allowed: $dql');
    }
    return registered[dql] = _FakeSubscription(failCancel: failCancel);
  }
}

class _FakeObserver {
  var cancelled = false;
  Future<void> cancel() async => cancelled = true;
}

class _FakeItem {
  _FakeItem(this.value);
  final Map<String, dynamic> value;
}

class _FakeResult {
  _FakeResult(this.items);
  final List<_FakeItem> items;
}

class _FakeStore {
  final executed = <(String, Map<String, dynamic>)>[];

  /// `user_access` docs by user id.
  final userAccess = <String, Map<String, dynamic>>{};
  Object? executeError;
  Object? userAccessError;
  Object? observerError;
  _FakeObserver? observer;
  void Function(dynamic)? onChange;

  Future<_FakeResult> execute(
    String dql, {
    Map<String, dynamic> arguments = const {},
  }) async {
    if (dql.contains('FROM user_access')) {
      if (userAccessError != null) throw userAccessError!;
      final doc = userAccess[arguments['id']];
      return _FakeResult([if (doc != null) _FakeItem(doc)]);
    }
    if (executeError != null) throw executeError!;
    executed.add((dql, arguments));
    if (dql.startsWith('EVICT')) _ops.add('evict');
    return _FakeResult([]);
  }

  _FakeObserver registerObserver(
    String query, {
    Map<String, dynamic> arguments = const {},
    void Function(dynamic)? onChange,
  }) {
    if (observerError != null) throw observerError!;
    this.onChange = onChange;
    return observer = _FakeObserver();
  }
}

class _FakeDitto {
  _FakeDitto({List<String>? userBusinesses}) {
    if (userBusinesses != null) {
      store.userAccess[_user] = {
        '_id': _user,
        'businesses': [
          for (final id in userBusinesses) {'id': id, 'name': 'B $id'},
        ],
      };
    }
  }
  final sync = _FakeSync();
  final store = _FakeStore();
}

const _user = 'user-1';

/// [AccountingMixin.watchChanges] over a fake store.
class _FakeFeedStore extends DittoCore with AccountingMixin {
  _FakeFeedStore(this.fake);
  final _FakeStore fake;
  @override
  dynamic get changeFeedStore => fake;
}

const _biz = '89ed8709-172d-4524-bab8-5f9d31f98657';
const _other = '0b9c6c8e-1111-4222-8333-944455556666';

/// Another business of the signed-in user.
const _own = '5d1f2a3b-7777-4888-9999-aaaabbbbcccc';

void main() {
  final hasDitto = Platform.environment['LIBDITTOFFI_PATH'] != null;
  final skip = hasDitto
      ? false
      : 'set LIBDITTOFFI_PATH to run against a real Ditto store';

  group('accounting cloud subscriptions', () {
    test('journal lines sync only for this business', () {
      final specs = accountingCloudSubscriptionSpecs(
        businessId: _biz,
        branchId: 'br-1',
      );
      final journal = [
        for (final s in specs)
          if (s.sql.contains('FROM journal_')) s,
      ];
      expect(journal.map((s) => s.key), [
        'journal_entries|$_biz',
        'journal_lines|$_biz',
      ]);
      for (final s in journal) {
        expect(s.sql, contains('WHERE businessId = :businessId'));
        expect(s.args, {'businessId': _biz});
      }
    });

    test('no accounting subscription reads a whole collection', () {
      for (final s in accountingCloudSubscriptionSpecs(
        businessId: _biz,
        branchId: 'br-1',
      )) {
        expect(s.sql, contains(' WHERE '), reason: s.key);
      }
    });

    test('branch collections are added only with a branch', () {
      final keys = accountingCloudSubscriptionSpecs(
        businessId: _biz,
      ).map((s) => s.key);
      expect(keys.where((k) => k.startsWith('transactions|')), isEmpty);
    });
  });

  group('with a fake Ditto', () {
    var n = 0;
    late String biz;
    late _FakeDitto ditto;

    setUp(() {
      // Subscriptions and evictions are remembered per process.
      biz = 'fake-biz-${n++}';
      ditto = _FakeDitto(userBusinesses: [biz]);
      resetAccountingCloudSubscriptionKeys();
    });

    /// The businesses each eviction kept, in order.
    List<Set<String>> evictedFor(_FakeDitto d) => [
      for (final (dql, args) in d.store.executed)
        if (dql == evictOtherBusinessesJournalLinesDql)
          {...(args['businessIds'] as List).cast<String>()},
    ];

    test('subscribes once per key, then evicts other businesses', () async {
      await ensureAccountingCloudSubscriptions(
        ditto: ditto,
        businessId: biz,
        branchId: 'br-1',
        userId: _user,
      );
      final specs = accountingCloudSubscriptionSpecs(
        businessId: biz,
        branchId: 'br-1',
      );
      expect(ditto.sync.registered, hasLength(specs.length));
      expect(evictedFor(ditto), [
        {biz},
      ]);

      // Already registered and evicted: nothing more.
      await ensureAccountingCloudSubscriptions(
        ditto: ditto,
        businessId: biz,
        branchId: 'br-1',
        userId: _user,
      );
      expect(ditto.sync.registered, hasLength(specs.length));
      expect(ditto.sync.registrations, specs.length);
      expect(evictedFor(ditto), hasLength(1));
    });

    test('a failed subscription is retried on the next call', () async {
      ditto.sync.failOn = 'FROM journal_lines';
      await ensureAccountingCloudSubscriptions(
        ditto: ditto,
        businessId: biz,
        userId: _user,
      );
      expect(
        ditto.sync.registered.keys.where((q) => q.contains('journal_lines')),
        isEmpty,
      );

      ditto.sync.failOn = null;
      await ensureAccountingCloudSubscriptions(
        ditto: ditto,
        businessId: biz,
        userId: _user,
      );
      expect(
        ditto.sync.registered.keys.where((q) => q.contains('journal_lines')),
        hasLength(1),
      );
    });

    test('an empty business subscribes to nothing', () async {
      await ensureAccountingCloudSubscriptions(ditto: ditto, businessId: '');
      await evictOtherBusinessesJournalLines(
        ditto: ditto,
        businessId: '',
        userId: _user,
      );
      expect(ditto.sync.registered, isEmpty);
      expect(ditto.store.executed, isEmpty);
    });

    test('switching business cancels the previous journal lines '
        'subscription before evicting', () async {
      _FakeSubscription linesSub(_FakeDitto d) => d.sync.registered.entries
          .singleWhere((e) => e.key.contains('FROM journal_lines'))
          .value;

      await ensureAccountingCloudSubscriptions(
        ditto: ditto,
        businessId: biz,
        userId: _user,
      );
      final first = linesSub(ditto);

      // A manual refresh re-registers the same business: both kept.
      resetAccountingCloudSubscriptionKeys();
      final again = _FakeDitto();
      await ensureAccountingCloudSubscriptions(
        ditto: again,
        businessId: biz,
        userId: _user,
      );
      expect(first.cancelled, isFalse);

      // Another business: every previous lines subscription goes, before
      // the eviction runs.
      final other = '$biz-other';
      final second = _FakeDitto(userBusinesses: [biz]);
      _ops.clear();
      await ensureAccountingCloudSubscriptions(
        ditto: second,
        businessId: other,
        userId: _user,
      );
      expect(_ops, ['cancel', 'cancel', 'evict']);
      expect(first.cancelled, isTrue);
      expect(linesSub(again).cancelled, isTrue);
      expect(linesSub(second).cancelled, isFalse);
      // The user's businesses are kept, the open one included.
      expect(evictedFor(second), [
        {biz, other},
      ]);

      // Back to the first business: subscribed again, not skipped.
      final third = _FakeDitto();
      await ensureAccountingCloudSubscriptions(
        ditto: third,
        businessId: biz,
        userId: _user,
      );
      expect(linesSub(third).cancelled, isFalse);
      expect(linesSub(second).cancelled, isTrue);
    });

    test('a failed cancel does not stop the new subscription', () async {
      ditto.sync.failCancel = true;
      await ensureAccountingCloudSubscriptions(
        ditto: ditto,
        businessId: biz,
        userId: _user,
      );
      final next = _FakeDitto();
      await ensureAccountingCloudSubscriptions(
        ditto: next,
        businessId: '$biz-next',
        userId: _user,
      );
      expect(
        next.sync.registered.keys.where((q) => q.contains('journal_lines')),
        hasLength(1),
      );
    });

    test('a failed eviction is tried again', () async {
      ditto.store.executeError = StateError('busy');
      await evictOtherBusinessesJournalLines(
        ditto: ditto,
        businessId: biz,
        userId: _user,
      );
      expect(evictedFor(ditto), isEmpty);

      ditto.store.executeError = null;
      await evictOtherBusinessesJournalLines(
        ditto: ditto,
        businessId: biz,
        userId: _user,
      );
      expect(evictedFor(ditto), [
        {biz},
      ]);
    });

    test('every business of the user is kept, not only the open one', () async {
      final mine = _FakeDitto(userBusinesses: ['$biz-a', '$biz-b', '']);
      await evictOtherBusinessesJournalLines(
        ditto: mine,
        businessId: biz,
        userId: _user,
      );
      expect(evictedFor(mine), [
        {biz, '$biz-a', '$biz-b'},
      ]);
    });

    test(
      'nothing is evicted while the user\'s businesses are unknown',
      () async {
        Future<List<Set<String>>> evict(_FakeDitto d, String? userId) async {
          await evictOtherBusinessesJournalLines(
            ditto: d,
            businessId: biz,
            userId: userId,
          );
          return evictedFor(d);
        }

        // No signed-in user (also the default outside the app).
        await ensureAccountingCloudSubscriptions(ditto: ditto, businessId: biz);
        expect(evictedFor(ditto), isEmpty);
        expect(await evict(ditto, ''), isEmpty);
        // No user_access doc for them.
        expect(await evict(_FakeDitto(), _user), isEmpty);
        // A doc without a business list, or with an empty one.
        final noList = _FakeDitto()..store.userAccess[_user] = {'_id': _user};
        expect(await evict(noList, _user), isEmpty);
        expect(await evict(_FakeDitto(userBusinesses: []), _user), isEmpty);
        final junk = _FakeDitto()
          ..store.userAccess[_user] = {
            'businesses': ['x', null, <String, dynamic>{}],
          };
        expect(await evict(junk, _user), isEmpty);
        // The doc cannot be read.
        final unreadable = _FakeDitto(userBusinesses: [biz])
          ..store.userAccessError = StateError('store closed');
        expect(await evict(unreadable, _user), isEmpty);

        // Once the list is readable, the eviction runs.
        expect(await evict(_FakeDitto(userBusinesses: [biz]), _user), [
          {biz},
        ]);
      },
    );

    test('the eviction keeps the businesses it is given', () {
      expect(
        evictOtherBusinessesJournalLinesDql,
        startsWith('EVICT FROM journal_lines WHERE '),
      );
      expect(evictOtherBusinessesJournalLinesDql, contains(':businessIds'));
    });
  });

  group('watchChanges over a fake store', () {
    test('fires on change and stops when cancelled', () async {
      final fake = _FakeStore();
      final store = _FakeFeedStore(fake);
      var fired = 0;
      final sub = store
          .watchChanges('journal_entries', 'SELECT * FROM journal_entries', {})
          .listen((_) => fired++);
      await pumpEventQueue();
      final onChange = fake.onChange!;

      onChange(null);
      onChange(null);
      await pumpEventQueue();
      expect(fired, 2);

      await sub.cancel();
      expect(fake.observer!.cancelled, isTrue);
      onChange(null);
      await pumpEventQueue();
      expect(fired, 2);
    });

    test('a failed registration is an error on the stream', () async {
      final fake = _FakeStore()..observerError = StateError('strict mode');
      final store = _FakeFeedStore(fake);
      final errors = <Object>[];
      final sub = store
          .watchChanges('journal_lines', 'SELECT * FROM journal_lines', {})
          .listen((_) {}, onError: errors.add);
      await pumpEventQueue();
      expect(errors, [isA<StateError>()]);
      await sub.cancel();
    });
  });

  group('on a strict-mode store', () {
    late Directory dir;
    late Ditto ditto;

    Future<void> insert(String collection, Map<String, dynamic> doc) =>
        ditto.store.execute(
          'INSERT INTO $collection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
          arguments: {'doc': doc},
        );

    Future<List<String>> lineIds() async {
      final r = await ditto.store.execute(
        'SELECT _id FROM journal_lines ORDER BY _id',
      );
      return [for (final i in r.items) i.value['_id'] as String];
    }

    setUp(() async {
      if (!hasDitto) return;
      TestWidgetsFlutterBinding.ensureInitialized();
      dir = await Directory.systemTemp.createTemp('ditto_ledger');
      PathProviderPlatform.instance = _FakePaths(dir.path);
      await Ditto.init();
      ditto = await Ditto.open(
        DittoConfig(
          databaseID: 'aaaaaaaa-bbbb-4ccc-8ddd-eeeeeeeeeee7',
          connect: const DittoConfigConnectSmallPeersOnly(),
          persistenceDirectory: dir.path,
        ),
      );
      await ditto.store.execute('ALTER SYSTEM SET DQL_STRICT_MODE = true');
    });

    tearDown(() async {
      if (!hasDitto) return;
      await ditto.close();
      await dir.delete(recursive: true);
    });

    test(
      'eviction drops only lines of businesses the user is not in',
      () async {
        await insert('journal_lines', {'_id': 'mine', 'businessId': _biz});
        await insert('journal_lines', {
          '_id': 'mine_snake',
          'business_id': _biz,
        });
        await insert('journal_lines', {
          '_id': 'mine_mixed',
          'businessId': 'legacy',
          'business_id': _biz,
        });
        await insert('journal_lines', {'_id': 'theirs', 'businessId': _other});
        await insert('journal_lines', {
          '_id': 'theirs_both',
          'businessId': _other,
          'business_id': _other,
        });
        await insert('journal_lines', {
          '_id': 'theirs_snake',
          'business_id': _other,
        });
        await insert('journal_lines', {
          '_id': 'theirs_snake_empty',
          'businessId': '',
          'business_id': _other,
        });
        await insert('journal_lines', {
          '_id': 'theirs_snake_null',
          'businessId': null,
          'business_id': _other,
        });
        await insert('journal_lines', {
          '_id': 'mine_snake_empty',
          'businessId': '',
          'business_id': _biz,
        });
        await insert('journal_lines', {
          '_id': 'unknown',
          'journalEntryId': 'x',
        });
        await insert('journal_lines', {
          '_id': 'unknown_both_empty',
          'businessId': '',
          'business_id': '',
        });
        await insert('journal_lines', {
          '_id': 'unknown_null',
          'businessId': null,
        });
        await insert('journal_lines', {
          '_id': 'unknown_empty',
          'businessId': '',
        });

        await insert('journal_lines', {'_id': 'own_other', 'businessId': _own});
        await insert('journal_lines', {
          '_id': 'own_other_snake',
          'business_id': _own,
        });
        await insert('user_access', {
          '_id': _user,
          'businesses': [
            {'id': _biz},
            {'id': _own},
          ],
        });

        // Without the user's businesses nothing goes.
        await evictOtherBusinessesJournalLines(
          ditto: ditto,
          businessId: _biz,
          userId: 'nobody',
        );
        expect(await lineIds(), contains('theirs'));

        await evictOtherBusinessesJournalLines(
          ditto: ditto,
          businessId: _biz,
          userId: _user,
        );

        expect(await lineIds(), [
          'mine',
          'mine_mixed',
          'mine_snake',
          'mine_snake_empty',
          'own_other',
          'own_other_snake',
          'unknown',
          'unknown_both_empty',
          'unknown_empty',
          'unknown_null',
        ]);

        // Once per business per process.
        await insert('journal_lines', {
          '_id': 'theirs_late',
          'businessId': _other,
        });
        await evictOtherBusinessesJournalLines(
          ditto: ditto,
          businessId: _biz,
          userId: _user,
        );
        expect(await lineIds(), contains('theirs_late'));
      },
      skip: skip,
    );

    test('the journal indexes are created', () async {
      for (final statement in localStoreIndexStatements()) {
        await ditto.store.execute(statement);
      }
      final r = await ditto.store.execute('SELECT * FROM system:indexes');
      final names = r.items.map((i) => i.value.toString()).join(' ');
      for (final name in [
        'idx_journal_entries_businessId',
        'idx_journal_entries_business_id',
        'idx_journal_lines_businessId',
        'idx_journal_lines_business_id',
        'idx_journal_lines_journalEntryId',
      ]) {
        expect(names, contains(name));
      }
    }, skip: skip);

    test('watchChanges fires on change and stops when cancelled', () async {
      final store = _AccountingStore()..setDitto(ditto);
      const query =
          'SELECT * FROM journal_entries '
          'WHERE businessId = :businessId OR business_id = :businessId';
      var fired = 0;
      final sub = store
          .watchChanges('journal_entries', query, {'businessId': _biz})
          .listen((_) => fired++);
      await Future<void>.delayed(const Duration(milliseconds: 200));
      final initial = fired;

      await insert('journal_entries', {'_id': 'e1', 'businessId': _biz});
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(fired, greaterThan(initial));

      await sub.cancel();
      final afterCancel = fired;
      await insert('journal_entries', {'_id': 'e2', 'businessId': _biz});
      await Future<void>.delayed(const Duration(milliseconds: 200));
      expect(fired, afterCancel);
    }, skip: skip);
  });

  test('watchChanges is empty before Ditto is open', () async {
    final store = _AccountingStore();
    expect(
      await store
          .watchChanges('journal_entries', 'SELECT * FROM journal_entries', {})
          .isEmpty,
      isTrue,
    );
  });
}
