import 'package:flipper_models/models/branch.dart';
import 'package:flipper_models/models/business.dart';
import 'package:flipper_models/models/category.dart';
import 'package:flipper_models/models/color.dart';
import 'package:flipper_models/models/login.dart';
import 'package:flipper_models/models/product.dart';
import 'package:flipper_models/models/stock.dart';
import 'package:flipper_models/models/sync.dart';
import 'package:flipper_models/models/unit.dart';
import 'package:flipper_models/models/variant_stock.dart';

import 'abstractions/api.dart';

class FakeApi implements Api {
  @override
  Future<Sync> authenticateWithOfflineDb({required String userId}) {
    // TODO: implement authenticateWithOfflineDb
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> businesses() {
    // TODO: implement canStart
    throw UnimplementedError();
  }

  @override
  Future<Login> login({required String phone}) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future payroll() {
    // TODO: implement payroll
    throw UnimplementedError();
  }

  @override
  Future<int> signup({required Map business}) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> products() {
    // TODO: implement products
    throw UnimplementedError();
  }

  @override
  Future<List<Stock>> stocks({required String productId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  Future<List<Branch>> branches({required String businessId}) {
    // TODO: implement branches
    throw UnimplementedError();
  }

  @override
  Future<bool> logOut() {
    // TODO: implement logOut
    throw UnimplementedError();
  }

  @override
  Future<List<PColor>> colors({required String branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  Future<List<Category>> categories({required String branchId}) {
    // TODO: implement categories
    throw UnimplementedError();
  }

  @override
  Future<List<Unit>> units({required String branchId}) {
    // TODO: implement units
    throw UnimplementedError();
  }

  @override
  Future<List<VariantStock>> variantStock(
      {required String branchId, required String variantId}) {
    // TODO: implement variantStock
    throw UnimplementedError();
  }

  @override
  Future<Product> createProduct({required Product product}) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> isTempProductExist() {
    // TODO: implement isTempProductExist
    throw UnimplementedError();
  }

  @override
  Future<List<VariantStock>> variantProduct(
      {required String branchId, required String productId}) {
    // TODO: implement variantProduct
    throw UnimplementedError();
  }

  @override
  Future<bool> delete({required String id, String? endPoint}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<int> create<T>({required Map data, required String endPoint}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<int> update<T>({required Map data, required String endPoint}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<int> addUnits({required Map data}) {
    // TODO: implement addUnits
    throw UnimplementedError();
  }

  @override
  Future<PColor> getColor({required String id, String? endPoint}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }
}
