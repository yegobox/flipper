import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'dart:typed_data';
// import 'package:flipper_models/power_sync/schema.dart';
import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/sync/models/transaction_with_items.dart';
import 'package:flipper_models/view_models/purchase_report_item.dart';
import 'package:flutter/src/material/date.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
// import 'package:supabase_flutter/supabase_flutter.dart' as superUser;
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/Booting.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'package:supabase_models/brick/models/log.model.dart';
import 'package:supabase_models/brick/models/sars.model.dart';
import 'package:supabase_models/brick/models/user.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_services/constants.dart';
// import 'package:flipper_services/proxy.dart';
import 'package:http/http.dart' as http;
// import 'package:cbl/cbl.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:flipper_services/ai_strategy_impl.dart';
// import 'package:flipper_services/database_provider.dart'
//     if (dart.library.html) 'DatabaseProvider.dart';

// ignore: unused_import
import 'package:flipper_services/replicator_provider.dart'
    if (dart.library.html) 'DatabaseProvider.dart';

// import 'package:cbl/cbl.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

class Capella extends AiStrategyImpl
    with Booting
    implements DatabaseSyncInterface {
  @override
  // ignore: override_on_non_overriding_member
  bool offlineLogin = false;

  Capella();

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  // late String apihub;
  // late String commApi;

  // TODO: implement countersCollection
  // Future<AsyncCollection> getCountersCollection() async {
  //   final database = capella!.database!;
  //   final collection = await database.collection(countersTable, scope);

  //   return collection ?? await database.createCollection(countersTable, scope);
  // }

  // // get configurations collection
  // Future<AsyncCollection> getConfigurationsCollection() async {
  //   final database = capella!.database!;
  //   final collection = await database.collection(configurationsTable, scope);

  //   return collection ??
  //       await database.createCollection(configurationsTable, scope);
  // }

  void _setApiEndpoints() {
    // if (foundation.kDebugMode) {
    //   apihub = AppSecrets.coreApi;
    //   commApi = AppSecrets.commApi;
    // } else {
    //   apihub = AppSecrets.apihubProd;
    //   commApi = AppSecrets.commApi;
    // }
  }

  @override
  Future<void> initCollections() async {
    _setApiEndpoints();

    /// create databse indexes
    // final collection = await capella?.database!.defaultCollection;
    /// end of creation of indexes
    // final config = ValueIndexConfiguration(['branchId', 'receiptType']);
    // await collection!.createIndex('branchIdReceiptType', config);
    // branchCollection =
    //     await capella?.database!.createCollection(branchesTable, scope);

    // businessCollection =
    //     await capella?.database?.createCollection(businessesTable, scope);

    // accessCollection =
    //     await capella?.database!.createCollection(accessesTable, scope);

    // await capella?.database!.createCollection(countersTable, scope);

    // init replicator
  }

  // @override
  // Future<CoreDataInterface> configureCapella(
  //     {required bool useInMemory, required LocalStorage box}) async {
  //   talker.warning("The real implementation of capella called");

  //   capella = await (await DatabaseProvider(
  //           encryptionKey: ProxyService.box.encryptionKey().toStringList())
  //       .initialize());
  //   talker.warning("CapelaDB ${capella?.database}");
  //   await initCollections();
  //   // init replicator for now here, it will be moved into settings later
  //   // await startReplicator();
  //   return this;
  // }

  @override
  Future<void> startReplicator() async {
    // final replicatorProvider = ReplicatorProvider(databaseProvider: capella!);
    // await replicatorProvider.init();
    // await replicatorProvider.startReplicator();
  }

  // Future<void> _suserbaseAuth() async {
  //   try {
  //     // Check if the user already exists
  //     final email = '${ProxyService.box.getBranchId()}@flipper.rw';
  //     final superUser.User? existingUser =
  //         superUser.Supabase.instance.client.auth.currentUser;

  //     if (existingUser == null) {
  //       // User does not exist, proceed to sign up
  //       await superUser.Supabase.instance.client.auth.signUp(
  //         email: email,
  //         password: email,
  //       );
  //       // Handle sign-up response if needed
  //     } else {
  //       // User exists, log them in
  //       await superUser.Supabase.instance.client.auth.signInWithPassword(
  //         email: email,
  //         password: email,
  //       );
  //     }
  //   } catch (e) {}
  // }

  @override
  Future<List<Counter>> getCounters(
      {required int branchId, bool fetchRemote = false}) async {
    throw UnimplementedError();
    // try {
    //   AsyncCollection? collection =
    //       await capella!.database!.collection(countersTable, scope);
    //   if (collection == null) {
    //     collection =
    //         await capella!.database!.createCollection(countersTable, scope);
    //   }

    //   final query = QueryBuilder()
    //       .select(SelectResult.all())
    //       .from(DataSource.collection(collection))
    //       .where(Expression.property('branchId')
    //           .equalTo(Expression.integer(branchId)));

    //   final result = await query.execute();
    //   final results = await result.allResults();

    //   List<Counter> counters = [];

    //   for (var item in results) {
    //     final Map<String, dynamic> json = item.toPlainMap();
    //     talker.warning("Query result: $json");

    //     // Handle both nested and flat JSON structures
    //     final Map<String, dynamic> counterData =
    //         json.containsKey(countersTable) ? json[countersTable] : json;

    //     try {
    //       final counter = Counter.fromJson(counterData);
    //       counters.add(counter);
    //     } catch (e) {
    //       talker.error('Error parsing counter: $e');
    //       // Continue processing other items even if one fails
    //       continue;
    //     }
    //   }

    //   return counters;
    // } catch (e) {
    //   talker.error('Error getting counters: $e');
    //   return [];
    // }
  }

  String get scope => "_default";

  @override
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Message> saveMessage({
    required String text,
    required String phoneNumber,
    required int branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    String? aiContext,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> conversationStream({required String conversationId}) {
    throw UnimplementedError();
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId,
      required String receiptType,
      required bool fetchRemote}) async {
    talker.warning("Using capella");
    throw UnimplementedError();
    // try {
    //   AsyncCollection? collection =
    //       await capella!.database!.collection(countersTable, scope);
    //   if (collection == null) {
    //     collection =
    //         await capella!.database!.createCollection(countersTable, scope);
    //   }

    //   final query = QueryBuilder()
    //       .select(SelectResult.all())
    //       .from(DataSource.collection(collection))
    //       .where(Expression.property('receiptType')
    //           .equalTo(Expression.string(receiptType))
    //           .and(Expression.property('branchId')
    //               .equalTo(Expression.integer(branchId))))
    //       .limit(Expression.integer(1));

    //   final result = await query.execute();
    //   final results = await result.allResults();

    //   if (results.isEmpty) {
    //     return null;
    //   }

    //   final Map<String, dynamic> json = results.first.toPlainMap();
    //   talker.warning("Query result: $json");

    //   final Map<String, dynamic> counterData =
    //       json.containsKey(countersTable) ? json[countersTable] : json;

    //   return Counter.fromJson(counterData);
    // } catch (e) {
    //   talker.error('Error getting counter: $e');
    //   return null;
    // }
  }

  @override
  Future<Configurations?> getByTaxType({required String taxtype}) async {
    throw UnimplementedError();
    // try {
    //   AsyncCollection? collection = await getConfigurationsCollection();
    //   final query = QueryBuilder()
    //       .select(SelectResult.all())
    //       .from(DataSource.collection(collection))
    //       .where(Expression.property('taxType')
    //           .equalTo(Expression.string(taxtype))
    //           .and(Expression.property('branchId').equalTo(
    //               Expression.integer(ProxyService.box.getBranchId()!))))
    //       .limit(Expression.integer(1));

    //   final result = await query.execute();
    //   final results = await result.allResults();

    //   if (results.isNotEmpty) {
    //     final Map<String, dynamic> json = results.first.toPlainMap();
    //     talker.warning("Query result: $json");
    //     return Configurations.fromJson(json);
    //   }
    //   return null;
    // } catch (e) {
    //   rethrow;
    // }
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stream<double> totalSales({required branchId}) {
    // TODO: implement soldStockValue
    throw UnimplementedError();
  }

  @override
  Future<void> spawnIsolate(isolateHandler) {
    // TODO: implement spawnIsolate
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName,
      {required String transactionId}) {
    // TODO: implement uploadPdfToS3
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Future<Branch> activeBranch() {
    // TODO: implement activeBranch
    throw UnimplementedError();
  }

  @override
  Future<int> addFavorite({required Favorite data}) {
    // TODO: implement addFavorite
    throw UnimplementedError();
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) {
    // TODO: implement addUnits
    throw UnimplementedError();
  }

  @override
  Future<int> addVariant(
      {required List<Variant> variations, required int branchId}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future<void> amplifyLogout() {
    // TODO: implement amplifyLogout
    throw UnimplementedError();
  }

  @override
  void assignCustomerToTransaction(
      {required String customerId, String? transactionId}) {
    // TODO: implement assignCustomerToTransaction
  }

  @override
  Stream<Tenant?> authState({required int branchId}) {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<bool> bindProduct(
      {required String productId, required String tenantId}) {
    // TODO: implement bindProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({int? businessId, bool? active = false}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<List<extensions.BusinessType>> businessTypes() {
    // TODO: implement businessTypes
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> categories({required int branchId}) {
    // TODO: implement categories
    throw UnimplementedError();
  }

  @override
  Stream<List<Category>> categoryStream() {
    // TODO: implement categoryStream
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Branch? defaultBranch() {
    // TODO: implement defaultBranch
    throw UnimplementedError();
  }

  @override
  Future<Business?> defaultBusiness() {
    // TODO: implement defaultBusiness
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBranch(
      {required int branchId, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement deleteBranch
    throw UnimplementedError();
  }

  @override
  Future<int> deleteFavoriteByIndex({required String favIndex}) {
    // TODO: implement deleteFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  void deleteItemFromCart(
      {required TransactionItem transactionItemId, String? transactionId}) {
    // TODO: implement deleteItemFromCart
  }

  @override
  Future<int> deleteTransactionByIndex({required String transactionIndex}) {
    // TODO: implement deleteTransactionByIndex
    throw UnimplementedError();
  }

  @override
  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath}) {
    // TODO: implement downloadAsset
    throw UnimplementedError();
  }

  @override
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"}) {
    // TODO: implement downloadAssetSave
    throw UnimplementedError();
  }

  @override
  Future<Product?> findProductByTenantId({required String tenantId}) {
    // TODO: implement findProductByTenantId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId(
      {required String productId}) {
    // TODO: implement geVariantStreamByProductId
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement getBusinessFromOnlineGivenId
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required String id}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getCustomVariant(
      {required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId}) {
    // TODO: implement getCustomVariant
    throw UnimplementedError();
  }

  @override
  Stream<Tenant?> getDefaultTenant({required int businessId}) {
    // TODO: implement getDefaultTenant
    throw UnimplementedError();
  }

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) {
    // TODO: implement getDevice
    throw UnimplementedError();
  }

  @override
  Future<Device?> getDeviceById({required int id}) {
    // TODO: implement getDeviceById
    throw UnimplementedError();
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) {
    // TODO: implement getDevices
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteById({required String favId}) {
    // TODO: implement getFavoriteById
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) {
    // TODO: implement getFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    // TODO: implement getFavoriteByIndexStream
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) {
    // TODO: implement getFavoriteByProdId
    throw UnimplementedError();
  }

  @override
  Future<List<Favorite>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<String> getFirebaseToken() {
    // TODO: implement getIdToken
    throw UnimplementedError();
  }

  @override
  Future<models.Plan?> getPaymentPlan(
      {required String businessId, bool fetchRemote = false}) {
    // TODO: implement getPaymentPlan
    throw UnimplementedError();
  }

  @override
  Future<extensions.IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement getPin
    throw UnimplementedError();
  }

  @override
  Pin? getPinLocal(
      {int? userId, required bool alwaysHydrate, String? phoneNumber}) {
    // TODO: implement getPinLocal
    throw UnimplementedError();
  }

  @override
  Future<String?> getPlatformDeviceId() {
    // TODO: implement getPlatformDeviceId
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) {
    // TODO: implement getReceipt
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Stream<double> wholeStockValue({required int branchId}) {
    // TODO: implement getStockValue
    throw UnimplementedError();
  }

  @override
  Tenant getTenant({int? userId, int? pin}) {
    // TODO: implement getTenant
    throw UnimplementedError();
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) {
    // TODO: implement getTransactionsAmountsSum
    throw UnimplementedError();
  }

  @override
  Future<bool> hasActiveSubscription(
      {required String businessId,
      required bool fetchRemote,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement hasActiveSubscription
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> isAdmin({required int userId, required String appFeature}) {
    // TODO: implement isAdmin
    throw UnimplementedError();
  }

  @override
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  @override
  Future<extensions.IUser> login(
      {required String userPhone,
      IUser? existingUser,
      required bool isInSignUpProgress,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> productStreams({String? prodIndex}) {
    // TODO: implement productStreams
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> products({required int branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) {
    // TODO: implement productsFuture
    throw UnimplementedError();
  }

  @override
  Future<void> reDownloadAsset() {
    // TODO: implement reDownloadAsset
    throw UnimplementedError();
  }

  @override
  Future<void> refreshSession({required int branchId, int? refreshRate = 5}) {
    // TODO: implement refreshSession
    throw UnimplementedError();
  }

  @override
  Future<void> refund({required int itemId}) {
    // TODO: implement refund
    throw UnimplementedError();
  }

  @override
  Future<bool> removeS3File({required String fileName}) {
    // TODO: implement removeS3File
    throw UnimplementedError();
  }

  @override
  Report report({required int id}) {
    // TODO: implement report
    throw UnimplementedError();
  }

  @override
  Stream<List<Report>> reports({required int branchId}) {
    // TODO: implement reports
    throw UnimplementedError();
  }

  @override
  Future<List<InventoryRequest>> requests({int? branchId, String? requestId}) {
    // TODO: implement requests
    throw UnimplementedError();
  }

  @override
  Stream<List<InventoryRequest>> requestsStream(
      {required int branchId,
      String filter = RequestStatus.pending,
      String? search}) {
    // TODO: implement requestsStream
    throw UnimplementedError();
  }

  @override
  void saveComposite({required Composite composite}) {
    // TODO: implement saveComposite
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<Plan> saveOrUpdatePaymentPlan(
      {required String businessId,
      int numberOfPayments = 1,
      required String selectedPlan,
      List<String>? addons,
      required int additionalDevices,
      required bool isYearlyPlan,
      required double totalPrice,
      // required String payStackUserId,
      required String paymentMethod,
      String? customerCode,
      models.Plan? plan,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement saveOrUpdatePaymentPlan
    throw UnimplementedError();
  }

  @override
  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid}) {
    // TODO: implement sendLoginRequest
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessageToIsolate() {
    // TODO: implement sendMessageToIsolate
    throw UnimplementedError();
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Stream<SKU?> sku({required int branchId, required int businessId}) {
    // TODO: implement sku
    throw UnimplementedError();
  }

  @override
  Future<({String customerCode, String url, int userId})> subscribe(
      {required int businessId,
      required Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) {
    // TODO: implement syncUserWithAwsIncognito
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> tenant(
      {int? businessId, int? userId, String? id, required bool fetchRemote}) {
    // TODO: implement tenant
    throw UnimplementedError();
  }

  @override
  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId}) {
    // TODO: implement tenants
    throw UnimplementedError();
  }

  @override
  Future<List<extensions.ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement tenantsFromOnline
    throw UnimplementedError();
  }

  @override
  Future<double> totalStock({String? productId, String? variantId}) {
    // TODO: implement totalStock
    throw UnimplementedError();
  }

  @override
  Future<List<IUnit>> units({required int branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<List<UnversalProduct>> universalProductNames({required int branchId}) {
    // TODO: implement universalProductNames
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addAccess(
      {required int userId,
      required String featureName,
      required String accessLevel,
      required String userType,
      required String status,
      required int branchId,
      required int businessId,
      DateTime? createdAt}) {
    // TODO: implement addAccess
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addAsset(
      {required String productId,
      required assetName,
      required int branchId,
      required int businessId}) {
    // TODO: implement addAsset
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addCategory(
      {required String name,
      required int branchId,
      required bool active,
      required bool focused,
      required DateTime lastTouched,
      String? id,
      required DateTime createdAt,
      required deletedAt}) {
    // TODO: implement addCategory
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addColor({required String name, required int branchId}) {
    // TODO: implement addColor
    throw UnimplementedError();
  }

  @override
  FutureOr<void> deleteAll<T extends Object>({required String tableName}) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<extensions.SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateAcess(
      {required int userId,
      String? featureName,
      String? status,
      String? accessLevel,
      String? userType}) {
    // TODO: implement updateAcess
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateAsset({required String assetId, String? assetName}) {
    // TODO: implement updateAsset
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateBranch(
      {required int branchId, String? name, bool? active, bool? isDefault}) {
    // TODO: implement updateBranch
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateCategory(
      {required String categoryId,
      String? name,
      bool? active,
      bool? focused,
      int? branchId}) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateColor(
      {required String colorId, String? name, bool? active}) {
    // TODO: implement updateColor
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateNotification(
      {required String notificationId, bool? completed}) {
    // TODO: implement updateNotification
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updatePin(
      {required int userId, String? phoneNumber, String? tokenUid}) {
    // TODO: implement updatePin
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateReport({required String reportId, bool? downloaded}) {
    // TODO: implement updateReport
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateStockRequest(
      {required String stockRequestId, DateTime? updatedAt, String? status}) {
    // TODO: implement updateStockRequest
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateTransactionItem(
      {double? qty,
      required String transactionItemId,
      double? discount,
      bool? active,
      double? taxAmt,
      bool ignoreForReport = false,
      int? quantityApproved,
      int? quantityRequested,
      bool? ebmSynced,
      bool? isRefunded,
      bool? incrementQty,
      double? price,
      double? prc,
      double? splyAmt,
      bool? doneWithTransaction,
      int? quantityShipped,
      double? taxblAmt,
      double? totAmt,
      double? dcRt,
      double? dcAmt}) {
    // TODO: implement updateTransactionItem
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateUnit(
      {required String unitId, String? name, bool? active, int? branchId}) {
    // TODO: implement updateUnit
    throw UnimplementedError();
  }

  @override
  FutureOr<Variant> addStockToVariant(
      {required Variant variant, Stock? stock}) {
    // TODO: implement addStockToVariant
    throw UnimplementedError();
  }

  @override
  FutureOr<Branch?> branch({required int serverId}) {
    // TODO: implement branch
    throw UnimplementedError();
  }

  @override
  Future<DatabaseSyncInterface> configureCapella(
      {required bool useInMemory, required LocalStorage box}) async {
    return this as DatabaseSyncInterface;
  }

  @override
  Future<DatabaseSyncInterface> configureLocal(
      {required bool useInMemory, required LocalStorage box}) async {
    return this as DatabaseSyncInterface;
  }

  @override
  Future<void> configureSystem(String userPhone, extensions.IUser user,
      {required bool offlineLogin}) {
    // TODO: implement configureSystem
    throw UnimplementedError();
  }

  @override
  FutureOr<T?> create<T>({required T data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required DateTime whenCreated,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter,
      required String timeReceivedFromserver,
      required int invoiceNumber}) {
    // TODO: implement createReceipt
    throw UnimplementedError();
  }

  @override
  Future<bool> firebaseLogin({String? token}) {
    // TODO: implement firebaseLogin
    throw UnimplementedError();
  }

  @override
  FutureOr<Assets?> getAsset({String? assetName, String? productId}) {
    // TODO: implement getAsset
    throw UnimplementedError();
  }

  @override
  FutureOr<Business> getBusiness({int? businessId}) {
    // TODO: implement getBusiness
    throw UnimplementedError();
  }

  @override
  FutureOr<Business?> getBusinessById({required int businessId}) {
    // TODO: implement getBusinessById
    throw UnimplementedError();
  }

  @override
  FutureOr<FlipperSaleCompaign?> getLatestCompaign() {
    // TODO: implement getLatestCompaign
    throw UnimplementedError();
  }

  @override
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required String transactionId}) {
    // TODO: implement getPaymentType
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId}) {
    // TODO: implement manageCashInOutTransaction
    throw UnimplementedError();
  }

  @override
  Stream<ITransaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool includeSubTotalCheck = false}) {
    // TODO: implement manageTransactionStream
    throw UnimplementedError();
  }

  @override
  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction}) {
    // TODO: implement removeCustomerFromTransaction
  }

  @override
  Future<Configurations> saveTax(
      {required String configId, required double taxPercentage}) {
    // TODO: implement saveTax
    throw UnimplementedError();
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) {
    // TODO: implement taxes
    throw UnimplementedError();
  }

  @override
  Future<void> updateStock(
      {required String stockId,
      double? qty,
      double? rsdQty,
      double? initialStock,
      bool? ebmSynced,
      bool appending = false,
      double? currentStock,
      double? value,
      DateTime? lastTouched}) {
    // TODO: implement updateStock
    throw UnimplementedError();
  }

  @override
  Future<bool> flipperDelete(
      {required String id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItem(
      {required String variantId, String? transactionId}) {
    // TODO: implement getTransactionItemByVariantId
    throw UnimplementedError();
  }

  @override
  DatabaseSyncInterface instance() {
    // TODO: implement instance
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<bool> isTaxEnabled({required int businessId}) {
    // TODO: implement isTaxEnabled
    throw UnimplementedError();
  }

  @override
  Future<void> saveEbm(
      {required int branchId,
      required String severUrl,
      required String bhFId,
      bool vatEnabled = false}) {
    // TODO: implement saveEbm
    throw UnimplementedError();
  }

  @override
  FutureOr<void> savePaymentType(
      {TransactionPaymentRecord? paymentRecord,
      String? transactionId,
      double amount = 0.0,
      String? paymentMethod,
      required bool singlePaymentOnly}) {
    // TODO: implement savePaymentType
    throw UnimplementedError();
  }

  @override
  Future<Pin?> savePin({required Pin pin}) {
    // TODO: implement savePin
    throw UnimplementedError();
  }

  @override
  List<TransactionItem> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    String? branchId,
    String? id,
    String? variantId,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
    bool forceRealData = true,
  }) {
    // TODO: implement transactionItems
    throw UnimplementedError();
  }

  @override
  FutureOr<brick.LPermission?> permission({required int userId}) {
    // TODO: implement permission
    throw UnimplementedError();
  }

  @override
  FutureOr<List<brick.LPermission>> permissions({required int userId}) {
    // TODO: implement permissions
    throw UnimplementedError();
  }

  @override
  void updateAccess(
      {required String accessId,
      required int userId,
      required String featureName,
      required int branchId,
      required int businessId,
      required String accessLevel,
      required String status,
      required String userType}) {
    // TODO: implement updateAccess
  }

  @override
  void whoAmI() {
    print("I am capella");
  }

  @override
  Future<brick.Tenant?> addNewTenant(
      {required brick.Business business,
      required brick.Branch branch,
      String? phoneNumber,
      String? name,
      String? id,
      String? email,
      int? businessId,
      bool? sessionActive,
      int? branchId,
      String? imageUrl,
      int? pin,
      bool? isDefault,
      required HttpClientInterface flipperHttpClient,
      required String userType}) {
    // TODO: implement saveTenant
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Access>> access(
      {required int userId, String? featureName, required bool fetchRemote}) {
    // TODO: implement access
    throw UnimplementedError();
  }

  @override
  FutureOr<brick.Branch> addBranch(
      {required String name,
      required int businessId,
      required String location,
      String? userOwnerPhoneNumber,
      HttpClientInterface? flipperHttpClient,
      int? serverId,
      String? description,
      String? longitude,
      String? latitude,
      required bool isDefault,
      required bool active,
      DateTime? lastTouched,
      DateTime? deletedAt,
      int? id}) {
    // TODO: implement addBranch
    throw UnimplementedError();
  }

  @override
  void notify({required brick.AppNotification notification}) {
    // TODO: implement notify
  }

 

  @override
  conversations({int? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError();
  }

  @override
  getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Business>> businesses(
      {int? userId, bool fetchOnline = false, bool active = false}) {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  FutureOr<String> itemCode(
      {required String countryCode,
      required String productType,
      required packagingUnit,
      required int branchId,
      required String quantityUnit}) {
    // TODO: implement itemCode
    throw UnimplementedError();
  }

  @override
  Stream<List<brick.ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool forceRealData = true,
      bool isCashOut = false,
      bool includePending = false,
      String? id,
      FilterType? filterType,
      bool removeAdjustmentTransactions = false,
      DateTime? startDate,
      DateTime? endDate}) {
    // TODO: implement transactionsStream
    throw UnimplementedError();
  }

  @override
  FutureOr<brick.SKU> getSku({required int branchId, required int businessId}) {
    // TODO: implement getSku
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Product>> getProducts(
      {String? key, int? prodIndex, required int branchId}) {
    // TODO: implement getProducts
    throw UnimplementedError();
  }

  @override
  Stream<List<brick.TransactionItem>> transactionItemsStreams(
      {String? transactionId,
      String? branchId,
      DateTime? startDate,
      String? branchIdString,
      DateTime? endDate,
      String? requestId,
      bool fetchRemote = false,
      bool forceRealData = true,
      bool? doneWithTransaction,
      bool? active}) {
    // TODO: implement transactionItemsStreams
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateVariant(
      {required List<brick.Variant> updatables,
      String? color,
      String? taxTyCd,
      num? approvedQty,
      num? invoiceNumber,
      Purchase? purchase,
      bool updateIo = true,
      double? dcRt,
      String? variantId,
      double? newRetailPrice,
      String? categoryId,
      double? retailPrice,
      double? prc,
      double? dftPrc,
      Map<String, String>? rates,
      double? supplyPrice,
      DateTime? expirationDate,
      Map<String, String>? dates,
      String? selectedProductType,
      String? productId,
      String? productName,
      String? unit,
      String? pkgUnitCd,
      bool? ebmSynced}) {
    // TODO: implement updateVariant
    throw UnimplementedError();
  }

  @override
  FutureOr<List<brick.Customer>> customers(
      {int? branchId, String? key, String? id}) {
    // TODO: implement customers
    throw UnimplementedError();
  }

  @override
  Future<brick.Customer?> addCustomer(
      {required brick.Customer customer, String? transactionId}) {
    // TODO: implement addCustomer
    throw UnimplementedError();
  }

  @override
  Future<List<brick.ITransaction>> transactions(
      {DateTime? startDate,
      DateTime? endDate,
      String? status,
      bool forceRealData = true,
      String? transactionType,
      bool isCashOut = false,
      String? id,
      bool fetchRemote = false,
      bool isExpense = false,
      FilterType? filterType,
      int? branchId,
      bool includeZeroSubTotal = false,
      bool skipOriginalTransactionCheck = false,
      bool includePending = false}) {
    // TODO: implement transactions
    throw UnimplementedError();
  }

  @override
  Future<brick.Business?> activeBusiness({int? userId}) {
    // TODO: implement activeBusiness
    throw UnimplementedError();
  }

  @override
  FutureOr<List<brick.Composite>> composites(
      {String? productId, String? variantId}) {
    // TODO: implement composites
    throw UnimplementedError();
  }

  @override
  Future<void> createOrUpdateBranchOnCloud(
      {required brick.Branch branch, required bool isOnline}) {
    // TODO: implement createOrUpdateBranchOnCloud
    throw UnimplementedError();
  }

  @override
  Future<void> createNewStock(
      {required brick.Variant variant,
      required brick.TransactionItem item,
      required int subBranchId}) {
    // TODO: implement createNewStock
    throw UnimplementedError();
  }

  @override
  Stream<List<brick.Customer>> customersStream(
      {required int branchId, String? key, String? id}) {
    // TODO: implement customersStream
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addTransaction({required brick.ITransaction transaction}) {
    // TODO: implement addTransaction
    throw UnimplementedError();
  }

  @override
  void clearData({required ClearData data, required int identifier}) {
    // TODO: implement clearData
  }

  @override
  Future<brick.Stock> getStockById({required String id}) {
    // TODO: implement getStockById
    throw UnimplementedError();
  }

  @override
  Future<brick.Variant> createVariant(
      {required String barCode,
      required int sku,
      required String productId,
      required int branchId,
      required double retailPrice,
      required double supplierPrice,
      required double qty,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      required String color,
      required int tinNumber,
      required int itemSeq,
      required String name,
      brick.Configurations? taxType}) {
    // TODO: implement createVariant
    throw UnimplementedError();
  }

  @override
  Future<void> processItem(
      {required brick.Variant item,
      required Map<String, String> quantitis,
      required Map<String, String> taxTypes,
      required Map<String, String> itemClasses,
      required Map<String, String> itemTypes}) {
    // TODO: implement processItem
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Variant>> selectImportItems({
    required int tin,
    required String bhfId,
  }) {
    // TODO: implement selectImportItems
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> isBranchEnableForPayment(
      {required String currentBranchId, bool fetchRemote = false}) {
    // TODO: implement isBranchEnableForPayment
    throw UnimplementedError();
  }

  @override
  FutureOr<void> setBranchPaymentStatus(
      {required String currentBranchId, required bool status}) {
    // TODO: implement setBranchPaymentStatus
    throw UnimplementedError();
  }

  @override
  Future<void> deletePaymentById(String id) {
    // TODO: implement deletePaymentById
    throw UnimplementedError();
  }

  @override
  Future<List<brick.CustomerPayments>> getAllPayments() {
    // TODO: implement getAllPayments
    throw UnimplementedError();
  }

  @override
  Future<brick.CustomerPayments?> getPaymentById(String id) {
    // TODO: implement getPaymentById
    throw UnimplementedError();
  }

  @override
  Future<brick.CustomerPayments> upsertPayment(brick.CustomerPayments payment) {
    // TODO: implement upsertPayment
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Country>> countries() {
    // TODO: implement countries
    throw UnimplementedError();
  }

  @override
  Future<brick.Variant?> getVariant(
      {String? id,
      String? modrId,
      String? name,
      String? itemClsCd,
      String? itemNm,
      String? stockId,
      String? itemCd,
      String? taskCd,
      String? bcd,
      String? productId}) {
    // TODO: implement getVariantById
    throw UnimplementedError();
  }

  @override
  Future<void> addTransactionItem(
      {brick.ITransaction? transaction,
      required bool partOfComposite,
      required DateTime lastTouched,
      required double discount,
      double? compositePrice,
      required double quantity,
      required bool ignoreForReport,
      bool? doneWithTransaction,
      required double currentStock,
      brick.Variant? variation,
      required double amountTotal,
      required String name,
      brick.TransactionItem? item}) {
    // TODO: implement addTransactionItem
    throw UnimplementedError();
  }

  @override
  Future<double> fetchCost(int branchId) {
    // TODO: implement fetchCost
    throw UnimplementedError();
  }

  @override
  Future<double> fetchProfit(int branchId) {
    // TODO: implement fetchProfit
    throw UnimplementedError();
  }

  @override
  Future<List<brick.BusinessAnalytic>> analytics({required int branchId}) {
    // TODO: implement analytics
    throw UnimplementedError();
  }

  @override
  FutureOr<List<brick.Stock>> stocks({required int branchId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  FutureOr<brick.Purchase?> getPurchase({required String id}) {
    // TODO: implement getPurchase
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Variant>> variants({
    required int branchId,
    String? productId,
    int? page,
    List<String>? taxTyCds,
    bool? stockSynchronized,
    String? variantId,
    bool forImportScreen = false,
    String? name,
    String? pchsSttsCd,
    String? bcd,
    String? purchaseId,
    int? itemsPerPage,
    String? imptItemSttsCd,
    bool forPurchaseScreen = false,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    bool fetchRemote = false,
  }) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Purchase>> selectPurchases({
    required String bhfId,
    required int tin,
    required String url,
    String? pchsSttsCd,
  }) {
    // TODO: implement selectPurchases
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFailedQueue() {
    // TODO: implement deleteFailedQueue
    throw UnimplementedError();
  }

  @override
  Future<int> queueLength() {
    // TODO: implement queueLength
    throw UnimplementedError();
  }

  @override
  Future<List<brick.FinanceProvider>> financeProviders() {
    // TODO: implement financeProviders
    throw UnimplementedError();
  }

  @override
  Future<brick.BusinessInfo> initializeEbm(
      {required String tin, required String bhfId, required String dvcSrlNo}) {
    // TODO: implement initializeEbm
    throw UnimplementedError();
  }

  @override
  Future<brick.VariantBranch?> variantBranch(
      {required String variantId, required String destinationBranchId}) {
    // TODO: implement variantBranch
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Purchase>> purchases() {
    // TODO: implement purchases
    throw UnimplementedError();
  }

  @override
  Future<void> saveVariant(
      brick.Variant item, brick.Business business, int branchId) {
    // TODO: implement saveVariant
    throw UnimplementedError();
  }

  @override
  Future<brick.Category?> activeCategory({required int branchId}) {
    // TODO: implement activeCategory
    throw UnimplementedError();
  }

  @override
  Future<void> markItemAsDoneWithTransaction(
      {required List<brick.TransactionItem> inactiveItems,
      required brick.ITransaction pendingTransaction,
      bool ignoreForReport = false,
      bool isDoneWithTransaction = false}) {
    // TODO: implement markItemAsDoneWithTransaction
    throw UnimplementedError();
  }

  @override
  Future<bool> saveTransactionItem(
      {double? compositePrice,
      double? updatableQty,
      bool ignoreForReport = false,
      required brick.Variant variation,
      required double amountTotal,
      required bool doneWithTransaction,
      required bool customItem,
      required brick.ITransaction pendingTransaction,
      required double currentStock,
      bool useTransactionItemForQty = false,
      required bool partOfComposite,
      brick.TransactionItem? item,
      int? invoiceNumber,
      String? sarTyCd}) {
    // TODO: implement saveTransaction
    throw UnimplementedError();
  }

  @override
  Future<brick.ITransaction?> manageTransaction(
      {required String transactionType,
      String status = PENDING,
      required bool isExpense,
      String? shiftId,
      required int branchId,
      bool includeSubTotalCheck = false}) {
    // TODO: implement manageTransaction
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateTransaction(
      {brick.ITransaction? transaction,
      String? receiptType,
      double? subTotal,
      String? note,
      num taxAmount = 0.0,
      String? status,
      String? customerId,
      bool? ebmSynced,
      String? sarTyCd,
      String? reference,
      String? customerTin,
      String? customerBhfId,
      double? cashReceived,
      bool? isRefunded,
      String? customerName,
      String? ticketName,
      DateTime? updatedAt,
      int? invoiceNumber,
      DateTime? lastTouched,
      int? supplierId,
      int? receiptNumber,
      int? totalReceiptNumber,
      bool? isProformaMode,
      String? sarNo,
      String? orgSarNo,
      bool isUnclassfied = false,
      String? transactionId,
      bool? isTrainingMode}) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

  @override
  Future<brick.Product?> createProduct(
      {required brick.Product product,
      required int businessId,
      required int branchId,
      double? splyAmt,
      String? taxTyCd,
      required int tinNumber,
      required String bhFId,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      String? modrId,
      String? orgnNatCd,
      String? exptNatCd,
      int? pkg,
      String? pkgUnitCd,
      String? qtyUnitCd,
      int? totWt,
      int? netWt,
      String? spplrNm,
      String? agntNm,
      int? invcFcurAmt,
      String? invcFcurCd,
      double? invcFcurExcrt,
      String? dclNo,
      String? taskCd,
      String? dclDe,
      String? hsCd,
      String? imptItemsttsCd,
      String? spplrItemClsCd,
      String? spplrItemCd,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      required bool createItemCode,
      bool ebmSynced = false,
      String? saleListId,
      brick.Purchase? purchase,
      String? pchsSttsCd,
      double? totAmt,
      double? taxAmt,
      double? taxblAmt,
      String? itemCd}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<brick.Product?> getProduct(
      {String? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateProduct(
      {String? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      required int branchId,
      required int businessId,
      String? imageUrl,
      String? expiryDate,
      String? categoryId}) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  Future<brick.Category> category({required String id}) {
    // TODO: implement category
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> getTransaction(
      {String? sarNo, required int branchId, String? id}) {
    throw UnimplementedError(
        'getTransaction needs to be implemented for Capella');
  }

  @override
  Future<ITransaction> assignTransaction(
      {double? updatableQty,
      required brick.Variant variant,
      required bool doneWithTransaction,
      required brick.ITransaction pendingTransaction,
      required brick.Business business,
      required int randomNumber,
      required String sarTyCd,
      bool useTransactionItemForQty = false,
      brick.TransactionItem? item,
      brick.Purchase? purchase,
      int? invoiceNumber}) {
    // TODO: implement assignTransaction
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Variant>> getExpiredItems(
      {required int branchId, int? daysToExpiry, int? limit}) {
    // TODO: implement getExpiredItems
    throw UnimplementedError();
  }

  @override
  Future<void> addBusiness(
      {required String id,
      required int userId,
      required int serverId,
      required String phoneNumber,
      String? name,
      String? currency,
      String? categoryId,
      String? latitude,
      String? longitude,
      String? timeZone,
      String? country,
      String? businessUrl,
      String? hexColor,
      String? imageUrl,
      String? type,
      bool? active,
      String? chatUid,
      String? metadata,
      String? role,
      int? lastSeen,
      String? firstName,
      String? lastName,
      String? createdAt,
      String? deviceToken,
      bool? backUpEnabled,
      String? subscriptionPlan,
      String? nextBillingDate,
      String? previousBillingDate,
      bool? isLastSubscriptionPaymentSucceeded,
      String? backupFileId,
      String? email,
      String? lastDbBackup,
      String? fullName,
      int? tinNumber,
      required String bhfId,
      String? dvcSrlNo,
      String? adrs,
      bool? taxEnabled,
      String? taxServerUrl,
      bool? isDefault,
      int? businessTypeId,
      DateTime? lastTouched,
      DateTime? deletedAt,
      required String encryptionKey}) {
    // TODO: implement addBusiness
    throw UnimplementedError();
  }

  @override
  Future<void> updateBusiness(
      {required int businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId}) {
    // TODO: implement updateBusiness
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteTransaction({required brick.ITransaction transaction}) {
    // TODO: implement deleteTransaction
    throw UnimplementedError();
  }

  @override
  Future<User?> authUser({required String uuid}) {
    // TODO: implement authUser
    throw UnimplementedError();
  }

  @override
  Future<User> saveUser({required User user}) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }

  @override
  Future<void> createPin(
      {required HttpClientInterface flipperHttpClient,
      required String phoneNumber,
      required int pin,
      required String branchId,
      required String businessId,
      required int defaultApp}) {
    // TODO: implement createPin
    throw UnimplementedError();
  }

  @override
  Future<bool> migrateToNewDateTime({required int branchId}) {
    // TODO: implement migrateToNewDateTime
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Access>> allAccess({required int userId}) {
    // TODO: implement allAccess
    throw UnimplementedError();
  }

  @override
  Future<brick.Ebm?> ebm({required int branchId, bool fetchRemote = false}) {
    // TODO: implement ebm
    throw UnimplementedError();
  }

  @override
  Future<void> hydrateDate({required String branchId}) {
    // TODO: implement hydrateDate
    throw UnimplementedError();
  }

  @override
  Stream<brick.Branch> activeBranchStream() {
    // TODO: implement activeBranchStream
    throw UnimplementedError();
  }

  @override
  Future<void> updateTenant(
      {String? tenantId,
      String? name,
      String? phoneNumber,
      String? email,
      int? userId,
      int? businessId,
      String? type,
      int? id,
      int? pin,
      bool? sessionActive,
      int? branchId}) {
    // TODO: implement updateTenant
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTransactionItemAndResequence({required String id}) {
    // TODO: implement deleteTransactionItemAndResequence
    throw UnimplementedError();
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<http.Response> getUniversalProducts(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement getUniversalProducts
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }

  @override
  Future<void> completeLogin(brick.Pin thePin) {
    // TODO: implement completeLogin
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> handleLoginError(dynamic e, StackTrace s,
      {String? responseChannel}) {
    throw UnimplementedError();
  }

  @override
  Future<int> clearOldLogs({required Duration olderThan, int? businessId}) {
    // TODO: implement clearOldLogs
    throw UnimplementedError();
  }

  @override
  Stream<Credit?> credit({required String branchId}) {
    // TODO: implement credit
    throw UnimplementedError();
  }

  @override
  Future<Credit?> getCredit({required String branchId}) {
    // TODO: implement getCredit
    throw UnimplementedError();
  }

  @override
  Future<List<Log>> getLogs({String? type, int? businessId, int limit = 100}) {
    // TODO: implement getLogs
    throw UnimplementedError();
  }

  @override
  Future<brick.CustomerPayments?> getPayment(
      {required String paymentReference}) {
    // TODO: implement getPayment
    throw UnimplementedError();
  }

  @override
  Future<bool> hasOfflineAssets() {
    // TODO: implement hasOfflineAssets
    throw UnimplementedError();
  }

  @override
  Stream<brick.ITransaction> pendingTransaction(
      {int? branchId,
      required String transactionType,
      bool forceRealData = true,
      required bool isExpense}) {
    // TODO: implement pendingTransaction
    throw UnimplementedError();
  }

  @override
  Future<brick.ITransaction?> pendingTransactionFuture(
      {int? branchId,
      required String transactionType,
      bool forceRealData = true,
      required bool isExpense}) {
    // TODO: implement pendingTransactionFuture
    throw UnimplementedError();
  }

  @override
  Future<brick.Assets> saveImageLocally(
      {required File imageFile,
      required String productId,
      required int branchId,
      required int businessId}) {
    // TODO: implement saveImageLocally
    throw UnimplementedError();
  }

  @override
  Future<void> saveLog(Log log) {
    // TODO: implement saveLog
    throw UnimplementedError();
  }

  @override
  Future<brick.Business?> signup(
      {required Map business, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<void> supabaseAuth() {
    // TODO: implement supabaseAuth
    throw UnimplementedError();
  }

  @override
  Future<List<String>> syncOfflineAssets() {
    // TODO: implement syncOfflineAssets
    throw UnimplementedError();
  }

  @override
  Future<void> updateCredit(Credit credit) {
    // TODO: implement updateCredit
    throw UnimplementedError();
  }

  @override
  Future<void> cleanDuplicatePlans() {
    // TODO: implement cleanDuplicatePlans
    throw UnimplementedError();
  }

  @override
  Future<void> saveBranch(brick.Branch branch) {
    // TODO: implement saveBranch
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Variant>> allImportsToDate() {
    // TODO: implement allImportsToDate
    throw UnimplementedError();
  }

  @override
  Future<List<PurchaseReportItem>> allPurchasesToDate() {
    // TODO: implement allPurchasesToDate
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionWithItems>> transactionsAndItems(
      {DateTime? startDate,
      DateTime? endDate,
      String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool fetchRemote = false,
      String? id,
      bool isExpense = false,
      FilterType? filterType,
      bool includeZeroSubTotal = false,
      bool includePending = false,
      bool skipOriginalTransactionCheck = false}) {
    // TODO: implement transactionsAndItems
    throw UnimplementedError();
  }

  @override
  Future<brick.ITransaction> collectPayment(
      {required double cashReceived,
      brick.ITransaction? transaction,
      required String paymentType,
      required double discount,
      required int branchId,
      required String bhfId,
      required bool isProformaMode,
      required bool isTrainingMode,
      required String transactionType,
      String? categoryId,
      bool directlyHandleReceipt = false,
      required bool isIncome,
      String? customerName,
      String? customerTin,
      String? customerPhone}) {
    // TODO: implement collectPayment
    throw UnimplementedError();
  }

  @override
  Future<brick.Shift> endShift(
      {required String shiftId, required double closingBalance, String? note}) {
    // TODO: implement endShift
    throw UnimplementedError();
  }

  @override
  Future<brick.Shift?> getCurrentShift({required int userId}) {
    // TODO: implement getCurrentShift
    throw UnimplementedError();
  }

  @override
  Stream<List<brick.Shift>> getShifts(
      {required int businessId, DateTimeRange<DateTime>? dateRange}) {
    // TODO: implement getShifts
    throw UnimplementedError();
  }

  @override
  Future<brick.Shift> startShift(
      {required int userId, required double openingBalance, String? note}) {
    // TODO: implement startShift
    throw UnimplementedError();
  }

  @override
  Future<brick.Stock> saveStock(
      {brick.Variant? variant,
      required double rsdQty,
      required String productId,
      required String variantId,
      required int branchId,
      required double currentStock,
      required double value}) {
    // TODO: implement saveStock
    throw UnimplementedError();
  }

  @override
  Future<brick.Shift> updateShiftTotals(
      {required double transactionAmount, required bool isRefund}) {
    // TODO: implement updateShiftTotals
    throw UnimplementedError();
  }

  @override
  Future<String> createStockRequest(List<brick.TransactionItem> items,
      {required int mainBranchId,
      required int subBranchId,
      String? deliveryNote,
      String? orderNote,
      String? financingId}) {
    // TODO: implement createStockRequest
    throw UnimplementedError();
  }

  @override
  Future<Sar?> getSar({required int branchId}) {
    // TODO: implement getSar
    throw UnimplementedError();
  }
  
  @override
  Future<void> updateCounters({required List<brick.Counter> counters, RwApiResponse? receiptSignature}) {
    // TODO: implement updateCounters
    throw UnimplementedError();
  }
}
