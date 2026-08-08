/// Ditto document mapping for the small per-branch reference collections
/// (`colors`, `units`).
///
/// These are the first models moved off Brick as part of the Ditto-only
/// migration. They are written to Ditto **and** mirrored to Brick, which is
/// what still carries them to Supabase — there is no `@DittoAdapter` on
/// [PColor] / [IUnit] and neither table is in data-connector's `SYNC_TABLES`.
///
/// Reads are Ditto-first with a one-time backfill: existing installs have
/// these rows only in SQLite, so an empty Ditto result falls back to Brick and
/// seeds Ditto from it rather than showing the user an empty list.
library;

import 'package:ditto_live/ditto_live.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:supabase_models/brick/models/all_models.dart';

const String colorsCollection = 'colors';
const String unitsCollection = 'units';

/// `collection|branchId` pairs already subscribed this session. Without this
/// guard every read would register another subscription and leak them until
/// sync stalls — the same failure `isTaxEnabled` hit during bulk import.
final Set<String> _referenceSubscribed = <String>{};

Future<void> ensureReferenceSubscription(
  Ditto ditto,
  String collection,
  String branchId,
) async {
  final key = '$collection|$branchId';
  if (!_referenceSubscribed.add(key)) return;
  try {
    final prepared = prepareDqlSyncSubscription(
      'SELECT * FROM $collection WHERE branchId = :branchId',
      {'branchId': branchId},
    );
    await ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
  } catch (_) {
    // Let the caller fall back to the local read; retry on the next call.
    _referenceSubscribed.remove(key);
  }
}

DateTime? _dateOrNull(dynamic value) {
  if (value == null) return null;
  if (value is DateTime) return value;
  return DateTime.tryParse(value.toString());
}

bool _boolOrFalse(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) return value.toLowerCase() == 'true';
  return false;
}

Map<String, dynamic> colorToDittoDoc(PColor color) => {
      '_id': color.id,
      'id': color.id,
      'name': color.name,
      'branchId': color.branchId,
      'active': color.active,
      'lastTouched': color.lastTouched?.toIso8601String(),
      'deletedAt': color.deletedAt?.toIso8601String(),
    };

PColor colorFromDittoDoc(Map<String, dynamic> doc) => PColor(
      id: (doc['id'] ?? doc['_id'])?.toString(),
      name: doc['name']?.toString(),
      branchId: doc['branchId']?.toString(),
      active: _boolOrFalse(doc['active']),
      lastTouched: _dateOrNull(doc['lastTouched']),
      deletedAt: _dateOrNull(doc['deletedAt']),
    );

Map<String, dynamic> unitToDittoDoc(IUnit unit) => {
      '_id': unit.id,
      'id': unit.id,
      'branchId': unit.branchId,
      'name': unit.name,
      'value': unit.value,
      'active': unit.active,
      'code': unit.code,
      'description': unit.description,
      'lastTouched': unit.lastTouched?.toIso8601String(),
      'createdAt': unit.createdAt,
    };

IUnit unitFromDittoDoc(Map<String, dynamic> doc) => IUnit(
      id: (doc['id'] ?? doc['_id'])?.toString(),
      branchId: doc['branchId']?.toString(),
      name: doc['name']?.toString(),
      value: doc['value']?.toString(),
      active: doc['active'] == null ? null : _boolOrFalse(doc['active']),
      code: doc['code']?.toString(),
      description: doc['description']?.toString(),
      lastTouched: _dateOrNull(doc['lastTouched']),
      createdAt: doc['createdAt']?.toString(),
    );

Future<void> upsertReferenceDoc(
  Ditto ditto,
  String collection,
  Map<String, dynamic> doc,
) async {
  await ditto.store.execute(
    'INSERT INTO $collection DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
    arguments: {'doc': doc},
  );
}
