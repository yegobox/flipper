import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/sync/interfaces/category_interface.dart';
import 'package:flipper_models/sync/interfaces/product_interface.dart';

import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_services/ai_strategy.dart';
import 'package:supabase_models/brick/models/all_models.dart' as odm;
// import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/all_models.dart' as models;
// import 'package:flipper_services/database_provider.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

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

abstract class DatabaseSyncInterface extends AiStrategy
    implements
        BranchInterface,
        PurchaseInterface,
        BusinessInterface,
        VariantInterface,
        AuthInterface,
        TransactionItemInterface,
        TransactionInterface,
        ProductInterface,
        TenantInterface,
        CategoryInterface {
  // Repository get repository;
  // DatabaseProvider? capella;
  // AsyncCollection? branchCollection;
  // AsyncCollection? businessCollection;
  // AsyncCollection? accessCollection;
  // AsyncCollection? permissionCollection;
  Future<List<Product>> products({required int branchId});
  Future<void> startReplicator();

  Future<DatabaseSyncInterface> configureLocal(
      {required bool useInMemory, required LocalStorage box});

  Future<DatabaseSyncInterface> configureCapella(
      {required bool useInMemory, required LocalStorage box});

  Future<void> initCollections();

  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password});

  Future<List<Configurations>> taxes({required int branchId});
  Future<Configurations> saveTax(
      {required String configId, required double taxPercentage});

  Future<double> totalStock({String? productId, String? variantId});

  Stream<List<Product>> productStreams({String? prodIndex});

  Future<List<PColor>> colors({required int branchId});
  Future<List<IUnit>> units({required int branchId});
  FutureOr<T?> create<T>({required T data});
  Stream<double> wholeStockValue({required int branchId});

  Future<bool> delete(
      {required String id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient});
  Future<PColor?> getColor({required String id});

  FutureOr<Configurations?> getByTaxType({required String taxtype});

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

  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required String favId});
  Future<Favorite?> getFavoriteByProdId({required String prodId});
  Future<Favorite?> getFavoriteByIndex({required String favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex});
  Stream<Tenant?> getDefaultTenant({required int businessId});
  Future<int> deleteFavoriteByIndex({required String favIndex});

  // AI Conversation History Methods
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Future<Message> saveMessage({
    required String text,
    required String phoneNumber,
    required int branchId,
    required String role,
    required String conversationId,
    String? aiResponse,
    String? aiContext,
  });

  Stream<List<Message>> conversationStream({required String conversationId});

  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId});

  Future<Variant?> getCustomVariant({
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
  });

  Future<ITransaction> collectPayment({
    required double cashReceived,
    ITransaction? transaction,
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
      {required Customer customer, String? transactionId});
  FutureOr<void> assignCustomerToTransaction(
      {required String customerId, String? transactionId});
  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction});
  // FutureOr<Customer?> getCustomer({String? key, int? id});
  // FutureOr<List<Customer>> getCustomers({String? key, int? id});
  // Future<Customer?> getCustomerFuture({String? key, int? id});

  FutureOr<List<Customer>> customers(
      {required int branchId, String? key, String? id});

  Stream<List<Customer>> customersStream(
      {required int branchId, String? key, String? id});

  Future<int> deleteTransactionByIndex({required String transactionIndex});

  Future<int> sendReport({required List<TransactionItem> transactionItems});

  Future<TransactionItem?> getTransactionItem(
      {required String variantId, String? transactionId});

  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient});

  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId});

  bool isSubscribed({required String feature, required int businessId});

  Future<List<Product>> productsFuture({required int branchId});

  FutureOr<List<Stock>> stocks({required int branchId});
  Future<Stock> getStockById({required String id});

  Future<List<Variant>> selectPurchases(
      {required String bhfId,
      required int tin,
      required String url,
      required String lastRequestdate});

  Future<Variant?> getVariant(
      {String? id,
      String? modrId,
      String? name,
      String? bcd,
      String? stockId,
      String? taskCd,
      String? itemClsCd,
      String? itemNm,
      String? itemCd,
      String? productId});
  Future<bool> isTaxEnabled({required int businessId});
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required DateTime whenCreated,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required odm.Counter counter,
      required int invoiceNumber});
  Future<Receipt?> getReceipt({required String transactionId});

  Future<void> refund({required int itemId});
  // Variant? getVariantByProductId({required String productId});

  Future<int> size<T>({required T object});
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType});
  Future<String?> getPlatformDeviceId();

  Future<bool> bindProduct(
      {required String productId, required String tenantId});
  Future<Product?> findProductByTenantId({required String tenantId});

  // Future<void> deleteAllProducts();

  Future<void> patchSocialSetting({required Setting setting});

  Future<Device?> getDevice(
      {required String phone, required String linkingCode});
  Future<Device?> getDeviceById({required int id});
  Future<List<Device>> getDevices({required int businessId});
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk});

  Stream<List<Variant>> geVariantStreamByProductId({required String productId});

  FutureOr<({double income, double expense})> getTransactionsAmountsSum(
      {required String period});

  Future<models.Ebm?> ebm({required int branchId, bool fetchRemote = false});
  Future<void> saveEbm(
      {required int branchId, required String severUrl, required String bhFId});

  Stream<Tenant?> authState({required int branchId});

  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient});
  FutureOr<Pin?> getPinLocal({required int userId});
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin});
  Future<Pin?> savePin({required Pin pin});

  Stream<double> totalSales({required int branchId});

  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
    required String lastRequestdate,
  });

  Future<void> syncUserWithAwsIncognito({required String identifier});
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"});
  Future<bool> removeS3File({required String fileName});
  FutureOr<Assets?> getAsset({String? assetName, String? productId});
  Future<void> amplifyLogout();
  Future<List<Product>> getProducts(
      {String? key, int? prodIndex, required int branchId});

  void saveComposite({required Composite composite});
  FutureOr<List<Composite>> composites({String? productId, String? variantId});
  Stream<SKU?> sku({required int branchId, required int businessId});
  FutureOr<SKU> getSku({required int branchId, required int businessId});
  Future<Variant> createVariant(
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
      models.Configurations? taxType});

  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName,
      {required String transactionId});
  DatabaseSyncInterface instance();
  FutureOr<Tenant?> tenant({int? businessId, int? userId});
  Stream<List<Report>> reports({required int branchId});
  Report report({required int id});

  FutureOr<bool> isAdmin({required int userId, required String appFeature});
  FutureOr<List<Access>> access({required int userId, String? featureName});
  Future<List<Access>> allAccess({required int userId});
  Stream<List<InventoryRequest>> requestsStream(
      {required int branchId, String? filter});
  FutureOr<List<InventoryRequest>> requests({int? branchId, String? requestId});
  FutureOr<Tenant?> getTenant({int? userId, int? pin});

  Future<({String url, int userId, String customerCode})> subscribe(
      {required int businessId,
      required Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount});

  Future<bool> firebaseLogin({String? token});
  FutureOr<Plan?> saveOrUpdatePaymentPlan({
    required int businessId,
    List<String>? addons,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    // required String payStackUserId,
    required String paymentMethod,
    String? customerCode,
    models.Plan? plan,
    int numberOfPayments = 1,
    required HttpClientInterface flipperHttpClient,
  });
  Future<models.Plan?> getPaymentPlan(
      {required int businessId, bool fetchRemote = false});
  FutureOr<FlipperSaleCompaign?> getLatestCompaign();

  void deleteItemFromCart(
      {required TransactionItem transactionItemId, String? transactionId});

  Future<void> createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline});

  Future<void> refreshSession({required int branchId, int? refreshRate = 5});
  Future<String> createStockRequest(List<TransactionItem> items,
      {required String deliveryNote,
      DateTime? deliveryDate,
      required ITransaction transaction,
      required int mainBranchId,
      required FinanceProvider financeOption});

  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath});

  Future<List<Branch>> branches(
      {required int businessId, bool? includeSelf = false});
  Future<List<ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient});
  FutureOr<Business?> getBusiness({int? businessId});
  Future<Business?> defaultBusiness();
  FutureOr<Branch?> defaultBranch();

  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient});

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

  void clearData({required ClearData data, required int identifier});

  FutureOr<Drawers?> closeDrawer(
      {required Drawers drawer, required double eod});
  FutureOr<Stock> saveStock({
    Variant? variant,
    required double rsdQty,
    required String productId,
    required String variantId,
    required int branchId,
    required double currentStock,
    required double value,
  });

  FutureOr<void> savePaymentType(
      {TransactionPaymentRecord? paymentRecord,
      String? transactionId,
      double amount = 0.0,
      String? paymentMethod,
      required bool singlePaymentOnly});
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required String transactionId});

  SendPort? sendPort;
  ReceivePort? receivePort;
  Future<String> getFirebaseToken();

  Future<void> sendMessageToIsolate();
  Future<void> spawnIsolate(dynamic isolateHandler);
  void reDownloadAsset();

  Future<void> processItem({
    required Variant item,
    required Map<String, String> quantitis,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  });

  FutureOr<void> updateStock({
    required String stockId,
    double? qty,
    double? rsdQty,
    double? initialStock,
    bool? ebmSynced,
    double? currentStock,
    double? value,
    DateTime? lastTouched,
    bool appending = false,
  });

  FutureOr<void> updateTransactionItem({
    double? qty,
    required String transactionItemId,
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

  void updateCounters({
    required List<Counter> counters,
    RwApiResponse? receiptSignature,
  });
  FutureOr<void> updateDrawer({
    required String drawerId,
    int? cashierId,
    int? nsSaleCount,
    int? trSaleCount,
    int? psSaleCount,
    int? csSaleCount,
    int? nrSaleCount,
    int? incompleteSale,
    double? totalCsSaleIncome,
    double? totalNsSaleIncome,
    DateTime? openingDateTime,
    double? closingBalance,
    bool? open,
  });

  FutureOr<void> updateTenant({
    required String tenantId,
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
    required String categoryId,
    String? name,
    bool? active,
    bool? focused,
    int? branchId,
  });

  FutureOr<void> updateUnit({
    required String unitId,
    String? name,
    bool? active,
    int? branchId,
  });

  FutureOr<void> updateColor(
      {required String colorId, String? name, bool? active});

  FutureOr<void> updateReport({required String reportId, bool? downloaded});

  FutureOr<void> updateBranch(
      {required int branchId, String? name, bool? active, bool? isDefault});

  FutureOr<void> updateNotification(
      {required String notificationId, bool? completed});

  FutureOr<void> updateStockRequest(
      {required String stockRequestId, DateTime? updatedAt, String? status});

  FutureOr<void> updateAcess({
    required int userId,
    String? featureName,
    String? status,
    String? accessLevel,
    String? userType,
  });
  FutureOr<void> updateAsset({
    required String assetId,
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
      {required String productId,
      required assetName,
      required int branchId,
      required int businessId});

  FutureOr<void> addCategory({
    required String name,
    required int branchId,
    required bool active,
    required bool focused,
    required DateTime lastTouched,
    String? id,
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

  FutureOr<LPermission?> permission({required int userId});

  void updateAccess(
      {required String accessId,
      required int userId,
      required String featureName,
      required String accessLevel,
      required String status,
      required String userType}) {}

  FutureOr<List<LPermission>> permissions({required int userId});

  getCounters({required int branchId, bool fetchRemote = false}) {}

  void notify({required AppNotification notification}) {}

  conversations({int? conversationId}) {}

  getTop5RecentConversations() {}

  Future<void> createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId});

  FutureOr<void> addTransaction({required ITransaction transaction});
  FutureOr<bool> isBranchEnableForPayment({required String currentBranchId});
  FutureOr<void> setBranchPaymentStatus(
      {required String currentBranchId, required bool status});

  /// Upserts a CustomerPayment. If a payment with the same ID already exists,
  /// it will be updated, otherwise a new payment will be created.
  Future<CustomerPayments> upsertPayment(CustomerPayments payment);

  /// Fetches a CustomerPayment by its ID.
  Future<CustomerPayments?> getPaymentById(String id);

  /// Fetches all CustomerPayments.
  Future<List<CustomerPayments>> getAllPayments();

  /// Deletes a CustomerPayment by its ID
  Future<void> deletePaymentById(String id);

  Future<List<Country>> countries();

  Future<double> fetchProfit(int branchId);

  Future<double> fetchCost(int branchId);
  Future<List<BusinessAnalytic>> analytics({required int branchId});
  Future<void> deleteFailedQueue();
  Future<int> queueLength();

  Future<List<FinanceProvider>> financeProviders();
  Future<VariantBranch?> variantBranch(
      {required String variantId, required String destinationBranchId});

  Future<BusinessInfo> initializeEbm(
      {required String tin, required String bhfId, required String dvcSrlNo});
}
