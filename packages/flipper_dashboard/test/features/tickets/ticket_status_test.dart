import 'package:flipper_dashboard/features/tickets/models/ticket_status.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter_test/flutter_test.dart';

// flutter test test/features/tickets/ticket_status_test.dart
void main() {
  group('TicketStatusExtension — Ticket Review + Handover statuses', () {
    test('fromString maps PENDING_REVIEW and AWAITING_HANDOVER', () {
      expect(
        TicketStatusExtension.fromString(PENDING_REVIEW),
        TicketStatus.pendingReview,
      );
      expect(
        TicketStatusExtension.fromString(AWAITING_HANDOVER),
        TicketStatus.awaitingHandover,
      );
    });

    test('statusValue round-trips back to the raw constant', () {
      expect(TicketStatus.pendingReview.statusValue, PENDING_REVIEW);
      expect(TicketStatus.awaitingHandover.statusValue, AWAITING_HANDOVER);
    });

    test('displayName is distinct from the legacy statuses', () {
      expect(TicketStatus.pendingReview.displayName, 'Pending Review');
      expect(TicketStatus.awaitingHandover.displayName, 'Reviewed');
    });

    test('unknown status still falls back to waiting (legacy default)', () {
      expect(
        TicketStatusExtension.fromString('someUnknownStatus'),
        TicketStatus.waiting,
      );
    });
  });
}
