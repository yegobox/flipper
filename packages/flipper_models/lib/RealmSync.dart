// ignore: unused_import
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flipper_models/isar/random.dart';
import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_models/realmInterface.dart';
import 'package:flipper_models/realmModels.dart';
import 'package:flipper_models/secrets.dart';
import 'package:flipper_services/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flipper_models/realm/realmITransaction.dart';
import 'package:flipper_models/sync_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'remote_service.dart';
import 'sync.dart';
import 'package:realm/realm.dart';

extension StringToIntList on String {
  List<int> toIntList() {
    return this.split(',').map((e) => int.parse(e.trim())).toList();
  }
}

abstract class SyncReaml<M extends IJsonSerializable> implements Sync {
  factory SyncReaml.create() => RealmSync<M>();
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments);

  void close();
  Future<bool> logout();
}

class RealmSync<M extends IJsonSerializable>
    with HandleItemMixin
    implements SyncReaml<M>, RealmApiInterface {
  Realm? realm;
  final talker = TalkerFlutter.init();

  Future<String> absolutePath(String fileName) async {
    final appDocsDirectory = await getApplicationDocumentsDirectory();
    final int businessId = ProxyService.box.getBusinessId()!;
    final int branchId = ProxyService.box.getBranchId()!;
    final realmDirectory = '${appDocsDirectory.path}/flipper-' +
        branchId.toString() +
        "_" +
        businessId.toString();

    // Create the new directory
    await Directory(realmDirectory).create(recursive: true);

    return "$realmDirectory/$fileName";
  }

  Future<RealmApiInterface> configure({required bool inTesting}) async {
    if (realm != null) {
      return this;
    }
    Configuration config;

    if (inTesting) {
      config = Configuration.inMemory(realmModels);
      realm = Realm(config);
    } else {
      List<int> key = ProxyService.box.encryptionKey().toIntList();
      String path = await absolutePath("db_");
      //NOTE: https://www.mongodb.com/docs/atlas/app-services/domain-migration/
      final app = App(AppConfiguration(AppSecrets.appId,
          baseUrl: Uri.parse("https://services.cloud.mongodb.com")));
      final user = app.currentUser ??
          await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));

      int? branchId = ProxyService.box.getBranchId();
      config = Configuration.flexibleSync(
        user,
        realmModels,
        encryptionKey: key,
        path: path,
        clientResetHandler: RecoverUnsyncedChangesHandler(
          onBeforeReset: (beforeResetRealm) {
            log("reset requested here..");

            ///which the SDK invokes prior to the client reset.
            ///You can use this callback to notify the user before the reset begins.
          },
        ),
        shouldCompactCallback: ((totalSize, usedSize) {
          // Compact if the file is over 10MB in size and less than 50% 'used'
          const tenMB = 10 * 1048576;
          return (totalSize > tenMB) &&
              (usedSize.toDouble() / totalSize.toDouble()) < 0.5;
        }),
      );
      // realm = await Realm.open(config);
      CancellationToken token = CancellationToken();

      // Cancel the open operation after 30 seconds.
      // Alternatively, you could display a loading dialog and bind the cancellation
      // to a button the user can click to stop the wait.
      Future<void>.delayed(
        const Duration(seconds: 30),
        () => token.cancel(
          CancelledException(
            cancellationReason: "Realm took too long to open",
          ),
        ),
      );
      try {
        //  realm = Realm(config);
        realm = await Realm.open(config, cancellationToken: token,
            onProgressCallback: (syncProgress) {
          if (syncProgress.progressEstimate == 1.0) {
            talker.info('All bytes transferred!');
          }
        });
        talker.info("Opened realm[1]");
      } catch (e) {
        talker.info("Opened realm[2]");
        realm = Realm(config);
      }
      // Realm.logger.level = RealmLogLevel.trace;
      await updateSubscription(branchId);

      /// removed await on bellow line because when it is in bootstrap, it might freeze the app
      await realm?.subscriptions.waitForSynchronization();
    }
    return this;
  }

  Future<void> updateSubscription(int? branchId) async {
    if (realm == null) return;
    final transactionItem =
        realm!.query<TransactionItem>(r'branchId == $0', [branchId]);
    final product = realm!.query<Product>(r'branchId == $0', [branchId]);
    final variant = realm!.query<Variant>(r'branchId == $0', [branchId]);
    final stock = realm!.query<Stock>(r'branchId == $0', [branchId]);
    final unit = realm!.query<IUnit>(r'branchId == $0', [branchId]);
    final counter = realm!.query<Counter>(r'branchId == $0', [branchId]);
    final receipt = realm!.query<Receipt>(r'branchId == $0', [branchId]);
    final customer = realm!.query<Customer>(r'branchId == $0', [branchId]);
    final transaction =
        realm!.query<RealmITransaction>(r'branchId == $0', [branchId]);
    //https://www.mongodb.com/docs/realm/sdk/flutter/sync/manage-sync-subscriptions/

    await customer.subscribe(
        name: "iCustomer-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await receipt.subscribe(
        name: "iReceipt-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await product.subscribe(
        name: "iProduct-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await counter.subscribe(
        name: "iCounter-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await variant.subscribe(
        name: "iVariant-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await stock.subscribe(
        name: "iStock-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await unit.subscribe(
        name: "iUnit-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);

    await transaction.subscribe(
        name: "transaction-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);
    await transactionItem.subscribe(
        name: "transactionItem-${branchId}",
        waitForSyncMode: WaitForSyncMode.always,
        update: true);
  }

  @override
  T? findObject<T extends RealmObject>(String query, List<dynamic> arguments) {
    if (realm == null) return null;
    final results = realm!.query<T>(query, arguments);
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  /// an experimental to call the mongo db api directly via api
  /// to get changes as subscribing to the change is not getting
  /// data to the device in time we think!

  @override
  void close() {
    if (realm == null) return null;
    realm!.close();
  }

  Future<bool> logout() async {
    ///https://stackoverflow.com/questions/40587563/when-should-i-call-realm-close
    ///until we have valid reason to close realm and logout
    ///then we are commenting code bellow
    ///this is because we are not interested in realm data once user logs out
    ///because technicaly it is not a problem to have realm data after logout on google auth main auth
    ///
    // final app = App(AppConfiguration(AppSecrets.appId,
    //     baseUrl: Uri.parse("https://services.cloud.mongodb.com")));
    // final user = app.currentUser ??
    //     await app.logIn(Credentials.apiKey(AppSecrets.mongoApiSecret));
    // await user.logOut();
    //    realm!.close();
    return true;
  }

  @override
  Future<Branch?> activeBranch() async {
    // TODO: since this will be cross shared to avoid users accessing other branch data also add branchId to the query
    // and also because this will be using in unit testing avoid using something that will require getIt instance
    return realm!.query<Branch>(r'isDefault == $0', [true]).firstOrNull;
  }

  @override
  Future<Category?> activeCategory({required int branchId}) async {
    return realm!.query<Category>(
        r'focused == $0 && active == $1 && branchId == $2 && deletedAt == null',
        [true, true, branchId]).firstOrNull;
  }

  @override
  Future<Customer?> addCustomer({
    required Customer customer,
    required int transactionId,
  }) async {
    try {
      // Open a write transaction
      realm!.write(() {
        // Add the customer to the Realm
        realm!.add(customer, update: true);

        // Get the transaction from Realm
        final transaction =
            realm!.all<ITransaction>().firstWhere((t) => t.id == transactionId);

        // Update the transaction with the customer ID
        transaction.customerId = customer.id;
      });

      return realm!.query<Customer>(r'id == $0', [customer.id]).first;
    } catch (e) {
      print('Failed to add customer: $e');
      rethrow;
    }
  }

  @override
  Future<int> addFavorite({required Favorite data}) async {
    try {
      final fav = realm!.query<Favorite>(
          r'favIndex == $0 && deletedAt == null', [data.favIndex!]).firstOrNull;

      if (fav == null) {
        data.id = randomNumber();
        await realm!.write(() {
          realm!.add(data);
        });
        return 200;
      } else {
        await realm!.write(() {
          fav.productId = data.productId;
        });
        return 200;
      }
    } catch (e) {
      print('Error adding favorite: $e');
      rethrow;
    }
  }

  @override
  Future<Stock?> addStockToVariant({required Variant variant}) {
    Stock stock = Stock( ObjectId,retailPrice: variant.retailPrice,)
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
  Future<int> addVariant({required List<Variant> variations}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future assignCustomerToTransaction(
      {required int customerId, int? transactionId}) {
    // TODO: implement assignCustomerToTransaction
    throw UnimplementedError();
  }

  @override
  Stream<ITenant?> authState({required int branchId}) {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<bool> bindProduct({required int productId, required int tenantId}) {
    // TODO: implement bindProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({int? businessId}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> businesses({int? userId}) {
    // TODO: implement businesses
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
  Future<Product?> createProduct(
      {required Product product, bool skipRegularVariant = false}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> createReceipt(
      {required EBMApiResponse signature,
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
  Future<bool> delete({required int id, String? endPoint}) {
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
  Future<int> deleteTransactionByIndex({required int transactionIndex}) {
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
  Stream<List<Variant>> geVariantStreamByProductId({required int productId}) {
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
  Future<PColor?> getColor({required int id}) {
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
  Future<Counter?> getCounter(
      {required int branchId, required String receiptType}) {
    // TODO: implement getCounter
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getCustomVariant() {
    // TODO: implement getCustomVariant
    throw UnimplementedError();
  }

  @override
  Future<Customer?> getCustomer({String? key, int? id}) {
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
  Future<Business> getOnlineBusiness({required int userId}) {
    // TODO: implement getOnlineBusiness
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProduct({required int id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<Product?> getProductByBarCode({required String barCode}) {
    // TODO: implement getProductByBarCode
    throw UnimplementedError();
  }

  @override
  Future<List<Product?>> getProductByName({required String name}) {
    // TODO: implement getProductByName
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> getProductList({int? prodIndex}) {
    // TODO: implement getProductList
    throw UnimplementedError();
  }

  @override
  Future<Receipt?> getReceipt({required int transactionId}) {
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
  Stream<double> getStockStream({int? productId, int? variantId}) {
    // TODO: implement getStockStream
    throw UnimplementedError();
  }

  @override
  Stream<double> getStockValue({required int branchId}) {
    // TODO: implement getStockValue
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
  Future<ITransaction?> getTransactionById({required int id}) {
    // TODO: implement getTransactionById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemById({required int id}) {
    // TODO: implement getTransactionItemById
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItemByVariantId(
      {required int variantId, required int? transactionId}) {
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
  Stream<List<ITransaction>> getTransactionsByCustomerId(
      {required int customerId}) {
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
  Future<Variant?> getVariantById({required int id}) {
    // TODO: implement getVariantById
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> getVariantByProductId({int? productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> getVariantByProductIdStream({int? productId}) {
    // TODO: implement getVariantByProductIdStream
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
  bool isTaxEnabled() {
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
  Future<void> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<void> logOutLight() {
    // TODO: implement logOutLight
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
  Future<int> registerOnSocial({String? phoneNumberOrEmail, String? password}) {
    // TODO: implement registerOnSocial
    throw UnimplementedError();
  }

  @override
  Future removeCustomerFromTransaction(
      {required int customerId, required int transactionId}) {
    // TODO: implement removeCustomerFromTransaction
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
      {required Business business,
      required Branch branch,
      required String userType}) {
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
  Future<Stock?> stockByVariantId(
      {required int variantId, bool nonZeroValue = false}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Future<double> stocks({int? productId, int? variantId}) {
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
  Future<List<ITenant>> tenants({int? businessId}) {
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
      {required int transactionId,
      required bool doneWithTransaction,
      required bool active}) {
    // TODO: implement transactionItems
    throw UnimplementedError();
  }

  @override
  Stream<List<ITransaction>> transactionList(
      {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement transactionList
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
  Future<int> userNameAvailable({required String name}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Future<Variant?> variant({int? variantId, String? name}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> variants({required int branchId, int? productId}) {
    // TODO: implement variants
    throw UnimplementedError();
  }
}
