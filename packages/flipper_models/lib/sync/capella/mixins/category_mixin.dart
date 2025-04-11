import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/category_interface.dart';
import 'package:supabase_models/brick/repository.dart';

mixin CategoryMixin implements CategoryInterface {
  Repository get repository;

  @override
  Future<List<Category>> categories({required int branchId}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Category>> categoryStream() {
    throw UnimplementedError();
  }

  @override
  Future<Category> category({required String id}) {
    throw UnimplementedError();
  }
}
