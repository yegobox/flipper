import 'dart:async';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_models/isar_models.dart';

class IsarAPIMock<M> implements IsarApiInterface {
  @override
  Future<Category?> activeCategory({required int branchId}) {
    // TODO: implement activeCategory
    throw UnimplementedError();
  }

  @override
  Future<List<Social>> activesocialAccounts({required int branchId}) {
    // TODO: implement activesocialAccounts
    throw UnimplementedError();
  }

  @override
  Future<List<UserActivity>> activities({required int userId}) {
    // TODO: implement activities
    throw UnimplementedError();
  }

  @override
  Future<Customer?> addCustomer(
      {required Map customer, required String transactionId}) {
    // TODO: implement addCustomer
    throw UnimplementedError();
  }

  @override
  Future<int> addFavorite({required Favorite data}) {
    // TODO: implement addFavorite
    throw UnimplementedError();
  }

  @override
  Pointss addPoint({required int userId, required int point}) {
    // TODO: implement addPoint
    throw UnimplementedError();
  }

  @override
  Future<Stock?> addStockToVariant({required Variant variant}) {
    // TODO: implement addStockToVariant
    throw UnimplementedError();
  }

  @override
  Future<void> addTransactionItem(
      {required ITransaction transaction, required TransactionItem item}) {
    // TODO: implement addTransactionItem
    throw UnimplementedError();
  }

  @override
  Future<int> addUnits<T>({required List<Map<String, dynamic>> units}) {
    // TODO: implement addUnits
    throw UnimplementedError();
  }

  @override
  Future<Subscription?> addUpdateSubscription(
      {required int userId,
      required int interval,
      required double recurringAmount,
      required String descriptor,
      required List<Feature> features}) {
    // TODO: implement addUpdateSubscription
    throw UnimplementedError();
  }

