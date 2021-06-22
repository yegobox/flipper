import 'package:flipper_models/business.dart';
import 'package:flipper_models/login.dart';
import 'package:flipper_models/product.dart';
import 'package:flipper_models/unit.dart';
import 'package:flipper_models/order_item.dart';
import 'package:flipper_models/spenn.dart';
import 'package:flipper_models/setting.dart';
import 'package:flipper_models/message.dart';
import 'package:flipper_models/customer.dart';
// import 'package:flipper_models/variant_stock.dart';
import 'package:flipper_models/branch.dart';
import 'package:flipper_models/stock.dart';
import 'package:flipper_models/color.dart';
import 'package:flipper_models/order.dart';
import 'package:flipper_models/category.dart';
import 'package:flipper_models/sync.dart';
import 'package:flipper_models/variants.dart';

abstract class Api<T> {
  Future<Login> login({required String phone});
  Future<List<Product>> products();
  Future<int> signup({required Map business});
  Future<SyncF> authenticateWithOfflineDb({required String userId});
  Future<List<Business>> businesses();
  Future<List<Branch>> branches({required int businessId});
  Future<List<Stock>> stocks({required int productId});
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
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<Product> createProduct({required Product product});
  Future<List<Product>> isTempProductExist();
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

  Future<List<OrderF>> orders();
  Future<OrderItem?> getOrderItem({required int id});

  Future<Variant> getCustomProductVariant();
  Future<Spenn> spennPayment({required double amount, required phoneNumber});
  Future<void> collectCashPayment(
      {required double cashReceived, required OrderF order});

// app settings and users settings
  Future<Setting?> getSetting({required int userId});

  Future<Setting?> createSetting(
      {required int userId, required Setting setting});
  Stream<List<Message>> messages({int? receiverId});
  void sendMessage({required int receiverId, required String message});
  Stream<List<Business>> users();

  Business getBusiness();
  Customer? addCustomer({required Map customer, required int orderId});
  void assingOrderToCustomer({required int customerId, required int orderId});
  Stream<Customer?> getCustomer({required String key});
  Stream<Customer?> getCustomerByOrderId({required int id});
  Future<List<OrderF>> getOrderById({required int id});
}
