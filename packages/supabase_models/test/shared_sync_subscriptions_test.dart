import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/sync/shared_sync_subscriptions.dart';

class _Sub {
  _Sub(this.query, this.arguments);

  final String query;
  final Map<String, dynamic>? arguments;
  bool cancelled = false;

  void cancel() => cancelled = true;
}

class _Sync {
  final registered = <_Sub>[];

  _Sub registerSubscription(String query, {Map<String, dynamic>? arguments}) {
    final sub = _Sub(query, arguments);
    registered.add(sub);
    return sub;
  }
}

class _Ditto {
  final sync = _Sync();
}

/// Each rebuild of the POS cart stream, each customer lookup and each report
/// used to register a new, never-cancelled subscription. Hundreds piled up,
/// Ditto's sync evaluated them all, and every synchronous Ditto call on the
/// UI thread waited behind that work (the POS freezes of 2026-11-09).
void main() {
  const branchWide = 'SELECT * FROM transactions WHERE branchId = :branchId';

  test('the same subscription is registered once, however often asked', () {
    final ditto = _Ditto();
    for (var i = 0; i < 200; i++) {
      SharedSyncSubscriptions.register(
        ditto,
        branchWide,
        arguments: {
          'branchId': 'b1',
          'openTicketStatuses': ['parked', 'pending']
        },
      );
    }
    expect(ditto.sync.registered, hasLength(1));
    expect(SharedSyncSubscriptions.liveOn(ditto), 1);
  });

  test('argument order does not make a new subscription', () {
    final ditto = _Ditto();
    SharedSyncSubscriptions.register(
      ditto,
      branchWide,
      arguments: {
        'a': 1,
        'b': {'y': 2, 'x': DateTime.utc(2026)}
      },
    );
    SharedSyncSubscriptions.register(
      ditto,
      branchWide,
      arguments: {
        'b': {'x': DateTime.utc(2026), 'y': 2},
        'a': 1
      },
    );
    expect(ditto.sync.registered, hasLength(1));
  });

  test('different arguments or queries are different subscriptions', () {
    final ditto = _Ditto();
    SharedSyncSubscriptions.register(ditto, branchWide,
        arguments: {'branchId': 'b1'});
    SharedSyncSubscriptions.register(ditto, branchWide,
        arguments: {'branchId': 'b2'});
    SharedSyncSubscriptions.register(ditto, 'SELECT * FROM stocks');
    expect(ditto.sync.registered, hasLength(3));
    expect(ditto.sync.registered.last.arguments, isNull);
  });

  test('a new history window replaces the old one, after it is live', () {
    final ditto = _Ditto();
    SharedSyncSubscriptions.register(
      ditto,
      branchWide,
      arguments: {
        'branchId': 'b1',
        'historyWindowStart': '2026-10-10T00:00:00'
      },
    );
    final before = SharedSyncSubscriptions.registrations;
    SharedSyncSubscriptions.register(
      ditto,
      branchWide,
      arguments: {
        'branchId': 'b1',
        'historyWindowStart': '2026-10-11T00:00:00'
      },
    );

    expect(SharedSyncSubscriptions.registrations, before + 1);
    expect(ditto.sync.registered, hasLength(2));
    expect(ditto.sync.registered.first.cancelled, isTrue);
    expect(ditto.sync.registered.last.cancelled, isFalse);
    expect(SharedSyncSubscriptions.liveOn(ditto), 1);
  });

  test('each Ditto session keeps its own subscriptions', () {
    final first = _Ditto();
    final second = _Ditto();
    SharedSyncSubscriptions.register(first, branchWide,
        arguments: {'branchId': 'b1'});
    SharedSyncSubscriptions.register(second, branchWide,
        arguments: {'branchId': 'b1'});
    expect(first.sync.registered, hasLength(1));
    expect(second.sync.registered, hasLength(1));
  });

  test('no Ditto yet is a no-op', () {
    final before = SharedSyncSubscriptions.registrations;
    SharedSyncSubscriptions.register(null, branchWide);
    expect(SharedSyncSubscriptions.registrations, before);
  });

  test('a replaced subscription whose session is gone is dropped quietly', () {
    final ditto = _ThrowingDitto();
    SharedSyncSubscriptions.register(
      ditto,
      branchWide,
      arguments: {'historyWindowStart': '2026-10-10T00:00:00'},
    );
    SharedSyncSubscriptions.register(
      ditto,
      branchWide,
      arguments: {'historyWindowStart': '2026-10-11T00:00:00'},
    );
    expect(SharedSyncSubscriptions.liveOn(ditto), 1);
  });

  test('values JSON cannot encode still make a stable key', () {
    final ditto = _Ditto();
    final odd = Object();
    SharedSyncSubscriptions.register(ditto, branchWide, arguments: {'x': odd});
    SharedSyncSubscriptions.register(ditto, branchWide, arguments: {'x': odd});
    expect(ditto.sync.registered, hasLength(1));
  });
}

class _ThrowingSub {
  void cancel() => throw StateError('Ditto closed');
}

class _ThrowingSync {
  _ThrowingSub registerSubscription(
    String query, {
    Map<String, dynamic>? arguments,
  }) =>
      _ThrowingSub();
}

class _ThrowingDitto {
  final sync = _ThrowingSync();
}
