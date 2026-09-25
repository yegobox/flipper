import 'package:flipper_models/models/kitchen_order.dart';

/// DQL for the Kitchen Display's `kitchen_orders` collection.
///
/// Functions take the raw Ditto `store` so the same statements run in the
/// Capella mixin and against a real local store in tests. None of them write
/// `transactions.status` except [repairLegacyKitchenStatusesOnStore], which
/// only ever moves a stranded ticket back to `parked`.

const String kitchenOrdersBranchSubscriptionDql =
    'SELECT * FROM kitchen_orders WHERE branchId = :branchId';

/// Orders still on the display. `IN` over the active stages rather than
/// `stage != 'served'` so the filter never depends on how a missing field
/// compares.
const String activeKitchenOrdersDql =
    'SELECT * FROM kitchen_orders WHERE branchId = :branchId '
    'AND stage IN :stages';

Map<String, dynamic> activeKitchenOrdersArgs(String branchId) => {
  'branchId': branchId,
  'stages': [for (final s in KitchenStage.active) s.wire],
};

/// What the Tickets list tags: orders still in the kitchen, plus ones served
/// since [since] — a served ticket still open is waiting on the cashier.
const String kitchenTicketTagsDql =
    'SELECT * FROM kitchen_orders WHERE branchId = :branchId '
    'AND (stage IN :stages OR (stage = :served AND servedAt >= :since))';

Map<String, dynamic> kitchenTicketTagsArgs(String branchId, DateTime since) => {
  ...activeKitchenOrdersArgs(branchId),
  'served': KitchenStage.served.wire,
  'since': since.toUtc().toIso8601String(),
};

/// The tickets behind the orders on the display — every status, so a ticket
/// paid at the till stays on the display until the kitchen serves it.
const String kitchenTicketsDql =
    'SELECT * FROM transactions WHERE _id IN :ids OR id IN :ids';

List<KitchenOrder> kitchenOrdersFromResult(dynamic queryResult) {
  final orders = <KitchenOrder>[];
  for (final item in queryResult.items) {
    orders.add(KitchenOrder.fromDitto(Map<String, dynamic>.from(item.value)));
  }
  return orders;
}

Future<KitchenOrder?> kitchenOrderOnStore(
  dynamic store,
  String transactionId,
) async {
  final result = await store.execute(
    'SELECT * FROM kitchen_orders WHERE _id = :id',
    arguments: {'id': transactionId},
  );
  final orders = kitchenOrdersFromResult(result);
  return orders.isEmpty ? null : orders.first;
}

Future<List<KitchenOrder>> activeKitchenOrdersOnStore(
  dynamic store,
  String branchId,
) async {
  final result = await store.execute(
    activeKitchenOrdersDql,
    arguments: activeKitchenOrdersArgs(branchId),
  );
  return kitchenOrdersFromResult(result);
}

/// Puts a ticket on the Kitchen Display.
///
/// An order already on the display keeps its stage — re-sending a ticket the
/// kitchen is cooking, or parking more lines into it, must not bounce it back
/// to Incoming. A served (or never sent) ticket starts again at Incoming.
Future<void> sendTicketToKitchenOnStore(
  dynamic store, {
  required String transactionId,
  required String branchId,
  String? sentBy,
  DateTime? now,
}) async {
  final existing = await kitchenOrderOnStore(store, transactionId);
  if (existing != null && existing.stage != KitchenStage.served) return;

  final at = (now ?? DateTime.now()).toUtc();
  await store.execute(
    'INSERT INTO kitchen_orders DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
    arguments: {
      'doc': KitchenOrder(
        transactionId: transactionId,
        branchId: branchId,
        stage: KitchenStage.incoming,
        sentAt: at,
        sentBy: sentBy,
        updatedAt: at,
      ).toDitto(),
    },
  );
}

