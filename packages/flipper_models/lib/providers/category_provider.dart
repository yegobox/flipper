import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'active_branch_provider.dart';

import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
part 'category_provider.g.dart';

@riverpod
Stream<List<Category>> category(Ref ref) {
  final branch = ref.watch(activeBranchProvider).value;
  final branchId = branch?.id ?? ProxyService.box.getBranchId();
  if (branchId == null) return const Stream.empty();
  return ProxyService.strategy.categoryStream(branchId: branchId);
}

@riverpod
Stream<List<Category>> categories(Ref ref, {required String branchId}) {
  return ProxyService.strategy.categoryStream(branchId: branchId);
}
