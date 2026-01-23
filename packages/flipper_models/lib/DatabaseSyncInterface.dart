import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:convert';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/DelegationInterface.dart';
import 'package:flipper_models/sync/interfaces/auth_interface.dart';
import 'package:flipper_models/sync/interfaces/branch_interface.dart';
import 'package:flipper_models/sync/interfaces/business_interface.dart';
import 'package:flipper_models/sync/interfaces/category_interface.dart';
import 'package:flipper_models/sync/interfaces/conversation_interface.dart';
import 'package:flipper_models/sync/interfaces/counter_interface.dart';
import 'package:flipper_models/sync/interfaces/customer_interface.dart';
import 'package:flipper_models/sync/interfaces/delete_interface.dart';
import 'package:flipper_models/sync/interfaces/ebm_interface.dart';
import 'package:flipper_models/sync/interfaces/product_interface.dart';
import 'package:flipper_models/sync/interfaces/receipt_interface.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/sync/interfaces/stock_recount_interface.dart';
import 'package:flipper_models/sync/mixins/shift_mixin.dart';
import 'package:flipper_services/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flipper_models/sync/interfaces/purchase_interface.dart';
import 'package:flipper_models/sync/interfaces/tenant_interface.dart';
import 'package:flipper_models/sync/interfaces/transaction_interface.dart';
import 'package:flipper_models/sync/interfaces/transaction_item_interface.dart';
import 'package:flipper_models/sync/interfaces/variant_interface.dart';
import 'package:flipper_models/sync/mixins/asset_mixin.dart';
import 'package:flipper_models/sync/interfaces/log_interface.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'package:flipper_services/ai_strategy.dart';
// import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:supabase_models/brick/models/all_models.dart' as models;
// import 'package:flipper_services/database_provider.dart'
//     if (dart.library.html) 'package:flipper_services/DatabaseProvider.dart';

enum ClearData { Business, Branch }

abstract class DataMigratorToLocal {
  Future<DataMigratorToLocal> configure(
      {required bool useInMemoryDb,
      bool useFallBack = false,
      String? encryptionKey,
      String? businessId,
      String? branchId,
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
        HttpClientInterface,
        ProductInterface,
        TenantInterface,
        DeleteInterface,
        EbmInterface,
        AssetInterface,
        CustomerInterface,
        CategoryInterface,
        StockRecountInterface,
        ShiftApi,
        StockInterface,
        CounterInterface,
        DelegationInterface,
        ConversationInterface,
        ReceiptInterface,
        LogInterface {
  // Repository get repository;
  // DatabaseProvider? capella;
  // AsyncCollection? branchCollection;
  // AsyncCollection? businessCollection;
  // AsyncCollection? accessCollection;
  // AsyncCollection? permissionCollection;
  Future<List<Product>> products({required String branchId});
  Future<void> startReplicator();

  Future<void> initCollections();

  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password});

  Future<List<Configurations>> taxes({required String branchId});
  Future<Configurations> saveTax(
      {required String configId, required double taxPercentage});

  Future<double> totalStock({String? productId, String? variantId});

  Stream<List<Product>> productStreams({String? prodIndex});

  Future<List<PColor>> colors({required String branchId});
  Future<List<IUnit>> units({required String branchId});
  FutureOr<T?> create<T>({required T data});
  Future<http.StreamedResponse> send(http.BaseRequest request);
  Future<http.Response> get(Uri url, {Map<String, String>? headers});
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Future<http.Response> getUniversalProducts(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding});
  Stream<double> wholeStockValue({required String branchId});

  Future<PColor?> getColor({required String id});

  FutureOr<Configurations?> getByTaxType({required String taxtype});

