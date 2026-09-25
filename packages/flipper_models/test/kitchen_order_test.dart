import 'package:flipper_models/models/kitchen_order.dart';
import 'package:flipper_models/sync/utils/kitchen_orders_store.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> _ticket({
  String status = 'inProgress',
  bool isOriginal = true,
  String? ticketName = 'Table 4',
  num subTotal = 12000,
  String transactionType = 'Sale',
}) => {
  '_id': 't1',
  'id': 't1',
  'branchId': 'b1',
  'status': status,
  'isOriginalTransaction': isOriginal,
  'ticketName': ticketName,
  'subTotal': subTotal,
  'transactionType': transactionType,
};

void main() {
  group('KitchenStage', () {
    test('wire strings round-trip; unknown falls back to incoming', () {
      for (final stage in KitchenStage.values) {
        expect(KitchenStage.fromWire(stage.wire), stage);
      }
      expect(KitchenStage.fromWire(null), KitchenStage.incoming);
      expect(KitchenStage.fromWire('bogus'), KitchenStage.incoming);
    });

    test('served is not an active column', () {
      expect(KitchenStage.active, isNot(contains(KitchenStage.served)));
    });
  });

  group('legacyKitchenStageForStatus', () {
    test('maps only the statuses the old Kitchen Display wrote', () {
      // The literals in kitchen_order.dart must match the ticket constants.
      expect(legacyKitchenStageForStatus(IN_PROGRESS), KitchenStage.inProgress);
      expect(legacyKitchenStageForStatus(WAITING), KitchenStage.ready);
      for (final other in [
        PARKED,
        PENDING,
        COMPLETE,
        ORDERING,
        PENDING_REVIEW,
        AWAITING_HANDOVER,
        null,
      ]) {
        expect(legacyKitchenStageForStatus(other), isNull, reason: '$other');
      }
    });
  });

  group('KitchenOrder document', () {
    test('toDitto / fromDitto round-trip', () {
      final order = KitchenOrder(
        transactionId: 't1',
        branchId: 'b1',
        stage: KitchenStage.ready,
        sentAt: DateTime.utc(2026, 9, 25, 12),
        sentBy: 'u1',
        updatedAt: DateTime.utc(2026, 9, 25, 12, 5),
        dueDate: DateTime.utc(2026, 9, 25, 12, 30),
      );
      final doc = order.toDitto();
      expect(doc['_id'], 't1');
      expect(doc['stage'], 'ready');

      final back = KitchenOrder.fromDitto(doc);
      expect(back.transactionId, 't1');
      expect(back.branchId, 'b1');
      expect(back.stage, KitchenStage.ready);
      expect(back.sentAt, order.sentAt);
      expect(back.sentBy, 'u1');
      expect(back.dueDate, order.dueDate);
    });
  });

  group('isStrandedKitchenTicket', () {
    test('a ticket the old Kitchen Display moved is stranded', () {
      expect(isStrandedKitchenTicket(_ticket()), isTrue);
      expect(isStrandedKitchenTicket(_ticket(status: WAITING)), isTrue);
    });

    test('MoMo "Mark not completed" rows (no ticket name) are left alone', () {
      expect(
        isStrandedKitchenTicket(_ticket(status: WAITING, ticketName: null)),
        isFalse,
      );
      expect(
        isStrandedKitchenTicket(_ticket(status: WAITING, ticketName: '  ')),
        isFalse,
      );
    });

    test('non-kitchen statuses and non-ticket rows are left alone', () {
      expect(isStrandedKitchenTicket(_ticket(status: PARKED)), isFalse);
      expect(isStrandedKitchenTicket(_ticket(status: ORDERING)), isFalse);
      expect(isStrandedKitchenTicket(_ticket(isOriginal: false)), isFalse);
      expect(isStrandedKitchenTicket(_ticket(subTotal: 0)), isFalse);
      expect(
        isStrandedKitchenTicket(_ticket(transactionType: 'Adjustment')),
        isFalse,
      );
    });
  });
}
