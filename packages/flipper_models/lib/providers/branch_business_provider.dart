import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_models/brick/models/branch.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'branch_business_provider.g.dart';

@riverpod
Future<List<Branch>> branches(
  Ref ref, {
  int? businessId,
}) async {
  final branches = await ProxyService.strategy.branches(businessId: businessId);
  return branches;
}
