import 'package:brick_core/query.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:supabase_models/brick/models/itemCode.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// Matches data-connector `list_codes_for_branch` / Ditto codes query window.
const kRraItemCodeLookupLimit = 200;

/// Last 7 characters of itemCd — global branch sequence, not prefix-scoped.
int parseRraItemCodeSequenceSuffix(String code) {
  if (code.length < 7) return 0;
  return int.tryParse(code.substring(code.length - 7)) ?? 0;
}

int maxRraItemCodeSequenceFromCodes(Iterable<String> codes) {
  var max = 0;
  for (final code in codes) {
    final seq = parseRraItemCodeSequenceSuffix(code);
    if (seq > max) max = seq;
  }
  return max;
}

/// Highest allocated sequence for [branchId] across local SQLite, Supabase,
/// and (when available) Ditto — same sources as data-connector bulk add.
Future<int> maxRraItemCodeSequenceForBranch({
  required Repository repository,
  required String branchId,
  Ditto? ditto,
  int limit = kRraItemCodeLookupLimit,
}) async {
  final codes = <String>{};

  try {
    final items = await repository.get<ItemCode>(
      query: Query(
        limit: limit,
        where: [
          Where('code').isNot(null),
          Where('branchId').isExactly(branchId),
        ],
        orderBy: [OrderBy('createdAt', ascending: false)],
      ),
      policy: OfflineFirstGetPolicy.awaitRemote,
    );
    codes.addAll(items.map((item) => item.code));
  } catch (_) {
    // Offline or Supabase unavailable — fall back to local/Ditto below.
  }

  if (ditto != null) {
    try {
      final result = await ditto.store.execute(
        'SELECT code FROM codes WHERE branchId = :branchId AND code IS NOT NULL ORDER BY createdAt DESC LIMIT 200',
        arguments: {'branchId': branchId},
      );
      for (final item in result.items) {
        final code = item.value['code']?.toString();
        if (code != null && code.isNotEmpty) {
          codes.add(code);
        }
      }
    } catch (_) {}
  }

  return maxRraItemCodeSequenceFromCodes(codes);
}
