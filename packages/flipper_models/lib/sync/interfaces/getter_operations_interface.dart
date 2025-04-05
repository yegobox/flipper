import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_services/constants.dart';

abstract class GetterOperationsInterface {
  Future<Device?> getDevice(
      {required String phone, required String linkingCode});
  Future<Device?> getDeviceById({required int id});
  Future<List<Device>> getDevices({required int businessId});
  Future<Drawers?> getDrawer({required int cashierId});
  Future<Favorite?> getFavoriteById({required String favId});
  Future<Favorite?> getFavoriteByIndex({required String favIndex});
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex});
  Future<Favorite?> getFavoriteByProdId({required String prodId});
  Future<List<Favorite>> getFavorites();
  Future<String> getFirebaseToken();
  FutureOr<FlipperSaleCompaign?> getLatestCompaign();
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required String transactionId});
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient});
  FutureOr<Pin?> getPinLocal({required int userId});
  Future<String?> getPlatformDeviceId();
  Future<List<Product>> getProducts(
      {String? key, int? prodIndex, required int branchId});
  Future<Receipt?> getReceipt({required String transactionId});
  FutureOr<Tenant?> getTenant({int? userId, int? pin});
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period});
  Future<Plan?> getPaymentPlan({required int businessId});
  Future<bool> hasActiveSubscription(
      {required int businessId,
      required HttpClientInterface flipperHttpClient});

  // Required methods that should be provided by other mixins
  FutureOr<Business?> getBusinessById({required int businessId});
  FutureOr<Branch?> branch({required int serverId});
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
  });
}
