import 'package:flipper_models/models/models.dart';

abstract class Api<T> {
  Future<List<ProductSync>> products({required int branchId});
  Future<int> signup({required Map business});
  Future<SyncF> login({required String userPhone});
  Future<List<BusinessSync>> getOnlineBusiness({required String userId});
  Future<List<BusinessSync>> getLocalOrOnlineBusiness({required String userId});
  Future<List<BranchSync>> branches({required int businessId});
  Future<List<BranchSync>> getLocalBranches({required int businessId});
  List<StockSync> stocks({required int productId});
  Stream<StockSync> stockByVariantIdStream({required int variantId});
  Stream<List<ProductSync>> productStreams({required int branchId});
  Future<StockSync> stockByVariantId({required int variantId});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Future<List<Unit>> units({required int branchId});
  Future<int> create<T>({required Map data, required String endPoint});
  Future<int> update<T>({required Map data, required String endPoint});
  Future<bool> delete({required dynamic id, String? endPoint});
  Future<PColor?> getColor({required int id, String? endPoint});
  Future<StockSync?> getStock({required int branchId, required int variantId});
  Future<List<VariantSync>> variants({
    required int branchId,
    required int productId,
  });
  Future<VariantSync?> variant({required int variantId});
  Future<int> addUnits({required Map data});

  Future<int> addVariant({
    required List<VariantSync> data,
    required double retailPrice,
    required double supplyPrice,
  });

  Future<ProductSync?> getProduct({required int id});
  Future<ProductSync?> getProductByBarCode({required String barCode});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<ProductSync> createProduct({required ProductSync product});
  Future<List<ProductSync>> isTempProductExist({required int branchId});
  Future<bool> logOut();

  Future<Voucher?> consumeVoucher({required int voucherCode});

  ///create an order if no pending order exist should create a new one
  ///then if it exist should return the existing one!
  Future<OrderFSync> createOrder({
    required double customAmount,
    required VariantSync variation,
    required double price,
    bool useProductName = false,
    String orderType = 'custom',
    double quantity = 1,
  });

  Future<List<OrderFSync>> orders({required int branchId});
  Future<OrderFSync?> order({required int branchId});
  Future<OrderItemSync?> getOrderItem({required int id});

  Future<VariantSync?> getCustomProductVariant();
  Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderFSync order});

// app settings and users settings
  Setting? getSetting({required int userId});

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
  Stream<List<BusinessSync>> users();
  //the method is not different from users, but users is for streaming users being added
  //to connected devices, while this method is for getting all users using List<Business>
  Stream<List<BusinessSync>> contacts();
  Future<List<BusinessSync>> getContacts();

  BusinessSync getBusiness();
  CustomerSync? addCustomer({required Map customer, required int orderId});
  Future assingOrderToCustomer({required int customerId, required int orderId});
  Stream<CustomerSync?> getCustomer({required String key});
  Stream<CustomerSync?> getCustomerByOrderId({required int id});
  Future<OrderFSync> getOrderById({required int id});
  Future<List<OrderFSync>> tickets();
  List<VariantSync> getVariantByProductId({required int productId});
  Future<List<OrderFSync>> getOrderByStatus({required String status});
  Future<int> sendReport({required List<OrderItemSync> orderItems});
  Future<void> createGoogleSheetDoc({required String email});
  BusinessSync getBusinessById({required int id});
  OrderItemSync? getOrderItemByVariantId(
      {required int variantId, required int orderId});
  //abstract method to update business
  Future<void> updateBusiness({required int id, required Map business});

  //analytics
  int lifeTimeCustomersForbranch({required int branchId});

  List<OrderFSync> weeklyOrdersReport({
    required DateTime weekStartDate,
    required DateTime weekEndDate,
    required int branchId,
  });
  //save discount
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<List<DiscountSync>> getDiscounts({required int branchId});

  OrderFSync addOrderItem({required OrderFSync order, required Map data});

  // Conversation createConversation({required Conversation conversation});

  // Conversation? getConversationByContactId({required int contactId});
  void emptySentMessageQueue();
  bool suggestRestore();

  Future<int> userNameAvailable({required String name});

  TenantSync? isTenant({required String phoneNumber});
  Future<BusinessSync> getBusinessFromOnlineGivenId({required int id});

  /// sync related methods
  // Future<void> addAllVariants({required List<VariantSync> variants});
  Future<void> syncProduct(
      {required ProductSync product,
      required VariantSync variant,
      required StockSync stock});
  // Future<void> addStock({required StockSync stock});
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

  Profile? profile({required int businessId});
  Profile? updateProfile({required Profile profile});
  void saveTenant({required String phoneNumber});
  Points addPoint({required int userId, required int point});
  Subscription addUpdateSubscription({
    required int userId,
    required int interval,
    required double recurringAmount,
    required String descriptor,
    required List<Feature> features,
  });
  Subscription? getSubscription({required int userId});
  Points? getPoints({required int userId});
  void consumePoints({required int userId, required int points});
}
