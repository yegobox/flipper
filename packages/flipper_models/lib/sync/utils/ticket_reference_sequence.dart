import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:supabase_models/brick/models/ticket_sequence.model.dart';

/// Per-branch, best-effort sequential ticket reference number (starts at 1),
/// distinct from a transaction's Ditto `id`. Deliberately Ditto-only — no
/// Brick/Supabase round trip in the ticket-creation path, since that adds
/// latency the sale-completion budget can't afford. Sync happens purely via
/// Ditto peer replication (branch-scoped subscription registered below).
///
/// NOT the RRA/EBM fiscal invoice number (that has its own authoritative
/// counter in `Counter`/`counters`).
///
/// Best-effort: two devices creating a ticket at the same instant while
/// offline from each other can rarely produce the same number — accepted,
/// since this is a display reference, not a fiscal/legal id.
Future<int> nextTicketReferenceNumber({
  required Ditto? ditto,
  required String branchId,
}) async {
  if (ditto == null) return 1;

  final docId = 'ticket_seq_$branchId';
  try {
    final prepared = prepareDqlSyncSubscription(
      'SELECT * FROM ticket_sequences WHERE branchId = :branchId',
      {'branchId': branchId},
    );
    ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );

    final result = await ditto.store.execute(
      'SELECT * FROM ticket_sequences WHERE _id = :id',
      arguments: {'id': docId},
    );

    final current = result.items.isNotEmpty
        ? TicketSequence.fromDittoDocument(
            Map<String, dynamic>.from(result.items.first.value),
          )
        : null;
    final next = (current?.nextNumber ?? 0) + 1;

    final doc = TicketSequence(
      id: docId,
      nextNumber: next,
      branchId: branchId,
      createdAt: DateTime.now().toUtc(),
    );

    await ditto.store.execute(
      'INSERT INTO ticket_sequences DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': doc.toDittoDocument()},
    );

    return next;
  } catch (_) {
    return 1;
  }
}
