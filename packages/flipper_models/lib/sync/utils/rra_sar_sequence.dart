import 'package:brick_core/query.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:ditto_live/ditto_live.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';

/// Matches data-connector `list_sars_for_branch` window.
const kRraSarLookupLimit = 20;

int parseSarNoValue(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

/// Highest branch SAR across Supabase (via Brick remote), SQLite, and Ditto.
///
/// Mirrors data-connector `resolve_sar_for_branch` so Flipper and bulk-add share
/// the same counter before `+ 1`.
Future<Sar> resolveSarForBranch({
  required Repository repository,
  required String branchId,
  Ditto? ditto,
  int limit = kRraSarLookupLimit,
}) async {
  var maxNo = 0;
  var sarId = 'sar_$branchId';
  DateTime? createdAt;

  try {
    final rows = await repository.get<Sar>(
      query: Query(
        limit: limit,
        where: [Where('branchId').isExactly(branchId)],
        orderBy: [OrderBy('sarNo', ascending: false)],
      ),
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    for (final row in rows) {
      if (row.sarNo >= maxNo) {
        maxNo = row.sarNo;
        sarId = row.id;
        createdAt = row.createdAt;
      }
    }
  } catch (_) {
    // Offline or Supabase unavailable — fall back to local/Ditto below.
  }

  if (ditto != null) {
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM sars WHERE branchId = :branchId ORDER BY sarNo DESC LIMIT 1',
        arguments: {'branchId': branchId},
      );
      if (result.items.isNotEmpty) {
        final data = result.items.first.value;
        final no = parseSarNoValue(data['sarNo']);
        if (no >= maxNo) {
          maxNo = no;
          final id = data['id']?.toString();
          if (id != null && id.isNotEmpty) {
            sarId = id;
          }
          final rawCreatedAt = data['createdAt']?.toString();
          if (rawCreatedAt != null) {
            createdAt = DateTime.tryParse(rawCreatedAt);
          }
        }
      }
    } catch (_) {}
  }

  return Sar(
    id: sarId,
    sarNo: maxNo,
    branchId: branchId,
    createdAt: createdAt ?? DateTime.now().toUtc(),
  );
}

/// Resolve max SAR, bump by one, persist to Brick (Supabase + Ditto sync).
Future<Sar> incrementAndPersistBranchSar({
  required Repository repository,
  required String branchId,
  Ditto? ditto,
}) async {
  final sar = await resolveSarForBranch(
    repository: repository,
    branchId: branchId,
    ditto: ditto,
  );
  final next = Sar(
    id: sar.id,
    sarNo: sar.sarNo + 1,
    branchId: branchId,
    createdAt: DateTime.now().toUtc(),
  );
  await repository.upsert(next);
  return next;
}
