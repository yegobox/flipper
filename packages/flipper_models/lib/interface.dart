import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';

abstract class IsarApiInterface {
  Future<List<Product>> products({required int branchId});
  Future<List<Tenant>> signup({required Map business});
  Future<ITransaction?> pendingTransaction(
      {required int branchId, required String transactionType});
  Future<IUser> login(
      {required String userPhone, required bool skipDefaultAppSetup});
  Future<List<Business>> businesses({int? userId});
  Future<Business> getOnlineBusiness({required int userId});
  Future<List<Branch>> branches({int? businessId});
  Future<double> stocks({String? productId, String? variantId});
  Stream<double> getStockStream({String? productId, String? variantId});
  Future<List<ITransaction>> transactionsFuture({
    String? status,
    String? transactionType,
    int? branchId,
    bool isCashOut = false,
    bool includePending = false,
  });
  Stream<List<Product>> productStreams({String? prodIndex});
  Stream<List<ITransaction>> orders({required int branchId});
  Future<List<Product>> getProductList({String? prodIndex});
  Future<Stock> stockByVariantId(
      {required String variantId, bool nonZeroValue = false});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Future<Category?> activeCategory({required int branchId});
  Future<List<IUnit>> units({required int branchId});
  T? create<T>({required T data});
  Stream<double> getStockValue({required int branchId});
  Future<int> update<T>({required T data, bool localUpdate = false});

  Future<bool> delete({required String id, String? endPoint});
  Future<PColor?> getColor({required String id, String? endPoint});
  Future<Stock?> getStock({required int branchId, required String variantId});
  Future<List<Variant>> variants({
    required int branchId,
    String? productId,
  });
  Future<Variant?> variant({String? variantId, String? name});
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units});

  Future<int> addVariant({required List<Variant> variations});

  Future<int> addFavorite({required Favorite data});
  Future<List<Favorite>> getFavorites();
  Future<Favorite?> getFavoriteById({required int favId});
  Future<Favorite?> getFavoriteByProdId({required String prodId});
  Future<Favorite?> getFavoriteByIndex({required int favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required int favIndex});
  Stream<ITenant?> getDefaultTenant({required int businessId});
  Future<int> deleteFavoriteByIndex({required int favIndex});

  Future<Product?> getProduct({required String id});
  Future<Product?> getProductByBarCode({required String barCode});
  Future<List<Product?>> getProductByName({required String name});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<Product> createProduct(
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
  Future<TransactionItem?> getTransactionItemById({required String id});

  Future<Variant?> getCustomVariant();
  Future<Spenn> spennPayment({required double amount, required phoneNumber});
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

  Future<Business?> getBusiness({int? businessId});
  Future<Customer?> addCustomer(
      {required Map customer, required String transactionId});
  Future assingTransactionToCustomer(
      {required String customerId, String? transactionId});
  Future<Customer?> getCustomer({String? key, String? transactionId});

  ITransaction? getTransactionById({required String id});
  Future<List<ITransaction>> tickets();
  Stream<List<ITransaction>> ticketsStreams();
  Stream<List<ITransaction>> getTransactionsByCustomerId(
      {required String customerId});
  Future<int> deleteTransactionByIndex({required String transactionIndex});

  Future<List<Variant>> getVariantByProductId({String? productId});
  Stream<List<Variant>> getVariantByProductIdStream({String? productId});

  Future<int> sendReport({required List<TransactionItem> transactionItems});
  Future<void> createGoogleSheetDoc({required String email});
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required String variantId, required String? transactionId});
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required String? transactionId});
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

  Future<List<ITenant>> tenants({int? businessId});
  Future<ITenant?> getTenantBYUserId({required int userId});
  Future<ITenant?> getTenantBYPin({required int pin});
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

  Future<Profile?> profile({required int businessId});
  Future<Profile?> updateProfile({required Profile profile});
  Future<Tenant> saveTenant(String phoneNumber, String name,
      {required Business business, required Branch branch});
  Pointss addPoint({required int userId, required int point});
  Future<Subscription?> addUpdateSubscription({
    required int userId,
    required int interval,
    required double recurringAmount,
    required String descriptor,
    required List<Feature> features,
  });
  Future<Subscription?> getSubscription({required int userId});
  Future<Pointss?> getPoints({required int userId});
  void consumePoints({required int userId, required int points});
  Future<Pin?> createPin();
  Future<Pin?> getPin({required String pin});

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
      {required String transactionId,
      required bool doneWithTransaction,
      required bool active});

  Future<Variant?> getVariantById({required String id});
  Future<bool> isTaxEnabled();
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
      required ITransaction transaction,
      required String qrCode,
      required String receiptType,
      required Counter counter});
  Future<Receipt?> getReceipt({required String transactionId});

  Future<void> refund({required String itemId});
  Future<bool> isDrawerOpen({required int cashierId});
  Future<Drawers?> getDrawer({required int cashierId});
  Future<Branch?> defaultBranch();
  Future<Business?> defaultBusiness();
  Future<Drawers?> openDrawer({required Drawers drawer});

  Future<int> size<T>({required T object});
  Future<Counter?> nSCounter({required int branchId});
  Future<Counter?> cSCounter({required int branchId});
  Future<Counter?> nRSCounter({required int branchId});
  Future<Counter?> tSCounter({required int branchId});
  Future<Counter?> pSCounter({required int branchId});
  Future<void> loadCounterFromOnline({required int businessId});

  String dbPath();
  Future<Customer?> nGetCustomerByTransactionId({required String id});
  Future<bool> bindProduct({required String productId, required int tenantId});
  Future<Product?> findProductByTenantId({required int tenantId});

  Future<void> deleteAllProducts();
  Future<Stock?> getStockById({required String id});

  /// socials methods
  Stream<Social> socialsStream({required int branchId});
  Future<Social?> getSocialById({required String id});

  Future<List<BusinessType>> businessTypes();

  /// list messages
  Stream<List<Conversation>> conversations({String conversationId});
  Future<void> sendScheduleMessages();
  Future<Conversation?> getConversation({required String messageId});
  Future<List<Conversation>> getScheduleMessages();
  Future<int> registerOnSocial({String phoneNumberOrEmail, String password});
  Future<SocialToken?> loginOnSocial(
      {String phoneNumberOrEmail, String password});
  Future<bool> isTokenValid(
      {required String tokenType, required int businessId});

  Stream<List<Conversation>> getTop5RecentConversations();

  //
  Future<void> patchSocialSetting({required Setting setting});
  Future<Setting?> getSocialSetting();

  Future<Device?> getDevice(
      {required String phone, required String linkingCode});
  Future<Device?> getDeviceById({required String id});
  Future<List<Device>> getDevices({required int businessId});
  Future<List<Device>> unpublishedDevices({required int businessId});
  Future<void> loadConversations(
      {required int businessId, int? pageSize = 10, String? pk, String? sk});
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId});

  Future<List<Social>> activesocialAccounts({required int branchId});

  Future<Stock?> addStockToVariant({required Variant variant});
  Stream<List<Variant>> geVariantStreamByProductId({required String productId});

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
  Stream<ITenant?> authState({required int branchId});

  Future<List<UserActivity>> activities({required int userId});
  Future<void> recordUserActivity(
      {required int userId, required String activity});

  Future<List<Customer>> customers({required int branchId});

  void clear();
  Future<List<SyncRecord>> syncedModels({required int branchId});
  // Future<double> todayTotalBalance
}
