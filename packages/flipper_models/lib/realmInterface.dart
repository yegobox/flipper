import 'dart:typed_data';

import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/RwApiResponse.dart';
import 'package:flipper_models/helperModels/social_token.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:realm/realm.dart';

extension StringToIntList on String? {
  List<int> toIntList() {
    if (this == null) {
      print('Input string is null');
      return []; // Return an empty list if the input is null
    }

    return this!
        .split(',')
        .map((e) => e.trim())
        .where((e) => int.tryParse(e) != null) // Filter out invalid elements
        .map(int.parse)
        .toList();
  }
}

abstract class SyncReaml<M extends IJsonSerializable> implements Sync {
  factory SyncReaml.create() => RealmAPI<M>();

  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments);

  void close();
}

abstract class RealmApiInterface {
  Future<List<Product>> products({required int branchId});

  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password});

  Future<double> stocks({int? productId, int? variantId});
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

  Stream<List<ITransaction>> orders({required int branchId});
  Future<List<Product>> getProductList({int? prodIndex, required int branchId});
  Stock? stockByVariantId(
      {required int variantId,
      required int branchId,
      bool nonZeroValue = false});
  Future<Stock?> stockByVariantIdFuture(
      {required int variantId, bool nonZeroValue = false});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Category? activeCategory({required int branchId});
  Future<List<IUnit>> units({required int branchId});
  T? create<T>({required T data});
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
  });
  Configurations getByTaxType({required String taxtype});
  Variant? variant({int? variantId, String? name});
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

  Product? getProduct({required int id});
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

  ///create an transaction if no pending transaction exist should create a new one
  ///then if it exist should return the existing one!
  ITransaction manageTransaction(
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
  Stream<List<ITransaction>> transactionList(
      {DateTime? startDate, DateTime? endDate});
  Future<Variant?> getCustomVariant({
    required int businessId,
    required int branchId,
    required int tinNumber,
    required String bhFId,
  });
  // Future<Spenn> spennPayment({required double amount, required phoneNumber});
  ITransaction collectPayment({
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

// app settings and users settings
  Future<Setting?> getSetting({required int businessId});

  Future<Setting?> createSetting({required Setting setting});
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
  Future assignCustomerToTransaction(
      {required int customerId, int? transactionId});
  Future removeCustomerFromTransaction(
      {required int customerId, required int transactionId});
  Customer? getCustomer({String? key, int? id});
  List<Customer> getCustomers({String? key, int? id});
  Future<Customer?> getCustomerFuture({String? key, int? id});

  ITransaction? getTransactionById({required int id});
  Future<List<ITransaction>> tickets();
  Stream<List<ITransaction>> ticketsStreams();
  Stream<List<ITransaction>> transactionStreamById(
      {required int id, required FilterType filterType});
  Future<int> deleteTransactionByIndex({required int transactionIndex});

  Stream<List<Variant>> getVariantByProductIdStream({int? productId});

  Future<int> sendReport({required List<TransactionItem> transactionItems});
  Future<void> createGoogleSheetDoc({required String email});
  TransactionItem? getTransactionItemByVariantId(
      {required int variantId, int? transactionId});
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId});

  //abstract method to update business

  //analytics
  int lifeTimeCustomersForbranch({required String branchId});

  //save discount
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<List<Discount>> getDiscounts({required int branchId});

  void addTransactionItem(
      {required ITransaction transaction,
      required TransactionItem item,
      required bool partOfComposite});

  void emptySentMessageQueue();
  bool suggestRestore();

  Future<int> userNameAvailable(
      {required String name, required HttpClientInterface flipperHttpClient});

  Future<List<Tenant>> tenants({int? businessId});
  Future<Tenant?> getTenantBYUserId({required int userId});

  Future<Tenant?> getTenantBYPin({required int pin});

  Future<void> syncProduct(
      {required Product product,
      required Variant variant,
      required Stock stock});
  bool isSubscribed({required String feature, required int businessId});
  bool subscribe({
    required String feature,
    required int businessId,
    required int agentCode,
  });
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

  Stream<List<ITransaction>> transactionsStream({
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

  Future<List<TransactionItem>> transactionItemsFuture(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active});

  Variant? getVariantById({required int id});
  bool isTaxEnabled({required Business business});
  Future<Receipt?> createReceipt(
      {required RwApiResponse signature,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter});
  Future<Receipt?> getReceipt({required int transactionId});

  Future<void> refund({required int itemId});

  Future<int> size<T>({required T object});
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType});
  // Future<void> loadCounterFromOnline({required int businessId});

  Future<String> dbPath({required String path, int? folder});
  Future<bool> bindProduct({required int productId, required int tenantId});
  Future<Product?> findProductByTenantId({required int tenantId});

  Future<void> deleteAllProducts();
  Future<Stock?> getStockById({required int id});

  /// socials methods
  // Stream<Social> socialsStream({required int branchId});
  // Future<Social?> getSocialById({required int id});

  // Future<List<BusinessType>> businessTypes();

  /// list messages
  Stream<List<Conversation>> conversations({String? conversationId});
  Future<void> sendScheduleMessages();
  Future<Conversation?> getConversation({required String messageId});
  Future<List<Conversation>> getScheduleMessages();
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password});
  // Future<SocialToken?> loginOnSocial(
  //     {String? phoneNumberOrEmail, String? password});
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId});

  Stream<List<Conversation>> getTop5RecentConversations();

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
        List<ITransaction> transactions,
        List<TransactionItem> transactionItems
      })> getUnSyncedData();
  Future<Conversation> sendMessage(
      {required String message, required Conversation latestConversation});
  Future<EBM?> getEbmByBranchId({required int branchId});

  // Future<ITenant> authState({required int branchId});

  Stream<Tenant?> authState({required int branchId});

  Future<void> recordUserActivity(
      {required int userId, required String activity});

  Future<List<Customer>> customers({required int branchId});
  void close();
  void clear();
  // Future<List<SyncRecord>> syncedModels({required int branchId});
  // Future<Permission?> permission({required int userId});

  Future<List<BusinessType>> businessTypes();
  Future<IPin?> getPin(
      {required String pin, required HttpClientInterface flipperHttpClient});

  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active});

  Future<RealmApiInterface> configure(
      {required bool useInMemoryDb,
      bool useFallBack = false,
      Realm? localRealm,
      String? encryptionKey,
      int? businessId,
      int? branchId,
      int? userId});
  Realm? realm;
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

  /// drawers
  bool isDrawerOpen({required int cashierId, required int branchId});
  Future<Drawers?> getDrawer({required int cashierId});

  Drawers? openDrawer({required Drawers drawer});
  Stream<List<TransactionItem>> transactionItemList(
      {DateTime? startDate, DateTime? endDate, bool? isPluReport});

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
  RealmApiInterface instance();
  Tenant? tenant({int? businessId, int? userId});
  Stream<List<Report>> reports({required int branchId});
  Report report({required int id});

  Future<
      ({
        double grossProfit,
        double netProfit,
      })> getReportData();

  /// determine if current running user is admin
  bool isAdmin({required int userId});
  Future<LPermission?> permission({required int userId});
  List<LPermission> permissions({required int userId});
  List<Access> access({required int userId});
  List<StockRequest> requests({required int branchId});
}
