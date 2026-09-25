import 'package:flipper_dashboard/features/kitchen_display/kitchen_stage.dart';
import 'package:flipper_models/models/kitchen_order.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

KitchenOrder _order(String id, KitchenStage stage, {int sentMin = 0}) =>
    KitchenOrder(
      transactionId: id,
      branchId: 'b1',
      stage: stage,
      sentAt: DateTime.utc(2026, 9, 25, 12).add(Duration(minutes: sentMin)),
    );

void main() {
  group('groupKitchenOrders', () {
    test('buckets by stage, oldest sent first, served dropped', () {
      final grouped = groupKitchenOrders<KitchenOrder>([
        _order('late', KitchenStage.incoming, sentMin: 10),
        _order('early', KitchenStage.incoming, sentMin: 1),
        _order('cooking', KitchenStage.inProgress),
        _order('plated', KitchenStage.ready),
        _order('gone', KitchenStage.served),
      ], (o) => o);

      expect(grouped.keys, KitchenStage.active);
      expect(grouped[KitchenStage.incoming]!.map((o) => o.transactionId), [
        'early',
        'late',
      ]);
      expect(grouped[KitchenStage.inProgress]!.map((o) => o.transactionId), [
        'cooking',
      ]);
      expect(grouped[KitchenStage.ready]!.map((o) => o.transactionId), [
        'plated',
      ]);
      expect(
        grouped.values.expand((l) => l).map((o) => o.transactionId),
        isNot(contains('gone')),
      );
    });

    test('every column is present even when empty', () {
      final grouped = groupKitchenOrders<KitchenOrder>(const [], (o) => o);
      for (final stage in KitchenStage.active) {
        expect(grouped[stage], isEmpty);
      }
    });
  });

  group('settledOverrides', () {
    test('keeps a drag the stream has not echoed yet', () {
      final settled = settledOverrides(
        [_order('a', KitchenStage.incoming)],
        {'a': KitchenStage.inProgress},
      );
      expect(settled, isEmpty);
    });

    test('drops a drag once the stream agrees', () {
      final settled = settledOverrides(
        [_order('a', KitchenStage.inProgress)],
        {'a': KitchenStage.inProgress},
      );
      expect(settled, {'a'});
    });

    test('drops a drag whose order left the stream (served)', () {
      final settled = settledOverrides(const [], {'a': KitchenStage.served});
      expect(settled, {'a'});
    });
  });

  group('dueDateForMove', () {
    final now = DateTime.utc(2026, 9, 25, 12);

    test('starting to cook defaults a 30 minute promise', () {
      final due = dueDateForMove(
        to: KitchenStage.inProgress,
        current: null,
        now: now,
      );
      expect(due.dueDate, now.add(const Duration(minutes: 30)));
      expect(due.clear, isFalse);
    });

    test('starting to cook keeps a promise already set', () {
      final set = now.add(const Duration(minutes: 5));
      final due = dueDateForMove(
        to: KitchenStage.inProgress,
        current: set,
        now: now,
      );
      expect(due.dueDate, set);
    });

    test('back to incoming clears it; ready leaves it alone', () {
      expect(
        dueDateForMove(to: KitchenStage.incoming, current: now, now: now).clear,
        isTrue,
      );
      final ready = dueDateForMove(
        to: KitchenStage.ready,
        current: now,
        now: now,
      );
      expect(ready.dueDate, isNull);
      expect(ready.clear, isFalse);
    });
  });

  test('servedMessage keys off the real ticket status constants', () {
    expect(servedMessage(COMPLETE), contains('already paid'));
    expect(servedMessage(PENDING), contains('cashier has this ticket'));
    expect(servedMessage(PARKED), contains('in Tickets'));
    expect(servedMessage(null), contains('in Tickets'));
  });
}
