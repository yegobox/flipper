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

      final zeroTarget = PersonalGoal(
        id: '2',
        branchId: 'b',
        name: 'y',
        savedAmount: 50,
        targetAmount: 0,
      );
      expect(zeroTarget.progressRatio, 0);
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
  });
}
