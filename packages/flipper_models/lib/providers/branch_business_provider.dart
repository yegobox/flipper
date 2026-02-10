import 'package:flipper_models/secrets.dart';
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

  // this refresh the user access from time to time to have fresh business and branches a user
  // is allowed to access
  ProxyService.strategy.sendLoginRequest(
    ProxyService.box.getUserPhone()!.replaceAll("+", ""),
    ProxyService.http,
    AppSecrets.apihubProdDomain,
  );

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
