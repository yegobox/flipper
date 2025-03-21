import 'package:flipper_models/realm_model_export.dart';

abstract class BusinessInterface {
  Future<Branch> activeBranch();
  Future<Business?> activeBusiness({int? userId});
  Future<Category?> activeCategory({required int branchId});
  Future<Business?> getBusinessById({required int businessId});
}
