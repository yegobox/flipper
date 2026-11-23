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

/// The active branch's categories, live.
///
/// Kept alive: opening the Ditto observer behind it is a synchronous call on
/// the UI thread that blocks while Ditto is busy syncing. As an auto-dispose
/// provider it reopened every time a screen that lists categories opened (the
/// product editor, Cash Book, pickers), so each open risked a freeze. Now it
/// opens once per branch; a branch switch rebuilds it through
/// [activeBranchProvider], which cancels the old observer.
@riverpod
Stream<List<Category>> category(Ref ref) {
  ref.keepAlive();
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
  return ProxyService.getStrategy(
    Strategy.capella,
  ).categoryStream(branchId: branchId);
}
