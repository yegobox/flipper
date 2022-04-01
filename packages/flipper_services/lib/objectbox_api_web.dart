import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/mobile_upload.dart';

import 'abstractions/api.dart';
import 'package:isar/isar.dart';

late Isar isar;

class ObjectBoxApi extends MobileUpload implements Api {
  @override
  CustomerSync? addCustomer({required Map customer, required int orderId}) {
    // TODO: implement addCustomer
    throw UnimplementedError();
  }

  @override
  OrderF addOrderItem({required OrderF order, required Map data}) {
    // TODO: implement addOrderItem
    throw UnimplementedError();
  }

  @override
  Points addPoint({required int userId, required int point}) {
    // TODO: implement addPoint
    throw UnimplementedError();
  }

  @override
  Future<int> addUnits({required Map data}) {
    // TODO: implement addUnits
    throw UnimplementedError();
  }

  @override
  Future<Subscription> addUpdateSubscription(
      {required int userId,
      required int interval,
      required double recurringAmount,
      required String descriptor,
      required List<Feature> features}) {
    // TODO: implement addUpdateSubscription
    throw UnimplementedError();
  }

  @override
  Future<int> addVariant(
      {required List<Variant> data,
      required double retailPrice,
      required double supplyPrice}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future assingOrderToCustomer(
      {required int customerId, required int orderId}) {
    // TODO: implement assingOrderToCustomer
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({required int businessId}) {
    // TODO: implement branches
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
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderF order}) {
    // TODO: implement collectCashPayment
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required int branchId}) {
    // TODO: implement colors
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
  Stream<List<Business>> contacts() {
    // TODO: implement contacts
    throw UnimplementedError();
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> createGoogleSheetDoc({required String email}) {
    // TODO: implement createGoogleSheetDoc
    throw UnimplementedError();
  }

  @override
  Future<OrderF> createOrder(
      {required double customAmount,
      required Variant variation,
      required double price,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) {
    // TODO: implement createOrder
    throw UnimplementedError();
  }

  @override
  Future<Pin?> createPin() {
    // TODO: implement createPin
    throw UnimplementedError();
  }

  @override
  Future<ProductSync> createProduct({required ProductSync product}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Setting?> createSetting({required Setting setting}) {
    // TODO: implement createSetting
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required id, String? endPoint}) {
    // TODO: implement delete
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
  Business? getBusiness() {
    // TODO: implement getBusiness
    throw UnimplementedError();
  }

  @override
  Business getBusinessById({required int id}) {
    // TODO: implement getBusinessById
    throw UnimplementedError();
  }

  @override
  Future<Business> getBusinessFromOnlineGivenId({required int id}) {
    // TODO: implement getBusinessFromOnlineGivenId
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required int id, String? endPoint}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getCustomProductVariant() {
    // TODO: implement getCustomProductVariant
    throw UnimplementedError();
  }

  @override
  Stream<CustomerSync?> getCustomer({required String key}) {
    // TODO: implement getCustomer
    throw UnimplementedError();
  }

  @override
  Stream<CustomerSync?> getCustomerByOrderId({required int id}) {
    // TODO: implement getCustomerByOrderId
    throw UnimplementedError();
  }

  @override
  Future<List<DiscountSync>> getDiscounts({required int branchId}) {
    // TODO: implement getDiscounts
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> getLocalBranches({required int businessId}) {
    // TODO: implement getLocalBranches
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getLocalOrOnlineBusiness({required String userId}) {
    // TODO: implement getLocalOrOnlineBusiness
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getOnlineBusiness({required String userId}) {
    // TODO: implement getOnlineBusiness
    throw UnimplementedError();
  }

  @override
  Future<OrderF> getOrderById({required int id}) {
    // TODO: implement getOrderById
    throw UnimplementedError();
  }

  @override
  Future<List<OrderF>> getOrderByStatus({required String status}) {
    // TODO: implement getOrderByStatus
    throw UnimplementedError();
  }

  @override
  Future<OrderItem?> getOrderItem({required int id}) {
    // TODO: implement getOrderItem
    throw UnimplementedError();
  }

  @override
  OrderItem? getOrderItemByVariantId(
      {required int variantId, required int orderId}) {
    // TODO: implement getOrderItemByVariantId
    throw UnimplementedError();
  }

  @override
  Future<Pin?> getPin({required String pin}) {
    // TODO: implement getPin
    throw UnimplementedError();
  }

  @override
  Points? getPoints({required int userId}) {
    // TODO: implement getPoints
    throw UnimplementedError();
  }

  @override
  Future<ProductSync?> getProduct({required int id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<ProductSync?> getProductByBarCode({required String barCode}) {
    // TODO: implement getProductByBarCode
    throw UnimplementedError();
  }

  @override
  Setting? getSetting({required int userId}) {
    // TODO: implement getSetting
    throw UnimplementedError();
  }

  @override
  Future<Stock?> getStock({required int branchId, required int variantId}) {
    // TODO: implement getStock
    throw UnimplementedError();
  }

  @override
  Future<Subscription?> getSubscription({required int userId}) {
    // TODO: implement getSubscription
    throw UnimplementedError();
  }

  @override
  List<Variant> getVariantByProductId({required int productId}) {
    // TODO: implement getVariantByProductId
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required int businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  ProductSync? isTempProductExist({required int branchId}) {
    // TODO: implement isTempProductExist
    throw UnimplementedError();
  }

  @override
  Future<TenantSync?> isTenant({required String phoneNumber}) {
    // TODO: implement isTenant
    throw UnimplementedError();
  }

  @override
  int lifeTimeCustomersForbranch({required int branchId}) {
    // TODO: implement lifeTimeCustomersForbranch
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<SyncF> login({required String userPhone}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Stream<List<Message>> messages({required int conversationId}) {
    // TODO: implement messages
    throw UnimplementedError();
  }

  @override
  void migrateToSync() {
    // TODO: implement migrateToSync
  }

  @override
  Future<OrderF?> order({required int branchId}) {
    // TODO: implement order
    throw UnimplementedError();
  }

  @override
  Future<List<OrderF>> orders({required int branchId}) {
    // TODO: implement orders
    throw UnimplementedError();
  }

  @override
  Stream<List<ProductSync>> productStreams({required int branchId}) {
    // TODO: implement productStreams
    throw UnimplementedError();
  }

  @override
  Stream<List<ProductSync>> products({required int branchId}) {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Profile? profile({required int businessId}) {
    // TODO: implement profile
    throw UnimplementedError();
  }

  @override
  Future<void> saveDiscount(
      {required int branchId, required name, double? amount}) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  void saveTenant({required String phoneNumber}) {
    // TODO: implement saveTenant
  }

  @override
  void sendMessage({required int receiverId, required Message message}) {
    // TODO: implement sendMessage
  }

  @override
  Future<int> sendReport({required List<OrderItem> orderItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  Future<int> signup({required Map business}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Spenn> spennPayment({required double amount, required phoneNumber}) {
    // TODO: implement spennPayment
    throw UnimplementedError();
  }

  @override
  Future<Stock> stockByVariantId({required int variantId}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Stream<Stock> stockByVariantIdStream({required int variantId}) {
    // TODO: implement stockByVariantIdStream
    throw UnimplementedError();
  }

  @override
  List<Stock> stocks({required int productId}) {
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
      {required ProductSync product,
      required Variant variant,
      required Stock stock}) {
    // TODO: implement syncProduct
    throw UnimplementedError();
  }

  @override
  Future<List<OrderF>> tickets() {
    // TODO: implement tickets
    throw UnimplementedError();
  }

  @override
  Future<List<Unit>> units({required int branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<void> updateBusiness({required int id, required Map business}) {
    // TODO: implement updateBusiness
    throw UnimplementedError();
  }

  @override
  Profile? updateProfile({required Profile profile}) {
    // TODO: implement updateProfile
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable({required String name}) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Stream<List<Business>> users() {
    // TODO: implement users
    throw UnimplementedError();
  }

  @override
  Future<Variant?> variant({required int variantId}) {
    // TODO: implement variant
    throw UnimplementedError();
  }

  @override
  Future<List<Variant>> variants(
      {required int branchId, required int productId}) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  @override
  List<OrderF> weeklyOrdersReport(
      {required DateTime weekStartDate,
      required DateTime weekEndDate,
      required int branchId}) {
    // TODO: implement weeklyOrdersReport
    throw UnimplementedError();
  }

  @override
  Future<List<ProductSync>> productsFuture({required int branchId}) {
    // TODO: implement productsFuture
    throw UnimplementedError();
  }
}
