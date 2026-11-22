import 'dart:async';
import 'dart:convert';

import 'package:flipper_models/bulk_rra_client.dart'
    show resolveDataConnectorBaseUrl;
import 'package:flipper_models/data_connector_client.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sku/sku_allocator.dart';
import 'package:flipper_models/sku/sku_duplicate_check.dart';
import 'package:flipper_models/sku/sku_format.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/core/local_mode/local_mode.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/variant.model.dart';

/// Preference key holding every business's reserved SKU numbers (one JSON
/// map). Must stay in `SharedPreferenceStorage._allowedKeys`.
const String kSkuBlocksKey = 'skuBlocks';

/// A SKU for a new item: either a value, or pending (no number available on
/// this device right now; data-connector assigns one on sync).
class SkuAssignment {
  const SkuAssignment._(this.sku);

  const SkuAssignment.value(String sku) : this._(sku);
  const SkuAssignment.pending() : this._(null);

  final String? sku;
  bool get pending => sku == null;
}

/// `POST /api/skus/reserve` on data-connector.
class SkuReserveClient {
  SkuReserveClient({required String baseUrl, http.Client? httpClient})
    : _http = httpClient ?? DataConnectorClient(baseUrl: baseUrl),
      _base = baseUrl.endsWith('/') ? baseUrl : '$baseUrl/';

  final http.Client _http;
  final String _base;

  Future<SkuNumberRange> reserve({
    required String businessId,
    required int size,
  }) async {
    final response = await _http.post(
      Uri.parse('${_base}api/skus/reserve'),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode({'businessId': businessId, 'size': size}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'SKU reserve failed: HTTP ${response.statusCode} ${response.body}',
      );
    }
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final start = (body['start'] as num).toInt();
    final end = (body['end'] as num).toInt();
    if (end < start) throw Exception('SKU reserve returned $start..$end');
    return SkuNumberRange(start, end);
  }
}

class _BoxSkuStore implements SkuAllocatorStore {
  const _BoxSkuStore();

  @override
  String? read() => ProxyService.box.readString(key: kSkuBlocksKey);

  @override
  Future<void> write(String value) =>
      ProxyService.box.writeString(key: kSkuBlocksKey, value: value);
}

class _AppSkuEnv implements SkuAllocatorEnv {
  const _AppSkuEnv();

  @override
  bool get isLocalMode => LocalMode.isOn;

  @override
  Future<SkuNumberRange> reserve({
    required String businessId,
    required int size,
  }) async {
    String? configured;
    final branchId = ProxyService.box.getBranchId();
    if (branchId != null && branchId.isNotEmpty) {
      configured = (await ProxyService.strategy.ebm(
        branchId: branchId,
        fetchRemote: false,
      ))?.dataConnectorUrl;
    }
    final base = await resolveDataConnectorBaseUrl(
      dataConnectorUrl: configured,
    );
    return SkuReserveClient(
      baseUrl: base,
    ).reserve(businessId: businessId, size: size);
  }

  @override
  Future<int> localMax({required String businessId}) async {
    final ditto = DittoService.instance.dittoInstance;
    if (ditto == null) return 0;
    final branches = await ProxyService.strategy.branches(
      businessId: businessId,
      localOnly: true,
    );
    final branchIds = branches.map((b) => b.id).toList();
    var highest = 0;
    void consider(Object? raw) {
      final n = raw is num
          ? (raw.toInt() <= 9999999 ? raw.toInt() : null)
          : legacySkuNumber(raw?.toString());
      if (n != null && n > highest) highest = n;
    }

    if (branchIds.isNotEmpty) {
      final variants = await ditto.store.execute(
        'SELECT sku FROM variants WHERE branchId IN :branchIds',
        arguments: {'branchIds': branchIds},
      );
      for (final item in variants.items) {
        consider(item.value['sku']);
      }
    }
    final legacy = await ditto.store.execute(
      'SELECT sku FROM skus WHERE businessId = :businessId',
      arguments: {'businessId': businessId},
    );
    for (final item in legacy.items) {
      consider(item.value['sku']);
    }
    return highest;
  }
}

SkuAllocator? _allocator;

/// The app's allocator. Tests replace it with [debugSetSkuAllocator].
SkuAllocator get skuAllocator => _allocator ??=
    SkuAllocator(store: const _BoxSkuStore(), env: const _AppSkuEnv())
      ..onRefillError = ((e) => talker.info('SKU block refill skipped: $e'))
      ..onWriteError = ((e) => talker.warning('SKU cursor not stored: $e'));

/// Swap the allocator (tests). Null restores the app's own.
void debugSetSkuAllocator(SkuAllocator? allocator) => _allocator = allocator;

/// Top up this device's SKU numbers in the background. Call at app start /
/// login once the business is known. Never throws and never blocks.
void topUpSkuNumbers(String? businessId) {
  if (businessId == null || businessId.isEmpty) return;
  try {
    skuAllocator.topUp(businessId: businessId);
  } catch (e) {
    talker.info('SKU top-up skipped: $e');
  }
}

