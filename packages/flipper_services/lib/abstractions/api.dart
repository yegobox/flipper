import 'package:flipper_models/models/models.dart';

abstract class Api<T> {
  Stream<List<ProductSync>> products({required int branchId});
  Future<List<ProductSync>> productsFuture({required int branchId});
  Future<int> signup({required Map business});
  Future<SyncF> login({required String userPhone});
  Future<List<Business>> getOnlineBusiness({required String userId});
  Future<List<Business>> getLocalOrOnlineBusiness({required String userId});
  Future<List<Branch>> branches({required int businessId});
  Future<List<Branch>> getLocalBranches({required int businessId});
  List<Stock> stocks({required int productId});
  Stream<Stock> stockByVariantIdStream({required int variantId});
  Stream<List<ProductSync>> productStreams({required int branchId});
  Future<Stock> stockByVariantId({required int variantId});
  Future<List<PColor>> colors({required int branchId});
  Future<List<Category>> categories({required int branchId});
  Future<List<Unit>> units({required int branchId});
  Future<int> create<T>({required Map data, required String endPoint});
  Future<int> update<T>({required Map data, required String endPoint});
  Future<bool> delete({required dynamic id, String? endPoint});
  Future<PColor?> getColor({required int id, String? endPoint});
  Future<Stock?> getStock({required int branchId, required int variantId});
  Future<List<Variant>> variants({
    required int branchId,
    required int productId,
  });
  Future<Variant?> variant({required int variantId});
  Future<int> addUnits({required Map data});

  Future<int> addVariant({
    required List<Variant> data,
    required double retailPrice,
    required double supplyPrice,
  });

  Future<ProductSync?> getProduct({required int id});
  Future<ProductSync?> getProductByBarCode({required String barCode});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<ProductSync> createProduct({required ProductSync product});
  ProductSync? isTempProductExist({required int branchId});
  Future<bool> logOut();

  Future<Voucher?> consumeVoucher({required int voucherCode});

  ///create an order if no pending order exist should create a new one
  ///then if it exist should return the existing one!
  Future<OrderF> createOrder({
    required double customAmount,
    required Variant variation,
    required double price,
    bool useProductName = false,
    String orderType = 'custom',
    double quantity = 1,
  });

  Future<List<OrderF>> orders({required int branchId});
  Future<OrderF?> order({required int branchId});
  Future<OrderItem?> getOrderItem({required int id});

  Future<Variant?> getCustomProductVariant();
  Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderF order});

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
  Stream<List<Business>> users();
  //the method is not different from users, but users is for streaming users being added
  //to connected devices, while this method is for getting all users using List<Business>
  Stream<List<Business>> contacts();
  Future<List<Business>> getContacts();

  Business? getBusiness();
  CustomerSync? addCustomer({required Map customer, required int orderId});
  Future assingOrderToCustomer({required int customerId, required int orderId});
  Stream<CustomerSync?> getCustomer({required String key});
  Stream<CustomerSync?> getCustomerByOrderId({required int id});
  Future<OrderF> getOrderById({required int id});
  Future<List<OrderF>> tickets();
  List<Variant> getVariantByProductId({required int productId});
  Future<List<OrderF>> getOrderByStatus({required String status});
  Future<int> sendReport({required List<OrderItem> orderItems});
  Future<void> createGoogleSheetDoc({required String email});
  Business getBusinessById({required int id});
  OrderItem? getOrderItemByVariantId(
      {required int variantId, required int orderId});
  //abstract method to update business
  Future<void> updateBusiness({required int id, required Map business});

  //analytics
  int lifeTimeCustomersForbranch({required int branchId});

  List<OrderF> weeklyOrdersReport({
    required DateTime weekStartDate,
    required DateTime weekEndDate,
    required int branchId,
  });
  //save discount
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount});

  Future<List<DiscountSync>> getDiscounts({required int branchId});

  OrderF addOrderItem({required OrderF order, required Map data});

  // Conversation createConversation({required Conversation conversation});

  // Conversation? getConversationByContactId({required int contactId});
  void emptySentMessageQueue();
  bool suggestRestore();

  Future<int> userNameAvailable({required String name});

  Future<TenantSync?> isTenant({required String phoneNumber});
  Future<Business> getBusinessFromOnlineGivenId({required int id});

  /// sync related methods
  // Future<void> addAllVariants({required List<Variant> variants});
  Future<void> syncProduct(
      {required ProductSync product,
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

  Profile? profile({required int businessId});
  Profile? updateProfile({required Profile profile});
  void saveTenant({required String phoneNumber});
  Points addPoint({required int userId, required int point});
  Future<Subscription> addUpdateSubscription({
    required int userId,
    required int interval,
    required double recurringAmount,
    required String descriptor,
    required List<Feature> features,
  });
  Future<Subscription?> getSubscription({required int userId});
  Points? getPoints({required int userId});
  void consumePoints({required int userId, required int points});
  Future<Pin?> createPin();
  Future<Pin?> getPin({required String pin});
}
