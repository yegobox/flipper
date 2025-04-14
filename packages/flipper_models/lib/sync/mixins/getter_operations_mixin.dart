import 'dart:async';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/sync/interfaces/getter_operations_interface.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_services/constants.dart';

mixin GetterOperationsMixin implements GetterOperationsInterface {
  Repository get repository;
  String get apihub;

  @override
  FutureOr<Business?> getBusinessById({required int businessId});
  @override
  FutureOr<Branch?> branch({required int serverId});
  @override
  Future<List<ITransaction>> transactions({
    DateTime? startDate,
    bool fetchRemote = false,
    DateTime? endDate,
    String? status,
    String? transactionType,
    bool isCashOut = false,
    String? id,
    FilterType? filterType,
    bool includeZeroSubTotal = false,
    int? branchId,
    bool isExpense = false,
    bool includePending = false,
  });

  @override
  Future<Device?> getDevice(
      {required String phone, required String linkingCode}) async {
    final query = Query(where: [
      Where('phone', value: phone, compare: Compare.exact),
      Where('linkingCode', value: linkingCode, compare: Compare.exact),
    ]);
    final List<Device> fetchedDevices =
        await repository.get<Device>(query: query);
    return fetchedDevices.firstOrNull;
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    final query = Query(where: [Where('id').isExactly(id)]);
    final List<Device> fetchedDevices = await repository.get<Device>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    return fetchedDevices.firstOrNull;
  }

  @override
  Future<List<Device>> getDevices({required int businessId}) async {
    final query = Query(where: [Where('businessId').isExactly(businessId)]);
    return await repository.get<Device>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<Drawers?> getDrawer({required int cashierId}) async {
    final query = Query(where: [Where('cashierId').isExactly(cashierId)]);
    final List<Drawers> fetchedDrawers = await repository.get<Drawers>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    return fetchedDrawers.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteById({required String favId}) async {
    final query = Query(where: [Where('id').isExactly(favId)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    return fetchedFavorites.firstOrNull;
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    final query = Query(where: [Where('favIndex').isExactly(favIndex)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    return fetchedFavorites.firstOrNull;
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    final query = Query(where: [Where('favIndex').isExactly(favIndex)]);
    return repository
        .subscribe<Favorite>(
          query: query,
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        )
        .map((data) => data.firstOrNull);
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    final query = Query(where: [Where('productId').isExactly(prodId)]);
    final List<Favorite> fetchedFavorites = await repository.get<Favorite>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    return fetchedFavorites.firstOrNull;
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    final query = Query();
    return await repository.get<Favorite>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<String> getFirebaseToken() async {
    return await FirebaseAuth.instance.currentUser?.getIdToken() ?? "NONE";
  }

  @override
  FutureOr<FlipperSaleCompaign?> getLatestCompaign() async {
    final query = Query(
      orderBy: [const OrderBy('createdAt', ascending: false)],
    );
    final List<FlipperSaleCompaign> fetchedCampaigns =
        await repository.get<FlipperSaleCompaign>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
    return fetchedCampaigns.firstOrNull;
  }

  @override
  FutureOr<List<TransactionPaymentRecord>> getPaymentType(
      {required String transactionId}) async {
    final query =
        Query(where: [Where('transactionId').isExactly(transactionId)]);
    return await repository.get<TransactionPaymentRecord>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<IPin?> getPin(
      {required String pinString,
      required HttpClientInterface flipperHttpClient}) async {
    final Uri uri = Uri.parse("$apihub/v2/api/pin/$pinString");

    try {
      final localPin = await repository.get<Pin>(
        query: Query(where: [Where('userId').isExactly(pinString)]),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );

      if (localPin.firstOrNull != null) {
        Business? business = await getBusinessById(
            businessId: localPin.firstOrNull!.businessId!);
        Branch? branchE =
            await branch(serverId: localPin.firstOrNull!.branchId!);
        if (branchE != null || business != null) {
          return IPin(
            id: int.tryParse(localPin.firstOrNull?.id ?? "0"),
            pin: localPin.firstOrNull?.pin ?? int.parse(pinString),
            userId: localPin.firstOrNull!.userId!.toString(),
            phoneNumber: localPin.firstOrNull!.phoneNumber!,
            branchId: localPin.firstOrNull!.branchId!,
            businessId: localPin.firstOrNull!.businessId!,
            ownerName: localPin.firstOrNull!.ownerName ?? "N/A",
            tokenUid: localPin.firstOrNull!.tokenUid ?? "N/A",
          );
        }
      }

      final response = await flipperHttpClient.get(uri);
      if (response.statusCode == 200) {
        return IPin.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw NeedSignUpException(term: "User does not exist needs signup.");
      } else {
        throw PinError(term: "Not found");
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  FutureOr<Pin?> getPinLocal({required int userId}) async {
    return (await repository.get<Pin>(
      query: Query(where: [Where('userId').isExactly(userId)]),
    ))
        .firstOrNull;
  }

  @override
  Future<String?> getPlatformDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (foundation.defaultTargetPlatform == foundation.TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.serialNumber;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.systemVersion;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.macOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      return macOsInfo.systemGUID;
    } else if (foundation.defaultTargetPlatform ==
        foundation.TargetPlatform.windows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId;
    }
    return null;
  }

  @override
  Future<List<Product>> getProducts(
      {String? key, int? prodIndex, required int branchId}) async {
    if (key != null) {
      return await repository.get<Product>(
        query: Query(where: [Where('name').isExactly(key)]),
      );
    }
    if (prodIndex != null) {
      return await repository.get<Product>(
        query: Query(where: [Where('id').isExactly(prodIndex)]),
      );
    }
    return await repository.get<Product>(
      query: Query(where: [Where('branchId').isExactly(branchId)]),
    );
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) async {
    return (await repository.get<Receipt>(
      query: Query(where: [Where('transactionId').isExactly(transactionId)]),
    ))
        .firstOrNull;
  }

  @override
  FutureOr<Tenant?> getTenant({int? userId, int? pin}) async {
    if (userId != null) {
      return (await repository.get<Tenant>(
        query: Query(where: [Where('userId').isExactly(userId)]),
      ))
          .firstOrNull;
    } else if (pin != null) {
      return (await repository.get<Tenant>(
        query: Query(where: [Where('pin').isExactly(pin)]),
      ))
          .firstOrNull;
    }
    throw Exception("UserId or Pin is required");
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum(
      {required String period}) async {
    DateTime oldDate;
    DateTime temporaryDate;

    if (period == 'Today') {
      DateTime tempToday = DateTime.now();
      oldDate = DateTime(tempToday.year, tempToday.month, tempToday.day);
    } else if (period == 'This Week') {
      oldDate = DateTime.now().subtract(Duration(days: 7));
    } else if (period == 'This Month') {
      oldDate = DateTime.now().subtract(Duration(days: 30));
    } else {
      oldDate = DateTime.now().subtract(Duration(days: 365));
    }

    List<ITransaction> transactionsList = await transactions();
    List<ITransaction> filteredTransactions = [];

    for (final transaction in transactionsList) {
      temporaryDate = transaction.createdAt!;
      if (temporaryDate.isAfter(oldDate)) {
        filteredTransactions.add(transaction);
      }
    }

    double sum_cash_in = 0;
    double sum_cash_out = 0;

    for (final transaction in filteredTransactions) {
      if (transaction.transactionType == 'Cash Out') {
        sum_cash_out = transaction.subTotal! + sum_cash_out;
      } else {
        sum_cash_in = transaction.subTotal! + sum_cash_in;
      }
    }

    return (income: sum_cash_in, expense: sum_cash_out);
  }

  @override
  Future<Plan?> getPaymentPlan({required int businessId}) async {
    try {
      final query = Query(where: [Where('businessId').isExactly(businessId)]);
      final result = await repository.get<Plan>(
        query: query,
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
      return result.firstOrNull;
    } catch (e) {
      talker.error(e);
      rethrow;
    }
  }
}