  FutureOr<void> addAccess({
    required String userId,
    required String featureName,
    required String accessLevel,
    required String userType,
    required String status,
    required String branchId,
    required String businessId,
    DateTime? createdAt,
  });
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units});

  Future<int> addFavorite({required Favorite data});

  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required String favId});
  Future<Favorite?> getFavoriteByProdId({required String prodId});
  Future<Favorite?> getFavoriteByIndex({required String favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex});
  Stream<Tenant?> getDefaultTenant({required String businessId});
  Future<int> deleteFavoriteByIndex({required String favIndex});

  // AI Conversation History Methods
  Future<List<Message>> getConversationHistory({
    required String conversationId,
    DateTime? startDate,
    DateTime? endDate,
    int? limit,
    int? offset,
  });

  Stream<List<Message>> conversationStream({required String conversationId});

  Future<Variant?> getCustomVariant({
    required String businessId,
    required String branchId,
    required int tinNumber,
    required String bhFId,
  });

  Future<Variant?> getUtilityVariant({
    required String name,
    required String branchId,
  });

  Future<ITransaction> collectPayment({
    required double cashReceived,
    ITransaction? transaction,
    required String paymentType,
    required double discount,
    required String branchId,
    required String bhfId,
    required bool isProformaMode,
    required bool isTrainingMode,
    required String transactionType,
    String? categoryId,
    bool directlyHandleReceipt = false,
    required bool isIncome,
    String? customerName,
    String? customerTin,
    String? customerPhone,
    required String countryCode,
    String? note,
  });

  Future<Setting?> getSetting({required String businessId});

  FutureOr<void> assignCustomerToTransaction(
      {required Customer customer, required ITransaction transaction});
  FutureOr<void> removeCustomerFromTransaction(
      {required ITransaction transaction});
  Stream<List<Customer>> customersStream(
      {required String branchId, String? key, String? id});

  Future<int> deleteTransactionByIndex({required String transactionIndex});

  Future<int> sendReport({required List<TransactionItem> transactionItems});

  Future<void> saveDiscount(
      {required String branchId, required name, double? amount});

  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient});

  bool isSubscribed({required String feature, required String businessId});

  Future<List<Product>> productsFuture({required String branchId});

  FutureOr<List<Stock>> stocks({required String branchId});
  Future<Stock> getStockById({required String id});

  Future<List<Purchase>> selectPurchases(
      {required String bhfId,
      required int tin,
      required String url,
      String? pchsSttsCd});

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
  Future<bool> isTaxEnabled(
      {required String businessId, required String branchId});

  Future<Receipt?> getReceipt({required String transactionId});

  Future<void> refund({required int itemId});
  // Variant? getVariantByProductId({required String productId});

  Future<int> size<T>({required T object});
  Future<Counter?> getCounter(
      {required String branchId,
      required String receiptType,
      required bool fetchRemote});
  Future<String?> getPlatformDeviceId();

  Future<bool> bindProduct(
      {required String productId, required String tenantId});
  Future<Product?> findProductByTenantId({required String tenantId});

  // Future<void> deleteAllProducts();

  Future<void> patchSocialSetting({required Setting setting});

  Future<Device?> getDevice(
      {required String phone, required String linkingCode});
  Future<Device?> getDeviceById({required int id});
  Future<List<Device>> getDevices({required String businessId});
  Future<void> loadConversations(
      {required String businessId, int? pageSize = 10, String? pk, String? sk});

  Stream<List<Variant>> geVariantStreamByProductId({required String productId});

  FutureOr<({double income, double expense})> getTransactionsAmountsSum(
      {required String period});

  Stream<Tenant?> authState({required String branchId});

  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient});
  FutureOr<Pin?> getPinLocal(
      {String? userId, String? phoneNumber, required bool alwaysHydrate});
  Future<void> configureSystem(String userPhone, IUser user,
      {required bool offlineLogin});
  Future<Pin?> savePin({required Pin pin});

  Stream<double> totalSales({required String branchId});

  Future<List<Variant>> selectImportItems({
    required int tin,
    required String bhfId,
  });

  Future<void> syncUserWithAwsIncognito({required String identifier});

  Future<bool> removeS3File({required String fileName});

  Future<void> amplifyLogout();
  Future<List<Product>> getProducts(
      {String? key, int? prodIndex, required String branchId});

  Future<void> saveComposite({required Composite composite});
  FutureOr<List<Composite>> composites({String? productId, String? variantId});
  Stream<SKU?> sku({required String branchId, required String businessId});
  FutureOr<SKU> getSku({required String branchId, required String businessId});
  Future<Variant> createVariant(
      {required String barCode,
      required int sku,
      required String productId,
      required String branchId,
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
  Stream<List<Report>> reports({required String branchId});
  Report report({required int id});

  FutureOr<bool> isAdmin({required String userId, required String appFeature});
  Future<List<Access>> access(
      {required String userId, String? featureName, required bool fetchRemote});
  Future<List<Access>> allAccess({required String userId});
  Stream<List<InventoryRequest>> requestsStream(
      {required String branchId,
      String filter = RequestStatus.pending,
      String? search});
  FutureOr<Tenant?> getTenant({String? userId, int? pin});

  Future<({String url, int userId, String customerCode})> subscribe(
      {required String businessId,
      required Business business,
      required int agentCode,
      required HttpClientInterface flipperHttpClient,
      required int amount});

  Future<bool> firebaseLogin({String? token});
  FutureOr<Plan?> saveOrUpdatePaymentPlan({
    required String businessId,
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
      {required String businessId, bool? fetchOnline});
  Future<void> upsertPlan(
      {required String businessId, required Plan selectedPlan});

  // Discount code methods
  Future<Map<String, dynamic>> validateDiscountCode({
    required String code,
    required String planName,
    required double amount,
  });

  Future<String?> applyDiscountToPlan({
    required String planId,
    required String discountCodeId,
    required double originalPrice,
    required double discountAmount,
    required double finalPrice,
    required String businessId,
  });

  Future<Map<String, dynamic>?> getPlanDiscount({
    required String planId,
  });

  double calculateDiscount({
    required double originalPrice,
    required String discountType,
    required double discountValue,
  });

  Future<void> cleanDuplicatePlans();
  FutureOr<FlipperSaleCompaign?> getLatestCompaign();

  Future<void> deleteItemFromCart(
      {required TransactionItem transactionItemId, String? transactionId});

  Future<void> createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline});

  Future<void> refreshSession({required String branchId, int? refreshRate = 5});
  Future<String> createStockRequest(List<TransactionItem> items,
      {required String mainBranchId,
      required String subBranchId,
      String? deliveryNote,
      String? orderNote,
      String? financingId});

  Future<Business?> signup(
      {required Map business, required HttpClientInterface flipperHttpClient});
  FutureOr<Business?> getBusiness({String? businessId});
  Future<Business?> defaultBusiness();
  FutureOr<Branch?> defaultBranch();

  Future<List<Business>> getContacts();

  Future<List<UnversalProduct>> universalProductNames(
      {required String branchId});

  Future<void> deleteBranch(
      {required String branchId,
      required HttpClientInterface flipperHttpClient});

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

  Future<void> processItem({
    required Variant item,
    required Map<String, String> quantitis,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  });

  Future<void> updateCounters({
    required List<Counter> counters,
    RwApiResponse? receiptSignature,
  });

  FutureOr<void> updateCategory({
    required String categoryId,
    String? name,
    bool? active,
    bool? focused,
    String? branchId,
  });

  FutureOr<void> updateUnit({
    required String unitId,
    String? name,
    bool? active,
    String? branchId,
  });

  FutureOr<void> updateColor(
      {required String colorId, String? name, bool? active});

  FutureOr<void> updateReport({required String reportId, bool? downloaded});

  FutureOr<void> updateNotification(
      {required String notificationId, bool? completed});

  FutureOr<void> updateStockRequest(
      {required String stockRequestId, DateTime? updatedAt, String? status});

  FutureOr<void> updateAcess({
    required String userId,
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
    required String userId,
    String? phoneNumber,
    String? tokenUid,
  });

  FutureOr<void> deleteAll<T extends Object>({
    required String tableName,
  });

  FutureOr<void> addCategory({
    required String name,
    required String branchId,
    required bool active,
    required bool focused,
    required DateTime lastTouched,
    String? id,
    required DateTime createdAt,
    required deletedAt,
  });

  FutureOr<void> addColor({required String name, required String branchId});

  void whoAmI();

  FutureOr<LPermission?> permission({required String userId});

  void updateAccess(
      {required String accessId,
      required String userId,
      required String featureName,
      required String accessLevel,
      required String status,
      required String branchId,
      required String businessId,
      required String userType}) {}

  FutureOr<List<LPermission>> permissions({required String userId});

  void notify({required AppNotification notification}) {}

  conversations({int? conversationId}) {}

  getTop5RecentConversations() {}

  Future<void> createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required String subBranchId});

  FutureOr<bool> isBranchEnableForPayment(
      {required String currentBranchId, bool fetchRemote = false});
  FutureOr<void> setBranchPaymentStatus(
      {required String currentBranchId, required bool status});

  /// Upserts a CustomerPayment. If a payment with the same ID already exists,
  /// it will be updated, otherwise a new payment will be created.
  Future<CustomerPayments> upsertPayment(CustomerPayments payment);

  Future<CustomerPayments?> getPayment({required String paymentReference});
  Future<Credit?> getCredit({required String branchId});
  Stream<Credit?> credit({required String branchId});
  Future<void> updateCredit(Credit credit);

  /// Fetches a CustomerPayment by its ID.
  Future<CustomerPayments?> getPaymentById(String id);

  /// Fetches all CustomerPayments.
  Future<List<CustomerPayments>> getAllPayments();

  /// Deletes a CustomerPayment by its ID
  Future<void> deletePaymentById(String id);

  Future<List<Country>> countries();

  Future<double> fetchProfit(String branchId);

  Future<double> fetchCost(String branchId);
  Future<List<BusinessAnalytic>> analytics({required String branchId});
  Stream<List<BusinessAnalytic>> streamRemoteAnalytics(
      {required String branchId});
  Future<void> deleteFailedQueue();
  Future<int> queueLength();

  Future<List<FinanceProvider>> financeProviders();
  Future<VariantBranch?> variantBranch(
      {required String variantId, required String destinationBranchId});

  Future<BusinessInfo> initializeEbm(
      {required String tin, required String bhfId, required String dvcSrlNo});

  Future<void> updateStockRequestItem({
    required String requestId,
    required String transactionItemId,
    int? quantityApproved,
    bool? ignoreForReport,
  });
}
