import 'package:flipper_models/realm_model_export.dart';

abstract class CategoryInterface {
  Future<List<Category>> categories({required int branchId});
  Future<Category> category({required String id});
  Stream<List<Category>> categoryStream();
}
