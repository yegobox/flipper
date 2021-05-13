import 'package:flipper_models/models/order.dart';
import 'package:flipper_models/models/variation.dart';

import 'package:flipper_models/models/variant_stock.dart';

import 'package:flipper_models/models/unit.dart';

import 'package:flipper_models/models/sync.dart';

import 'package:flipper_models/models/stock.dart';

import 'package:flipper_models/models/product.dart';

import 'package:flipper_models/models/login.dart';

import 'package:flipper_models/models/color.dart';

import 'package:flipper_models/models/category.dart';

import 'package:flipper_models/models/business.dart';

import 'package:flipper_models/models/branch.dart';

import 'abstractions/api.dart';

class HiveApi implements Api {
  @override
  Future<int> addUnits({required Map data}) {
    // TODO: implement addUnits
    throw UnimplementedError();
  }

  @override
  Future<Sync> authenticateWithOfflineDb({required String userId}) {
    // TODO: implement authenticateWithOfflineDb
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({required String businessId}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<List<Business>?> businesses() {
    // TODO: implement businesses
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> categories({required String branchId}) {
    // TODO: implement categories
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required String branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct({required Product product}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required String id, String? endPoint}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<PColor> getColor({required String id, String? endPoint}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<Product> getProduct({required String id}) {
    // TODO: implement getProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> isTempProductExist() {
    // TODO: implement isTempProductExist
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<Login> login({required String phone}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> products() {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<int> signup({required Map business}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<Stock> stockByVariantId({required String variantId}) {
    // TODO: implement stockByVariantId
    throw UnimplementedError();
  }

  @override
  Stream<Stock> stockByVariantIdStream({required String variantId}) {
    // TODO: implement stockByVariantIdStream
    throw UnimplementedError();
  }

  @override
  Future<List<Stock>> stocks({required String productId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  Future<List<Unit>> units({required String branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<VariantStock>> variantStock(
      {required String branchId, required String variantId}) {
    // TODO: implement variantStock
    throw UnimplementedError();
  }

  @override
  Future<List<Variation>> variants(
      {required String branchId, required String productId}) {
    // TODO: implement variants
    throw UnimplementedError();
  }

  @override
  Future<int> addVariant(
      {required List<Variation> data,
      required double retailPrice,
      required double supplyPrice}) {
    // TODO: implement addVariant
    throw UnimplementedError();
  }

  @override
  Future<Order> createOrder(
      {required double customAmount,
      required Variation variation,
      required String stockId,
      bool useProductName = false,
      String orderType = 'custom',
      double quantity = 1}) {
    // TODO: implement createOrder
    throw UnimplementedError();
  }

  @override
  Future<bool> updateOrder(
      {required Order order,
      required double customAmount,
      bool completeOrder = false}) {
    // TODO: implement updateOrder
    throw UnimplementedError();
  }
}
