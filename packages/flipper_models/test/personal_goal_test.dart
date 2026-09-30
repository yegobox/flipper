import 'package:flipper_models/models/personal_goal.dart';
import 'package:test/test.dart';

void main() {
  group('PersonalGoal', () {
    test('fromJson maps Ditto-style document', () {
      final g = PersonalGoal.fromJson({
        '_id': 'g1',
        'branchId': 'b1',
        'name': 'Emergency',
        'savedAmount': 1.8e6,
        'targetAmount': 3e6,
        'isTopPriority': true,
        'createdAt': '2025-01-01T00:00:00.000Z',
        'updatedAt': '2025-06-01T12:00:00.000Z',
      });
      expect(g.id, 'g1');
      expect(g.branchId, 'b1');
      expect(g.savedAmount, 1.8e6);
      expect(g.targetAmount, 3e6);
      expect(g.isTopPriority, true);
      expect(g.progressPercent, 60);
    });

    test('progressRatio is clamped', () {
      final over = PersonalGoal(
        id: '1',
        branchId: 'b',
        name: 'x',
        savedAmount: 200,
        targetAmount: 100,
      );
      expect(over.progressRatio, 1);
      expect(over.progressPercent, 100);
      expect(over.isAtOrAboveTarget, isTrue);
      expect(over.remainingToTarget, 0);

      final zeroTarget = PersonalGoal(
        id: '2',
        branchId: 'b',
        name: 'y',
        savedAmount: 50,
        targetAmount: 0,
      );
      expect(zeroTarget.progressRatio, 0);

      final open = PersonalGoal(
        id: '3',
        branchId: 'b',
        name: 'z',
        savedAmount: 40,
        targetAmount: 100,
      );
      expect(open.isAtOrAboveTarget, isFalse);
      expect(open.remainingToTarget, 60);
    });

    test('toJson roundtrip preserves amounts', () {
      final original = PersonalGoal(
        id: 'id1',
        branchId: 'br',
        name: 'Test',
        savedAmount: 100,
        targetAmount: 500,
        isTopPriority: false,
        autoAllocationPercent: 15,
      );
      final decoded = PersonalGoal.fromJson(original.toJson());
      expect(decoded.id, original.id);
      expect(decoded.savedAmount, original.savedAmount);
      expect(decoded.targetAmount, original.targetAmount);
      expect(decoded.autoAllocationPercent, 15);
    });

    test('fromJson maps last contribution metadata', () {
      final g = PersonalGoal.fromJson({
        '_id': 'g1',
        'branchId': 'b1',
        'name': 'Inventory',
        'savedAmount': 150,
        'targetAmount': 1000,
        'lastContributionTransactionId': 'txn-9',
        'lastContributionDeviceKey': 'device-remote',
        'lastContributionAmount': 15,
      });
      expect(g.lastContributionTransactionId, 'txn-9');
      expect(g.lastContributionDeviceKey, 'device-remote');
      expect(g.lastContributionAmount, 15);
    });
    group('recurrence', () {
      PersonalGoal monthly({
        double saved = 80000,
        String? periodKey = '2026-08',
        List<GoalCycle> history = const [],
      }) => PersonalGoal(
        id: 'g',
        branchId: 'b',
        name: 'Rent',
        savedAmount: saved,
        targetAmount: 100000,
        recurrence: GoalRecurrence.monthly,
        periodKey: periodKey,
        cycleHistory: history,
        lastContributionDeviceKey: 'dev-1',
        lastContributionAmount: 500,
      );

      test('legacy doc without recurrence fields is one-shot', () {
        final g = PersonalGoal.fromJson({
          '_id': 'g1',
          'branchId': 'b1',
          'name': 'Old',
          'savedAmount': 10,
          'targetAmount': 20,
        });
        expect(g.recurrence, GoalRecurrence.none);
        expect(g.isRecurring, isFalse);
        expect(g.periodKey, isNull);
        expect(g.cycleHistory, isEmpty);
        expect(identical(g.effectiveAt(DateTime(2030)), g), isTrue);
      });

      test('toJson round-trips recurrence, period and history', () {
        final g = monthly(
          history: const [
            GoalCycle(
              periodKey: '2026-07',
              savedAmount: 100000,
              targetAmount: 100000,
              reached: true,
            ),
          ],
        );
        final json = g.toJson();
        expect(json['recurrence'], 'monthly');
        expect(json['periodKey'], '2026-08');
        final back = PersonalGoal.fromJson(json);
        expect(back.recurrence, GoalRecurrence.monthly);
        expect(back.periodKey, '2026-08');
        expect(back.cycleHistory.single.periodKey, '2026-07');
        expect(back.cycleHistory.single.reached, isTrue);
        expect(back.cycleHistory.single.savedAmount, 100000);
      });

      test('switching recurrence off is written explicitly', () {
        final off = monthly().copyWith(
          recurrence: GoalRecurrence.none,
          clearPeriodKey: true,
        );
        final json = off.toJson();
        expect(json['recurrence'], 'none');
        expect(json.containsKey('periodKey'), isTrue);
        expect(json['periodKey'], isNull);
      });

      test('effectiveAt in the same period is a no-op', () {
        final g = monthly(periodKey: '2026-09');
        expect(identical(g.effectiveAt(DateTime(2026, 9, 30)), g), isTrue);
      });

      test('effectiveAt in a new period resets and records history', () {
        final g = monthly(saved: 100000).effectiveAt(DateTime(2026, 9, 1));
        expect(g.savedAmount, 0);
        expect(g.periodKey, '2026-09');
        expect(g.isAtOrAboveTarget, isFalse);
        expect(g.lastContributionDeviceKey, isNull);
        expect(g.lastContributionAmount, isNull);
        final cycle = g.cycleHistory.single;
        expect(cycle.periodKey, '2026-08');
        expect(cycle.savedAmount, 100000);
        expect(cycle.targetAmount, 100000);
        expect(cycle.reached, isTrue);
      });

      test('effectiveAt is idempotent', () {
        final now = DateTime(2026, 9, 10);
        final once = monthly().effectiveAt(now);
        final twice = once.effectiveAt(now);
        expect(identical(once, twice), isTrue);
        expect(twice.cycleHistory.length, 1);
      });

      test('history keeps the newest maxCycleHistory periods', () {
        final history = [
          for (var m = 12; m >= 1; m--)
            GoalCycle(
              periodKey: '2025-${m.toString().padLeft(2, '0')}',
              savedAmount: 1,
              targetAmount: 1,
              reached: true,
            ),
        ];
        final g = monthly(
          periodKey: '2026-01',
          history: history,
        ).effectiveAt(DateTime(2026, 2, 3));
        expect(g.cycleHistory.length, PersonalGoal.maxCycleHistory);
        expect(g.cycleHistory.first.periodKey, '2026-01');
        expect(g.cycleHistory.last.periodKey, '2025-02');
      });

      test('recurring goal without a period adopts the current one', () {
        final g = monthly(periodKey: null).effectiveAt(DateTime(2026, 9, 5));
        expect(g.periodKey, '2026-09');
        expect(g.savedAmount, 80000);
        expect(g.cycleHistory, isEmpty);
      });

      test('creditSince spots a credit within a period', () {
        final before = monthly(saved: 1000, periodKey: '2026-09');
        final after = before.copyWith(savedAmount: 1500);
        expect(after.creditSince(before), 500);
        expect(before.creditSince(after), -500);
      });

      test('creditSince counts a rollover + credit as the new amount', () {
        final before = monthly(saved: 100000, periodKey: '2026-08');
        final after = monthly(saved: 500, periodKey: '2026-09');
        expect(after.creditSince(before), 500);
      });

      test('a read-only rollover is not a credit', () {
        final before = monthly(saved: 100000, periodKey: '2026-08');
        final after = before.effectiveAt(DateTime(2026, 9, 1));
        expect(after.creditSince(before), 0);
      });
    });
  });
}
