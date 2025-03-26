import 'package:flipper_models/realm_model_export.dart';

abstract class CategoryInterface {
  Future<List<Category>> categories({required int branchId});
  Stream<List<Category>> categoryStream();
}
