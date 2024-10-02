import 'dart:convert';
import 'dart:typed_data';

import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/iuser.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/helperModels/tenant.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:http/src/response.dart';
import 'package:realm_dart/src/realm_class.dart';

import 'package:amplify_flutter/amplify_flutter.dart' as amplify;
// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart' as cognito;

abstract class RealmViaHttp {
  Future<bool> isCouponValid(
      {required HttpClientInterface flipperHttpClient,
      required String couponCode});
  Future<bool> isPaymentComplete(
      {required HttpClientInterface flipperHttpClient,
      required int businessId});
  Future<bool> hasAcessSaved(
      {required HttpClientInterface flipperHttpClient,
      required int businessId});
}

class RealmViaHttpService implements RealmViaHttp, RealmApiInterface {
  @override
  Business? getBusinessById({required int businessId}) {
    return null;
  }

  @override
  Pin? savePin({required Pin pin}) {
    return null;
  }

  @override
  void savePaymentType({required TransactionPaymentRecord paymentRecord}) {}

  @override
  void updateCounters({
    required List<Counter> counters,
    required RwApiResponse receiptSignature,
  }) {}
  @override
  List<TransactionPaymentRecord> getPaymentType({required int transactionId}) {
    return [];
  }

  @override
  void updateTransactionStatus(ITransaction transaction, String receiptType) {}

  @override
  void saveStock({required Variant variant}) {}
  @override
  Future<bool> hasAcessSaved(
      {required HttpClientInterface flipperHttpClient,
      required int businessId}) async {
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json'
    };
    final response = await flipperHttpClient.post(
        headers: headers,
        Uri.parse(AppSecrets.mongoBaseUrl + '/data/v1/action/find'),
        body: json.encode({
          "collection": AppSecrets.AccessCollection,
          "database": AppSecrets.database,
          "dataSource": AppSecrets.dataSource,
          "filter": {"businessId": businessId}
        }));
    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List documents = responseData['documents'] ?? [];

