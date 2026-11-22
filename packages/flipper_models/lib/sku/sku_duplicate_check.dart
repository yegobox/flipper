import 'package:flipper_models/sku/sku_format.dart';

/// A variant that already carries a SKU, as read from Ditto.
class SkuHolder {
  const SkuHolder({
    required this.id,
    this.name,
    this.branchId,
    this.productId,
    this.itemCd,
    this.bcd,
  });

  factory SkuHolder.fromDitto(Map<String, dynamic> row) => SkuHolder(
    id: (row['id'] ?? row['_id'])?.toString() ?? '',
    name: row['name']?.toString(),
    branchId: row['branchId']?.toString(),
    productId: row['productId']?.toString(),
    itemCd: row['itemCd']?.toString(),
    bcd: row['bcd']?.toString(),
  );

  final String id;
  final String? name;
  final String? branchId;
  final String? productId;
  final String? itemCd;
  final String? bcd;
}

/// Whether saving [typed] needs the duplicate check.
///
/// Only a new or changed SKU is checked. SKUs used to be numbered per branch,
/// so branch A's "42" and branch B's "42" are usually different items:
/// re-saving an old item unchanged must never be blocked.
bool skuNeedsDuplicateCheck({required String? typed, String? stored}) {
  final next = normalizeSku(typed);
  if (next.isEmpty) return false;
  return next != normalizeSku(stored);
}

/// The variant that [candidate]'s SKU clashes with, or null when it is free.
///
/// [holders] are the variants of the business that carry the same SKU
/// (compared trimmed and case-insensitively). The rules:
/// - The candidate itself never counts.
/// - **Same branch:** any other variant with this SKU blocks the save,
///   including a sibling variant of the same product (siblings get `-02`,
///   `-03` suffixes). The server's unique index on `(branch_id, lower(sku))`
///   enforces the same rule.
/// - **Other branches:** the same item may carry the same SKU there. A holder
///   is the same item when it has the same `productId`, or the same non-empty
///   `itemCd`, or the same non-empty `bcd`. Any other holder blocks the save.
SkuHolder? findSkuClash({
  required SkuHolder candidate,
  required Iterable<SkuHolder> holders,
}) {
  bool same(String? a, String? b) {
    final x = a?.trim() ?? '';
    return x.isNotEmpty && x == (b?.trim() ?? '');
  }

  for (final holder in holders) {
    if (holder.id.isNotEmpty && holder.id == candidate.id) continue;
    if (holder.branchId == candidate.branchId) return holder;
    final sameItem =
        same(holder.productId, candidate.productId) ||
        same(holder.itemCd, candidate.itemCd) ||
        same(holder.bcd, candidate.bcd);
    if (!sameItem) return holder;
  }
  return null;
}

/// Runs a Ditto query and returns the rows (injected so the check is testable
/// without Ditto).
typedef SkuRowsQuery =
    Future<List<Map<String, dynamic>>> Function(
      String sql,
      Map<String, dynamic> arguments,
    );

/// One local Ditto query over every branch of the business. Works offline.
const String kSkuHoldersQuery =
    'SELECT _id, id, name, branchId, productId, itemCd, bcd, sku '
    'FROM variants '
    "WHERE branchId IN :branchIds AND LOWER(TRIM(COALESCE(sku, ''))) = :sku";

/// Look for a clash for [candidate] carrying [sku]. Returns null when the SKU
/// is free, or when it is unchanged from [storedSku] (no check needed).
Future<SkuHolder?> checkSkuDuplicate({
  required String sku,
  required SkuHolder candidate,
  required List<String> branchIds,
  required SkuRowsQuery query,
  String? storedSku,
}) async {
  if (!skuNeedsDuplicateCheck(typed: sku, stored: storedSku)) return null;
  final ids = {
    ...branchIds,
    if (candidate.branchId != null) candidate.branchId!,
  }.where((id) => id.isNotEmpty).toList();
  if (ids.isEmpty) return null;
  final rows = await query(kSkuHoldersQuery, {
    'branchIds': ids,
    'sku': normalizeSku(sku),
  });
  return findSkuClash(
    candidate: candidate,
    holders: rows.map(SkuHolder.fromDitto),
  );
}
