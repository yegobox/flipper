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
// import 'package:flipper_models/helperModels/iuser.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';

import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_models/brick/models/all_models.dart' as models;
import 'package:flipper_services/database_provider.dart'
    if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';
import 'package:supabase_models/brick/repository.dart';
// import 'package:cbl/src/database/collection.dart'
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

abstract class RealmInterface {
  // Repository get repository;
  // DatabaseProvider? capella;
  // AsyncCollection? branchCollection;
  // AsyncCollection? businessCollection;
  // AsyncCollection? accessCollection;
  // AsyncCollection? permissionCollection;
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
      {required String configId, required double taxPercentage});

  Future<double> totalStock({String? productId, String? variantId});

  FutureOr<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
  });
  Stream<List<Product>> productStreams({String? prodIndex});

  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  FutureOr<Category?> activeCategory({required int branchId});
  Future<List<IUnit>> units({required int branchId});
  FutureOr<T?> create<T>({required T data});
  Stream<double> wholeStockValue({required int branchId});

  Future<bool> delete(
      {required String id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient});
  Future<PColor?> getColor({required String id});

  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
    String? variantId,
    int? page,
    String? purchaseId,
    bool excludeApprovedInWaitingOrCanceledItems = false,
    int? itemsPerPage,
    String? name,
    String? bcd,
    // this define if we are ready to show item on dashboard,
    String? imptItemsttsCd,
    bool fetchRemote = false,
  });
  FutureOr<Configurations?> getByTaxType({required String taxtype});
  FutureOr<Purchase?> getPurchase({required String purchaseId});

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
      String? id,
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
  Future<Favorite?> getFavoriteById({required String favId});
  Future<Favorite?> getFavoriteByProdId({required String prodId});
  Future<Favorite?> getFavoriteByIndex({required String favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex});
  Stream<Tenant?> getDefaultTenant({required int businessId});
  Future<int> deleteFavoriteByIndex({required String favIndex});

  FutureOr<Product?> getProduct(
      {String? id,
      String? barCode,
      required int branchId,
      String? name,
      required int businessId});

  Future<Product?> createProduct(
      {required Product product,
      Purchase? purchase,
      String? modrId,
      String? orgnNatCd,
      String? exptNatCd,
      int? pkg,
      String? pkgUnitCd,
      String? spplrItemClsCd,
      String? spplrItemCd,
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
      required bool createItemCode,
      String? imptItemsttsCd,
      required int businessId,
      required int branchId,
      required int tinNumber,
      required String bhFId,
      Map<String, String>? taxTypes,
      Map<String, String>? itemClasses,
      Map<String, String>? itemTypes,
      bool skipRegularVariant = false,
      double qty = 1,
      double supplyPrice = 0,
      double retailPrice = 0,
      int itemSeq = 1,
      bool ebmSynced = false,
      String? pchsSttsCd,
      double? totAmt,
      String? itemCd,
      double? taxAmt});

  Stream<ITransaction> manageTransactionStream(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool includeSubTotalCheck = false});

  FutureOr<ITransaction?> manageTransaction(
      {required String transactionType,
      required bool isExpense,
      required int branchId,
      bool includeSubTotalCheck = false});

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

  Future<TransactionItem?> getTransactionItemByVariantId(
      {required String variantId, String? transactionId});

  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<void> addTransactionItem({
    ITransaction? transaction,
    required bool partOfComposite,
    required DateTime lastTouched,
    required double discount,
    double? compositePrice,
    required double quantity,
    required double currentStock,
    Variant? variation,
    required double amountTotal, // Added to match old implementation
    required String name,
    TransactionItem? item, // Added to match old implementation
  });

  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient});

  Future<List<Tenant>> tenants({int? businessId, int? excludeUserId});

  bool isSubscribed({required String feature, required int businessId});

  Future<List<Product>> productsFuture({required int branchId});

  Stream<List<ITransaction>> transactionsStream({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
    String? id,
    FilterType? filterType,
    DateTime? startDate,
    DateTime? endDate,
  });

  FutureOr<List<TransactionItem>> transactionItems({
    String? transactionId,
    bool? doneWithTransaction,
    int? branchId,
    String? id,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
  });

  FutureOr<List<Stock>> stocks({required int branchId});
  Future<Stock> getStockById({required String id});

  Future<List<Variant>> selectPurchases(
      {required String bhfId, required int tin, required String url, required String lastRequestdate});

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

  FutureOr<Variant> addStockToVariant({required Variant variant, Stock? stock});
  Stream<List<Variant>> geVariantStreamByProductId({required String productId});

  FutureOr<({double income, double expense})> getTransactionsAmountsSum(
      {required String period});

  Future<models.Ebm?> ebm({required int branchId, bool fetchRemote = false});
  Future<void> saveEbm(
      {required int branchId, required String severUrl, required String bhFId});

  Stream<Tenant?> authState({required int branchId});

  Future<List<BusinessType>> businessTypes();
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient});
  FutureOr<Pin?> getPinLocal({required int userId});
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin});
  Future<Pin?> savePin({required Pin pin});
  Stream<List<TransactionItem>> transactionItemsStreams({
    String? transactionId,
    int? branchId,
    DateTime? startDate,
    DateTime? endDate,
    bool? doneWithTransaction,
    bool? active,
    bool fetchRemote = false,
    String? requestId,
  });

  Stream<double> totalSales({required int branchId});

  Stream<List<Category>> categoryStream();
  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId, required String lastRequestdate,
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

  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName);
  RealmInterface instance();
  FutureOr<Tenant?> tenant({int? businessId, int? userId});
  Stream<List<Report>> reports({required int branchId});
  Report report({required int id});

  FutureOr<bool> isAdmin({required int userId, required String appFeature});
  FutureOr<List<Access>> access({required int userId, String? featureName});
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
    // required String payStackUserId,
    required String paymentMethod,
    String? customerCode,
    models.Plan? plan,
    int numberOfPayments = 1,
    required HttpClientInterface flipperHttpClient,
  });
  Future<models.Plan?> getPaymentPlan({required int businessId});
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

  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false,
      required Pin pin,
      required HttpClientInterface flipperHttpClient});

  Future<List<Business>> businesses({required int userId});
  Future<Business?> activeBusiness({int? userId});

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

  FutureOr<void> updateTransaction(
      {required ITransaction? transaction,
      String? receiptType,
      double? subTotal,
      String? note,
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
      int? receiptNumber,
      int? totalReceiptNumber,
      bool? isProformaMode,
      bool? isTrainingMode,

      /// because transaction is involved in account reporting
      /// and in other ways to facilitate that everything in flipper has attached transaction
      /// we want to make it unclassified i.e neither it is income or expense
      /// this help us having wrong computation on dashboard of what is income or expenses.
      bool isUnclassfied = false});

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

  FutureOr<void> updateVariant({
    required List<Variant> updatables,
    String? color,
    String? taxTyCd,
    String? variantId,
    double? newRetailPrice,
    double? retailPrice,
    Map<String, String>? rates,
    double? supplyPrice,
    Map<String, String>? dates,
    String? selectedProductType,
    String? productId,
    String? productName,
    String? unit,
    String? pkgUnitCd,
    bool? ebmSynced,
    DateTime? expirationDate,
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

  FutureOr<void> updateProduct(
      {String? productId,
      String? name,
      bool? isComposite,
      String? unit,
      String? color,
      required int branchId,
      required int businessId,
      String? imageUrl,
      String? expiryDate});

  FutureOr<void> updateColor(
      {required String colorId, String? name, bool? active});

  FutureOr<void> updateReport({required String reportId, bool? downloaded});

  FutureOr<void> updateBusiness(
      {required int businessId,
      String? name,
      bool? active,
      bool? isDefault,
      String? backupFileId});

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

  FutureOr<String> itemCode({
    required int branchId,
    required String countryCode, // e.g., "RW"
    required String productType, // e.g., "2"
    required String packagingUnit, // e.g., "NT"
    required String quantityUnit, // e.g., "BJ"
  });

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
  Future<VariantBranch?> variantBranch({required String variantId});

  Future<BusinessInfo> initializeEbm(
      {required String tin, required String bhfId, required String dvcSrlNo});
}