  @override
  Future<int> addVariant({required List<Variant> variations}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future assingTransactionToCustomer(
      {required String customerId, String? transactionId}) {
    // TODO: implement assingTransactionToCustomer
    throw UnimplementedError();
  }

  @override
  Stream<ITenant?> authState({required int branchId}) {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<bool> bindProduct({required String productId, required int tenantId}) {
    // TODO: implement bindProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({required int businessId}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<List<BusinessType>> businessTypes() {
    // TODO: implement businessTypes
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> businesses({required int userId}) {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  Future<Counter?> cSCounter({required int branchId}) {
    // TODO: implement cSCounter
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> categories({required int branchId}) {
    // TODO: implement categories
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
  Future<void> collectPayment(
      {required double cashReceived,
      required ITransaction transaction,
      required String paymentType}) {
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
  Future<Pin?> createPin() {
    // TODO: implement createPin
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct(
      {required Product product, bool skipRegularVariant = false}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
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
  Future<List<Customer>> customers({required int branchId}) {
    // TODO: implement customers
    throw UnimplementedError();
  }

  @override
  String dbPath() {
    // TODO: implement dbPath
    throw UnimplementedError();
  }

  @override
  Future<Branch?> defaultBranch() {
    // TODO: implement defaultBranch
    throw UnimplementedError();
  }

  @override
  Future<Business?> defaultBusiness() {
    // TODO: implement defaultBusiness
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required String id, String? endPoint}) {
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
  Future<int> deleteTransactionByIndex({required String transactionIndex}) {
    // TODO: implement deleteTransactionByIndex
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
  Stream<List<Variant>> geVariantStreamByProductId(
      {required String productId}) {
    // TODO: implement geVariantStreamByProductId
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusiness({int? businessId}) {
    // TODO: implement getBusiness
    throw UnimplementedError();
  }

  @override
  Future<Business?> getBusinessFromOnlineGivenId({required int id}) {
    // TODO: implement getBusinessFromOnlineGivenId
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required String id, String? endPoint}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Conversation?> getConversation({required String messageId}) {
    // TODO: implement getConversation
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getCustomVariant() {
    // TODO: implement getCustomVariant
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getCustomer({String? key, String? transactionId}) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Stream<ITenant?> getDefaultTenant({required int businessId}) {
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
  Future<Device?> getDeviceById({required String id}) {
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
  Future<Drawers?> getDrawer({required int cashierId}) {
    // TODO: implement getDrawer
    throw UnimplementedError();
  }

  @override
  Future<EBM?> getEbmByBranchId({required int branchId}) {
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
  Future<Favorite?> getFavoriteByProdId({required String prodId}) {
    // TODO: implement getFavoriteByProdId
    throw UnimplementedError();
  }

  @override
  Future<List<Favorite>> getFavorites() {
    // TODO: implement getFavorites
    throw UnimplementedError();
  }

  @override
  Future<Business> getOnlineBusiness({required int userId}) {
    // TODO: implement getOnlineBusiness
    throw UnimplementedError();
  }

  @override
  Future<Pin?> getPin({required String pin}) {
    // TODO: implement getPin
    throw UnimplementedError();
  }

  @override
  Future<Pointss?> getPoints({required int userId}) {
    // TODO: implement getPoints
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProduct({required String id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) {
    // TODO: implement getProductByBarCode
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductList({String? prodIndex}) {
    // TODO: implement getProductList
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) {
    // TODO: implement getReceipt
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
  Future<Social?> getSocialById({required String id}) {
    // TODO: implement getSocialById
    throw UnimplementedError();
  }

  @override
  Future<Setting?> getSocialSetting() {
    // TODO: implement getSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock({required int branchId, required String variantId}) {
    // TODO: implement getStock
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStockById({required String id}) {
    // TODO: implement getStockById
    throw UnimplementedError();
  }

  @override
  Future<Subscription?> getSubscription({required int userId}) {
    // TODO: implement getSubscription
    throw UnimplementedError();
  }

  @override
  Future<ITenant?> getTenantBYPin({required int pin}) {
    // TODO: implement getTenantBYPin
    throw UnimplementedError();
  }

  @override
  Future<ITenant?> getTenantBYUserId({required int userId}) {
    // TODO: implement getTenantBYUserId
    throw UnimplementedError();
  }

  @override
  Stream<List<Conversation>> getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  ITransaction? getTransactionById({required String id}) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required String id}) {
    // TODO: implement getTransactionItemById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required String variantId, required String? transactionId}) {
    // TODO: implement getTransactionItemByVariantId
    throw UnimplementedError();
  }

  @override
  Future<List<TransactionItem>> getTransactionItemsByTransactionId(
      {required String? transactionId}) {
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
  Stream<List<ITransaction>> getTransactionsByCustomerId(
      {required String customerId}) {
    // TODO: implement getTransactionsByCustomerId
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
  Future<Variant?> getVariantById({required String id}) {
    // TODO: implement getVariantById
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> getVariantByProductId({String? productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError();
  }

  @override
  Future<bool> isDrawerOpen({required int cashierId}) {
    // TODO: implement isDrawerOpen
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<bool> isTaxEnabled() {
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
  Future<void> loadCounterFromOnline({required int businessId}) {
    // TODO: implement loadCounterFromOnline
    throw UnimplementedError();
  }

  @override
  Future<void> logOut() async {
    /// mock this function
  }

  @override
  Future<void> logOutLight() {
    // TODO: implement logOutLight
    throw UnimplementedError();
  }

  @override
  Future<IUser> login(
      {required String userPhone, required bool skipDefaultAppSetup}) {
    // TODO: implement login
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
      {required String transactionType}) {
    // TODO: implement manageCashInOutTransaction
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> manageTransaction({required String transactionType}) {
    // TODO: implement manageTransaction
    throw UnimplementedError();
  }

  @override
  Future<Customer?> nGetCustomerByTransactionId({required String id}) {
    // TODO: implement nGetCustomerByTransactionId
    throw UnimplementedError();
  }

  @override
  Future<Counter?> nRSCounter({required int branchId}) {
    // TODO: implement nRSCounter
    throw UnimplementedError();
  }

  @override
  Future<Counter?> nSCounter({required int branchId}) {
    // TODO: implement nSCounter
    throw UnimplementedError();
  }

  @override
  Future<Drawers?> openDrawer({required Drawers drawer}) {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> orders({required int branchId}) {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Future<Counter?> pSCounter({required int branchId}) {
    // TODO: implement pSCounter
    throw UnimplementedError();
  }

  @override
  Future<void> patchSocialSetting({required Setting setting}) {
    // TODO: implement patchSocialSetting
    throw UnimplementedError();
  }

  @override
  Future<ITransaction?> pendingTransaction(
      {required int branchId, required String transactionType}) {
    // TODO: implement pendingTransaction
    throw UnimplementedError();
  }

  @override
  Stream<List<Product>> productStreams({String? prodIndex}) {
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
  Future<Profile?> profile({required int businessId}) {
    // TODO: implement profile
    throw UnimplementedError();
  }

  @override
  Future<void> recordUserActivity(
      {required int userId, required String activity}) {
    // TODO: implement recordUserActivity
    throw UnimplementedError();
  }

  @override
  Future<void> refreshSession({required int branchId, int? refreshRate = 5}) {
    // TODO: implement refreshSession
    throw UnimplementedError();
  }

  @override
  Future<void> refund({required String itemId}) {
    // TODO: implement refund
    throw UnimplementedError();
  }

  @override
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password}) {
    // TODO: implement registerOnSocial
    throw UnimplementedError();
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<Tenant> saveTenant(String phoneNumber, String name,
      {required Business business, required Branch branch}) {
    // TODO: implement saveTenant
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
  Future<List<Tenant>> signup({required Map business}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stream<Social> socialsStream({required int branchId}) {
    // TODO: implement socialsStream
    throw UnimplementedError();
  }

  @override
  Future<Spenn> spennPayment({required double amount, required phoneNumber}) {
    // TODO: implement spennPayment
    throw UnimplementedError();
  }

  @override
  Future<Stock> stockByVariantId(
      {required String variantId, bool nonZeroValue = false}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Future<double> stocks({String? productId, String? variantId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  bool subscribe(
      {required String feature,
      required int businessId,
      required int agentCode}) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  bool suggestRestore() {
    // TODO: implement suggestRestore
    throw UnimplementedError();
  }

  @override
  Future<void> syncProduct(
      {required Product product,
      required Variant variant,
      required Stock stock}) {
    // TODO: implement syncProduct
    throw UnimplementedError();
  }

  @override
  Future<List<SyncRecord>> syncedModels({required int branchId}) {
    // TODO: implement syncedModels
    throw UnimplementedError();
  }

  @override
  Future<Counter?> tSCounter({required int branchId}) {
    // TODO: implement tSCounter
    throw UnimplementedError();
  }

  @override
  Future<List<ITenant>> tenants({required int businessId}) {
    // TODO: implement tenants
    throw UnimplementedError();
  }

  @override
  Future<List<ITenant>> tenantsFromOnline({required int businessId}) {
    // TODO: implement tenantsFromOnline
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
  Future<List<TransactionItem>> transactionItems(
      {required String transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItems
    throw UnimplementedError();
  }

  @override
  Future<List<ITransaction>> transactionsFuture(
      {String? status,
      String? transactionType,
      int? branchId,
      bool isCashOut = false,
      bool includePending = false}) {
    // TODO: implement transactionsFuture
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
  Future<int> update<T>({required T data, bool localUpdate = false}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<bool> updateContact(
      {required Map<String, dynamic> contact, required int businessId}) {
    // TODO: implement updateContact
    throw UnimplementedError();
  }

  @override
  Future<Profile?> updateProfile({required Profile profile}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable({required String name}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Future<Variant?> variant({String? variantId, String? name}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> variants({required int branchId, String? productId}) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  Future<IsarApiInterface> getInstance() async {
    return this;
  }

  @override
  Stream<double> getStockStream({String? productId, String? variantId}) {
    // TODO: implement getStockStream
    throw UnimplementedError();
  }

  @override
  Future<List<Product?>> getProductByName({required String name}) {
    // TODO: implement getProductByName
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({String? productId}) {
    // TODO: implement getVariantByProductIdStream
    throw UnimplementedError();
  }
}
