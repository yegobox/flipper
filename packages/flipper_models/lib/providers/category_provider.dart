import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'active_branch_provider.dart';

import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/models/all_models.dart';
part 'category_provider.g.dart';

/// After updating focus flags, [categoryProvider]'s underlying stream can
/// emit slightly later; set this synchronously when the user confirms a category so UI
/// (e.g. cashbook Row) reflects the selection immediately. Cleared when the stream matches.
@Riverpod(keepAlive: true)
class OptimisticFocusedCategory extends _$OptimisticFocusedCategory {
  @override
  Category? build() => null;

  void setFocused(Category category) => state = category;

  void clear() => state = null;
}

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

/// Ditto-backed category list (Capella). Prefer for screens that should not rely on the
/// default Brick cloudSync category subscription on native.
@riverpod
Stream<List<Category>> capellaCategories(Ref ref, {required String branchId}) {
  return ProxyService.getStrategy(Strategy.capella).categoryStream(
    branchId: branchId,
  );
}
