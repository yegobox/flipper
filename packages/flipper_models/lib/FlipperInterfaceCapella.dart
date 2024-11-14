import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:firestore_models/firestore_models.dart';
import 'package:firestore_models/transaction.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/constants.dart';
import 'package:realm/realm.dart' as realmO;
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:http/http.dart' as http;

import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:cbl/src/database/collection.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

enum ClearData { Business, Branch }

enum SyncProvider { FIRESTORE, CAPELLA, SUPABASE }

abstract class DataMigratorToLocal {
  Future<DataMigratorToLocal> configure(
      {required bool useInMemoryDb,
      bool useFallBack = false,
      String? encryptionKey,
      int? businessId,
      int? branchId,
      int? userId});
  // Realm? realm;
  Future<String> dbPath({required String path, int? folder});
  DataMigratorToLocal instance();
  void copyRemoteDataToLocalDb();
  List<String> activeRealmSubscriptions();
}

abstract class FlipperInterfaceCapella {
  DatabaseProvider? capella;

  AsyncCollection? branchCollection;
  AsyncCollection? businessCollection;
  AsyncCollection? accessCollection;
  AsyncCollection? permissionCollection;
  Future<AsyncCollection> getCountersCollection();
  Future<List<Counter>> getCounters({required int branchId});
  Future<List<Product>> products({required int branchId});
  Future<void> startReplicator();

  Future<Configurations> taxes({required int branchId});
  Future<Configurations> saveTax(
      {required int configId, required double taxPercentage});

  void replicateData<T>(String tableName, T data,
      {bool? useNewImplementation = false});
  Future<void> processbatchBackUp<T extends realmO.RealmObject>(List<T> batch);
  Future<bool> firebaseLogin({String? token});
  void cancelWatch({required String tableName});
  void cancelAll();
  Future<void> handleRealmChanges<T>({
    required realmO.RealmResults<T> results,
    required String tableName,
    required String idField,
    required int Function(T) getId,
    required Map<String, dynamic> Function(T) convertToMap,
    required Function(Map<String, dynamic>) preProcessMap,
    required SyncProvider syncProvider,
  });
  Future<void> handleRealmChangesAsync<T>({
    required realmO.RealmResults<T> results,
    required String tableName,
    required String idField,
    required int Function(T) getId,
    required Map<String, dynamic> Function(T) convertToMap,
    required Function(Map<String, dynamic>) preProcessMap,
    required SyncProvider syncProvider,
  });
  Future<void> deleteRecord(
      {required String tableName, required String idField, required int id});
  Future<void> updateRecord({
    required String tableName,
    required String idField,
    required Map<String, dynamic> map,
    required int id,
    required List<SyncProvider> syncProviders,
  });

  Future<void> watchTable<T extends realmO.RealmObject>({
    required String tableName,
    required List<int> branchIds,
    required String idField,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    required SyncProvider syncProvider,
  });

  Future<void> watchTableAsync<T extends realmO.RealmObject>({
    required String tableName,
    required String idField,
    required List<int> branchIds,
    bool useWatch = false,
    required T Function(Map<String, dynamic>) createRealmObject,
    required void Function(T, Map<String, dynamic>) updateRealmObject,
    required SyncProvider syncProvider,
  });
  Future<void> backUp({
    required int branchId,
    required String encryptionKey,
    required String dbPath,
  });
  Future<void> deleteDuplicate({required String tableName});

  Future<FlipperInterfaceCapella> configureLocal(
      {required bool useInMemory, required LocalStorage box});

  Future<FlipperInterfaceCapella> configureCapella(
      {required bool useInMemory, required LocalStorage box});
  void whoAmI();
  Future<void> initCollections();

