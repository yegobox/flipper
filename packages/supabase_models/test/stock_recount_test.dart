import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/brick/models/stock_recount.model.dart';

void main() {
  group('StockRecount Model Tests', () {
    late StockRecount recount;

    setUp(() {
      recount = StockRecount(
        branchId: 1,
        userId: 'user123',
        deviceId: 'device456',
        deviceName: 'Device B',
        notes: 'Monthly recount',
      );
    });

    test('should create a StockRecount with default values', () {
      expect(recount.id, isNotNull);
      expect(recount.id.length, equals(36)); // UUID v4 format
      expect(recount.branchId, equals(1));
      expect(recount.status, equals('draft'));
      expect(recount.userId, equals('user123'));
      expect(recount.deviceId, equals('device456'));
      expect(recount.deviceName, equals('Device B'));
      expect(recount.notes, equals('Monthly recount'));
      expect(recount.totalItemsCounted, equals(0));
      expect(recount.createdAt, isA<DateTime>());
      expect(recount.submittedAt, isNull);
      expect(recount.syncedAt, isNull);
    });

    test('should create a StockRecount with custom id', () {
      final customRecount = StockRecount(
        id: 'custom-id-123',
        branchId: 2,
      );
      expect(customRecount.id, equals('custom-id-123'));
      expect(customRecount.branchId, equals(2));
    });

    test('should have correct status states', () {
      expect(recount.status, equals('draft'));

      final submitted = recount.submit();
      expect(submitted.status, equals('submitted'));

      final synced = submitted.markSynced();
      expect(synced.status, equals('synced'));
    });

    test('should allow transition from draft to submitted', () {
      expect(recount.canTransitionTo('submitted'), isTrue);
      expect(recount.canTransitionTo('synced'), isFalse);
    });

    test('should submit recount and update status', () {
      final submitted = recount.submit();

      expect(submitted.status, equals('submitted'));
      expect(submitted.submittedAt, isNotNull);
      expect(submitted.submittedAt, isA<DateTime>());
      expect(submitted.syncedAt, isNull);
    });
    test('should not allow submitting already submitted recount', () {
      final submitted = recount.submit();

      expect(submitted.canTransitionTo('submitted'), isFalse);
      expect(() => submitted.submit(), throwsA(isA<StateError>()));
    });

    test('should allow transition from submitted to synced', () {
      final submitted = recount.submit();

      expect(submitted.canTransitionTo('synced'), isTrue);
      expect(submitted.canTransitionTo('submitted'), isFalse);
    });

    test('should mark recount as synced', () {
      final submitted = recount.submit();
      final synced = submitted.markSynced();

      expect(synced.status, equals('synced'));
      expect(synced.syncedAt, isNotNull);
      expect(synced.syncedAt, isA<DateTime>());
    });
    test('should not allow marking draft as synced', () {
      expect(recount.canTransitionTo('synced'), isFalse);
      expect(() => recount.markSynced(), throwsA(isA<StateError>()));
    });

    test('should not allow any transition from synced state', () {
      final submitted = recount.submit();
      final synced = submitted.markSynced();

      expect(synced.canTransitionTo('draft'), isFalse);
      expect(synced.canTransitionTo('submitted'), isFalse);
      expect(synced.canTransitionTo('synced'), isFalse);
    });

    test('should create a copy with updated fields', () {
      final copy = recount.copyWith(
        status: 'submitted',
        totalItemsCounted: 10,
        notes: 'Updated notes',
      );

      expect(copy.id, equals(recount.id));
      expect(copy.branchId, equals(recount.branchId));
      expect(copy.status, equals('submitted'));
      expect(copy.totalItemsCounted, equals(10));
      expect(copy.notes, equals('Updated notes'));
      expect(copy.userId, equals(recount.userId));
    });

    test('should maintain immutability when copying', () {
      final copy = recount.copyWith(status: 'submitted');

      expect(recount.status, equals('draft'));
      expect(copy.status, equals('submitted'));
      expect(recount.id, equals(copy.id));
    });

    test('should handle null values in copyWith', () {
      final recountWithNotes = StockRecount(
        branchId: 1,
        notes: 'Original notes',
      );

      final copy = recountWithNotes.copyWith();

      expect(copy.id, equals(recountWithNotes.id));
      expect(copy.notes, equals('Original notes'));
    });

    test('should validate status flow: draft -> submitted -> synced', () {
      // Start in draft
      expect(recount.status, equals('draft'));

      // Move to submitted
      final submitted = recount.submit();
      expect(submitted.status, equals('submitted'));
      expect(submitted.submittedAt, isNotNull);

      // Move to synced
      final synced = submitted.markSynced();
      expect(synced.status, equals('synced'));
      expect(synced.syncedAt, isNotNull);

      // Verify timestamps are in correct order
      expect(synced.createdAt.isBefore(synced.submittedAt!), isTrue);
      expect(synced.submittedAt!.isBefore(synced.syncedAt!), isTrue);
    });
    test('should handle totalItemsCounted correctly', () {
      final recountWithItems = StockRecount(
        branchId: 1,
        totalItemsCounted: 25,
      );

      expect(recountWithItems.totalItemsCounted, equals(25));

      final updated = recountWithItems.copyWith(totalItemsCounted: 30);
      expect(updated.totalItemsCounted, equals(30));
    });

    test('should preserve deviceId and deviceName through state transitions',
        () {
      final submitted = recount.submit();
      final synced = submitted.markSynced();

      expect(synced.deviceId, equals('device456'));
      expect(synced.deviceName, equals('Device B'));
    });

    test('should create UTC timestamps', () {
      expect(recount.createdAt.isUtc, isTrue);

      final submitted = recount.submit();
      expect(submitted.submittedAt!.isUtc, isTrue);

      final synced = submitted.markSynced();
      expect(synced.syncedAt!.isUtc, isTrue);
    });
  });
}
