import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/category_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:brick_offline_first/brick_offline_first.dart';

mixin CategoryMixin implements CategoryInterface {
  Repository get repository;

  @override
  Future<List<Category>> categories({required String branchId}) {
    return repository.get<Category>(
        query: Query(where: [Where('branchId').isExactly(branchId)]));
  }

  @override
  Stream<List<Category>> categoryStream({String? branchId}) {
    final id = branchId ?? ProxyService.box.getBranchId()!;
    return repository.subscribe<Category>(
        policy: OfflineFirstGetPolicy.localOnly,
        query: Query(where: [Where('branchId').isExactly(id)]));
  }

  @override
  Future<Category?> category({required String id}) async {
    return (await repository.get<Category>(
            query: Query(where: [Where('id').isExactly(id)])))
        .firstOrNull;
  }

  @override
  Future<void> addCategory(
      {required String name,
      required String branchId,
      required bool active,
      required bool focused,
      required DateTime lastTouched,
      String? id,
      required DateTime createdAt,
      required dynamic deletedAt}) async {
    final category = await repository.get<Category>(
        query: Query(where: [
          Where('name').isExactly(name),
          Where('branchId').isExactly(branchId),
        ]),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);
    if (category.firstOrNull == null) {
      await repository.upsert<Category>(Category(
        focused: focused,
        name: name,
        active: active,
        branchId: branchId,
        lastTouched: lastTouched,
        deletedAt: deletedAt,
      ));
    }
  }

  @override
  Future<Category> ensureUncategorizedCategory(
      {required String branchId}) async {
    final existing = await repository.get<Category>(
        query: Query(where: [
          Where('name').isExactly("UnCategorized"),
          Where('branchId').isExactly(branchId),
        ]),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist);

    if (existing.isNotEmpty) {
      return existing.first;
    }

    final newCategory = Category(
      name: "UnCategorized",
      branchId: branchId,
      focused: false,
      active: true,
      lastTouched: DateTime.now().toUtc(),
    );

    await repository.upsert<Category>(newCategory);
    return newCategory;
  }
}
