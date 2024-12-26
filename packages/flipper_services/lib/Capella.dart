import 'dart:async';
import 'dart:isolate';

import 'dart:typed_data';
import 'package:flipper_models/RealmInterface.dart';
import 'package:flipper_models/power_sync/schema.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;
// import 'package:supabase_flutter/supabase_flutter.dart' as superUser;
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:flipper_models/helper_models.dart' as extensions;
import 'package:flipper_models/Booting.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/constants.dart';
// import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:cbl/cbl.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'DatabaseProvider.dart';

// ignore: unused_import
import 'package:flipper_services/replicator_provider.dart'
    if (dart.library.html) 'DatabaseProvider.dart';

class Capella with Booting implements RealmInterface {
  @override
  DatabaseProvider? capella;
  bool offlineLogin = false;

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  /// define models
  @override
  AsyncCollection? branchCollection;
  @override
  AsyncCollection? businessCollection;
  @override
  AsyncCollection? accessCollection;
  @override
  AsyncCollection? permissionCollection;
  late String apihub;
  late String commApi;

  // TODO: implement countersCollection
  Future<AsyncCollection> getCountersCollection() async {
    final database = capella!.database!;
    final collection = await database.collection(countersTable, scope);

    return collection ?? await database.createCollection(countersTable, scope);
  }

  // get configurations collection
  Future<AsyncCollection> getConfigurationsCollection() async {
    final database = capella!.database!;
    final collection = await database.collection(configurationsTable, scope);

    return collection ??
        await database.createCollection(configurationsTable, scope);
  }

  void _setApiEndpoints() {
    if (foundation.kDebugMode) {
      apihub = AppSecrets.coreApi;
      commApi = AppSecrets.commApi;
    } else {
      apihub = AppSecrets.apihubProd;
      commApi = AppSecrets.commApi;
    }
  }

