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
}
