import 'package:flipper_models/RealmApi.dart';
import 'package:flipper_models/isar/business_type.dart';
import 'package:flipper_models/isar/iuser.dart';
import 'package:flipper_models/isar/pin.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/isar/social_token.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:flipper_services/constants.dart';
import 'package:realm/realm.dart';

import 'isar/tenant.dart';

extension StringToIntList on String {
  List<int> toIntList() {
    return this.split(',').map((e) => int.parse(e.trim())).toList();
  }
}

abstract class SyncReaml<M extends IJsonSerializable> implements Sync {
  factory SyncReaml.create() => RealmAPI<M>();

  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments);

  void close();

  Future<bool> logout();
}

abstract class RealmApiInterface {
  Future<List<Product>> products({required int branchId});
  Future<List<ITenant>> signup({required Map business});
  Future<ITransaction?> pendingTransaction(
      {required int branchId, required String transactionType});
  // Future<IUser> login(
  //     {required String userPhone, required bool skipDefaultAppSetup});
  Future<List<Business>> businesses({required int userId});
  Future<SocialToken?> loginOnSocial(
      {String? phoneNumberOrEmail, String? password});
  Future<Business> getOnlineBusiness({required int userId});
  Future<List<Branch>> branches({int? businessId});
  Future<double> stocks({int? productId, int? variantId});
  Stream<double> getStockStream({int? productId, int? variantId});
  Future<List<ITransaction>> transactionsFuture({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
  });
  Stream<List<Product>> productStreams({int? prodIndex});

  Stream<List<ITransaction>> orders({required int branchId});
  Future<List<Product>> getProductList({int? prodIndex});
  Future<Stock?> stockByVariantId(
      {required int variantId, bool nonZeroValue = false});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Future<Category?> activeCategory({required int branchId});
  Future<List<IUnit>> units({required int branchId});
  T? create<T>({required T data});
  Stream<double> getStockValue({required int branchId});
  Future<int> update<T>({required T data, bool localUpdate = false});

  Future<bool> delete({required int id, String? endPoint});
  Future<PColor?> getColor({required int id});
  Future<Stock?> getStock({required int branchId, required int variantId});
  Future<List<Variant>> variants({
    required int branchId,
    int? productId,
  });
  Future<Variant?> variant({int? variantId, String? name});
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units});

  Future<int> addVariant({required List<Variant> variations});

  Future<int> addFavorite({required Favorite data});
  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required int favId});
  Future<Favorite?> getFavoriteByProdId({required int prodId});
  Future<Favorite?> getFavoriteByIndex({required int favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex});
  Stream<Tenant?> getDefaultTenant({required int businessId});
  Future<int> deleteFavoriteByIndex({required int favIndex});

  Future<Product?> getProduct({required int id});
  Future<Product?> getProductByBarCode({required String barCode});
  Future<List<Product?>> getProductByName({required String name});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<Product?> createProduct(
      {required Product product, bool skipRegularVariant = false});
  Future<void> logOut();
  Future<void> logOutLight();

  Future<Voucher?> consumeVoucher({required int voucherCode});

  ///create an transaction if no pending transaction exist should create a new one
  ///then if it exist should return the existing one!
  Future<ITransaction> manageTransaction({required String transactionType});

  Future<ITransaction> manageCashInOutTransaction(
      {required String transactionType});

  Future<List<ITransaction>> completedTransactions(
      {required int branchId, String? status = COMPLETE});
  Future<TransactionItem?> getTransactionItemById({required int id});
  Stream<List<ITransaction>> transactionList(
      {DateTime? startDate, DateTime? endDate});
  Future<Variant?> getCustomVariant();
  // Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<void> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType});

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

  Future<List<Business>> getContacts();

  Future<Business> getBusiness({int? businessId});
  Future<Customer?> addCustomer(
      {required Customer customer, required int transactionId});
  Future assignCustomerToTransaction(
      {required int customerId, int? transactionId});
  Future removeCustomerFromTransaction(
      {required int customerId, required int transactionId});
  Future<Customer?> getCustomer({String? key, int? id});

  Future<ITransaction?> getTransactionById({required int id});
  Future<List<ITransaction>> tickets();
  Stream<List<ITransaction>> ticketsStreams();
  Stream<List<ITransaction>> getTransactionsByCustomerId(
      {required int customerId});
  Future<int> deleteTransactionByIndex({required int transactionIndex});

  Future<List<Variant>> getVariantByProductId({int? productId});
  Stream<List<Variant>> getVariantByProductIdStream({int? productId});

  Future<int> sendReport({required List<TransactionItem> transactionItems});
  Future<void> createGoogleSheetDoc({required String email});
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, required int? transactionId});
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required int? transactionId});
  //abstract method to update business

  //analytics
  int lifeTimeCustomersForbranch({required String branchId});

  //save discount
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<List<Discount>> getDiscounts({required int branchId});

  Future<void> addTransactionItem(
      {required ITransaction transaction, required TransactionItem item});

  void emptySentMessageQueue();
  bool suggestRestore();

  Future<int> userNameAvailable({required String name});
  Future<IUser> login(
      {required String userPhone,
      required bool skipDefaultAppSetup,
      bool stopAfterConfigure = false});

  Future<LPermission?> permission({required int userId});

  Future<List<Tenant>> tenants({int? businessId});
  Future<Tenant?> getTenantBYUserId({required int userId});
  Future<Branch> activeBranch();
  Future<Tenant?> getTenantBYPin({required int pin});
  Future<List<ITenant>> tenantsFromOnline({required int businessId});
  Future<Business?> getBusinessFromOnlineGivenId({required int id});

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
  Future<Tenant> saveTenant(String phoneNumber, String name,
      {required Business business,
      required Branch branch,
      required String userType});
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
  Future<List<TransactionItem>> transactionItems(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active});

  Future<Variant?> getVariantById({required int id});
  bool isTaxEnabled();
  Future<Receipt?> createReceipt(
      {required EBMApiResponse signature,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter});
  Future<Receipt?> getReceipt({required int transactionId});

  Future<void> refund({required int itemId});
  Future<bool> isDrawerOpen({required int cashierId});
  Future<Drawers?> getDrawer({required int cashierId});
  Future<Branch?> defaultBranch();
  Future<Business?> defaultBusiness();
  Future<Drawers?> openDrawer({required Drawers drawer});

  Future<int> size<T>({required T object});
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType});
  Future<void> loadCounterFromOnline({required int businessId});

  String dbPath();
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

  Future<void> refreshSession({required int branchId, int? refreshRate = 5});
  Stream<Tenant?> authState({required int branchId});

  // Future<List<UserActivity>> activities({required int userId});
  Future<void> recordUserActivity(
      {required int userId, required String activity});

  Future<List<Customer>> customers({required int branchId});

  void clear();
  // Future<List<SyncRecord>> syncedModels({required int branchId});
  // Future<Permission?> permission({required int userId});

  Future<List<BusinessType>> businessTypes();
  Future<IPin?> getPin({required String pin});
  bool isRealmClosed();
  Future<RealmApiInterface> configure({required bool inTesting});
  Stream<List<TransactionItem>> transactionItemsStreams(
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active});
}
