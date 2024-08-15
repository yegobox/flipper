import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:realm/realm.dart';
import 'package:http/http.dart' as http;

enum ClearData { Business, Branch }

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
      bool stopAfterConfigure = false,
      required HttpClientInterface flipperHttpClient});

  /// since when we log in we get all business in login response object
  /// it is assumed that this business/branches are for user access
  List<Business> businesses();
  Future<Business?> activeBusinesses({required int userId});
  // Future<Business> getOnlineBusiness({required int userId});
  List<Branch> branches({int? businessId});
  Future<List<ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient});
  Business getBusiness({int? businessId});
  Future<Business> getBusinessFuture({int? businessId});
  Future<Business?> defaultBusiness();
  Branch? defaultBranch();
  Future<Branch> activeBranch();

  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient});
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient});
  Future<List<Business>> getContacts();
  Future<Tenant?> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required HttpClientInterface flipperHttpClient,
      required String userType});
  Future<List<UnversalProduct>> universalProductNames({required int branchId});
  Stream<List<AppNotification>> notificationStream({required int identifier});
  void notify({required AppNotification notification});
  AppNotification notification({required int id});
  Future<Branch> addBranch(
      {required String name,
      required int businessId,
      required String location,
      required String userOwnerPhoneNumber,
      required HttpClientInterface flipperHttpClient});
  Future<void> deleteBranch(
      {required int branchId, required HttpClientInterface flipperHttpClient});
  Branch? branch({required int serverId});

  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub);

  Future<void> configureRemoteRealm(String userPhone, IUser user,
      {Realm? localRealm});

  /// drawers
  bool isDrawerOpen({required int cashierId, required int branchId});
  Future<Drawers?> getDrawer({required int cashierId});

  Drawers? openDrawer({required Drawers drawer});
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport});

  void clearData({required ClearData data});
}
