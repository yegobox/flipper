import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branch_business_provider.g.dart';

@riverpod
Future<List<Branch>> branches(Ref ref, {String? businessId}) async {
  if (businessId == null) return [];

  final userId = ProxyService.box.getUserId();
  if (userId == null) return [];

  // Check if Ditto is ready before calling getUserAccess
  if (!ProxyService.ditto.isReady()) {
    return []; // Return empty list if Ditto not ready yet
  }

  // Read branches from Ditto user_access (populated at login). Permission
  // refreshes use use_access_permissions_realtime / explicit sendLoginRequest.
  final userAccess = await ProxyService.ditto.getUserAccess(userId);
  if (userAccess != null && userAccess.containsKey('businesses')) {
    final List<dynamic> businessesJson = userAccess['businesses'];
    final businessJson = businessesJson.firstWhere(
      (b) => b['id'] == businessId,
      orElse: () => null,
    );

    if (businessJson != null && businessJson.containsKey('branches')) {
      final List<dynamic> branchesJson = businessJson['branches'];
      return branchesJson
          .map((json) => Branch.fromMap(Map<String, dynamic>.from(json)))
          .toList();
    }
  }

  return [];
}