  @override
  Future<void> initCollections() async {
    _setApiEndpoints();

    /// create databse indexes
    // final collection = await capella?.database!.defaultCollection;
    /// end of creation of indexes
    // final config = ValueIndexConfiguration(['branchId', 'receiptType']);
    // await collection!.createIndex('branchIdReceiptType', config);
    branchCollection =
        await capella?.database!.createCollection(branchesTable, scope);

    businessCollection =
        await capella?.database?.createCollection(businessesTable, scope);

    accessCollection =
        await capella?.database!.createCollection(accessesTable, scope);

    await capella?.database!.createCollection(countersTable, scope);

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
  void consumePoints({required int userId, required int points}) {
    // TODO: implement consumePoints
  }

  @override
  Future<List<Counter>> getCounters({required int branchId}) async {
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
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) async {
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
  Future<List<ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stream<double> soldStockValue({required branchId}) {
    // TODO: implement soldStockValue
    throw UnimplementedError();
  }

  @override
  Future<void> spawnIsolate(isolateHandler) {
    // TODO: implement spawnIsolate
    throw UnimplementedError();
  }

  @override
  Stream<double> stockValue({required branchId}) {
    // TODO: implement stockValue
    throw UnimplementedError();
  }

  @override
  Future<int> updateNonRealm<T>(
      {required T data, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement updateNonRealm
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName) {
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
  Future<Business?> activeBusiness({required int userId}) {
    // TODO: implement activeBusinesses
    throw UnimplementedError();
  }

  @override
  Category? activeCategory({required int branchId}) {
    // TODO: implement activeCategory
    throw UnimplementedError();
  }

  @override
  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId}) {
    // TODO: implement addCustomer
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
      {required int customerId, int? transactionId}) {
    // TODO: implement assignCustomerToTransaction
  }

  @override
  Stream<Tenant?> authState({required int branchId}) {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<bool> bindProduct({required int productId, required int tenantId}) {
    // TODO: implement bindProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false}) {
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
  Future<bool> checkIn({required String? checkInCode}) {
    // TODO: implement checkIn
    throw UnimplementedError();
  }

  @override
  void clear() {
    // TODO: implement clear
  }

  @override
  void clearData({required ClearData data}) {
    // TODO: implement clearData
  }

  @override
  Drawers? closeDrawer({required Drawers drawer, required double eod}) {
    // TODO: implement closeDrawer
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Composite composite({required int variantId}) {
    // TODO: implement composite
    throw UnimplementedError();
  }

  @override
  List<Composite> composites({required int productId}) {
    // TODO: implement composites
    throw UnimplementedError();
  }

  @override
  List<Composite> compositesByVariantId({required int variantId}) {
    // TODO: implement compositesByVariantId
    throw UnimplementedError();
  }

  @override
  void createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId}) {
    // TODO: implement createNewStock
  }

  @override
  void createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline}) {
    // TODO: implement createOrUpdateBranchOnCloud
  }

  @override
  Future<Product?> createProduct(
      {required Product product,
      required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      bool ebmSynced = false}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  int createStockRequest(List<TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required int mainBranchId}) {
    // TODO: implement createStockRequest
    throw UnimplementedError();
  }

  @override
  void createVariant(
      {required String barCode,
      required String sku,
      required int productId,
      required int branchId,
      required double retailPrice,
      required double supplierPrice,
      required double qty,
      required String color,
      required int tinNumber,
      required int itemSeq,
      required String name}) {
    // TODO: implement createVariant
  }

  @override
  List<Customer> customers({required int branchId}) {
    // TODO: implement customers
    throw UnimplementedError();
  }

  @override
  Future<String> dbPath({required String path, int? folder}) {
    // TODO: implement dbPath
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
  Future<void> deleteAllProducts() {
    // TODO: implement deleteAllProducts
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBranch(
      {required int branchId, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement deleteBranch
    throw UnimplementedError();
  }

  @override
  Future<int> deleteFavoriteByIndex({required int favIndex}) {
    // TODO: implement deleteFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  void deleteItemFromCart(
      {required TransactionItem transactionItemId, int? transactionId}) {
    // TODO: implement deleteItemFromCart
  }

  @override
  Future<int> deleteTransactionByIndex({required int transactionIndex}) {
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
  Future<Product?> findProductByTenantId({required int tenantId}) {
    // TODO: implement findProductByTenantId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
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
  Future<PColor?> getColor({required int id}) {
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
  Future<Customer?> getCustomer({String? key, int? id}) {
    // TODO: implement getCustomer
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
  Future<Drawers?> getDrawer({required int cashierId}) {
    // TODO: implement getDrawer
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteById({required int favId}) {
    // TODO: implement getFavoriteById
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required int favIndex}) {
    // TODO: implement getFavoriteByIndex
    throw UnimplementedError();
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex}) {
    // TODO: implement getFavoriteByIndexStream
    throw UnimplementedError();
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required int prodId}) {
    // TODO: implement getFavoriteByProdId
    throw UnimplementedError();
  }

  @override
  Future<List<Favorite>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<String> getIdToken() {
    // TODO: implement getIdToken
    throw UnimplementedError();
  }

  @override
  Future<models.Plan?> getPaymentPlan({required int businessId}) {
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
  Pin? getPinLocal({required int userId}) {
    // TODO: implement getPinLocal
    throw UnimplementedError();
  }

  @override
  Future<String?> getPlatformDeviceId() {
    // TODO: implement getPlatformDeviceId
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) {
    // TODO: implement getReceipt
    throw UnimplementedError();
  }

  @override
  Future<({double grossProfit, double netProfit})> getReportData() {
    // TODO: implement getReportData
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock(
      {required int branchId,
      int? variantId,
      bool nonZeroValue = false,
      int? id}) {
    // TODO: implement getStock
    throw UnimplementedError();
  }

  @override
  Stock? getStockById({required int id}) {
    // TODO: implement getStockById
    throw UnimplementedError();
  }

  @override
  Stream<double> getStockStream(
      {int? productId, int? variantId, required int branchId}) {
    // TODO: implement getStockStream
    throw UnimplementedError();
  }

  @override
  Stream<double> getStockValue({required int branchId}) {
    // TODO: implement getStockValue
    throw UnimplementedError();
  }

  @override
  Tenant getTenant({int? userId, int? pin}) {
    // TODO: implement getTenant
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) {
    // TODO: implement getTransactionItemById
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId}) {
    // TODO: implement getTransactionItemsByTransactionId
    throw UnimplementedError();
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) {
    // TODO: implement getTransactionsAmountsSum
    throw UnimplementedError();
  }

  @override
  Variant? getVariantByProductId({required int productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    // TODO: implement getVariantByProductIdStream
    throw UnimplementedError();
  }

  @override
  List<Variant> getVariants({String? key}) {
    // TODO: implement getVariants
    throw UnimplementedError();
  }

  @override
  Future<bool> hasActiveSubscription(
      {required int businessId,
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
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    // TODO: implement isDrawerOpen
    throw UnimplementedError();
  }

  @override
  bool isRealmClosed() {
    // TODO: implement isRealmClosed
    throw UnimplementedError();
  }

  @override
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId}) {
    // TODO: implement isTokenValid
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required String branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
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
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> markModelForEbmUpdate<T>(
      {required T model, bool updated = true}) {
    // TODO: implement markModelForEbmUpdate
    throw UnimplementedError();
  }

  @override
  Drawers? openDrawer({required Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Stream<Plan?> paymentPlanStream({required int businessId}) {
    // TODO: implement paymentPlanStream
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> productStreams({int? prodIndex}) {
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
  void reDownloadAsset() {
    // TODO: implement reDownloadAsset
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
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password}) {
    // TODO: implement registerOnSocial
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
  List<StockRequest> requests({required int branchId}) {
    // TODO: implement requests
    throw UnimplementedError();
  }

  @override
  Stream<List<StockRequest>> requestsStream(
      {required int branchId, required String filter}) {
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
      {required int businessId,
      int numberOfPayments = 1,
      required String selectedPlan,
      List<String>? addons,
      required int additionalDevices,
      required bool isYearlyPlan,
      required double totalPrice,
      required int payStackUserId,
      required String paymentMethod,
      String? customerCode,
      models.Plan? plan,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement saveOrUpdatePaymentPlan
    throw UnimplementedError();
  }

  @override
  Future<RwApiResponse> selectImportItems(
      {required int tin, required String bhfId, required String lastReqDt}) {
    // TODO: implement selectImportItems
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
  Future<List<Stock>> stocks({required int branchId}) {
    // TODO: implement stocks
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
  Tenant? tenant({int? businessId, int? userId}) {
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
  Future<double> totalStock({int? productId, int? variantId}) {
    // TODO: implement totalStock
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport}) {
    // TODO: implement transactionItemList
    throw UnimplementedError();
  }

  @override
  List<TransactionItem> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItemsFuture
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required int branchId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItemsStreams
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
  Future<List<Device>> unpublishedDevices({required int businessId}) {
    // TODO: implement unpublishedDevices
    throw UnimplementedError();
  }

  @override
  void upSert() {
    // TODO: implement upSert
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
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
      {required int productId,
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
      required int id,
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
  Future<Customer?> getCustomerFuture({String? key, int? id}) {
    // TODO: implement getCustomerFuture
    throw UnimplementedError();
  }

  @override
  Future<
      ({
        List<Device> devices,
        List<Favorite> favorites,
        List<Product> products,
        List<Stock> stocks,
        List<TransactionItem> transactionItems,
        List<ITransaction> transactions,
        List<Variant> variants
      })> getUnSyncedData() {
    // TODO: implement getUnSyncedData
    throw UnimplementedError();
  }

  @override
  Stream<double> initialStock({required branchId}) {
    // TODO: implement initialStock
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
  FutureOr<void> updateAsset({required int assetId, String? assetName}) {
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
      {required int categoryId,
      String? name,
      bool? active,
      bool? focused,
      int? branchId}) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateColor(
      {required int colorId, String? name, bool? active}) {
    // TODO: implement updateColor
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateDrawer(
      {required int drawerId,
      int? cashierId,
      int? nsSaleCount,
      int? trSaleCount,
      int? psSaleCount,
      int? csSaleCount,
      int? nrSaleCount,
      int? incompleteSale,
      double? totalCsSaleIncome,
      double? totalNsSaleIncome,
      String? openingDateTime,
      double? closingBalance,
      bool? open}) {
    // TODO: implement updateDrawer
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateNotification(
      {required int notificationId, bool? completed}) {
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
  FutureOr<void> updateProduct(
      {int? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      required int branchId,
      required int businessId,
      String? imageUrl,
      String? expiryDate}) {
    // TODO: implement updateProduct
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateReport({required int reportId, bool? downloaded}) {
    // TODO: implement updateReport
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateStockRequest(
      {required int stockRequestId, DateTime? updatedAt, String? status}) {
    // TODO: implement updateStockRequest
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateTenant(
      {required int tenantId,
      String? name,
      String? phoneNumber,
      String? email,
      int? businessId,
      String? type,
      int? pin,
      int? userId,
      int? id,
      bool? sessionActive,
      int? branchId}) {
    // TODO: implement updateTenant
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateTransaction(
      {required ITransaction transaction,
      String? receiptType,
      double? subTotal,
      String? note,
      String? status,
      int? customerId,
      bool? ebmSynced,
      String? sarTyCd,
      String? reference,
      String? customerTin,
      String? customerBhfId,
      double? cashReceived,
      bool? isRefunded,
      String? customerName,
      String? ticketName,
      String? updatedAt,
      int? invoiceNumber,
      DateTime? lastTouched,
      int? receiptNumber,
      int? totalReceiptNumber,
      bool? isProformaMode,
      bool? isTrainingMode}) {
    // TODO: implement updateTransaction
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateTransactionItem(
      {double? qty,
      required int transactionItemId,
      double? discount,
      bool? active,
      double? taxAmt,
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
      {required int unitId, String? name, bool? active, int? branchId}) {
    // TODO: implement updateUnit
    throw UnimplementedError();
  }

  @override
  FutureOr<Stock?> addStockToVariant({required Variant variant, Stock? stock}) {
    // TODO: implement addStockToVariant
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite}) {
    // TODO: implement addTransactionItem
    throw UnimplementedError();
  }

  @override
  FutureOr<Branch?> branch({required int serverId}) {
    // TODO: implement branch
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType,
      required double discount,
      required int branchId,
      required String bhfId,
      required bool isProformaMode,
      required bool isTrainingMode,
      required String transactionType,
      String? categoryId,
      bool directlyHandleReceipt = false,
      required bool isIncome}) {
    // TODO: implement collectPayment
    throw UnimplementedError();
  }

  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) {
    // TODO: implement completedTransactions
    throw UnimplementedError();
  }

  @override
  Future<RealmInterface> configureCapella(
      {required bool useInMemory, required LocalStorage box}) async {
    return this as RealmInterface;
  }

  @override
  Future<RealmInterface> configureLocal(
      {required bool useInMemory, required LocalStorage box}) async {
    return this as RealmInterface;
  }

  @override
  Future<void> configureSystem(String userPhone, extensions.IUser user,
      {required bool offlineLogin}) {
    // TODO: implement configureSystem
    throw UnimplementedError();
  }

  @override
  T? create<T>({required T data}) {
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
      required int invoiceNumber}) {
    // TODO: implement createReceipt
    throw UnimplementedError();
  }

  @override
  Future<Ebm?> ebm({required int branchId}) {
    // TODO: implement ebm
    throw UnimplementedError();
  }

  @override
  Future<bool> firebaseLogin({String? token}) {
    // TODO: implement firebaseLogin
    throw UnimplementedError();
  }

  @override
  FutureOr<Assets?> getAsset({String? assetName, int? productId}) {
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
  FutureOr<List<Customer>> getCustomers({String? key, int? id}) {
    // TODO: implement getCustomers
    throw UnimplementedError();
  }

  @override
  FutureOr<FlipperSaleCompaign?> getLatestCompaign() {
    // TODO: implement getLatestCompaign
    throw UnimplementedError();
  }

  @override
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required int transactionId}) {
    // TODO: implement getPaymentType
    throw UnimplementedError();
  }

  @override
  ITransaction? getTransactionById({required int id}) {
    // TODO: implement getTransactionById
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
  FutureOr<ITransaction> manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) {
    // TODO: implement manageTransaction
    throw UnimplementedError();
  }

  @override
  Stream<ITransaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false}) {
    // TODO: implement manageTransactionStream
    throw UnimplementedError();
  }

  @override
  void removeCustomerFromTransaction({required ITransaction transaction}) {
    // TODO: implement removeCustomerFromTransaction
  }

  @override
  Future<Configurations> saveTax(
      {required int configId, required double taxPercentage}) {
    // TODO: implement saveTax
    throw UnimplementedError();
  }

  @override
  Future<List<Configurations>> taxes({required int branchId}) {
    // TODO: implement taxes
    throw UnimplementedError();
  }

  @override
  Future<List<ITransaction>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
  }

  @override
  List<ITransaction> transactions(
      {DateTime? startDate,
      DateTime? endDate,
      String? status,
      String? transactionType,
      int? branchId,
      bool isExpense = false,
      bool includePending = false}) {
    // TODO: implement transactions
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateStock(
      {required int stockId,
      double? qty,
      double? rsdQty,
      double? initialStock,
      bool? ebmSynced,
      double? currentStock,
      double? value,
      DateTime? lastTouched}) {
    // TODO: implement updateStock
    throw UnimplementedError();
  }

  @override
  Variant? variant({int? variantId, String? name}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<bool> delete(
      {required int id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  TransactionItem? getTransactionItemByVariantId(
      {required int variantId, int? transactionId}) {
    // TODO: implement getTransactionItemByVariantId
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getVariantById({required int id}) {
    // TODO: implement getVariantById
    throw UnimplementedError();
  }

  @override
  RealmInterface instance() {
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
      required String bhFId}) {
    // TODO: implement saveEbm
    throw UnimplementedError();
  }

  @override
  FutureOr<void> savePaymentType(
      {TransactionPaymentRecord? paymentRecord,
      int? transactionId,
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
  FutureOr<void> saveStock(
      {Variant? variant,
      required double rsdQty,
      required int productId,
      required int variantId,
      required int branchId,
      required double currentStock,
      required double value}) {
    // TODO: implement saveStock
    throw UnimplementedError();
  }

  @override
  Stock? stockByVariantId(
      {required int variantId,
      required int branchId,
      bool nonZeroValue = false}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  List<TransactionItem> transactionItems(
      {int? transactionId,
      bool? doneWithTransaction,
      required int branchId,
      bool? active}) {
    // TODO: implement transactionItems
    throw UnimplementedError();
  }

  @override
  Future<void> processItem(
      {required brick.Item item,
      required Map<String, String> quantitis,
      required Map<String, String> taxTypes,
      required Map<String, String> itemClasses,
      required Map<String, String> itemTypes}) {
    // TODO: implement processItem
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addBusiness(
      {required int id,
      required int userId,
      required int serverId,
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
      {required int accessId,
      required int userId,
      required String featureName,
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
  Future<brick.Tenant?> saveTenant(
      {required brick.Business business,
      required brick.Branch branch,
      String? phoneNumber,
      String? name,
      int? id,
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
  FutureOr<List<brick.Access>> access(
      {required int userId, String? featureName}) {
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
  FutureOr<void> updateVariant(
      {required List<brick.Variant> updatables,
      String? color,
      String? taxTyCd,
      int? variantId,
      double? newRetailPrice,
      double? retailPrice,
      Map<int, String>? rates,
      double? supplyPrice,
      Map<int, String>? dates,
      String? selectedProductType,
      int? productId,
      String? productName,
      String? unit,
      String? pkgUnitCd,
      bool? ebmSynced}) {
    // TODO: implement updateVariant
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateBusiness(
      {required int businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId}) {
    // TODO: implement updateBusiness
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Discount>> getDiscounts({required int branchId}) {
    // TODO: implement getDiscounts
    throw UnimplementedError();
  }

  @override
  void notify({required brick.AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  void updateCounters(
      {required List<brick.Counter> counters,
      RwApiResponse? receiptSignature}) {
    // TODO: implement updateCounters
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
  Future<List<brick.Business>> businesses({required int userId}) {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  FutureOr<String> itemCode(
      {required String countryCode,
      required String productType,
      required packagingUnit,
      required String quantityUnit}) {
    // TODO: implement itemCode
    throw UnimplementedError();
  }

  @override
  Stream<List<brick.ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false,
      int? id,
      FilterType? filterType,
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
  FutureOr<brick.Product?> getProduct(
      {int? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Product>> getProducts(
      {String? key, int? prodIndex, required int branchId}) {
    // TODO: implement getProducts
    throw UnimplementedError();
  }

  @override
  Future<List<brick.Variant>> variants(
      {required int branchId, int? productId, int? page, int? itemsPerPage}) {
    // TODO: implement variants
    throw UnimplementedError();
  }
}