/// Moves an order between Kitchen Display columns. Touches `kitchen_orders`
/// only.
Future<void> updateKitchenStageOnStore(
  dynamic store, {
  required String transactionId,
  required KitchenStage stage,
  DateTime? dueDate,
  bool clearDueDate = false,
  DateTime? now,
}) async {
  final at = (now ?? DateTime.now()).toUtc().toIso8601String();
  final setClauses = <String>['stage = :stage', 'updatedAt = :updatedAt'];
  final args = <String, dynamic>{
    'id': transactionId,
    'stage': stage.wire,
    'updatedAt': at,
  };
  if (stage == KitchenStage.served) {
    setClauses.add('servedAt = :updatedAt');
  }
  if (clearDueDate) {
    setClauses.add('dueDate = NULL');
  } else if (dueDate != null) {
    setClauses.add('dueDate = :dueDate');
    args['dueDate'] = dueDate.toUtc().toIso8601String();
  }
  await store.execute(
    'UPDATE kitchen_orders SET ${setClauses.join(', ')} WHERE _id = :id',
    arguments: args,
  );

  // Served hands the ticket to the cashier. A ticket the old Kitchen Display
  // stranded on a kitchen status could not be collected, so return it to
  // parked here too (normally the on-open repair already has).
  if (stage == KitchenStage.served) {
    final result = await store.execute(
      'SELECT * FROM transactions WHERE _id = :id',
      arguments: {'id': transactionId},
    );
    for (final item in result.items) {
      await _unstrandTicket(store, Map<String, dynamic>.from(item.value), at);
    }
  }
}

/// Moves one stranded ticket back to `parked`; false if [doc] is not one.
/// Conditional on the status read, so a ticket another device has moved on
/// since (resumed, paid) is left alone.
Future<bool> _unstrandTicket(
  dynamic store,
  Map<String, dynamic> doc,
  String atIso,
) async {
  if (!isStrandedKitchenTicket(doc)) return false;
  await store.execute(
    'UPDATE transactions SET status = :parked, updatedAt = :at, '
    'lastTouched = :at WHERE _id = :id AND status = :status',
    arguments: {
      'parked': 'parked',
      'at': atIso,
      'id': (doc['_id'] ?? doc['id']).toString(),
      'status': doc['status'],
    },
  );
  return true;
}

/// Tickets the old Kitchen Display stranded by writing `inProgress` /
/// `waiting` onto `transactions.status`: the till cannot Collect or Resume
/// them, since both key off `parked`.
///
/// Only rows that look like a parked sale ticket qualify — an original
/// transaction with a ticket name and a subtotal, not an adjustment. That
/// keeps out MoMo rows, which also use `waiting` ("Mark not completed") but
/// never carry a ticket name.
bool isStrandedKitchenTicket(Map<String, dynamic> doc) {
  if (legacyKitchenStageForStatus(doc['status'] as String?) == null) {
    return false;
  }
  if (doc['isOriginalTransaction'] != true) return false;
  final name = doc['ticketName'];
  if (name is! String || name.trim().isEmpty) return false;
  final subTotal = doc['subTotal'];
  if (subTotal is! num || subTotal <= 0) return false;
  if (doc['transactionType'] == 'Adjustment') return false;
  return true;
}

/// Moves every stranded ticket in [branchId] back to `parked` and onto the
/// Kitchen Display at the stage it was dragged to. Idempotent: once nothing
/// matches it is a single read. Returns the number of tickets repaired.
Future<int> repairLegacyKitchenStatusesOnStore(
  dynamic store, {
  required String branchId,
  DateTime? now,
}) async {
  final result = await store.execute(
    'SELECT * FROM transactions WHERE branchId = :branchId '
    'AND status IN :statuses',
    arguments: {
      'branchId': branchId,
      'statuses': ['inProgress', 'waiting'],
    },
  );

  final at = (now ?? DateTime.now()).toUtc();
  final atIso = at.toIso8601String();
  var repaired = 0;
  for (final item in result.items) {
    final doc = Map<String, dynamic>.from(item.value);
    if (!isStrandedKitchenTicket(doc)) continue;

    final id = (doc['_id'] ?? doc['id']).toString();
    final status = doc['status'] as String;
    final stage = legacyKitchenStageForStatus(status)!;

    // Kitchen document first: if the status write below fails the ticket is
    // still stranded but no worse off, and the next run retries it.
    final existing = await kitchenOrderOnStore(store, id);
    if (existing == null) {
      final rawDue = doc['dueDate'];
      await store.execute(
        'INSERT INTO kitchen_orders DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {
          'doc': KitchenOrder(
            transactionId: id,
            branchId: branchId,
            stage: stage,
            sentAt: at,
            updatedAt: at,
            dueDate: rawDue is String ? DateTime.tryParse(rawDue) : null,
          ).toDitto(),
        },
      );
    }

    await _unstrandTicket(store, doc, atIso);
    repaired++;
  }
  return repaired;
}
