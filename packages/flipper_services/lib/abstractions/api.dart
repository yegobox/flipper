import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/login.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/unit.dart';
import 'package:flipper_models/models/variant_stock.dart';
import 'package:flipper_models/models/branch.dart';
import 'package:flipper_models/models/stock.dart';
import 'package:flipper_models/models/color.dart';
import 'package:flipper_models/models/order.dart';
import 'package:flipper_models/models/category.dart';
import 'package:flipper_models/models/sync.dart';
import 'package:flipper_models/models/variation.dart';

abstract class Api<T> {
  Future<Login> login({required String phone});
  Future<List<Product>> products();
  Future<int> signup({required Map business});
  Future<Sync> authenticateWithOfflineDb({required String userId});
  Future<List<Business>?> businesses();
  Future<List<Branch>> branches({required String businessId});
  Future<List<Stock>> stocks({required String productId});
  Stream<Stock> stockByVariantIdStream({required String variantId});
  Future<Stock> stockByVariantId({required String variantId});
  Future<List<PColor>> colors({required String branchId});
  Future<List<Category>> categories({required String branchId});
  Future<List<Unit>> units({required String branchId});
  Future<int> create<T>({required Map data, required String endPoint});
  Future<int> update<T>({required Map data, required String endPoint});
  Future<bool> delete({required String id, String? endPoint});
  Future<PColor> getColor({required String id, String? endPoint});
  Future<List<VariantStock>> variantStock(
      {required String branchId, required String variantId});
  Future<List<Variation>> variants({
    required String branchId,
    required String productId,
  });
  Future<int> addUnits({required Map data});

  Future<int> addVariant({
    required List<Variation> data,
    required double retailPrice,
    required double supplyPrice,
  });

  Future<Product> getProduct({required String id});
  // Future
  //this function for now figure out what is the business id on backend side.
  Future<Product> createProduct({required Product product});
  Future<List<Product>> isTempProductExist();
  Future<bool> logOut();

  ///create an order if no pending order exist should create a new one
  ///then if it exist should return the existing one!
  Future<Order> createOrder({
    required double customAmount,
    required Variation variation,
    required String stockId,
    bool useProductName = false,
    String orderType = 'custom',
    double quantity = 1,
  });

  Future<List<Order>> orders();

  Future<Variation> getCustomProductVariant();
}
