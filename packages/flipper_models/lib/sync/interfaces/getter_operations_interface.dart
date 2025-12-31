import 'dart:async';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_services/constants.dart';

abstract class GetterOperationsInterface {
  Future<Device?> getDevice(
      {required String phone, required String linkingCode});
  Future<Device?> getDeviceById({required int id});
  Future<List<Device>> getDevices({required String businessId});
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
  FutureOr<Pin?> getPinLocal({
    String? userId,
    String? phoneNumber,
    required bool alwaysHydrate,
  });
  Future<String?> getPlatformDeviceId();
  Future<List<Product>> getProducts(
      {String? key, int? prodIndex, required String branchId});
  Future<Receipt?> getReceipt({required String transactionId});
  FutureOr<Tenant?> getTenant({String? userId, int? pin});
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period});
  Future<Plan?> getPaymentPlan({
    required String businessId,
    bool? fetchOnline,
  });

  // Required methods that should be provided by other mixins
  FutureOr<Business?> getBusinessById({required String businessId});
  FutureOr<Branch?> branch({required String serverId});
  FutureOr<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    String? transactionType,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    String? branchId,
    bool isExpense = false,
    bool includePending = false,
  });
}
