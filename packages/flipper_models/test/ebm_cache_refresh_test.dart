import 'dart:async';

import 'package:flipper_models/services/ebm_cache_refresh.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/ebm_cache_refresh_test.dart
void main() {
  late List<String> fetched;

  Future<Object?> fetch(String branchId) async {
    fetched.add(branchId);
    return null;
  }

  setUp(() {
    fetched = [];
    EbmCacheRefresh.debugReset();
  });

  test('fetches once per branch per session', () async {
    await EbmCacheRefresh.refreshOnce(
      branchId: 'b1',
      localMode: false,
      fetch: fetch,
    );
    await EbmCacheRefresh.refreshOnce(
      branchId: 'b1',
      localMode: false,
      fetch: fetch,
    );
    await EbmCacheRefresh.refreshOnce(
      branchId: 'b2',
      localMode: false,
      fetch: fetch,
    );

    expect(fetched, ['b1', 'b2']);
  });

  test('skips local mode and a missing branch', () async {
    await EbmCacheRefresh.refreshOnce(
      branchId: 'b1',
      localMode: true,
      fetch: fetch,
    );
    await EbmCacheRefresh.refreshOnce(
      branchId: null,
      localMode: false,
      fetch: fetch,
    );
    await EbmCacheRefresh.refreshOnce(
      branchId: '',
      localMode: false,
      fetch: fetch,
    );

    expect(fetched, isEmpty);
  });

  test('a fetch that hangs only holds the caller until the timeout', () async {
    final never = Completer<Object?>();
    await expectLater(
      EbmCacheRefresh.refreshOnce(
        branchId: 'b1',
        localMode: false,
        fetch: (_) => never.future,
        timeout: const Duration(milliseconds: 10),
      ),
      completes,
    );
  });

  test('a failing fetch never throws', () async {
    await expectLater(
      EbmCacheRefresh.refreshOnce(
        branchId: 'b1',
        localMode: false,
        fetch: (_) async => throw StateError('offline'),
      ),
      completes,
    );
  });

  test('the caller is not held while the fetch runs', () async {
    final pending = Completer<Object?>();
    var finished = false;
    unawaited(
      EbmCacheRefresh.refreshOnce(
        branchId: 'b1',
        localMode: false,
        fetch: (_) => pending.future,
      ).then((_) => finished = true),
    );
    await Future<void>.delayed(Duration.zero);
    expect(finished, isFalse);

    pending.complete(null);
    await Future<void>.delayed(Duration.zero);
    expect(finished, isTrue);
  });
}