  // Future<T> writeN<T>({
  //   required String tableName,
  //   required T Function() writeCallback,
  //   required Future<void> Function(T) onAdd,
  // });

  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password});

  Future<double> totalStock({int? productId, int? variantId});
  List<Stock> stocks({required int branchId});
  Stream<double> getStockStream(
      {int? productId, int? variantId, required int branchId});
  List<Transaction> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
  });
  Stream<List<Product>> productStreams({int? prodIndex});

  Stream<List<Transaction>> orders({required int branchId});
  Future<List<Product>> getProductList({int? prodIndex, required int branchId});
  Future<Stock?> stockByVariantId(
      {required int variantId,
      required int branchId,
      bool nonZeroValue = false});
  Future<Stock?> stockByVariantIdFuture(
      {required int variantId, bool nonZeroValue = false});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Category? activeCategory({required int branchId});
  Future<List<IUnit>> units({required int branchId});
  Future<T?> create<T>({required T data});
  Stream<double> getStockValue({required int branchId});
  Future<int> updateNonRealm<T>(
      {required T data, required HttpClientInterface flipperHttpClient});

  Future<bool> delete(
      {required int id,
      String? endPoint,
      required HttpClientInterface flipperHttpClient});
  Future<PColor?> getColor({required int id});
  Future<Stock?> getStock({required int branchId, required int variantId});
  Future<List<Variant>> variants({
    required int branchId,
    int? productId,
    int? page,
    int? itemsPerPage,
  });
  Future<Configurations?> getByTaxType({required String taxtype});
  Future<Variant?> variant({int? variantId, String? name});
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units});

  Future<int> addVariant(
      {required List<Variant> variations, required int branchId});

  Future<int> addFavorite({required Favorite data});
  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required int favId});
  Future<Favorite?> getFavoriteByProdId({required int prodId});
  Future<Favorite?> getFavoriteByIndex({required int favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex});
  Stream<Tenant?> getDefaultTenant({required int businessId});
  Future<int> deleteFavoriteByIndex({required int favIndex});

  Future<Product?> getProduct({required int id});
  Future<Product?> getProductByBarCode(
      {required String barCode, required int branchId});
  Future<List<Product?>> getProductByName(
      {required String name, required int branchId});
  // Future
  //this function for now figure out what is the business id on backend side.
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
      bool ebmSynced = false});

  Future<Voucher?> consumeVoucher({required int voucherCode});

  Stream<Transaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false});

  ///create an transaction if no pending transaction exist should create a new one
  ///then if it exist should return the existing one!
  Transaction manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false});

  Future<Transaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId});

  Future<List<Transaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE});
  Future<TransactionItem?> getTransactionItemById({required int id});
  Stream<List<Transaction>> transactionList(
      {DateTime? startDate, DateTime? endDate});
  Future<Variant?> getCustomVariant({
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
  });
  // Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<Transaction> collectPayment({
    required double cashReceived,
    required Transaction transaction,
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
  });

