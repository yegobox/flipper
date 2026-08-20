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
const String countriesCollection = 'countries';
const String financeProvidersCollection = 'finance_providers';
const String configurationsCollection = 'configurations';

/// `dittoInstance|collection|branchId` triples already subscribed. Without this
/// guard every read would register another subscription and leak them until
/// sync stalls — the same failure `isTaxEnabled` hit during bulk import.
///
/// The Ditto instance is part of the key: subscriptions belong to the instance
/// that registered them, so a recreated singleton (logout/login, teardown) must
/// be able to register its own rather than being skipped as "already done".
final Set<String> _referenceSubscribed = <String>{};

Future<void> ensureReferenceSubscription(
  Ditto ditto,
  String collection,
  String branchId,
) async {
  final key = '${identityHashCode(ditto)}|$collection|$branchId';
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

// ---------------------------------------------------------------------------
// Global catalogues: `countries`, `finance_providers`.
//
// These originate in Supabase rather than on a device, so they have no branch
// to scope by and no client write path. Brick reached them with a remote-backed
// `repository.get`; without Brick the client reads Supabase directly and keeps
// a Ditto copy so the list still works offline (country pickers appear during
// signup, which can happen on a bad connection).
//
// Supabase columns are snake_case — verified against `.snaplet/dataModel.json`:
//   countries         -> id, code, sort_order, name, description
//   finance_providers -> id, name, interest_rate,
//                        suppliers_that_accept_this_finance_facility
// ---------------------------------------------------------------------------

/// `dittoInstance|collection` pairs already subscribed. Keyed by instance for
/// the same reason as [_referenceSubscribed].
final Set<String> _globalReferenceSubscribed = <String>{};

Future<void> ensureGlobalReferenceSubscription(
  Ditto ditto,
  String collection,
) async {
  final key = '${identityHashCode(ditto)}|$collection';
  if (!_globalReferenceSubscribed.add(key)) return;
  try {
    final prepared =
        prepareDqlSyncSubscription('SELECT * FROM $collection', null);
    await ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );
  } catch (_) {
    _globalReferenceSubscribed.remove(key);
  }
}

int _intOrZero(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '') ?? 0;
}

num _numOrZero(dynamic value) {
  if (value is num) return value;
  return num.tryParse(value?.toString() ?? '') ?? 0;
}

Country countryFromSupabaseRow(Map<String, dynamic> row) => Country(
      id: row['id']?.toString(),
      name: row['name']?.toString() ?? '',
      sortOrder: _intOrZero(row['sort_order']),
      description: row['description']?.toString() ?? '',
      code: row['code']?.toString() ?? '',
    );

Map<String, dynamic> countryToDittoDoc(Country country) => {
      '_id': country.id,
      'id': country.id,
      'name': country.name,
      'sortOrder': country.sortOrder,
      'description': country.description,
      'code': country.code,
    };

Country countryFromDittoDoc(Map<String, dynamic> doc) => Country(
      id: (doc['id'] ?? doc['_id'])?.toString(),
      name: doc['name']?.toString() ?? '',
      sortOrder: _intOrZero(doc['sortOrder']),
      description: doc['description']?.toString() ?? '',
      code: doc['code']?.toString() ?? '',
    );

FinanceProvider financeProviderFromSupabaseRow(Map<String, dynamic> row) =>
    FinanceProvider(
      id: row['id']?.toString(),
      name: row['name']?.toString() ?? '',
      interestRate: _numOrZero(row['interest_rate']),
      suppliersThatAcceptThisFinanceFacility:
          row['suppliers_that_accept_this_finance_facility']?.toString() ?? '',
    );

Map<String, dynamic> financeProviderToDittoDoc(FinanceProvider provider) => {
      '_id': provider.id,
      'id': provider.id,
      'name': provider.name,
      'interestRate': provider.interestRate,
      'suppliersThatAcceptThisFinanceFacility':
          provider.suppliersThatAcceptThisFinanceFacility,
    };

FinanceProvider financeProviderFromDittoDoc(Map<String, dynamic> doc) =>
    FinanceProvider(
      id: (doc['id'] ?? doc['_id'])?.toString(),
      name: doc['name']?.toString() ?? '',
      interestRate: _numOrZero(doc['interestRate']),
      suppliersThatAcceptThisFinanceFacility:
          doc['suppliersThatAcceptThisFinanceFacility']?.toString() ?? '',
    );

// ---------------------------------------------------------------------------
// Tax configuration (`configurations`).
//
// Server-owned like the catalogues: rows originate in Supabase, the client only
// reads them. Cached in Ditto so tax lookups work offline — `getByTaxType` runs
// on the sale path and must not need a round trip.
// ---------------------------------------------------------------------------

double? _doubleOrNull(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

Configurations configurationFromSupabaseRow(Map<String, dynamic> row) =>
    Configurations(
      id: row['id']?.toString(),
      taxType: row['tax_type']?.toString(),
      taxPercentage: _doubleOrNull(row['tax_percentage']),
      businessId: row['business_id']?.toString(),
      branchId: row['branch_id']?.toString(),
    );

Map<String, dynamic> configurationToDittoDoc(Configurations config) => {
      '_id': config.id,
      'id': config.id,
      'taxType': config.taxType,
      'taxPercentage': config.taxPercentage,
      'businessId': config.businessId,
      'branchId': config.branchId,
    };

Configurations configurationFromDittoDoc(Map<String, dynamic> doc) =>
    Configurations(
      id: (doc['id'] ?? doc['_id'])?.toString(),
      taxType: doc['taxType']?.toString(),
      taxPercentage: _doubleOrNull(doc['taxPercentage']),
      businessId: doc['businessId']?.toString(),
      branchId: doc['branchId']?.toString(),
    );

/// Pull every `configurations` row for [branchId] from Supabase and seed the
/// Ditto cache. Returns what it fetched.
Future<List<Configurations>> hydrateTaxConfigurationsIntoDitto({
  required Ditto? ditto,
  required String branchId,
  required Future<List<Map<String, dynamic>>> Function() fetchRows,
}) async {
  final rows = await fetchRows();
  final configs = rows.map(configurationFromSupabaseRow).toList();
  if (ditto != null) {
    for (final config in configs) {
      await upsertReferenceDoc(
        ditto,
        configurationsCollection,
        configurationToDittoDoc(config),
      );
    }
  }
  return configs;
}
