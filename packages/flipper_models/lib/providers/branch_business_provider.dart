import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branch_business_provider.g.dart';

/// Branches the current user may access for [businessId].
///
/// Same source as [LoginChoices] (`Ditto user_access` via `getBranches`).
/// Local Brick rows only enrich fields (e.g. `isDefault`) for those ids —
/// never add branches the user cannot access.
@riverpod
Future<List<Branch>> branches(Ref ref, {String? businessId}) async {
  if (businessId == null) return [];

  final userId = ProxyService.box.getUserId();
  if (userId == null) return [];

  final branchesById = <String, Branch>{};

  if (ProxyService.ditto.isReady()) {
    final branchesJson =
        await ProxyService.ditto.getBranches(userId, businessId);
    for (final json in branchesJson) {
      final branch = Branch.fromMap(Map<String, dynamic>.from(json));
      if (branch.businessId != null &&
          branch.businessId!.isNotEmpty &&
          branch.businessId != businessId) {
        continue;
      }
      branchesById[branch.id] = branch;
    }
  }

  if (branchesById.isNotEmpty) {
    try {
      final ids = branchesById.keys.toList();
      final localBranches = await Repository().get<Branch>(
        query: Query(
          where: [
            Where('businessId').isExactly(businessId),
            Where('id').isIn(ids),
          ],
        ),
        policy: OfflineFirstGetPolicy.localOnly,
      );
      for (final branch in localBranches) {
        branchesById[branch.id] = branch;
      }
    } catch (_) {
      // Local read is best-effort.
    }
  }

  return branchesById.values.toList();
}

/// Every branch row synced for [businessId] (admin screens, e.g. Add Branch).
@riverpod
Future<List<Branch>> allBusinessBranches(Ref ref, {String? businessId}) async {
  if (businessId == null) return [];

  try {
    return await Repository().get<Branch>(
      query: Query(where: [Where('businessId').isExactly(businessId)]),
      policy: OfflineFirstGetPolicy.localOnly,
    );
  } catch (_) {
    return [];
  }
}

/// Pulls latest branch rows from Supabase into local Brick/SQLite.
Future<void> hydrateBusinessBranchesFromRemote({required String? businessId}) async {
  if (businessId == null) return;

  try {
    await Repository().get<Branch>(
      query: Query(where: [Where('businessId').isExactly(businessId)]),
      policy: OfflineFirstGetPolicy.alwaysHydrate,
    );
  } catch (_) {
    // Offline or hydrate failed; caller still shows cached data.
  }
}
