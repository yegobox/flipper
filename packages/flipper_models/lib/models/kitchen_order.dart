/// Where an order sits on the Kitchen Display.
///
/// Stored on its own `kitchen_orders` document, never on the ticket's
/// `transactions.status`. A ticket keeps its own status (`parked`, `pending`,
/// `complete`, …) while the kitchen moves it: the till's Collect / Resume and
/// the Tickets badge all key off `status == parked`, and the old Kitchen
/// Display broke them by writing `inProgress` / `waiting` onto the ticket.
enum KitchenStage {
  incoming('incoming'),
  inProgress('inProgress'),
  ready('ready'),

  /// Cleared by the kitchen. Off the display for good; the document stays so
  /// a re-send can tell "already served" from "never sent".
  served('served');

  const KitchenStage(this.wire);

  final String wire;

  /// Stages the Kitchen Display shows, in column order.
  static const List<KitchenStage> active = [incoming, inProgress, ready];

  static KitchenStage fromWire(String? raw) {
    for (final stage in values) {
      if (stage.wire == raw) return stage;
    }
    return incoming;
  }
}

/// Stage for a ticket the pre-`kitchen_orders` Kitchen Display left with a
/// kitchen status written onto `transactions.status`. Null for every status
/// that did not come from the Kitchen Display.
KitchenStage? legacyKitchenStageForStatus(String? status) {
  switch (status) {
    case 'inProgress':
      return KitchenStage.inProgress;
    case 'waiting':
      return KitchenStage.ready;
    default:
      return null;
  }
}

/// A ticket sent to the kitchen (Ditto `kitchen_orders`, `_id ==
/// transactionId`).
///
/// Ditto-only, like `branch_document_settings`: it is not in data-connector's
/// `SYNC_TABLES`, and keeping it off `transactions` means the Supabase mirror
/// of that table never sees a column it does not have.
class KitchenOrder {
  const KitchenOrder({
    required this.transactionId,
    required this.branchId,
    required this.stage,
    this.sentAt,
    this.sentBy,
    this.updatedAt,
    this.dueDate,
    this.servedAt,
  });

  static const String collection = 'kitchen_orders';

  /// Doubles as the Ditto document id.
  final String transactionId;
  final String branchId;
  final KitchenStage stage;
  final DateTime? sentAt;
  final String? sentBy;
  final DateTime? updatedAt;

  /// When the kitchen promised the order. Lives here, not on the ticket's
  /// `dueDate`, which is the loan due date.
  final DateTime? dueDate;

  /// When the kitchen pressed Served — the ticket is then the cashier's to
  /// collect. Drives the "Served · ready for payment" tag in Tickets.
  final DateTime? servedAt;

  factory KitchenOrder.fromDitto(Map<String, dynamic> doc) {
    final id = (doc['transactionId'] ?? doc['_id'] ?? doc['id']).toString();
    return KitchenOrder(
      transactionId: id,
      branchId: (doc['branchId'] ?? '').toString(),
      stage: KitchenStage.fromWire(doc['stage'] as String?),
      sentAt: _parseDate(doc['sentAt']),
      sentBy: doc['sentBy'] as String?,
      updatedAt: _parseDate(doc['updatedAt']),
      dueDate: _parseDate(doc['dueDate']),
      servedAt: _parseDate(doc['servedAt']),
    );
  }

  Map<String, dynamic> toDitto() => {
    '_id': transactionId,
    'id': transactionId,
    'transactionId': transactionId,
    'branchId': branchId,
    'stage': stage.wire,
    'sentAt': sentAt?.toUtc().toIso8601String(),
    'sentBy': sentBy,
    'updatedAt': updatedAt?.toUtc().toIso8601String(),
    'dueDate': dueDate?.toUtc().toIso8601String(),
    'servedAt': servedAt?.toUtc().toIso8601String(),
  };

  KitchenOrder copyWith({KitchenStage? stage}) => KitchenOrder(
    transactionId: transactionId,
    branchId: branchId,
    stage: stage ?? this.stage,
    sentAt: sentAt,
    sentBy: sentBy,
    updatedAt: updatedAt,
    dueDate: dueDate,
    servedAt: servedAt,
  );

  static DateTime? _parseDate(Object? raw) {
    if (raw is DateTime) return raw;
    if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
    return null;
  }
}
