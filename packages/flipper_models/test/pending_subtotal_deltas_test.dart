import 'package:flipper_models/sync/utils/pending_subtotal_deltas.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late List<({String transactionId, double delta})> writes;
  late PendingSubtotalDeltas deltas;

  setUp(() {
    writes = [];
    deltas = PendingSubtotalDeltas(window: const Duration(milliseconds: 20));
  });

  Future<void> record(String id, double delta) async {
    writes.add((transactionId: id, delta: delta));
  }

  Future<void> settle() =>
      Future<void>.delayed(const Duration(milliseconds: 60));

  test('a burst of taps costs one parent write carrying the sum', () async {
    for (var i = 0; i < 10; i++) {
      deltas.add(transactionId: 'txn-1', delta: 100, onFlush: record);
    }
    await settle();

    expect(writes, [(transactionId: 'txn-1', delta: 1000.0)]);
  });

  test('nothing is written while taps keep arriving', () async {
    deltas.add(transactionId: 'txn-1', delta: 100, onFlush: record);
    for (var i = 0; i < 5; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      deltas.add(transactionId: 'txn-1', delta: 100, onFlush: record);
    }

    expect(writes, isEmpty);
    expect(deltas.pendingFor('txn-1'), 600);

    await settle();
    expect(writes, [(transactionId: 'txn-1', delta: 600.0)]);
  });

  test('carts are gathered independently', () async {
    deltas.add(transactionId: 'txn-1', delta: 100, onFlush: record);
    deltas.add(transactionId: 'txn-2', delta: 250, onFlush: record);
    await settle();

    expect(
      writes.map((w) => w.transactionId).toSet(),
      {'txn-1', 'txn-2'},
    );
    expect(deltas.pendingFor('txn-1'), 0);
    expect(deltas.pendingFor('txn-2'), 0);
  });

  test('a discarded delta never lands on an absolute subtotal', () async {
    deltas.add(transactionId: 'txn-1', delta: 880, onFlush: record);

    // Completion computed the total from the finished lines and wrote it.
    deltas.discard('txn-1');
    await settle();

    expect(writes, isEmpty);
    expect(deltas.pendingFor('txn-1'), 0);
  });

  test('discarding one cart leaves another cart owed', () async {
    deltas.add(transactionId: 'txn-1', delta: 880, onFlush: record);
    deltas.add(transactionId: 'txn-2', delta: 120, onFlush: record);

    deltas.discard('txn-1');
    await settle();

    expect(writes, [(transactionId: 'txn-2', delta: 120.0)]);
  });

  test('flush writes immediately without waiting out the window', () async {
    deltas.add(transactionId: 'txn-1', delta: 400, onFlush: record);

    await deltas.flush(transactionId: 'txn-1', onFlush: record);

    expect(writes, [(transactionId: 'txn-1', delta: 400.0)]);
    // The cancelled timer must not write the same delta a second time.
    await settle();
    expect(writes, hasLength(1));
  });

  test('flushing an unknown cart writes nothing', () async {
    await deltas.flush(transactionId: 'txn-none', onFlush: record);

    expect(writes, isEmpty);
  });

  test('deltas that cancel out are not written at all', () async {
    deltas.add(transactionId: 'txn-1', delta: 100, onFlush: record);
    deltas.add(transactionId: 'txn-1', delta: -100, onFlush: record);
    await settle();

    expect(writes, isEmpty);
  });

  test('a zero delta never opens a window', () async {
    deltas.add(transactionId: 'txn-1', delta: 0, onFlush: record);
    await settle();

    expect(writes, isEmpty);
  });
}
