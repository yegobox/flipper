import 'package:ditto_live/ditto_live.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/repository.dart';

int parseSarNoValue(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

/// Branch SAR from Ditto only — mirrors data-connector `resolve_sar_for_branch`.
///
/// Supabase/SQLite are updated as mirrors on upsert; they are not read for the
/// sequence counter.
Future<Sar> resolveSarForBranch({
  required String branchId,
  Ditto? ditto,
}) async {
  var sarId = 'sar_$branchId';
  var maxNo = 0;
  DateTime? createdAt;

  if (ditto != null) {
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM sars WHERE branchId = :branchId ORDER BY sarNo DESC LIMIT 1',
        arguments: {'branchId': branchId},
      );
      if (result.items.isNotEmpty) {
        final data = result.items.first.value;
        maxNo = parseSarNoValue(data['sarNo']);
        final id = data['id']?.toString();
        if (id != null && id.isNotEmpty) {
          sarId = id;
        }
        final rawCreatedAt = data['createdAt']?.toString();
        if (rawCreatedAt != null) {
          createdAt = DateTime.tryParse(rawCreatedAt);
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

/// Read max SAR from Ditto, bump by one, persist via Brick (Supabase + Ditto push).
Future<Sar> incrementAndPersistBranchSar({
  required Repository repository,
  required String branchId,
  Ditto? ditto,
}) async {
  final sar = await resolveSarForBranch(branchId: branchId, ditto: ditto);
  final next = Sar(
    id: sar.id,
    sarNo: sar.sarNo + 1,
    branchId: branchId,
    createdAt: DateTime.now().toUtc(),
  );
  await repository.upsert(next);
  return next;
}
