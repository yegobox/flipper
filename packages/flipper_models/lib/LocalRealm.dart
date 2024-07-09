import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:realm/realm.dart';

abstract class LocalRealmInterface {
  Future<LocalRealmInterface> configureLocal({required bool useInMemory});
  Realm? localRealm;
  bool isRealmClosed();
  Future<void> refreshSession({required int branchId, int? refreshRate = 5});
  Future<List<UserActivity>> activities({required int userId});
  // Future<String> dbPath({required String path});
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false});
  Future<List<Business>> businesses({required int userId});
  Future<Business?> activeBusinesses({required int userId});
  Future<Business> getOnlineBusiness({required int userId});
  Future<List<Branch>> branches({int? businessId});
  Future<List<ITenant>> signup({required Map business});
  Business getBusiness({int? businessId});
  Future<Business> getBusinessFuture({int? businessId});
  Future<Business?> defaultBusiness();
  Future<Branch?> defaultBranch();
  Future<Branch> activeBranch();

  Future<List<ITenant>> tenantsFromOnline({required int businessId});
  Future<Business?> getBusinessFromOnlineGivenId({required int id});
  Future<List<Business>> getContacts();
  Future<Tenant> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required String userType});
  Future<List<UnversalProduct>> universalProductNames({required int branchId});
  Stream<List<AppNotification>> notificationStream({required int identifier});
  void notify({required AppNotification notification});
  AppNotification notification({required int id});
}
