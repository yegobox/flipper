import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_services/abstractions/storage.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/models/all_models.dart' as odm;

import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:cbl/src/database/collection.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:supabase_models/brick/models/all_models.dart' as brick;

enum ClearData { Business, Branch }

abstract class DataMigratorToLocal {
  Future<DataMigratorToLocal> configure(
      {required bool useInMemoryDb,
      bool useFallBack = false,
      String? encryptionKey,
      int? businessId,
      int? branchId,
      int? userId});

  DataMigratorToLocal instance();
  void copyRemoteDataToLocalDb();
  List<String> activeRealmSubscriptions();
}

abstract class RealmInterface {
  DatabaseProvider? capella;
  AsyncCollection? branchCollection;
  AsyncCollection? businessCollection;
  AsyncCollection? accessCollection;
  AsyncCollection? permissionCollection;
  Future<List<Product>> products({required int branchId});
  Future<void> startReplicator();

  Future<RealmInterface> configureLocal(
      {required bool useInMemory, required LocalStorage box});

  Future<RealmInterface> configureCapella(
      {required bool useInMemory, required LocalStorage box});

  Future<void> initCollections();

  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password});

  Future<List<Configurations>> taxes({required int branchId});
  Future<Configurations> saveTax(
      {required int configId, required double taxPercentage});

  Future<double> totalStock({int? productId, int? variantId});
  List<Stock> stocks({required int branchId});
  Stream<double> getStockStream(
      {int? productId, int? variantId, required int branchId});
  List<ITransaction> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
  });
  Stream<List<Product>> productStreams({int? prodIndex});

  Future<List<Product>> getProductList({int? prodIndex, required int branchId});
  Stock? stockByVariantId(
      {required int variantId,
      required int branchId,
      bool nonZeroValue = false});

  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  FutureOr<Category?> activeCategory({required int branchId});
  Future<List<IUnit>> units({required int branchId});
  T? create<T>({required T data});
  Stream<double> getStockValue({required int branchId});
  Future<int> updateNonRealm<T>(
      {required T data, required HttpClientInterface flipperHttpClient});

  Future<bool> delete(
      {required int id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient});
  Future<PColor?> getColor({required int id});
  Future<Stock?> getStock(
      {required int branchId,
      required int variantId,
      bool nonZeroValue = false,
      int? id});
  List<Variant> variants({
    required int branchId,
    int? productId,
    int? page,
    int? itemsPerPage,
  });
  FutureOr<Configurations?> getByTaxType({required String taxtype});
  Variant? variant({int? variantId, String? name});

  FutureOr<void> addAccess({
    required int userId,
    required String featureName,
    required String accessLevel,
    required String userType,
    required String status,
    required int branchId,
    required int businessId,
    DateTime? createdAt,
  });
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units});

  Future<int> addVariant(
      {required List<Variant> variations, required int branchId});

  Future<int> addFavorite({required Favorite data});

  Future<Tenant?> saveTenant(
      {required Business business,
      required Branch branch,
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
      required String userType});

  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required int favId});
  Future<Favorite?> getFavoriteByProdId({required int prodId});
  Future<Favorite?> getFavoriteByIndex({required int favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex});
  Stream<Tenant?> getDefaultTenant({required int businessId});
  Future<int> deleteFavoriteByIndex({required int favIndex});

  FutureOr<Product?> getProduct(
      {int? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId});

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

  Stream<ITransaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false});

  FutureOr<ITransaction> manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool? includeSubTotalCheck = false});

  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId});

  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE});
  Future<TransactionItem?> getTransactionItemById({required int id});

  Future<Variant?> getCustomVariant({
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
  });

  Future<ITransaction> collectPayment({
    required double cashReceived,
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
    required bool isIncome,
  });

  Future<Setting?> getSetting({required int businessId});

  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId});
  void assignCustomerToTransaction(
      {required int customerId, int? transactionId});
  void removeCustomerFromTransaction({required ITransaction transaction});
  FutureOr<Customer?> getCustomer({String? key, int? id});
  FutureOr<List<Customer>> getCustomers({String? key, int? id});
  Future<Customer?> getCustomerFuture({String? key, int? id});

  ITransaction? getTransactionById({required int id});
  Future<List<ITransaction>> tickets();

  Future<int> deleteTransactionByIndex({required int transactionIndex});

  Stream<List<Variant>> getVariantByProductIdStream({int? productId});

  Future<int> sendReport({required List<TransactionItem> transactionItems});

  TransactionItem? getTransactionItemByVariantId(
      {required int variantId, int? transactionId});
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId});

  int lifeTimeCustomersForbranch({required String branchId});

  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  FutureOr<void> addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite});

  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient});

  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId});

  bool isSubscribed({required String feature, required int businessId});

  void consumePoints({required int userId, required int points});

  Future<List<Product>> productsFuture({required int branchId});

  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
    int? id,
    FilterType? filterType,
    DateTime? startDate,
    DateTime? endDate,
  });

  FutureOr<List<TransactionItem>> transactionItems(
      {int? transactionId,
      bool? doneWithTransaction,
      required int branchId,
      bool? active});

  List<TransactionItem> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active});

  Future<Variant?> getVariantById({required int id});
  Future<bool> isTaxEnabled({required int businessId});
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required DateTime whenCreated,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required odm.Counter counter,
      required int invoiceNumber});
  Future<Receipt?> getReceipt({required int transactionId});

  Future<void> refund({required int itemId});
  Variant? getVariantByProductId({required int productId});

  Future<int> size<T>({required T object});
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType});
  Future<String?> getPlatformDeviceId();

  Future<bool> bindProduct({required int productId, required int tenantId});
  Future<Product?> findProductByTenantId({required int tenantId});

  Future<void> deleteAllProducts();
  FutureOr<Stock?> getStockById({required int id});

  Future<bool> isTokenValid(
      {required String tokenType, required int businessId});

  Future<void> patchSocialSetting({required Setting setting});

  Future<Device?> getDevice(
      {required String phone, required String linkingCode});
  Future<Device?> getDeviceById({required int id});
  Future<List<Device>> getDevices({required int businessId});
  Future<List<Device>> unpublishedDevices({required int businessId});
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk});

  FutureOr<Stock?> addStockToVariant({required Variant variant, Stock? stock});
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
        List<ITransaction> transactions,
        List<TransactionItem> transactionItems
      })> getUnSyncedData();

  Future<models.Ebm?> ebm({required int branchId});
  Future<void> saveEbm(
      {required int branchId, required String severUrl, required String bhFId});

  Stream<Tenant?> authState({required int branchId});

  List<Customer> customers({required int branchId});

  Future<List<BusinessType>> businessTypes();
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient});
  FutureOr<Pin?> getPinLocal({required int userId});
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin});
  Future<Pin?> savePin({required Pin pin});
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required int branchId,
      required bool doneWithTransaction,
      required bool active});

  bool isRealmClosed();

  Stream<double> stockValue({required branchId});

  Stream<double> soldStockValue({required branchId});
  Stream<double> initialStock({required branchId});
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
  FutureOr<Assets?> getAsset({String? assetName, int? productId});
  Future<void> amplifyLogout();
  List<Product> getProducts({String? key});
  List<Variant> getVariants({String? key});

  void saveComposite({required Composite composite});
  List<Composite> composites({required int productId});
  List<Composite> compositesByVariantId({required int variantId});
  Composite? composite({required int variantId});
  Stream<SKU?> sku({required int branchId, required int businessId});
  FutureOr<SKU> getSku({required int branchId, required int businessId});
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
  RealmInterface instance();
  FutureOr<Tenant?> tenant({int? businessId, int? userId});
  Stream<List<Report>> reports({required int branchId});
  Report report({required int id});

  Future<
      ({
        double grossProfit,
        double netProfit,
      })> getReportData();

  FutureOr<bool> isAdmin({required int userId, required String appFeature});
  FutureOr<List<Access>> access({required int userId, String? featureName});
  Stream<List<StockRequest>> requestsStream(
      {required int branchId, required String filter});
  List<StockRequest> requests({required int branchId});
  FutureOr<Tenant?> getTenant({int? userId, int? pin});

  Future<({String url, int userId, String customerCode})> subscribe(
      {required int businessId,
      required Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount});

  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient});
  Future<bool> firebaseLogin({String? token});
  FutureOr<Plan?> saveOrUpdatePaymentPlan({
    required int businessId,
    List<String>? addons,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required int payStackUserId,
    required String paymentMethod,
    String? customerCode,
    models.Plan? plan,
    int numberOfPayments = 1,
    required HttpClientInterface flipperHttpClient,
  });
  Future<models.Plan?> getPaymentPlan({required int businessId});
  FutureOr<FlipperSaleCompaign?> getLatestCompaign();
  Stream<Plan?> paymentPlanStream({required int businessId});

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

  Future<void> refreshSession({required int branchId, int? refreshRate = 5});
  int createStockRequest(List<TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required int mainBranchId});

  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath});

  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient});

  Future<List<Business>> businesses({required int userId});
  Future<Business?> activeBusiness({required int userId});

  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false});
  Future<List<ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient});
  FutureOr<Business?> getBusiness({int? businessId});
  FutureOr<Business?> getBusinessById({required int businessId});
  Future<Business?> defaultBusiness();
  FutureOr<Branch?> defaultBranch();
  Future<Branch> activeBranch();

  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient});
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient});
  Future<List<Business>> getContacts();

  Future<List<UnversalProduct>> universalProductNames({required int branchId});

  Future<void> deleteBranch(
      {required int branchId, required HttpClientInterface flipperHttpClient});
  FutureOr<Branch?> branch({required int serverId});

  Future<http.Response> sendLoginRequest(
      String phoneNumber, HttpClientInterface flipperHttpClient, String apihub,
      {String? uid});

  bool isDrawerOpen({required int cashierId, required int branchId});
  Future<Drawers?> getDrawer({required int cashierId});

  Drawers? openDrawer({required Drawers drawer});

  void clearData({required ClearData data});

  Drawers? closeDrawer({required Drawers drawer, required double eod});
  FutureOr<void> saveStock({
    Variant? variant,
    required double rsdQty,
    required int productId,
    required int variantId,
    required int branchId,
    required double currentStock,
    required double value,
  });

  FutureOr<void> savePaymentType(
      {TransactionPaymentRecord? paymentRecord,
      int? transactionId,
      double amount = 0.0,
      String? paymentMethod,
      required bool singlePaymentOnly});
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required int transactionId});

  SendPort? sendPort;
  ReceivePort? receivePort;
  Future<String> getIdToken();
  void upSert();
  Future<void> sendMessageToIsolate();
  Future<void> spawnIsolate(dynamic isolateHandler);
  void reDownloadAsset();

  Future<void> processItem({
    required brick.Item item,
    required Map<String, String> quantitis,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  });

  FutureOr<void> updateStock({
    required int stockId,
    double? qty,
    double? rsdQty,
    double? initialStock,
    bool? ebmSynced,
    double? currentStock,
    double? value,
    DateTime? lastTouched,
  });

  FutureOr<void> updateTransactionItem({
    double? qty,
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
    double? dcAmt,
  });

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
      bool? isTrainingMode});

  void updateCounters({
    required List<Counter> counters,
    RwApiResponse? receiptSignature,
  });
  FutureOr<void> updateDrawer({
    required int drawerId,
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
    bool? open,
  });

  FutureOr<void> updateVariant({
    required List<Variant> updatables,
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
    bool? ebmSynced,
  });
  FutureOr<void> updateTenant({
    required int tenantId,
    String? name,
    String? phoneNumber,
    String? email,
    int? businessId,
    String? type,
    int? pin,
    bool? sessionActive,
    int? branchId,
    int? userId,
    int? id,
  });

  FutureOr<void> updateCategory({
    required int categoryId,
    String? name,
    bool? active,
    bool? focused,
    int? branchId,
  });

  FutureOr<void> updateUnit({
    required int unitId,
    String? name,
    bool? active,
    int? branchId,
  });

  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId});

  FutureOr<void> updateProduct(
      {int? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      required int branchId,
      required int businessId,
      String? imageUrl,
      String? expiryDate});

  FutureOr<void> updateColor(
      {required int colorId, String? name, bool? active});

  FutureOr<void> updateReport({required int reportId, bool? downloaded});

  FutureOr<void> updateBusiness(
      {required int businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId});

  FutureOr<void> updateBranch(
      {required int branchId, String? name, bool? active, bool? isDefault});

  FutureOr<void> updateNotification(
      {required int notificationId, bool? completed});

  FutureOr<void> updateStockRequest(
      {required int stockRequestId, DateTime? updatedAt, String? status});

  FutureOr<void> updateAcess({
    required int userId,
    String? featureName,
    String? status,
    String? accessLevel,
    String? userType,
  });
  FutureOr<void> updateAsset({
    required int assetId,
    String? assetName,
  });

  FutureOr<void> updatePin({
    required int userId,
    String? phoneNumber,
    String? tokenUid,
  });

  FutureOr<void> deleteAll<T extends Object>({
    required String tableName,
  });

  FutureOr<void> addAsset(
      {required int productId,
      required assetName,
      required int branchId,
      required int businessId});

  FutureOr<void> addCategory({
    required String name,
    required int branchId,
    required bool active,
    required bool focused,
    required DateTime lastTouched,
    required int id,
    required DateTime createdAt,
    required deletedAt,
  });

  FutureOr<void> addColor({required String name, required int branchId});

  FutureOr<Branch> addBranch({
    required String name,
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
    int? id,
  });

  void whoAmI();

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
      required String encryptionKey});

  FutureOr<LPermission?> permission({required int userId});

  void updateAccess(
      {required int accessId,
      required int userId,
      required String featureName,
      required String accessLevel,
      required String status,
      required String userType}) {}

  FutureOr<List<LPermission>> permissions({required int userId});

  getCounters({required int branchId}) {}

  Future<List<Discount>> getDiscounts({required int branchId});

  void notify({required AppNotification notification}) {}

  conversations({int? conversationId}) {}

  getTop5RecentConversations() {}

  FutureOr<String> itemCode({
    required String countryCode, // e.g., "RW"
    required String productType, // e.g., "2"
    required String packagingUnit, // e.g., "NT"
    required String quantityUnit, // e.g., "BJ"
  });
}
