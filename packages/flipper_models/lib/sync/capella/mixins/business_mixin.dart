import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaBusinessMixin implements BusinessInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Branch> activeBranch() async {
    throw UnimplementedError('activeBranch needs to be implemented for Capella');
  }

  @override
  Future<Business?> activeBusiness({int? userId}) async {
    throw UnimplementedError('activeBusiness needs to be implemented for Capella');
  }

  @override
  Future<Category?> activeCategory({required int branchId}) async {
    throw UnimplementedError('activeCategory needs to be implemented for Capella');
  }

  @override
  Future<Business?> getBusinessById({required int businessId}) async {
    throw UnimplementedError('getBusinessById needs to be implemented for Capella');
  }
}