// app settings and users settings
  Future<Setting?> getSetting({required int businessId});

  // Stream<List<Conversation>> conversationStreamList({int? receiverId});
  // void sendMessage({required int receiverId, required Message message});
  // Stream<List<Message>> messages({required int conversationId});

  /// we treat all business as users and as contact at the same time
  /// this is because a business act as point of contact for a user
  /// and we do not to refer to the business phone number to send messages
  /// we only care about name, this deliver from our core mission that
  /// we want to make communication easy for business and users i.e customers
  ///
  //the method is not different from users, but users is for streaming users being added
  //to connected devices, while this method is for getting all users using List<Business>

  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId});
  void assignCustomerToTransaction(
      {required int customerId, int? transactionId});
  void removeCustomerFromTransaction({required Transaction transaction});
  Future<Customer?> getCustomer({String? key, int? id});
  List<Customer> getCustomers({String? key, int? id});
  Future<Customer?> getCustomerFuture({String? key, int? id});

  Future<Transaction?> getTransactionById({required int id});
  Future<List<Transaction>> tickets();
  Stream<List<Transaction>> ticketsStreams();
  Stream<List<Transaction>> transactionStreamById(
      {required int id, required FilterType filterType});
  Future<int> deleteTransactionByIndex({required int transactionIndex});

  Stream<List<Variant>> getVariantByProductIdStream({int? productId});

  Future<int> sendReport({required List<TransactionItem> transactionItems});

  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, int? transactionId});
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId});

  //abstract method to update business

  //analytics
  int lifeTimeCustomersForbranch({required String branchId});

  //save discount
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  // Future<List<Discount>> getDiscounts({required int branchId});

  void addTransactionItem(
      {required Transaction transaction,
      required TransactionItem item,
      required bool partOfComposite});

  void emptySentMessageQueue();

  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient});

  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId});
  Future<Tenant?> getTenantBYUserId({required int userId});

  Future<Tenant?> getTenantBYPin({required int pin});

  Future<bool> isSubscribed({required String feature, required int businessId});

  Future<bool> checkIn({required String? checkInCode});
  Future<bool> enableAttendance(
      {required int businessId, required String email});

  // Future<Profile?> profile({required int businessId});
  // Future<Profile?> updateProfile({required Profile profile});

  // Future<Pointss> addPoint({required int userId, required int point});

  // Future<Pointss?> getPoints({required int userId});
  void consumePoints({required int userId, required int points});
  // Future<Pin?> createPin();
  // Future<Pin?> getPin({required String pin});

  Future<List<Product>> productsFuture({required int branchId});

  Stream<List<Transaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
  });

  /// get a list of transactionItems given transactionId
  List<TransactionItem> transactionItems(
      {required int transactionId,
      required bool doneWithTransaction,
      required int branchId,
      required bool active});

  List<TransactionItem> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active});

  Variant? getVariantById({required int id});
  bool isTaxEnabled({required Business business});
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required DateTime whenCreated,
      required Transaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter,
      required int invoiceNumber});
  Future<Receipt?> getReceipt({required int transactionId});

  Future<void> refund({required int itemId});
  Variant? getVariantByProductId({required int productId});

  Future<int> size<T>({required T object});
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType});
  Future<String?> getPlatformDeviceId();

  Future<String> dbPath({required String path, int? folder});
  Future<bool> bindProduct({required int productId, required int tenantId});
  Future<Product?> findProductByTenantId({required int tenantId});

  Future<void> deleteAllProducts();
  Stock? getStockById({required int id});

  /// socials methods
  // Stream<Social> socialsStream({required int branchId});
  // Future<Social?> getSocialById({required int id});

  // Future<List<BusinessType>> businessTypes();

  /// list messages
  // Stream<List<Conversation>> conversations({String? conversationId});
  // Future<void> sendScheduleMessages();
  // Future<Conversation?> getConversation({required String messageId});
  // Future<List<Conversation>> getScheduleMessages();
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password});
  // Future<SocialToken?> loginOnSocial(
  //     {String? phoneNumberOrEmail, String? password});
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId});

  // Stream<List<Conversation>> getTop5RecentConversations();

  //
  Future<void> patchSocialSetting({required Setting setting});
  Future<Setting?> getSocialSetting();

  Future<Device?> getDevice(
      {required String phone, required String linkingCode});
  Future<Device?> getDeviceById({required int id});
  Future<List<Device>> getDevices({required int businessId});
  Future<List<Device>> unpublishedDevices({required int businessId});
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk});
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId});

  // Future<List<Social>> activesocialAccounts({required int branchId});

  Future<Stock?> addStockToVariant({required Variant variant});
  Stream<List<Variant>> geVariantStreamByProductId({required int productId});

  Future<({double income, double expense})> getTransactionsAmountsSum(
      {required String period});
  Future<
      ({
        List<Stock> stocks,
        List<Variant> variants,
        List<Product> products,
        List<Favorite> favorites,
        List<Device> devices,
        List<Transaction> transactions,
        List<TransactionItem> transactionItems
      })> getUnSyncedData();
  // Future<Conversation> sendMessage(
  //     {required String message, required Conversation latestConversation});
  EBM? ebm({required int branchId});
  void saveEbm(
      {required int branchId, required String severUrl, required String bhFId});

  // Future<ITenant> authState({required int branchId});

  Stream<Tenant?> authState({required int branchId});

  Future<void> recordUserActivity(
      {required int userId, required String activity});

  List<Customer> customers({required int branchId});
  void close();
  void clear();
  // Future<List<SyncRecord>> syncedModels({required int branchId});
  // Future<Permission?> permission({required int userId});

  Future<List<BusinessType>> businessTypes();
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient});
  Pin? getPinLocal({required int userId});
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin});
  Future<Pin?> savePin({required Pin pin});
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required int branchId,
      required bool doneWithTransaction,
      required bool active});

  bool isRealmClosed();

  /// we sum all non negative and non 0 stock value with the
  /// retailing price
  Stream<double> stockValue({required branchId});

  /// we sum up all soldItem that we get by querying the non negative stock
  /// and non zero then what we get we query related sold item

  Stream<double> soldStockValue({required branchId});
  Future<void> markModelForEbmUpdate<T>(
      {required T model, bool updated = true});
  Stream<List<Category>> categoryStream();
  Future<RwApiResponse> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastReqDt,
  });

  Future<void> syncUserWithAwsIncognito({required String identifier});
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"});
  Future<bool> removeS3File({required String fileName});
  Assets? getAsset({String? assetName, int? productId});
  Future<void> amplifyLogout();
  List<Product> getProducts({String? key});
  List<Variant> getVariants({String? key});

  void saveComposite({required Composite composite});
  List<Composite> composites({required int productId});
  List<Composite> compositesByVariantId({required int variantId});
  Composite composite({required int variantId});
  Stream<SKU?> sku({required int branchId, required int businessId});
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
      required String name});

  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName);
  FlipperInterfaceCapella instance();
  Tenant? tenant({int? businessId, int? userId});
  Stream<List<Report>> reports({required int branchId});
  Report report({required int id});

  Future<
      ({
        double grossProfit,
        double netProfit,
      })> getReportData();

  /// determine if current running user is admin
  bool isAdmin({required int userId, required String appFeature});
  Future<LPermission?> permission({required int userId});
  List<LPermission> permissions({required int userId});
  List<Accesses> access({required int userId});
  Stream<List<StockRequest>> requestsStream(
      {required int branchId, required String filter});
  List<StockRequest> requests({required int branchId});
  Tenant getTenant({required int userId});

  Future<({String url, int userId, String customerCode})> subscribe(
      {required int businessId,
      required Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount});

  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient});

  Future<PaymentPlan> saveOrUpdatePaymentPlan({
    required int businessId,
    List<String>? addons,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required int payStackUserId,
    required String paymentMethod,
    String? customerCode,
    required HttpClientInterface flipperHttpClient,
  });
  Future<PaymentPlan?> getPaymentPlan({required int businessId});
  FlipperSaleCompaign? getLatestCompaign();
  Stream<PaymentPlan?> paymentPlanStream({required int businessId});

  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport});

  void deleteItemFromCart(
      {required TransactionItem transactionItemId, int? transactionId});

  void createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId});
  void createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline});

  Future<List<Activity>> activities({required int userId});
  Future<void> refreshSession({required int branchId, int? refreshRate = 5});
  int createStockRequest(List<TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required int mainBranchId});
  void updateStock({required int stockId, required double qty});

  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath});

  void updateTransactionItemQty({required qty, required int transactionItemId});

  // Future<String> dbPath({required String path});
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient});

  /// since when we log in we get all business in login response object
  /// it is assumed that this business/branches are for user access
  List<Business> businesses();
  Future<Business?> activeBusinesses({required int userId});
  // Future<Business> getOnlineBusiness({required int userId});
  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false});
  Future<List<ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient});
  Business getBusiness({int? businessId});
  Business? getBusinessById({required int businessId});
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
  Future<List<UniversalProduct>> universalProductNames({required int branchId});
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
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid});

  /// drawers
  bool isDrawerOpen({required int cashierId, required int branchId});
  Future<Drawers?> getDrawer({required int cashierId});

  Drawers? openDrawer({required Drawers drawer});

  void clearData({required ClearData data});

  Drawers? closeDrawer({required Drawers drawer, required double eod});
  void saveStock({required Variant variant});
  void updateTransactionStatus(Transaction transaction, String receiptType);
  void savePaymentType({required TransactionPaymentRecord paymentRecord});
  List<TransactionPaymentRecord> getPaymentType({required int transactionId});

  void updateCounters({
    required List<Counter> counters,
    RwApiResponse? receiptSignature,
  });
  SendPort? sendPort;
  ReceivePort? receivePort;
  Future<String> getIdToken();
  void upSert();
  Future<void> sendMessageToIsolate();
  Future<void> spawnIsolate(dynamic isolateHandler);
  void reDownloadAsset();
  void clearVariants();
}
