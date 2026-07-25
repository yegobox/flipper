/// Per-branch, best-effort sequential ticket reference number (starts at 1),
/// distinct from a transaction's Ditto `id`. Deliberately Ditto-only — no
/// Brick/Supabase round trip in the ticket-creation path (that adds latency
/// we can't afford here). Sync happens purely via Ditto peer replication;
/// see `nextTicketReferenceNumber` in
/// `package:flipper_models/sync/utils/ticket_reference_sequence.dart`.
///
/// NOT the RRA/EBM fiscal invoice number (that has its own authoritative
/// counter in `Counter`/`counters`).
class TicketSequence {
  const TicketSequence({
    required this.id,
    required this.nextNumber,
    required this.branchId,
    required this.createdAt,
  });

  final String id;
  final int nextNumber;
  final String branchId;
  final DateTime createdAt;

  factory TicketSequence.fromDittoDocument(Map<String, dynamic> data) {
    return TicketSequence(
      id: data['id']?.toString() ?? data['_id']?.toString() ?? '',
      nextNumber: _parseInt(data['nextNumber']),
      branchId: data['branchId']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(data['createdAt']?.toString() ?? '') ??
              DateTime.now().toUtc(),
    );
  }

  Map<String, dynamic> toDittoDocument() => {
        '_id': id,
        'id': id,
        'nextNumber': nextNumber,
        'branchId': branchId,
        'createdAt': createdAt.toIso8601String(),
      };

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