/// A SKU for one more variant of a product whose other variants carry
/// [siblingSkus]. When a sibling has a generated SKU (`BEV-00042`), the new
/// variant takes the next suffix (`BEV-00042-02`) and uses no counter number.
/// Otherwise it gets a fresh SKU from [assignNewSku].
Future<SkuAssignment> assignVariantSku({
  required String businessId,
  required Iterable<String?> siblingSkus,
  String? categoryId,
  String? categoryName,
  String? skuPrefix,
}) async {
  final siblings = siblingSkus.toList();
  for (final sibling in siblings) {
    final base = skuBase(sibling);
    if (base == null) continue;
    final next = nextVariantSku(base, siblings);
    if (next != null) return SkuAssignment.value(next);
  }
  return assignNewSku(
    businessId: businessId,
    categoryId: categoryId,
    categoryName: categoryName,
    skuPrefix: skuPrefix,
  );
}

/// Gives each of [variants] that has no SKU one before it is saved, from
/// [assign] (called with the SKUs the product's variants hold so far, so it
/// can take the next suffix: [assignVariantSku]). [otherSkus] are the SKUs of
/// the product's variants that are not in [variants]. A variant that already
/// has a SKU, or is already SKU pending, is left alone; a pending assignment
/// leaves `sku` null and sets `skuPending`.
Future<void> fillMissingVariantSkus(
  List<Variant> variants, {
  Iterable<String?> otherSkus = const [],
  required Future<SkuAssignment> Function(List<String?> siblingSkus) assign,
}) async {
  final siblings = <String?>[
    for (final v in variants)
      if ((v.sku ?? '').trim().isNotEmpty) v.sku!.trim(),
    ...otherSkus,
  ];
  for (final variant in variants) {
    if ((variant.sku ?? '').trim().isNotEmpty) continue;
    if (variant.skuPending == true) continue;
    final assignment = await assign(List.of(siblings));
    variant
      ..sku = assignment.sku
      ..skuPending = assignment.pending;
    if (assignment.sku != null) siblings.add(assignment.sku);
  }
}

/// A SKU for a new item. Reads only local state (the reserved block and the
/// local Ditto category), so it works offline and never waits for the server.
/// Any failure yields [SkuAssignment.pending]: the item still saves.
Future<SkuAssignment> assignNewSku({
  required String businessId,
  String? categoryId,
  String? categoryName,
  String? skuPrefix,
}) async {
  try {
    var prefixSource = skuPrefix;
    var nameSource = categoryName;
    if (prefixSource == null && categoryId != null && categoryId.isNotEmpty) {
      final category = await ProxyService.strategy.category(id: categoryId);
      prefixSource = category?.skuPrefix;
      nameSource ??= category?.name;
    }
    final sku = await skuAllocator.nextSku(
      businessId: businessId,
      skuPrefix: prefixSource,
      categoryName: nameSource,
    );
    return sku == null
        ? const SkuAssignment.pending()
        : SkuAssignment.value(sku);
  } catch (e, s) {
    talker.warning('SKU assignment failed; saving as pending: $e', e, s);
    return const SkuAssignment.pending();
  }
}

/// A preview of the SKU a new item would get (`BEV-00064`), without taking
/// the number. Null when this device has no number yet: the form shows
/// "SKU pending" and the item still saves.
String? previewNextSku({
  required String businessId,
  String? skuPrefix,
  String? categoryName,
}) {
  try {
    final number = skuAllocator.peek(businessId: businessId);
    if (number == null) return null;
    return formatSku(
      deriveSkuPrefix(skuPrefix: skuPrefix, categoryName: categoryName),
      number,
    );
  } catch (_) {
    return null;
  }
}

Future<List<Map<String, dynamic>>> _dittoRows(
  String sql,
  Map<String, dynamic> arguments,
) async {
  final ditto = DittoService.instance.dittoInstance;
  if (ditto == null) return const [];
  final result = await ditto.store.execute(sql, arguments: arguments);
  return [
    for (final item in result.items) Map<String, dynamic>.from(item.value),
  ];
}

/// The variant of the business already using [sku], or null when it is free
/// (or unchanged from [storedSku]). One local Ditto query: works offline.
/// See [findSkuClash] for the rules.
Future<SkuHolder?> findSkuInUse({
  required String sku,
  required String businessId,
  required SkuHolder candidate,
  String? storedSku,
}) async {
  if (!skuNeedsDuplicateCheck(typed: sku, stored: storedSku)) return null;
  final branches = await ProxyService.strategy.branches(
    businessId: businessId,
    localOnly: true,
  );
  return checkSkuDuplicate(
    sku: sku,
    candidate: candidate,
    storedSku: storedSku,
    branchIds: [for (final b in branches) b.id],
    query: _dittoRows,
  );
}

/// SKUs already held by the variants of [productId] at [branchId] (local).
Future<List<String>> productVariantSkus({
  required String productId,
  required String branchId,
}) async {
  try {
    final rows = await _dittoRows(
      'SELECT sku FROM variants WHERE productId = :productId '
      'AND branchId = :branchId',
      {'productId': productId, 'branchId': branchId},
    );
    return [
      for (final row in rows)
        if ((row['sku']?.toString().trim() ?? '').isNotEmpty)
          row['sku'].toString().trim(),
    ];
  } catch (_) {
    return const [];
  }
}
