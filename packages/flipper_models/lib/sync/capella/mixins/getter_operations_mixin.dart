import 'dart:async';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_models/sync/interfaces/getter_operations_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/sale_device_id.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaGetterOperationsMixin implements GetterOperationsInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Future<Device?> getDevice({
    required String phone,
    required String linkingCode,
  }) async {
    throw UnimplementedError('getDevice needs to be implemented for Capella');
  }

  @override
  Future<Device?> getDeviceById({required int id}) async {
    throw UnimplementedError(
      'getDeviceById needs to be implemented for Capella',
    );
  }

  @override
  Future<List<Device>> getDevices({required String businessId}) async {
    throw UnimplementedError('getDevices needs to be implemented for Capella');
  }

  @override
  Future<Favorite?> getFavoriteById({required String favId}) async {
    throw UnimplementedError(
      'getFavoriteById needs to be implemented for Capella',
    );
  }

  @override
  Future<Favorite?> getFavoriteByIndex({required String favIndex}) async {
    throw UnimplementedError(
      'getFavoriteByIndex needs to be implemented for Capella',
    );
  }

  @override
  Stream<Favorite?> getFavoriteByIndexStream({required String favIndex}) {
    throw UnimplementedError(
      'getFavoriteByIndexStream needs to be implemented for Capella',
    );
  }

  @override
  Future<Favorite?> getFavoriteByProdId({required String prodId}) async {
    throw UnimplementedError(
      'getFavoriteByProdId needs to be implemented for Capella',
    );
  }

  @override
  Future<List<Favorite>> getFavorites() async {
    throw UnimplementedError(
      'getFavorites needs to be implemented for Capella',
    );
  }

  @override
  Future<String> getFirebaseToken() async {
    throw UnimplementedError(
      'getFirebaseToken needs to be implemented for Capella',
    );
  }

  @override
  FutureOr<FlipperSaleCompaign?> getLatestCompaign() async {
    throw UnimplementedError(
      'getLatestCompaign needs to be implemented for Capella',
    );
  }

  @override
  Future<Plan?> getPaymentPlan({
    required String businessId,
    bool? fetchOnline,
    bool? preferFresh,
  }) async {
    try {
      // Prefer Ditto when live (e.g. PlanDittoScheduler). Plan is not in Brick/SQLite — if Ditto misses
      // or is not ready, read the `plans` row from Supabase (same as GetterOperationsMixin).
      if (dittoService.isReady()) {
        final plan = await dittoService.getPaymentPlanFromDitto(businessId);
        if (plan != null) {
          talker.info('getPaymentPlan: from Ditto businessId=$businessId');
          return plan;
        }
        talker.info(
          'getPaymentPlan: no plan in Ditto for businessId=$businessId — fetching from Supabase',
        );
      } else {
        talker.info(
          'getPaymentPlan: Ditto not ready for businessId=$businessId — fetching plan from Supabase',
        );
      }

      final remote = await _paymentPlanFromSupabase(businessId);
      if (remote != null) {
        talker.info('getPaymentPlan: from Supabase businessId=$businessId');
      }
      return remote;
    } catch (e) {
      talker.error('getPaymentPlan error: $e');
      rethrow;
    }
  }

  @override
  FutureOr<List<TransactionPaymentRecord>> getPaymentType({
    required String transactionId,
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto != null) {
        const sql =
            'SELECT * FROM transaction_payment_records WHERE transactionId = :transactionId';
        final queryResult = await ditto.store.execute(
          sql,
          arguments: {'transactionId': transactionId},
        );
        if (queryResult.items.isNotEmpty) {
          final fromDitto = <TransactionPaymentRecord>[];
          for (final item in queryResult.items) {
            final data = Map<String, dynamic>.from(item.value);
            final rec = _transactionPaymentRecordFromDittoRow(data);
            if (rec != null) {
              fromDitto.add(rec);
            }
          }
          if (fromDitto.isNotEmpty) {
            return fromDitto;
          }
        }
      }
    } catch (e, s) {
      talker.warning(
        'getPaymentType: Ditto query failed for $transactionId, falling back to repository: $e',
        s,
      );
    }

    final query = Query(
      where: [Where('transactionId').isExactly(transactionId)],
    );
    return repository.get<TransactionPaymentRecord>(
      query: query,
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
    );
  }

  @override
  Future<IPin?> getPin({
    required String pinString,
    required HttpClientInterface flipperHttpClient,
  }) async {
    throw UnimplementedError('getPin needs to be implemented for Capella');
  }

  @override
  Future<String?> getPlatformDeviceId() async {
    try {
      return await resolveSaleDeviceId();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> getProducts({
    String? key,
    int? prodIndex,
    required String branchId,
  }) async {
    throw UnimplementedError('getProducts needs to be implemented for Capella');
  }

  @override
  Future<Receipt?> getReceipt({required String transactionId}) async {
    throw UnimplementedError('getReceipt needs to be implemented for Capella');
  }

  @override
  FutureOr<Tenant?> getTenant({String? userId, int? pin}) async {
    throw UnimplementedError('getTenant needs to be implemented for Capella');
  }

  @override
  Future<({double expense, double income})> getTransactionsAmountsSum({
    required String period,
  }) async {
    throw UnimplementedError(
      'getTransactionsAmountsSum needs to be implemented for Capella',
    );
  }

  @override
  FutureOr<Business?> getBusinessById({
    required String businessId,
    bool fetchOnline = false,
  }) async {
    throw UnimplementedError(
      'getBusinessById needs to be implemented for Capella',
    );
  }

  // branch() is implemented by CapellaBranchMixin (do not stub here — later
  // mixins shadow earlier ones and would hide the Ditto implementation).

  @override
  Future<List<ITransaction>> transactions({
    DateTime? startDate,
    DateTime? endDate,
    String? status,
    bool skipOriginalTransactionCheck = false,
    String? transactionType,
    bool isCashOut = false,
    bool fetchRemote = false,
    String? id,
    bool isExpense = false,
    FilterType? filterType,
    String? branchId,
    bool includeZeroSubTotal = false,
    bool includePending = false,
    bool forceRealData = true,
    List<String>? receiptNumber,
    String? customerId,
  }) async {
    throw UnimplementedError(
      'transactions needs to be implemented for Capella',
    );
  }
}

Future<Plan?> _paymentPlanFromSupabase(String businessId) async {
  final row = await Supabase.instance.client
      .from('plans')
      .select()
      .eq('business_id', businessId)
      .maybeSingle();
  if (row == null) return null;
  return Plan.fromSupabaseJson(Map<String, dynamic>.from(row));
}

double? _parsePaymentAmount(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

DateTime? _parsePaymentCreatedAt(dynamic v) {
  if (v == null) return null;
  if (v is DateTime) return v;
  return DateTime.tryParse(v.toString());
}

/// Maps a Ditto SQL row for [transaction_payment_records] to the Brick model.
TransactionPaymentRecord? _transactionPaymentRecordFromDittoRow(
  Map<String, dynamic> data,
) {
  final tid = data['transactionId']?.toString();
  if (tid == null || tid.isEmpty) return null;
  final id = data['id']?.toString() ?? data['_id']?.toString();
  return TransactionPaymentRecord(
    id: id,
    transactionId: tid,
    amount: _parsePaymentAmount(data['amount']) ?? 0.0,
    paymentMethod: data['paymentMethod']?.toString(),
    createdAt: _parsePaymentCreatedAt(data['createdAt']),
  );
}
