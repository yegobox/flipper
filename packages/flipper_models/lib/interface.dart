import 'package:flipper_models/isar/receipt_signature.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/constants.dart';

abstract class IsarApiInterface {
  Future<List<Product>> products({required int branchId});
  Future<int> signup({required Map business});
  Future<Order?> pendingOrder({required int branchId});
  Future<SyncF> login({required String userPhone});
  Future<Business> getOnlineBusiness({required String userId});
  Future<Business> getLocalOrOnlineBusiness({required String userId});
  Future<List<Branch>> branches({required int businessId});
  Future<List<Branch>> getLocalBranches({required int businessId});
  Future<List<Stock?>> stocks({required int productId});
  Stream<Stock> stockByVariantIdStream({required int variantId});
  Stream<List<Product>> productStreams({required int branchId});
  Future<Stock?> stockByVariantId({required int variantId});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Stream<List<Category>> categoriesStream({required int branchId});
  Stream<Order?> pendingOrderStream();
  Future<List<Unit>> units({required int branchId});
  Future<int> create<T>({required T data, required String endPoint});
  Future<int> update<T>(
      {required T data,
      @Deprecated(
        'Dont pass this param',
      )
          String? endPoint});
  Future<bool> delete({required dynamic id, String? endPoint});
  Future<PColor?> getColor({required int id, String? endPoint});
  Future<Stock?> getStock({required int branchId, required int variantId});
  Future<List<Variant>> variants({
    required int branchId,
    required int productId,
  });
  Future<Variant?> variant({required int variantId});
  Future<int> addUnits<T>({required T data});

  Future<int> addVariant({
    required List<Variant> data,
    required double retailPrice,
    required double supplyPrice,
  });

  Future<Product?> getProduct({required int id});
  Future<Product?> getProductByBarCode({required String barCode});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<Product> createProduct({required Product product});
  Future<Product?> isTempProductExist({required int branchId});
  Future<bool> logOut();

  Future<Voucher?> consumeVoucher({required int voucherCode});

  ///create an order if no pending order exist should create a new one
  ///then if it exist should return the existing one!
  Future<Order> manageOrder({
    String orderType = 'custom',
  });

  Future<List<Order>> completedOrders(
      {required int branchId, String? status = completeStatus});
  Future<OrderItem?> getOrderItem({required int id});

  Future<Variant?> getCustomVariant();
  Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<void> collectCashPayment(
      {required double cashReceived, required Order order});

// app settings and users settings
  Future<Setting?> getSetting({required int userId});

  Future<Setting?> createSetting({required Setting setting});
  // Stream<List<Conversation>> conversationStreamList({int? receiverId});
  void sendMessage({required int receiverId, required Message message});
  Stream<List<Message>> messages({required int conversationId});

  /// we treat all business as users and as contact at the same time
  /// this is because a business act as point of contact for a user
  /// and we do not to refer to the business phone number to send messages
  /// we only care about name, this deliver from our core mission that
  /// we want to make communication easy for business and users i.e customers
  ///
  Stream<List<Business>> users();
  //the method is not different from users, but users is for streaming users being added
  //to connected devices, while this method is for getting all users using List<Business>
  Stream<List<Business>> contacts();
  Future<List<Business>> getContacts();

  Future<Business?> getBusiness();
  Future<Customer?> addCustomer({required Map customer, required int orderId});
  Future assingOrderToCustomer({required int customerId, required int orderId});
  Stream<Customer?> getCustomer({required String key});
  Stream<Customer?> getCustomerByOrderId({required int id});
  Future<Order?> getOrderById({required int id});
  Future<List<Order>> tickets();
  Future<List<Variant>> getVariantByProductId({required int productId});

  Future<int> sendReport({required List<OrderItem> orderItems});
  Future<void> createGoogleSheetDoc({required String email});
  Future<Business?> getBusinessById({required int id});
  Future<OrderItem?> getOrderItemByVariantId(
      {required int variantId, required int? orderId});
  //abstract method to update business
  Future<void> updateBusiness({required int id, required Map business});

  //analytics
  int lifeTimeCustomersForbranch({required int branchId});

  Future<List<Order>> weeklyOrdersReport({
    required DateTime weekStartDate,
    required DateTime weekEndDate,
    required int branchId,
  });
  //save discount
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<List<Discount>> getDiscounts({required int branchId});

  Future<void> addOrderItem({required Order order, OrderItem? item});
  Future<void> updateOrderItem({required Order order, required OrderItem item});

  // Conversation createConversation({required Conversation conversation});

  // Conversation? getConversationByContactId({required int contactId});
  void emptySentMessageQueue();
  bool suggestRestore();

  Future<int> userNameAvailable({required String name});

  Future<TenantSync?> isTenant({required String phoneNumber});
  Future<Business?> getBusinessFromOnlineGivenId({required int id});

  /// sync related methods
  // Future<void> addAllVariants({required List<Variant> variants});
  Future<void> syncProduct(
      {required Product product,
      required Variant variant,
      required Stock stock});
  // Future<void> addStock({required Stock stock});
  void migrateToSync();
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
  void saveTenant({required String phoneNumber});
  Points addPoint({required int userId, required int point});
  Future<Subscription?> addUpdateSubscription({
    required int userId,
    required int interval,
    required double recurringAmount,
    required String descriptor,
    required List<Feature> features,
  });
  Future<Subscription?> getSubscription({required int userId});
  Future<Points?> getPoints({required int userId});
  void consumePoints({required int userId, required int points});
  Future<Pin?> createPin();
  Future<Pin?> getPin({required String pin});

  Future<List<Product>> productsFuture({required int branchId});

  /// get a list of orderItems given orderId
  Future<List<OrderItem>> orderItems({required int orderId});
  Future<Variant?> getVariantById({required int id});
  Future<bool> isTaxEnabled();
  Future<Receipt?> createReceipt(
      {required ReceiptSignature signature,
      required Order order,
      required String qrCode,
      required String receiptType});
  Future<Receipt?> getReceipt({required int orderId});
}
