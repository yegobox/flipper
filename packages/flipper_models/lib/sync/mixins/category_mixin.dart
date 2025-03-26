import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/sync/interfaces/category_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:supabase_models/brick/repository.dart';

mixin CategoryMixin implements CategoryInterface {
  Repository get repository;

  @override
  Future<List<Category>> categories({required int branchId}) {
    return repository.get<Category>(
        query: Query(where: [Where('branchId').isExactly(branchId)]));
  }

  @override
  Stream<List<Category>> categoryStream() {
    final branchId = ProxyService.box.getBranchId()!;
    return repository.subscribe<Category>(
        query: Query(where: [Where('branchId').isExactly(branchId)]));
  }
}
