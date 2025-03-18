import 'dart:async';
import 'package:flipper_models/sync/interfaces/getter_operations_interface.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_services/constants.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaGetterOperationsMixin implements GetterOperationsInterface {
  Repository get repository;
  Talker get talker;

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    throw UnimplementedError('getDevice needs to be implemented for Capella');
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    throw UnimplementedError(
        'getDeviceById needs to be implemented for Capella');
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    throw UnimplementedError('getDevices needs to be implemented for Capella');
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    throw UnimplementedError('getDrawer needs to be implemented for Capella');
  }

  @override
  Future<Favorite?> getFavoriteById({required String favId}) async {
    throw UnimplementedError(
        'getFavoriteById needs to be implemented for Capella');
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    throw UnimplementedError(
        'getFavoriteByIndex needs to be implemented for Capella');
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    throw UnimplementedError(
        'getFavoriteByIndexStream needs to be implemented for Capella');
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    throw UnimplementedError(
        'getFavoriteByProdId needs to be implemented for Capella');
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    throw UnimplementedError(
        'getFavorites needs to be implemented for Capella');
  }

  @override
  Future<String> getFirebaseToken() async {
    throw UnimplementedError(
        'getFirebaseToken needs to be implemented for Capella');
  }

  @override
  FutureOr<FlipperSaleCompaign?> getLatestCompaign() async {
    throw UnimplementedError(
        'getLatestCompaign needs to be implemented for Capella');
  }

  @override
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required String transactionId}) async {
    throw UnimplementedError(
        'getPaymentType needs to be implemented for Capella');
  }

  @override
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) async {
    throw UnimplementedError('getPin needs to be implemented for Capella');
  }

  @override
  FutureOr<Pin?> getPinLocal({required int userId}) async {
    throw UnimplementedError('getPinLocal needs to be implemented for Capella');
  }

  @override
  Future<String?> getPlatformDeviceId() async {
    throw UnimplementedError(
        'getPlatformDeviceId needs to be implemented for Capella');
  }

  @override
  Future<List<Product>> getProducts(
      {String? key, int? prodIndex, required int branchId}) async {
    throw UnimplementedError('getProducts needs to be implemented for Capella');
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) async {
    throw UnimplementedError('getReceipt needs to be implemented for Capella');
  }

  @override
  FutureOr<Tenant?> getTenant({int? userId, int? pin}) async {
    throw UnimplementedError('getTenant needs to be implemented for Capella');
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) async {
    throw UnimplementedError(
        'getTransactionsAmountsSum needs to be implemented for Capella');
  }

  @override
  Future<Plan?> getPaymentPlan({required int businessId}) async {
    throw UnimplementedError(
        'getPaymentPlan needs to be implemented for Capella');
  }

  @override
  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient}) async {
    throw UnimplementedError(
        'hasActiveSubscription needs to be implemented for Capella');
  }

  @override
  Future<Business?> getBusinessById({required int businessId}) async {
    throw UnimplementedError(
        'getBusinessById needs to be implemented for Capella');
  }

  @override
  Future<Branch?> branch({required int serverId}) async {
    throw UnimplementedError('branch needs to be implemented for Capella');
  }

  @override
  FutureOr<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
  }) async {
    throw UnimplementedError(
        'transactions needs to be implemented for Capella');
  }
}
