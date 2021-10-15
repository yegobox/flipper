import 'package:flipper_models/business.dart';
import 'package:flipper_models/login.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/discount.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/order_item.dart';
import 'package:flipper_models/spenn.dart';
import 'package:flipper_models/conversation.dart';
import 'package:flipper_models/setting.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_models/customer.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/color.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_models/variants.dart';

abstract class Api<T> {
  Future<Login> login({required String phone});
  Future<List<Product>> products({required int branchId});
  Future<int> signup({required Map business});
  Future<SyncF> authenticateWithOfflineDb({required String userId});
  Future<List<Business>> businesses({required String userId});
  Future<List<Business>> lBusinesses({required String userId});
  Future<List<Branch>> branches({required int businessId});
  Future<List<Branch>> lbranches({required int businessId});
  List<Stock> stocks({required int productId});
  Stream<Stock> stockByVariantIdStream({required int variantId});
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

  Future<Product?> getProduct({required int id});
  Future<Product?> getProductByBarCode({required String barCode});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<Product> createProduct({required Product product});
  Future<List<Product>> isTempProductExist({required int branchId});
  Future<bool> logOut();

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

  Future<Variant> getCustomProductVariant();
  Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderF order});

// app settings and users settings
  Setting? getSetting({required int userId});

  Future<Setting?> createSetting(
      {required int userId, required Setting setting});
  Stream<List<Conversation>> conversationStreamList({int? receiverId});
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

  Business getBusiness();
  Customer? addCustomer({required Map customer, required int orderId});
  Future assingOrderToCustomer({required int customerId, required int orderId});
  Stream<Customer?> getCustomer({required String key});
  Stream<Customer?> getCustomerByOrderId({required int id});
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

  Future<List<Discount>> getDiscounts({required int branchId});

  OrderF addOrderItem({required OrderF order, required Map data});

  Conversation createConversation({required Conversation conversation});

  Conversation? getConversationByContactId({required int contactId});
  void emptySentMessageQueue();
  bool suggestRestore();

  Future<int> userNameAvailable({required String name});
}