      if (documents.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      // If the status code is not 200, return false
      return false;
    }
  }

  @override
  void updateTransactionItemQty(
      {required qty, required int transactionItemId}) {
    throw UnimplementedError();
  }

  @override
  Future<Stream<double>> downloadAsset(
      {required int branchId,
      required String assetName,
      required String subPath}) {
    throw UnimplementedError();
  }

  @override
  Future<bool> isCouponValid(
      {required HttpClientInterface flipperHttpClient,
      required String couponCode}) async {
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json'
    };
    final response = await flipperHttpClient.post(
        headers: headers,
        Uri.parse(AppSecrets.mongoBaseUrl + '/data/v1/action/find'),
        body: json.encode({
          "collection": AppSecrets.flipperCompaignCollection,
          "database": AppSecrets.database,
          "dataSource": AppSecrets.dataSource,
          "filter": {"couponCode": couponCode}
        }));
    if (response.statusCode == 200) {
      // Parse the response body
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List documents = responseData['documents'] ?? [];

      if (documents.isNotEmpty) {
        // Print the discountRate of the first document
        final discountRate = documents.first['discountRate'];
        print('Discount Rate: $discountRate');
        return true;
      } else {
        return false;
      }
    } else {
      // If the status code is not 200, return false
      return false;
    }
  }

  @override
  Future<bool> isPaymentComplete(
      {required HttpClientInterface flipperHttpClient,
      required int businessId}) async {
    var headers = {
      'api-key': AppSecrets.apikey,
      'Content-Type': 'application/json'
    };
    final response = await flipperHttpClient.post(
        headers: headers,
        Uri.parse(AppSecrets.mongoBaseUrl + '/data/v1/action/find'),
        body: json.encode({
          "collection": AppSecrets.paymentPlanCollection,
          "database": AppSecrets.database,
          "dataSource": AppSecrets.dataSource,
          "filter": {"businessId": businessId}
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List documents = responseData['documents'] ?? [];
      if (documents.isNotEmpty) {
        // Print the discountRate of the first document
        return documents.first['paymentCompletedByUser'];
      } else {
        return false;
      }
    }
    return false;
  }

  @override
  Realm? realm;

  @override
  List<Access> access({required int userId}) {
    // TODO: implement access
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
  Future<Stock?> addStockToVariant({required Variant variant}) {
    // TODO: implement addStockToVariant
    throw UnimplementedError();
  }

  @override
  void addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite}) {
    // TODO: implement addTransactionItem
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
  Future<void> amplifyLogout() async {
    try {
      amplify.Amplify.Auth.signOut();
    } catch (e) {}
  }

  @override
  void assignCustomerToTransaction(
      {required int customerId, int? transactionId}) {
    // TODO: implement assignCustomerToTransaction
    throw UnimplementedError();
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
  Future<List<BusinessType>> businessTypes() {
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
  void close() {
    // TODO: implement close
  }

  @override
  ITransaction collectPayment(
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
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE}) {
    // TODO: implement completedTransactions
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
  Future<RealmApiInterface> configure(
      {required bool useInMemoryDb,
      bool useFallBack = false,
      Realm? localRealm,
      String? encryptionKey,
      int? businessId,
      int? branchId,
      int? userId}) {
    // TODO: implement configure
    throw UnimplementedError();
  }

  @override
  void consumePoints({required int userId, required int points}) {
    // TODO: implement consumePoints
  }

  @override
  Future<Voucher?> consumeVoucher({required int voucherCode}) {
    // TODO: implement consumeVoucher
    throw UnimplementedError();
  }

  @override
  Stream<List<Conversation>> conversations({String? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError();
  }

  @override
  T? create<T>({required T data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> createGoogleSheetDoc({required String email}) {
    // TODO: implement createGoogleSheetDoc
    throw UnimplementedError();
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
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter}) {
    // TODO: implement createReceipt
    throw UnimplementedError();
  }

  @override
  Future<Setting?> createSetting({required Setting setting}) {
    // TODO: implement createSetting
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
  Future<bool> delete(
      {required int id,
      String? endPoint,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAllProducts() {
    // TODO: implement deleteAllProducts
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
  Future<Stream<double>> downloadAssetSave(
      {String? assetName, String? subPath = "branch"}) {
    // TODO: implement downloadAssetSave
    throw UnimplementedError();
  }

  @override
  void emptySentMessageQueue() {
    // TODO: implement emptySentMessageQueue
  }

  @override
  Future<bool> enableAttendance(
      {required int businessId, required String email}) {
    // TODO: implement enableAttendance
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
  Assets? getAsset({String? assetName, int? productId}) {
    // TODO: implement getAsset
    throw UnimplementedError();
  }

  @override
  Configurations getByTaxType({required String taxtype}) {
    // TODO: implement getByTaxType
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required int id}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) {
    // TODO: implement getConversation
    throw UnimplementedError();
  }

  @override
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) {
    // TODO: implement getCounter
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
  Customer? getCustomer({String? key, int? id}) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getCustomerFuture({String? key, int? id}) {
    // TODO: implement getCustomerFuture
    throw UnimplementedError();
  }

  @override
  List<Customer> getCustomers({String? key, int? id}) {
    // TODO: implement getCustomers
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
  Future<List<Discount>> getDiscounts({required int branchId}) {
    // TODO: implement getDiscounts
    throw UnimplementedError();
  }

  @override
  void saveEbm(
      {required int branchId,
      required String severUrl,
      required String bhFId}) {
    // TODO: implement getEbmByBranchId
    throw UnimplementedError();
  }

  @override
  EBM? ebm({required int branchId}) {
    // TODO: implement getEbmByBranchId
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
  FlipperSaleCompaign? getLatestCompaign() {
    // TODO: implement getLatestCompaign
    throw UnimplementedError();
  }

  @override
  PaymentPlan? getPaymentPlan({required int businessId}) {
    // TODO: implement getPaymentPlan
    throw UnimplementedError();
  }

  @override
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement getPin
    throw UnimplementedError();
  }

  @override
  Product? getProduct({required int id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProductByBarCode(
      {required String barCode, required int branchId}) {
    // TODO: implement getProductByBarCode
    throw UnimplementedError();
  }

  @override
  Future<List<Product?>> getProductByName(
      {required String name, required int branchId}) {
    // TODO: implement getProductByName
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductList(
      {int? prodIndex, required int branchId}) {
    // TODO: implement getProductList
    throw UnimplementedError();
  }

  @override
  List<Product> getProducts({String? key}) {
    // TODO: implement getProducts
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
  Future<List<Conversation>> getScheduleMessages() {
    // TODO: implement getScheduleMessages
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSetting({required int businessId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSocialSetting() {
    // TODO: implement getSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock({required int branchId, required int variantId}) {
    // TODO: implement getStock
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStockById({required int id}) {
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
  Tenant getTenant({required int userId}) {
    // TODO: implement getTenant
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> getTenantBYPin({required int pin}) {
    // TODO: implement getTenantBYPin
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> getTenantBYUserId({required int userId}) {
    // TODO: implement getTenantBYUserId
    throw UnimplementedError();
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  ITransaction? getTransactionById({required int id}) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) {
    // TODO: implement getTransactionItemById
    throw UnimplementedError();
  }

  @override
  TransactionItem? getTransactionItemByVariantId(
      {required int variantId, int? transactionId}) {
    // TODO: implement getTransactionItemByVariantId
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
  Variant? getVariantById({required int id}) {
    // TODO: implement getVariantById
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
  RealmApiInterface instance() {
    // TODO: implement instance
    throw UnimplementedError();
  }

  @override
  bool isAdmin({required int userId, required String appFeature}) {
    // TODO: implement isAdmin
    throw UnimplementedError();
  }

  @override
  bool isRealmClosed() {
    // TODO: implement isRealmClosed
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  bool isTaxEnabled({required Business business}) {
    // TODO: implement isTaxEnabled
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
  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password}) {
    // TODO: implement loginOnSocial
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
  ITransaction manageTransaction(
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
  Future<void> markModelForEbmUpdate<T>(
      {required T model, bool updated = true}) {
    // TODO: implement markModelForEbmUpdate
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Stream<PaymentPlan?> paymentPlanStream({required int businessId}) {
    // TODO: implement paymentPlanStream
    throw UnimplementedError();
  }

  @override
  Future<LPermission?> permission({required int userId}) {
    // TODO: implement permission
    throw UnimplementedError();
  }

  @override
  List<LPermission> permissions({required int userId}) {
    // TODO: implement permissions
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
  Future<void> recordUserActivity(
      {required int userId, required String activity}) {
    // TODO: implement recordUserActivity
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
  void removeCustomerFromTransaction({required ITransaction transaction}) {
    // TODO: implement removeCustomerFromTransaction
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
  Future<PaymentPlan> saveOrUpdatePaymentPlan(
      {required int businessId,
      required String selectedPlan,
      required int additionalDevices,
      required bool isYearlyPlan,
      required double totalPrice,
      required int payStackUserId,
      required String paymentMethod,
      String? customerCode,
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
  Future<Conversation> sendMessage(
      {required String message, required Conversation latestConversation}) {
    // TODO: implement sendMessage
    throw UnimplementedError();
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<void> sendScheduleMessages() {
    // TODO: implement sendScheduleMessages
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
  Stream<double> soldStockValue({required branchId}) {
    // TODO: implement soldStockValue
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
  Future<Stock?> stockByVariantIdFuture(
      {required int variantId, bool nonZeroValue = false}) {
    // TODO: implement stockByVariantIdFuture
    throw UnimplementedError();
  }

  @override
  Stream<double> stockValue({required branchId}) {
    // TODO: implement stockValue
    throw UnimplementedError();
  }

  @override
  Future<double> totalStock({int? productId, int? variantId}) {
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
  Future<List<ITransaction>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> ticketsStreams() {
    // TODO: implement ticketsStreams
    throw UnimplementedError();
  }

  @override
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport}) {
    // TODO: implement transactionItemList
    throw UnimplementedError();
  }

  @override
  List<TransactionItem> transactionItems(
      {required int transactionId,
      required bool doneWithTransaction,
      required int branchId,
      required bool active}) {
    // TODO: implement transactionItems
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
  Stream<List<ITransaction>> transactionList(
      {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement transactionList
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> transactionStreamById(
      {required int id, required FilterType filterType}) {
    // TODO: implement transactionStreamById
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
  Stream<List<ITransaction>> transactionsStream(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) {
    // TODO: implement transactionsStream
    throw UnimplementedError();
  }

  @override
  Future<List<IUnit>> units({required int branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<List<Device>> unpublishedDevices({required int businessId}) {
    // TODO: implement unpublishedDevices
    throw UnimplementedError();
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
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
  Variant? variant({int? variantId, String? name}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  List<Variant> variants(
      {required int branchId, int? productId, int? page, int? itemsPerPage}) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  @override
  Future<Branch> activeBranch() {
    // TODO: implement activeBranch
    throw UnimplementedError();
  }

  @override
  Future<Business?> activeBusinesses({required int userId}) {
    // TODO: implement activeBusinesses
    throw UnimplementedError();
  }

  @override
  Future<List<Activity>> activities({required int userId}) {
    // TODO: implement activities
    throw UnimplementedError();
  }

  @override
  Future<Branch> addBranch(
      {required String name,
      required int businessId,
      required String location,
      required String userOwnerPhoneNumber,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement addBranch
    throw UnimplementedError();
  }

  @override
  Branch? branch({required int serverId}) {
    // TODO: implement branch
    throw UnimplementedError();
  }

  @override
  List<Branch> branches({required int businessId, bool? includeSelf = false}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  List<Business> businesses() {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  void clearData({required ClearData data}) {
    // TODO: implement clearData
  }

  @override
  Future<RealmApiInterface> configureLocal({required bool useInMemory}) {
    // TODO: implement configureLocal
    throw UnimplementedError();
  }

  @override
  Future<void> configureRemoteRealm(String userPhone, IUser user,
      {Realm? realm}) {
    // TODO: implement configureRemoteRealm
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
  Business getBusiness({int? businessId}) {
    // TODO: implement getBusiness
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId(
      {required int id, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement getBusinessFromOnlineGivenId
    throw UnimplementedError();
  }

  @override
  Future<Business> getBusinessFuture({int? businessId}) {
    // TODO: implement getBusinessFuture
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) {
    // TODO: implement getDrawer
    throw UnimplementedError();
  }

  @override
  bool isDrawerOpen({required int cashierId, required int branchId}) {
    // TODO: implement isDrawerOpen
    throw UnimplementedError();
  }

  @override
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      required Pin pin,
      bool stopAfterConfigure = false,
      required HttpClientInterface flipperHttpClient}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  AppNotification notification({required int id}) {
    // TODO: implement notification
    throw UnimplementedError();
  }

  @override
  Stream<List<AppNotification>> notificationStream({required int identifier}) {
    // TODO: implement notificationStream
    throw UnimplementedError();
  }

  @override
  void notify({required AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  Drawers? openDrawer({required Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Future<void> refreshSession({required int branchId, int? refreshRate = 5}) {
    // TODO: implement refreshSession
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required HttpClientInterface flipperHttpClient,
      required String userType}) {
    // TODO: implement saveTenant
    throw UnimplementedError();
  }

  @override
  Future<Response> sendLoginRequest(String phoneNumber,
      HttpClientInterface flipperHttpClient, String apihub) {
    // TODO: implement sendLoginRequest
    throw UnimplementedError();
  }

  @override
  Future<List<ITenant>> signup(
      {required Map business, required HttpClientInterface flipperHttpClient}) {
    // TODO: implement signup
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
  Future<List<UnversalProduct>> universalProductNames({required int branchId}) {
    // TODO: implement universalProductNames
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
  Drawers? closeDrawer({required Drawers drawer, required double eod}) {
    // TODO: implement closeDrawer
    throw UnimplementedError();
  }

  @override
  List<String> activeRealmSubscriptions() {
    // TODO: implement activeRealmSubscriptions
    throw UnimplementedError();
  }

  @override
  Future<void> forceSubs(
      {int? businessId, Realm? localRealm, int? branchId, int? userId}) {
    // TODO: implement forceSubs
    throw UnimplementedError();
  }

  @override
  Stream<List<StockRequest>> requestsStream(
      {required int branchId, required String filter}) {
    // TODO: implement requestsStream
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
  List<Stock> stocks({required int branchId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  void updateStock({required int stockId, required double qty}) {
    // TODO: implement updateStock
  }
}

class RealmViaHttpServiceMock implements RealmViaHttp {
  @override
  Future<bool> isCouponValid(
      {required HttpClientInterface flipperHttpClient,
      required String couponCode}) async {
    return true;
  }

  @override
  Future<bool> isPaymentComplete(
      {required HttpClientInterface flipperHttpClient,
      required int businessId}) async {
    return true;
  }

  @override
  Future<bool> hasAcessSaved(
      {required HttpClientInterface flipperHttpClient,
      required int businessId}) {
    // TODO: implement hasAcessSaved
    throw UnimplementedError();
  }
}
