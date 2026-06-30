import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branch_business_provider.g.dart';

@riverpod
Future<List<Branch>> branches(Ref ref, {String? businessId}) async {
  if (businessId == null) return [];

  final userId = ProxyService.box.getUserId();
  if (userId == null) return [];

  final branchesById = <String, Branch>{};

  // Permission-aware list from Ditto user_access (populated at login).
  if (ProxyService.ditto.isReady()) {
    final userAccess = await ProxyService.ditto.getUserAccess(userId);
    if (userAccess != null && userAccess.containsKey('businesses')) {
      final List<dynamic> businessesJson = userAccess['businesses'];
      final businessJson = businessesJson.firstWhere(
        (b) => b['id'] == businessId,
        orElse: () => null,
      );

      if (businessJson != null && businessJson.containsKey('branches')) {
        final List<dynamic> branchesJson = businessJson['branches'];
        for (final json in branchesJson) {
          final branch = Branch.fromMap(Map<String, dynamic>.from(json));
          branchesById[branch.id] = branch;
        }
      }
    }
  }

  // Merge Brick/SQLite branches over user_access so fields like isDefault stay
  // current after Supabase updates (user_access is only refreshed at login).
  try {
    final localBranches = await Repository().get<Branch>(
      query: Query(where: [Where('businessId').isExactly(businessId)]),
      policy: OfflineFirstGetPolicy.localOnly,
    );
    for (final branch in localBranches) {
      branchesById[branch.id] = branch;
    }
  } catch (_) {
    // Local read is best-effort.
  }

  return branchesById.values.toList();
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
