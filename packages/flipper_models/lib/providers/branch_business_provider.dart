import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branch_business_provider.g.dart';

@riverpod
Future<List<Branch>> branches(
  Ref ref, {
  String? businessId,
}) async {
  if (businessId == null) return [];

  final userId = ProxyService.box.getUserId();
  if (userId == null) return [];

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
