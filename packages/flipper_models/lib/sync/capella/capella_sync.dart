import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/sync/mixins/category_mixin.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_core/query.dart' as brick;
import 'package:flipper_services/Miscellaneous.dart';
import 'package:http/src/base_request.dart';
import 'package:http/src/response.dart';
import 'package:http/src/streamed_response.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'package:supabase_models/brick/models/log.model.dart';
import 'package:supabase_models/brick/repository/storage.dart';
import 'package:flipper_services/constants.dart';
import 'package:talker/talker.dart';
import 'package:flipper_models/sync/capella/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/business_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/conversation_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/customer_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/delete_operations_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/ebm_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/favorite_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/getter_operations_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/product_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/purchase_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/receipt_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/stock_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/storage_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/system_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/tenant_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_item_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/variant_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/shift_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/counter_mixin.dart';
import 'package:flipper_services/ai_strategy_impl.dart';
import 'package:flipper_models/sync/mixins/stock_recount_mixin.dart';
import 'package:supabase_models/brick/models/all_models.dart';
import 'package:flipper_web/services/ditto_service.dart';

class CapellaSync extends AiStrategyImpl
    with
        CapellaAuthMixin,
        CapellaBranchMixin,
        CapellaBusinessMixin,
        CapellaConversationMixin,
        CapellaCounterMixin,
        CapellaCustomerMixin,
        CapellaDeleteOperationsMixin,
        CapellaEbmMixin,
        CapellaFavoriteMixin,
        CoreMiscellaneous,
        CapellaGetterOperationsMixin,
        CapellaProductMixin,
        CapellaPurchaseMixin,
        CapellaReceiptMixin,
        CapellaStorageMixin,
        CapellaSystemMixin,
        CapellaTenantMixin,
        CapellaTransactionItemMixin,
        CapellaTransactionMixin,
        CapellaVariantMixin,
        CapellaShiftMixin,
        CapellaStockMixin,
        CategoryMixin,
        StockRecountMixin
    implements DatabaseSyncInterface {
  CapellaSync();

  DittoService get dittoService => DittoService.instance;
  @override
  Future<void> initCollections() async {
    throw UnimplementedError('initCollections needs to be implemented');
  }

  @override
  Future<Stream<double>> downloadAsset({
    required int branchId,
    required String assetName,
    required String subPath,
  }) async {
    throw UnimplementedError('downloadAsset needs to be implemented');
  }

  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    throw UnimplementedError('downloadAssetSave needs to be implemented');
  }

  @override
  Future<void> startReplicator() async {
    throw UnimplementedError('startReplicator needs to be implemented');
  }

  @override
  Stream<List<ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      String? id,
      FilterType? filterType,
      bool includePending = false,
      DateTime? startDate,
      bool removeAdjustmentTransactions = false,
      bool forceRealData = true,
      required bool skipOriginalTransactionCheck,
      DateTime? endDate}) {
    // TODO: implement transactionsStream
    throw UnimplementedError();
  }

  @override
  Future<List<BusinessType>> businessTypes() {
    // TODO: implement businessTypes
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
  Future<List<ITenant>> tenantsFromOnline(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement tenantsFromOnline
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> manageTransaction(
      {required String transactionType,
      required int branchId,
      String status = PENDING,
      required bool isExpense,
      bool includeSubTotalCheck = false,
      String? shiftId}) {
    // TODO: implement manageTransaction
    throw UnimplementedError();
  }

  @override
  Stream<ITransaction> pendingTransaction(
      {int? branchId,
      required String transactionType,
      bool forceRealData = true,
      required bool isExpense}) {
    // TODO: implement pendingTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> updateIoFunc(
      {required Variant variant, Purchase? purchase, double? approvedQty}) {
    // TODO: implement updateIoFunc
    throw UnimplementedError();
  }

  @override
  Future<void> mergeTransactions(
      {required ITransaction from, required ITransaction to}) {
    // TODO: implement mergeTransactions
    throw UnimplementedError();
  }

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  @override
  Future<List<Access>> access(
      {required int userId, String? featureName, required bool fetchRemote}) {
    // TODO: implement access
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
  FutureOr<Branch> addBranch(
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
  Future<List<Access>> allAccess({required int userId}) {
    // TODO: implement allAccess
    throw UnimplementedError();
  }

  @override
  Future<void> amplifyLogout() {
    // TODO: implement amplifyLogout
    throw UnimplementedError();
  }

  @override
  Future<List<BusinessAnalytic>> analytics({required int branchId}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        throw Exception('Ditto not initialized');
      }

      final result = await ditto.store.execute(
        'SELECT * FROM business_analytics WHERE branchId = :branchId ORDER BY date DESC',
        arguments: {'branchId': branchId},
      );

      return result.items.map((item) {
        final data = Map<String, dynamic>.from(item.value);
        return BusinessAnalytic(
          id: data['_id'] ?? data['id'],
          branchId: data['branchId'],
          date: data['date'] != null
              ? DateTime.parse(data['date'])
              : DateTime.now(),
          itemName: data['itemName'] ?? 'Unknown Item',
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          profit: (data['profit'] as num?)?.toDouble() ?? 0.0,
          unitsSold: (data['unitsSold'] as int?) ?? 0,
          taxRate: (data['taxRate'] as num?)?.toDouble() ?? 0.0,
          trafficCount: (data['trafficCount'] as int?) ?? 0,
          categoryName: data['categoryName'],
          categoryId: data['categoryId'],
        );
      }).toList();
    } catch (e) {
      // get it from sqlite as fallback upsert it for it to be saved into ditto next time
      final data = await repository.get<BusinessAnalytic>(
        /// since we always want fresh data and assumption is that ai is supposed to work with internet on, then this make sense.
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(
          // limit: 100,
          where: [brick.Where('branchId').isExactly(branchId)],
          orderBy: [brick.OrderBy('date', ascending: false)],
        ),
      );
      for (var element in data) {
        repository.upsert<BusinessAnalytic>(element);
      }
      return data;
    }
  }

  @override
  FutureOr<void> assignCustomerToTransaction(
      {required Customer customer, String? transactionId}) {
    // TODO: implement assignCustomerToTransaction
    throw UnimplementedError();
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
  Future<void> cleanDuplicatePlans() {
    // TODO: implement cleanDuplicatePlans
    throw UnimplementedError();
  }

  @override
  Future<int> clearOldLogs({required Duration olderThan, int? businessId}) {
    // TODO: implement clearOldLogs
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> collectPayment(
      {required double cashReceived,
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
      String? customerName,
      String? customerTin,
      String? customerPhone,
      required String countryCode}) {
    // TODO: implement collectPayment
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  FutureOr<List<Composite>> composites({String? productId, String? variantId}) {
    // TODO: implement composites
    throw UnimplementedError();
  }

  @override
  conversations({int? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError();
  }

  @override
  Future<List<Country>> countries() {
    // TODO: implement countries
    throw UnimplementedError();
  }

  @override
  FutureOr<T?> create<T>({required T data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> createNewStock(
      {required Variant variant,
      required TransactionItem item,
      required int subBranchId}) {
    // TODO: implement createNewStock
    throw UnimplementedError();
  }

  @override
  Future<void> createOrUpdateBranchOnCloud(
      {required Branch branch, required bool isOnline}) {
    // TODO: implement createOrUpdateBranchOnCloud
    throw UnimplementedError();
  }

  @override
  Future<String> createStockRequest(List<TransactionItem> items,
      {required int mainBranchId,
      required int subBranchId,
      String? deliveryNote,
      String? orderNote,
      String? financingId}) {
    // TODO: implement createStockRequest
    throw UnimplementedError();
  }

  @override
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
      Configurations? taxType}) {
    // TODO: implement createVariant
    throw UnimplementedError();
  }

  @override
  Stream<Credit?> credit({required String branchId}) {
    // TODO: implement credit
    throw UnimplementedError();
  }

  @override
  Stream<List<Customer>> customersStream(
      {required int branchId, String? key, String? id}) {
    // TODO: implement customersStream
    throw UnimplementedError();
  }

  @override
  FutureOr<Branch?> defaultBranch() {
    // TODO: implement defaultBranch
    throw UnimplementedError();
  }

  @override
  Future<Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  FutureOr<void> deleteAll<T extends Object>({required String tableName}) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFailedQueue() {
    // TODO: implement deleteFailedQueue
    throw UnimplementedError();
  }

  @override
  Future<void> deletePaymentById(String id) {
    // TODO: implement deletePaymentById
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTransactionItemAndResequence({required String id}) {
    // TODO: implement deleteTransactionItemAndResequence
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
  Future<List<FinanceProvider>> financeProviders() {
    // TODO: implement financeProviders
    throw UnimplementedError();
  }

  @override
  Future<bool> flipperDelete(
      {required String id,
      String? endPoint,
      HttpClientInterface? flipperHttpClient}) {
    // TODO: implement flipperDelete
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId(
      {required String productId}) {
    // TODO: implement geVariantStreamByProductId
    throw UnimplementedError();
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<CustomerPayments>> getAllPayments() {
    // TODO: implement getAllPayments
    throw UnimplementedError();
  }

  @override
  FutureOr<Assets?> getAsset({String? assetName, String? productId}) {
    // TODO: implement getAsset
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required String id}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Credit?> getCredit({required String branchId}) {
    // TODO: implement getCredit
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
  Future<List<Log>> getLogs({String? type, int? businessId, int limit = 100}) {
    // TODO: implement getLogs
    throw UnimplementedError();
  }

  @override
  Future<CustomerPayments?> getPayment({required String paymentReference}) {
    // TODO: implement getPayment
    throw UnimplementedError();
  }

  @override
  Future<CustomerPayments?> getPaymentById(String id) {
    // TODO: implement getPaymentById
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItem(
      {required String variantId, String? transactionId}) {
    // TODO: implement getTransactionItem
    throw UnimplementedError();
  }

  @override
  Future<Response> getUniversalProducts(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement getUniversalProducts
    throw UnimplementedError();
  }

  @override
  Future<bool> hasOfflineAssets() {
    // TODO: implement hasOfflineAssets
    throw UnimplementedError();
  }

  @override
  Future<BusinessInfo> initializeEbm(
      {required String tin, required String bhfId, required String dvcSrlNo}) {
    // TODO: implement initializeEbm
    throw UnimplementedError();
  }

  @override
  DatabaseSyncInterface instance() {
    // TODO: implement instance
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> isAdmin({required int userId, required String appFeature}) {
    // TODO: implement isAdmin
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> isBranchEnableForPayment(
      {required String currentBranchId, bool fetchRemote = false}) {
    // TODO: implement isBranchEnableForPayment
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
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk}) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  @override
  void notify({required AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  Future<Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  FutureOr<LPermission?> permission({required int userId}) {
    // TODO: implement permission
    throw UnimplementedError();
  }

  @override
  FutureOr<List<LPermission>> permissions({required int userId}) {
    // TODO: implement permissions
    throw UnimplementedError();
  }

  @override
  Future<Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<void> processItem(
      {required Variant item,
      required Map<String, String> quantitis,
      required Map<String, String> taxTypes,
      required Map<String, String> itemClasses,
      required Map<String, String> itemTypes}) {
    // TODO: implement processItem
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> productsFuture({required int branchId}) {
    // TODO: implement productsFuture
    throw UnimplementedError();
  }

  @override
  Future<Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<int> queueLength() {
    // TODO: implement queueLength
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
  Stream<List<InventoryRequest>> requestsStream(
      {required int branchId,
      String filter = RequestStatus.pending,
      String? search}) {
    // TODO: implement requestsStream
    throw UnimplementedError();
  }

  @override
  Future<void> saveComposite({required Composite composite}) {
    // TODO: implement saveComposite
    throw UnimplementedError();
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<Assets> saveImageLocally(
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
  FutureOr<Plan?> saveOrUpdatePaymentPlan(
      {required String businessId,
      List<String>? addons,
      required String selectedPlan,
      required int additionalDevices,
      required bool isYearlyPlan,
      required double totalPrice,
      required String paymentMethod,
      String? customerCode,
      Plan? plan,
      int numberOfPayments = 1,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement saveOrUpdatePaymentPlan
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
  Future<StreamedResponse> send(BaseRequest request) {
    // TODO: implement send
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
  FutureOr<void> setBranchPaymentStatus(
      {required String currentBranchId, required bool status}) {
    // TODO: implement setBranchPaymentStatus
    throw UnimplementedError();
  }

  @override
  Future<Business?> signup(
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
  Stream<SKU?> sku({required int branchId, required int businessId}) {
    // TODO: implement sku
    throw UnimplementedError();
  }

  @override
  Future<void> spawnIsolate(isolateHandler) {
    // TODO: implement spawnIsolate
    throw UnimplementedError();
  }

  @override
  FutureOr<List<Stock>> stocks({required int branchId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  Stream<List<BusinessAnalytic>> streamRemoteAnalytics(
      {required int branchId}) {
    // TODO: implement streamRemoteAnalytics
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
  Future<List<String>> syncOfflineAssets() {
    // TODO: implement syncOfflineAssets
    throw UnimplementedError();
  }

  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) {
    // TODO: implement syncUserWithAwsIncognito
    throw UnimplementedError();
  }

  @override
  Stream<double> totalSales({required int branchId}) {
    // TODO: implement totalSales
    throw UnimplementedError();
  }

  @override
  Future<List<UnversalProduct>> universalProductNames({required int branchId}) {
    // TODO: implement universalProductNames
    throw UnimplementedError();
  }

  @override
  void updateAccess(
      {required String accessId,
      required int userId,
      required String featureName,
      required String accessLevel,
      required String status,
      required int branchId,
      required int businessId,
      required String userType}) {
    // TODO: implement updateAccess
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
  Future<void> updateCredit(Credit credit) {
    // TODO: implement updateCredit
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
  FutureOr<void> updateUnit(
      {required String unitId, String? name, bool? active, int? branchId}) {
    // TODO: implement updateUnit
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPdfToS3(Uint8List pdfData, String fileName,
      {required String transactionId}) {
    // TODO: implement uploadPdfToS3
    throw UnimplementedError();
  }

  @override
  Future<CustomerPayments> upsertPayment(CustomerPayments payment) {
    // TODO: implement upsertPayment
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Future<VariantBranch?> variantBranch(
      {required String variantId, required String destinationBranchId}) {
    // TODO: implement variantBranch
    throw UnimplementedError();
  }

  @override
  void whoAmI() {
    print("I am the son of Capella ");
  }

  @override
  // TODO: implement apihub
  String get apihub => throw UnimplementedError();

  @override
  Future<DatabaseSyncInterface> configureCapella(
      {required bool useInMemory, required LocalStorage box}) {
    // TODO: implement configureCapella
    throw UnimplementedError();
  }

  @override
  Future<DatabaseSyncInterface> configureLocal(
      {required bool useInMemory, required LocalStorage box}) async {
    return this;
  }

  final Talker _talker = Talker();

  @override
  Talker get talker => _talker;

  @override
  Future<Plan?> getPaymentPlan(
      {required String businessId, bool? fetchOnline}) {
    // TODO: implement getPaymentPlan
    throw UnimplementedError();
  }

  @override
  FutureOr<Pin?> getPinLocal(
      {int? userId, String? phoneNumber, required bool alwaysHydrate}) {
    // TODO: implement getPinLocal
    throw UnimplementedError();
  }
}
