import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/cache/utility_cash_variant_cache.dart';
import 'package:flipper_models/helpers/cash_movement_utility_variant.dart';
import 'package:flipper_models/flipper_http_client.dart';
import 'package:flipper_models/helperModels/business_type.dart';
import 'package:flipper_models/sync/capella/mixins/delegation_mixin.dart';
import 'package:flipper_models/sync/mixins/category_mixin.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_core/query.dart' as brick;
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flipper_services/proxy.dart';
import 'package:http/src/base_request.dart';
import 'package:http/src/response.dart';
import 'package:http/src/streamed_response.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_models/brick/models/credit.model.dart';
import 'package:supabase_models/brick/models/log.model.dart';
import 'package:flipper_models/models/subscription_plan.dart';
import 'package:talker/talker.dart';
import 'package:flipper_models/sync/capella/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/business_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/conversation_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/customer_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/delete_operations_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/ebm_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/favorite_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/getter_operations_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/product_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/purchase_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/receipt_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/stock_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/storage_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/system_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/tenant_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_item_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/transaction_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/variant_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/shift_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/stock_recount_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/counter_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/personal_goals_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/settings_mixin.dart';
import 'package:flipper_services/ai_strategy_impl.dart';
import 'package:flipper_models/sync/mixins/stock_recount_mixin.dart';
import 'package:supabase_models/brick/models/all_models.dart' hide BusinessType;
import 'package:flipper_models/sync/capella/mixins/production_output_mixin.dart';
import 'package:flipper_web/services/ditto_service.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flipper_models/SyncStrategy.dart';

import 'package:flipper_services/constants.dart';

class CapellaSync extends AiStrategyImpl
    with
        CapellaAuthMixin,
        CapellaBranchMixin,
        CapellaBusinessMixin,
        CapellaConversationMixin,
        CapellaCounterMixin,
        CapellaCustomerMixin,
        CapellaDeleteOperationsMixin,
        CapellaEbmMixin,
        CapellaFavoriteMixin,
        CoreMiscellaneous,
        CapellaGetterOperationsMixin,
        CapellaProductMixin,
        CapellaPurchaseMixin,
        CapellaReceiptMixin,
        CapellaStorageMixin,
        CapellaSystemMixin,
        CapellaTenantMixin,
        CapellaTransactionItemMixin,
        CapellaTransactionMixin,
        CapellaVariantMixin,
        CapellaShiftMixin,
        CapellaStockMixin,
        CategoryMixin,
        CapellaDelegationMixin,
        StockRecountMixin,
        CapellaStockRecountMixin,
        CapellaSettingsMixin,
        CapellaProductionOutputMixin,
        CapellaPersonalGoalsMixin
    implements DatabaseSyncInterface {
  CapellaSync();

  DittoService get dittoService => DittoService.instance;
  @override
  Future<void> initCollections() async {
    throw UnimplementedError('initCollections needs to be implemented');
  }

  @override
  Future<Stream<double>> downloadAsset({
    required String branchId,
    required String assetName,
    required String subPath,
  }) async {
    throw UnimplementedError('downloadAsset needs to be implemented');
  }

  @override
  Future<void> upsertPlan({
    required String businessId,
    required Plan selectedPlan,
  }) async {
    throw UnimplementedError('upsertPlan needs to be implemented');
  }

  @override
  Future<Map<String, dynamic>> validateDiscountCode({
    required String code,
    required String planName,
    required double amount,
  }) async {
    try {
      final response = await Supabase.instance.client
          .rpc(
            'validate_discount_code',
            params: {
              'p_code': code,
              'p_plan_name': planName,
              'p_amount': amount,
            },
          )
          .single();

      return response;
    } catch (e) {
      talker.error('Failed to validate discount code: $e');
      return {
        'is_valid': false,
        'error_message': 'Failed to validate code: $e',
      };
    }
  }

  @override
  Future<String?> applyDiscountToPlan({
    required String planId,
    required String discountCodeId,
    required double originalPrice,
    required double discountAmount,
    required double finalPrice,
    required String businessId,
  }) async {
    try {
      final response = await Supabase.instance.client.rpc(
        'apply_discount_to_plan',
        params: {
          'p_plan_id': planId,
          'p_discount_code_id': discountCodeId,
          'p_original_price': originalPrice,
          'p_discount_amount': discountAmount,
          'p_final_price': finalPrice,
          'p_business_id': businessId,
        },
      );

      talker.info('Discount applied successfully to plan $planId');
      return response as String?;
    } catch (e) {
      talker.error('Failed to apply discount: $e');
      throw Exception('Failed to apply discount: $e');
    }
  }

  @override
  Future<Map<String, dynamic>?> getPlanDiscount({
    required String planId,
  }) async {
    try {
      final response = await Supabase.instance.client
          .from('plan_discounts')
          .select('*, discount_codes(*)')
          .eq('plan_id', planId)
          .maybeSingle();

      return response;
    } catch (e) {
      talker.error('Failed to get plan discount: $e');
      return null;
    }
  }

  @override
  double calculateDiscount({
    required double originalPrice,
    required String discountType,
    required double discountValue,
  }) {
    if (discountType == 'percentage') {
      return originalPrice * (discountValue / 100);
    } else {
      // Fixed amount
      return discountValue;
    }
  }

  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    throw UnimplementedError('downloadAssetSave needs to be implemented');
  }

  @override
  Future<void> startReplicator() async {
    throw UnimplementedError('startReplicator needs to be implemented');
  }

  @override
  Future<List<BusinessType>> businessTypes() {
    // TODO: implement businessTypes
    throw UnimplementedError();
  }

  @override
  Future<Tenant?> tenant({
    String? businessId,
    String? userId,
    String? tenantId,
    required bool fetchRemote,
  }) {
    // TODO: implement tenant
    throw UnimplementedError();
  }

  @override
  Future<List<Tenant>> tenants({String? businessId, int? excludeUserId}) {
    // TODO: implement tenants
    throw UnimplementedError();
  }

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  @override
  Future<List<Access>> access({
    required String userId,
    String? featureName,
    required bool fetchRemote,
  }) {
    // TODO: implement access
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addAccess({
    required String userId,
    required String featureName,
    required String accessLevel,
    required String userType,
    required String status,
    required String branchId,
    required String businessId,
    DateTime? createdAt,
  }) {
    // TODO: implement addAccess
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addAsset({
    required String productId,
    required assetName,
    required String branchId,
    required String businessId,
    String? variantId,
  }) {
    // TODO: implement addAsset
    throw UnimplementedError();
  }

  @override
  FutureOr<Branch> addBranch({
    required String name,
    required String businessId,
    required String location,
    String? userOwnerPhoneNumber,
    HttpClientInterface? flipperHttpClient,
    int? serverId,
    String? description,
    num? longitude,
    num? latitude,
    required bool isDefault,
    required bool active,
    DateTime? lastTouched,
    DateTime? deletedAt,
    int? id,
  }) {
    // TODO: implement addBranch
    throw UnimplementedError();
  }

  @override
  FutureOr<void> addColor({required String name, required String branchId}) {
    // TODO: implement addColor
    throw UnimplementedError();
  }

  @override
  Future<List<Access>> allAccess({required String userId}) {
    // TODO: implement allAccess
    throw UnimplementedError();
  }

  @override
  Future<void> amplifyLogout() {
    // TODO: implement amplifyLogout
    throw UnimplementedError();
  }

  @override
  Future<List<BusinessAnalytic>> analytics({required String branchId}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        throw Exception('Ditto not initialized');
      }

      // Subscribe to the collection first
      final preparedBa = prepareDqlSyncSubscription(
        "SELECT * FROM business_analytics WHERE branchId = :branchId",
        {'branchId': branchId},
      );
      ditto.sync.registerSubscription(
        preparedBa.dql,
        arguments: preparedBa.arguments,
      );

      final result = await ditto.store.execute(
        'SELECT * FROM business_analytics WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
      );

      talker.info("Queries result: ${result.items.length}");

      return result.items.map((item) {
        final data = Map<String, dynamic>.from(item.value);
        return BusinessAnalytic(
          id: data['_id'] ?? data['id'],
          stockRemainedAtTheTimeOfSale:
              double.tryParse(
                data['stockRemainedAtTheTimeOfSale']?.toString() ?? '0',
              ) ??
              0.0,
          transactionId: data['transactionId'],
          branchId: data['branchId'],
          date: data['date'] != null
              ? DateTime.parse(data['date'])
              : DateTime.now(),
          itemName: data['itemName'] ?? 'Unknown Item',
          price: double.tryParse(data['price']?.toString() ?? '0') ?? 0.0,
          profit: double.tryParse(data['profit']?.toString() ?? '0') ?? 0.0,
          unitsSold: int.tryParse(data['unitsSold']?.toString() ?? '0') ?? 0,
          taxRate: double.tryParse(data['taxRate']?.toString() ?? '0') ?? 0.0,
          trafficCount:
              int.tryParse(data['trafficCount']?.toString() ?? '0') ?? 0,
          categoryName: data['categoryName'],
          categoryId: data['categoryId'],
          value: double.tryParse(data['value']?.toString() ?? '0') ?? 0.0,
          supplyPrice:
              double.tryParse(data['supplyPrice']?.toString() ?? '0') ?? 0.0,
          retailPrice:
              double.tryParse(data['retailPrice']?.toString() ?? '0') ?? 0.0,
          currentStock:
              double.tryParse(data['currentStock']?.toString() ?? '0') ?? 0.0,
          stockValue:
              double.tryParse(data['stockValue']?.toString() ?? '0') ?? 0.0,
          paymentMethod: data['paymentMethod'] ?? 'cash',
          customerType: data['customerType'] ?? 'walk-in',
          discountAmount:
              double.tryParse(data['discountAmount']?.toString() ?? '0') ?? 0.0,
          taxAmount:
              double.tryParse(data['taxAmount']?.toString() ?? '0') ?? 0.0,
        );
      }).toList();
    } catch (e) {
      talker.error('Error fetching analytics: $e');
      // get it from sqlite as fallback upsert it for it to be saved into ditto next time
      final data = await repository.get<BusinessAnalytic>(
        /// since we always want fresh data and assumption is that ai is supposed to work with internet on, then this make sense.
        policy: OfflineFirstGetPolicy.alwaysHydrate,
        query: brick.Query(
          // limit: 100,
          where: [brick.Where('branchId').isExactly(branchId)],
          orderBy: [brick.OrderBy('date', ascending: false)],
        ),
      );
      for (var element in data) {
        repository.upsert<BusinessAnalytic>(element);
      }
      return data;
    }
  }

  @override
  FutureOr<void> assignCustomerToTransaction({
    required Customer customer,
    required ITransaction transaction,
  }) {
    // TODO: implement assignCustomerToTransaction
    throw UnimplementedError();
  }

  @override
  Stream<Tenant?> authState({required String branchId}) {
    // TODO: implement authState
    throw UnimplementedError();
  }

  @override
  Future<bool> bindProduct({
    required String productId,
    required String tenantId,
  }) {
    // TODO: implement bindProduct
    throw UnimplementedError();
  }

  @override
  Future<void> cleanDuplicatePlans() {
    // TODO: implement cleanDuplicatePlans
    throw UnimplementedError();
  }

  @override
  Future<int> clearOldLogs({required Duration olderThan, String? businessId}) {
    // TODO: implement clearOldLogs
    throw UnimplementedError();
  }

  @override
  Future<ITransaction> collectPayment({
    required double cashReceived,
    ITransaction? transaction,
    required String paymentType,
    required double discount,
    required String branchId,
    required String bhfId,
    required bool isProformaMode,
    required bool isTrainingMode,
    required String transactionType,
    String? categoryId,
    bool directlyHandleReceipt = false,
    required bool isIncome,
    String? customerName,
    String? customerTin,
    String? customerPhone,
    required String countryCode,
    String? note,
    String? completionStatus,
    List<TransactionItem>? preloadedLineItems,
    bool isUtilityCashbookMovement = false,
    bool skipPersonalGoalAutoSweep = false,
    bool skipTransactionPersist = false,
  }) async {
    if (transaction == null) {
      throw Exception('transaction is null');
    }

    try {
      if (note != null) transaction.note = note;

      final userId = ProxyService.box.getUserId();
      transaction.customerTin = customerTin;

      final resolvedSalePhone =
          customerPhone ?? ProxyService.box.currentSaleCustomerPhoneNumber();
      if (countryCode != "N/A" &&
          countryCode != "" &&
          resolvedSalePhone != null &&
          resolvedSalePhone.isNotEmpty) {
        transaction.currentSaleCustomerPhoneNumber =
            countryCode + resolvedSalePhone;
      }
      transaction.customerPhone = resolvedSalePhone;
      transaction.customerName =
          customerName ?? ProxyService.box.customerName();

      // Line items: caller can pass fresh lines to skip an extra Ditto read on hot paths.
      final List<TransactionItem> items;
      if (preloadedLineItems != null && preloadedLineItems.isNotEmpty) {
        items = preloadedLineItems;
      } else {
        items = await transactionItems(transactionId: transaction.id);
      }
      transaction.numberOfItems = items.length;
      transaction.discountAmount = items.fold<double>(
        0.0,
        (a, b) => a + (b.dcAmt?.toDouble() ?? 0.0),
      );

      final computedSubTotal = items.isEmpty
          ? cashReceived
          : items.fold(0.0, (a, b) => a + (b.price * b.qty));
      transaction.subTotal = computedSubTotal;

      transaction.customerChangeDue =
          cashReceived - (transaction.subTotal ?? 0);

      // Update shift totals via SQLite (shifts aren't managed in Ditto yet);
      // must run after [transaction.subTotal] is known from line items.
      if (userId != null) {
        try {
          final shifts = await repository.get<Shift>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: brick.Query(
              where: [
                brick.Where('userId').isExactly(userId),
                brick.Where(
                  'businessId',
                ).isExactly(ProxyService.box.getBusinessId()!),
                brick.Where('status').isExactly(ShiftStatus.Open.name),
              ],
            ),
          );
          final currentShift = shifts.lastOrNull;
          if (currentShift != null) {
            num saleAmount = transaction.subTotal ?? 0.0;
            if (!isIncome) {
              saleAmount = -saleAmount;
            }

            final updatedCashSales = (currentShift.cashSales ?? 0) + saleAmount;
            final updatedExpectedCash =
                currentShift.openingBalance + updatedCashSales;

            await repository.upsert<Shift>(
              currentShift.copyWith(
                cashSales: updatedCashSales,
                expectedCash: updatedExpectedCash,
              ),
            );
          }
        } catch (e) {
          talker.warning('Shift update during collectPayment failed: $e');
        }
      }

      if (transaction.isLoan == true) {
        transaction.originalLoanAmount ??= computedSubTotal;
        final totalPaidSoFar = (transaction.cashReceived ?? 0.0) + cashReceived;
        transaction.cashReceived = totalPaidSoFar;
        transaction.remainingBalance = computedSubTotal - totalPaidSoFar;
        transaction.lastPaymentDate = DateTime.now().toUtc();
        transaction.lastPaymentAmount = cashReceived;
      } else {
        transaction.cashReceived =
            (transaction.cashReceived ?? 0.0) + cashReceived;
        transaction.remainingBalance =
            computedSubTotal - (transaction.cashReceived ?? 0.0);
      }

      transaction.transactionType = transactionType;
      transaction.categoryId = categoryId;
      transaction.isIncome = isIncome;
      transaction.isExpense = !isIncome;
      transaction.paymentType = ProxyService.box.paymentType() ?? paymentType;

      // Write transaction to Ditto (optional: caller persists once on completion).
      if (!skipTransactionPersist) {
        await updateTransaction(
          transaction: transaction,
          status: completionStatus,
          subTotal: transaction.subTotal,
          cashReceived: transaction.cashReceived,
          customerName: transaction.customerName,
          customerTin: customerTin,
          customerPhone: transaction.customerPhone,
          note: transaction.note,
          updatedAt: DateTime.now(),
          lastTouched: DateTime.now(),
          remainingBalance: transaction.remainingBalance?.toDouble(),
          isLoan: transaction.isLoan,
        );
      }

      try {
        final resolvedCompletionForGoals =
            completionStatus ?? transaction.status;
        await applyPersonalGoalAutoSweepIfEligible(
          branchId: branchId,
          transactionId: transaction.id,
          completionStatus: resolvedCompletionForGoals,
          isIncome: isIncome,
          isProformaMode: isProformaMode,
          isTrainingMode: isTrainingMode,
          transactionType: transactionType,
          items: items,
          isUtilityCashbookMovement: isUtilityCashbookMovement,
          skipPersonalGoalAutoSweep: skipPersonalGoalAutoSweep,
        );
      } catch (e, s) {
        talker.warning('collectPayment: personal goal auto-sweep skipped: $e\n$s');
      }

      // Defer variant lastTouched updates to avoid DB contention during receipt
      Future.delayed(const Duration(seconds: 5), () async {
        try {
          final variantIds = items
              .map((i) => i.variantId)
              .whereType<String>()
              .toSet();
          for (final id in variantIds) {
            final variant = await getVariant(id: id);
            if (variant != null) {
              variant.lastTouched = DateTime.now().toUtc();
              await repository.upsert<Variant>(variant);
            }
          }
        } catch (e) {
          talker.warning('Deferred variant touch failed: $e');
        }
      });

      return transaction;
    } catch (e, s) {
      talker.error('Capella collectPayment failed: $e', s);
      rethrow;
    }
  }

  @override
  Future<ITransaction> completeCashMovement({
    required String branchId,
    required String bhfId,
    required double cashReceived,
    required bool isIncome,
    required String utilityVariantName,
    required String paymentType,
    required double discount,
    required String countryCode,
    required bool isProformaMode,
    required bool isTrainingMode,
    required String transactionTypeForRecord,
    String? categoryId,
    String? note,
    bool skipPersonalGoalAutoSweep = false,
  }) async {
    final pending = await manageTransaction(
      branchId: branchId,
      transactionType: utilityVariantName,
      isExpense: !isIncome,
    );
    if (pending == null) {
      throw StateError(
        'completeCashMovement: could not create or load pending transaction',
      );
    }

    final baseVariant = await UtilityCashVariantCache.instance.getOrFetch(
      db: this,
      branchId: branchId,
      utilityName: utilityVariantName,
    );
    if (baseVariant == null) {
      throw StateError(
        'completeCashMovement: missing utility variant for $utilityVariantName',
      );
    }

    final linedVariant = cloneUtilityVariantForCashLine(
      utilityVariant: baseVariant,
      cashReceived: cashReceived,
      transactionType: utilityVariantName,
    );

    await saveTransactionItem(
      variation: linedVariant,
      amountTotal: cashReceived,
      customItem: true,
      pendingTransaction: pending,
      currentStock: 0,
      partOfComposite: false,
      doneWithTransaction: true,
      ignoreForReport: false,
      updatePendingTransactionSubtotal: false,
    );

    final preloaded = syntheticPreloadedCashLine(
      linedVariant: linedVariant,
      transactionId: pending.id,
      branchId: branchId,
      cashReceived: cashReceived,
    );

    final txn = await collectPayment(
      cashReceived: cashReceived,
      transaction: pending,
      paymentType: paymentType,
      discount: discount,
      branchId: branchId,
      bhfId: bhfId,
      countryCode: countryCode,
      isProformaMode: isProformaMode,
      isTrainingMode: isTrainingMode,
      transactionType: transactionTypeForRecord,
      categoryId: categoryId,
      directlyHandleReceipt: false,
      isIncome: isIncome,
      note: note,
      completionStatus: COMPLETE,
      preloadedLineItems: preloaded,
      isUtilityCashbookMovement: true,
      skipPersonalGoalAutoSweep: skipPersonalGoalAutoSweep,
    );
    final movementReceipt = isIncome
        ? TransactionType.cashIn
        : TransactionType.cashOut;
    await updateTransaction(
      transaction: txn,
      receiptType: movementReceipt,
      updatedAt: DateTime.now(),
      lastTouched: DateTime.now(),
    );
    txn.receiptType = movementReceipt;
    return txn;
  }

  @override
  Future<List<PColor>> colors({required String branchId}) {
    // TODO: implement colors
    throw UnimplementedError();
  }

  @override
  FutureOr<List<Composite>> composites({String? productId, String? variantId}) {
    // TODO: implement composites
    throw UnimplementedError();
  }

  @override
  conversations({int? conversationId}) {
    // TODO: implement conversations
    throw UnimplementedError();
  }

  @override
  Future<List<Country>> countries() {
    // TODO: implement countries
    throw UnimplementedError();
  }

  @override
  FutureOr<T?> create<T>({required T data}) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> createNewStock({
    required Variant variant,
    required TransactionItem item,
    required String subBranchId,
  }) {
    // TODO: implement createNewStock
    throw UnimplementedError();
  }

  @override
  Future<void> createOrUpdateBranchOnCloud({
    required Branch branch,
    required bool isOnline,
  }) {
    // TODO: implement createOrUpdateBranchOnCloud
    throw UnimplementedError();
  }

  @override
  Future<Variant> createVariant({
    required String barCode,
    required int sku,
    required String productId,
    required String branchId,
    required double retailPrice,
    required double supplierPrice,
    required double qty,
    Map<String, String>? taxTypes,
    Map<String, String>? itemClasses,
    Map<String, String>? itemTypes,
    required String color,
    required int tinNumber,
    required int itemSeq,
    required String name,
    Configurations? taxType,
  }) {
    // TODO: implement createVariant
    throw UnimplementedError();
  }

  @override
  Stream<Credit?> credit({required String branchId}) {
    // TODO: implement credit
    throw UnimplementedError();
  }

  @override
  FutureOr<Branch?> defaultBranch() {
    // TODO: implement defaultBranch
    throw UnimplementedError();
  }

  @override
  Future<Response> delete(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  FutureOr<void> deleteAll<T extends Object>({required String tableName}) {
    // TODO: implement deleteAll
    throw UnimplementedError();
  }

  @override
  Future<void> deleteFailedQueue() {
    // TODO: implement deleteFailedQueue
    throw UnimplementedError();
  }

  @override
  Future<void> deletePaymentById(String id) {
    // TODO: implement deletePaymentById
    throw UnimplementedError();
  }

  @override
  Future<void> deleteTransactionItemAndResequence({required String id}) {
    // TODO: implement deleteTransactionItemAndResequence
    throw UnimplementedError();
  }

  @override
  Future<double> fetchCost(String branchId) {
    // TODO: implement fetchCost
    throw UnimplementedError();
  }

  @override
  Future<double> fetchProfit(String branchId) {
    // TODO: implement fetchProfit
    throw UnimplementedError();
  }

  @override
  Future<List<FinanceProvider>> financeProviders() {
    // TODO: implement financeProviders
    throw UnimplementedError();
  }

  @override
  Stream<List<Variant>> geVariantStreamByProductId({
    required String productId,
  }) {
    // TODO: implement geVariantStreamByProductId
    throw UnimplementedError();
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<List<CustomerPayments>> getAllPayments() {
    // TODO: implement getAllPayments
    throw UnimplementedError();
  }

  @override
  FutureOr<Assets?> getAsset({
    String? assetName,
    String? productId,
    String? variantId,
  }) {
    // TODO: implement getAsset
    throw UnimplementedError();
  }

  @override
  Future<PColor?> getColor({required String id}) {
    // TODO: implement getColor
    throw UnimplementedError();
  }

  @override
  Future<List<Business>> getContacts() {
    // TODO: implement getContacts
    throw UnimplementedError();
  }

  @override
  Future<Credit?> getCredit({required String branchId}) async {
    try {
      final response = await Supabase.instance.client
          .from('credits')
          .select()
          .eq('branch_id', branchId)
          .maybeSingle();

      if (response == null) return null;

      return Credit(
        id: response['id'] as String,
        branchId: response['branch_id'] as String?,
        businessId: response['business_id'] as String?,
        credits: (response['credits'] as num).toDouble(),
        createdAt: DateTime.parse(response['created_at'] as String),
        updatedAt: DateTime.parse(response['updated_at'] as String),
        branchServerId: response['branch_server_id']?.toString() ?? '',
      );
    } catch (e) {
      talker.error('CapellaSync: Failed to get credit: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateCredit(Credit credit) async {
    try {
      await Supabase.instance.client
          .from('credits')
          .update({
            'branch_id': credit.branchId,
            'business_id': credit.businessId,
            'credits': credit.credits,
            'updated_at': credit.updatedAt.toIso8601String(),
            'branch_server_id': credit.branchServerId,
          })
          .eq('id', credit.id);
    } catch (e) {
      talker.error('CapellaSync: Failed to update credit: $e');
      rethrow;
    }
  }

  @override
  Future<Variant?> getCustomVariant({
    required String businessId,
    required String branchId,
    required int tinNumber,
    required String bhFId,
  }) {
    // TODO: implement getCustomVariant
    throw UnimplementedError();
  }

  @override
  Future<Variant?> getUtilityVariant({
    required String name,
    required String branchId,
  }) async {
    try {
      final businessId = ProxyService.box.getBusinessId();
      final ditto = dittoService.dittoInstance;
      if (businessId != null && ditto != null) {
        final utilityProduct = await getProduct(
          branchId: branchId,
          businessId: businessId,
          name: 'Utility',
        );
        if (utilityProduct != null) {
          final r = await ditto.store.execute(
            'SELECT * FROM variants WHERE branchId = :branchId '
            'AND productId = :productId AND name = :name LIMIT 1',
            arguments: {
              'branchId': branchId,
              'productId': utilityProduct.id,
              'name': name,
            },
          );
          if (r.items.isNotEmpty) {
            return Variant.fromJson(
              Map<String, dynamic>.from(r.items.first.value),
            );
          }
        }
      }
    } catch (e, st) {
      talker.warning('getUtilityVariant Ditto path failed: $e\n$st');
    }
    try {
      return await ProxyService.getStrategy(
        Strategy.cloudSync,
      ).getUtilityVariant(name: name, branchId: branchId);
    } catch (e, st) {
      talker.error('getUtilityVariant fallback failed: $e\n$st');
      return null;
    }
  }

  @override
  Future<List<Log>> getLogs({
    String? type,
    String? businessId,
    int limit = 100,
  }) {
    // TODO: implement getLogs
    throw UnimplementedError();
  }

  @override
  Future<CustomerPayments?> getPayment({required String paymentReference}) {
    // TODO: implement getPayment
    throw UnimplementedError();
  }

  @override
  Future<CustomerPayments?> getPaymentById(String id) {
    // TODO: implement getPaymentById
    throw UnimplementedError();
  }

  @override
  @override
  getTop5RecentConversations() {
    // TODO: implement getTop5RecentConversations
    throw UnimplementedError();
  }

  @override
  Future<TransactionItem?> getTransactionItem({
    required String variantId,
    String? transactionId,
  }) {
    // TODO: implement getTransactionItem
    throw UnimplementedError();
  }

  @override
  Future<Response> getUniversalProducts(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    // TODO: implement getUniversalProducts
    throw UnimplementedError();
  }

  @override
  Future<bool> hasOfflineAssets() {
    // TODO: implement hasOfflineAssets
    throw UnimplementedError();
  }

  @override
  Future<BusinessInfo> initializeEbm({
    required String tin,
    required String bhfId,
    required String dvcSrlNo,
  }) {
    // TODO: implement initializeEbm
    throw UnimplementedError();
  }

  @override
  DatabaseSyncInterface instance() {
    // TODO: implement instance
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> isAdmin({required String userId, required String appFeature}) {
    // TODO: implement isAdmin
    throw UnimplementedError();
  }

  @override
  FutureOr<bool> isBranchEnableForPayment({
    required String currentBranchId,
    bool fetchRemote = false,
  }) {
    // TODO: implement isBranchEnableForPayment
    throw UnimplementedError();
  }

  @override
  bool isSubscribed({required String feature, required String businessId}) {
    // TODO: implement isSubscribed
    throw UnimplementedError();
  }

  @override
  Future<bool> isTaxEnabled({
    required String businessId,
    required String branchId,
  }) {
    // TODO: implement isTaxEnabled
    throw UnimplementedError();
  }

  @override
  Future<void> loadConversations({
    required String businessId,
    int? pageSize = 10,
    String? pk,
    String? sk,
  }) {
    // TODO: implement loadConversations
    throw UnimplementedError();
  }

  @override
  void notify({required AppNotification notification}) {
    // TODO: implement notify
  }

  @override
  Future<Response> patch(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  @override
  FutureOr<LPermission?> permission({required String userId}) {
    // TODO: implement permission
    throw UnimplementedError();
  }

  @override
  FutureOr<List<LPermission>> permissions({required String userId}) {
    // TODO: implement permissions
    throw UnimplementedError();
  }

  @override
  Future<Response> post(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<void> processItem({
    required Variant item,
    required Map<String, String> quantitis,
    required Map<String, String> taxTypes,
    required Map<String, String> itemClasses,
    required Map<String, String> itemTypes,
  }) {
    // TODO: implement processItem
    throw UnimplementedError();
  }

  @override
  Future<List<Product>> productsFuture({required String branchId}) {
    // TODO: implement productsFuture
    throw UnimplementedError();
  }

  @override
  Future<Response> put(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<int> queueLength() {
    // TODO: implement queueLength
    throw UnimplementedError();
  }

  @override
  Future<void> reDownloadAsset() {
    // TODO: implement reDownloadAsset
    throw UnimplementedError();
  }

  @override
  Future<void> refreshSession({
    required String branchId,
    int? refreshRate = 5,
  }) {
    // TODO: implement refreshSession
    throw UnimplementedError();
  }

  @override
  Future<void> refund({required int itemId}) {
    // TODO: implement refund
    throw UnimplementedError();
  }

  @override
  Future<bool> removeS3File({required String fileName}) {
    // TODO: implement removeS3File
    throw UnimplementedError();
  }

  @override
  Report report({required int id}) {
    // TODO: implement report
    throw UnimplementedError();
  }

  @override
  Stream<List<Report>> reports({required String branchId}) {
    // TODO: implement reports
    throw UnimplementedError();
  }

  @override
  Future<void> saveComposite({required Composite composite}) {
    // TODO: implement saveComposite
    throw UnimplementedError();
  }

  @override
  Future<void> saveDiscount({
    required String branchId,
    required name,
    double? amount,
  }) {
    // TODO: implement saveDiscount
    throw UnimplementedError();
  }

  @override
  Future<Assets> saveImageLocally({
    required File imageFile,
    required String productId,
    required String branchId,
    required String businessId,
    String subPath = 'branch',
    String? variantId,
  }) {
    // TODO: implement saveImageLocally
    throw UnimplementedError();
  }

  @override
  Future<void> saveLog(Log log) {
    // TODO: implement saveLog
    throw UnimplementedError();
  }

  @override
  FutureOr<Plan?> saveOrUpdatePaymentPlan({
    required String businessId,
    List<String>? addons,
    required String selectedPlan,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required String paymentMethod,
    String? customerCode,
    Plan? plan,
    int numberOfPayments = 1,
    required HttpClientInterface flipperHttpClient,
  }) {
    // TODO: implement saveOrUpdatePaymentPlan
    throw UnimplementedError();
  }

  @override
  FutureOr<void> savePaymentType({
    TransactionPaymentRecord? paymentRecord,
    String? transactionId,
    double amount = 0.0,
    String? paymentMethod,
    required bool singlePaymentOnly,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for savePaymentType');
      return;
    }

    if (transactionId == null) {
      throw ArgumentError('transactionId cannot be null');
    }

    if (paymentMethod == null && paymentRecord == null) {
      throw ArgumentError(
        'Either paymentMethod or paymentRecord must be provided',
      );
    }

    Future<void> mirrorDeleteZeroAmountSqlite() async {
      final withAmount0 = await repository
          .get<TransactionPaymentRecord>(
            policy: OfflineFirstGetPolicy.localOnly,
            query: brick.Query(
              where: [
                brick.Where('transactionId').isExactly(transactionId),
                brick.Where('amount').isExactly(0.0),
              ],
            ),
          )
          .then((records) => records.isEmpty ? null : records.first);
      if (withAmount0 != null) {
        await repository.delete<TransactionPaymentRecord>(
          withAmount0,
          query: brick.Query(action: QueryAction.delete),
        );
      }
    }

    // 1) Drop stale zero-amount rows (matches CoreSync semantics).
    try {
      await ditto.store.execute(
        'DELETE FROM transaction_payment_records WHERE transactionId = :transactionId AND amount = :zero',
        arguments: {'transactionId': transactionId, 'zero': 0.0},
      );
    } catch (e, s) {
      talker.warning(
        'savePaymentType: Ditto delete zero-amount rows failed: $e',
        s,
      );
    }

    await mirrorDeleteZeroAmountSqlite();

    // 2) Single-payment mode: clear existing tender rows before inserting the new one.
    if (singlePaymentOnly) {
      await deletePaymentRecords(transactionId: transactionId);

      final existingRecords = await repository.get<TransactionPaymentRecord>(
        query: brick.Query(
          where: [brick.Where('transactionId').isExactly(transactionId)],
        ),
      );

      await Future.wait(
        existingRecords.map(
          (record) => repository.delete<TransactionPaymentRecord>(
            record,
            query: brick.Query(action: QueryAction.delete),
          ),
        ),
      );
    }

    Future<void> upsertDitto(TransactionPaymentRecord r) async {
      final doc = <String, dynamic>{
        'id': r.id,
        '_id': r.id,
        'transactionId': r.transactionId,
        'amount': r.amount,
        'paymentMethod': r.paymentMethod,
        'createdAt': r.createdAt?.toUtc().toIso8601String(),
      };

      await ditto.store.execute(
        'INSERT INTO transaction_payment_records DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
        arguments: {'doc': doc},
      );
    }

    if (paymentRecord != null) {
      await upsertDitto(paymentRecord);
      await repository.upsert<TransactionPaymentRecord>(paymentRecord);
      return;
    }

    if (amount != 0) {
      final newPaymentRecord = TransactionPaymentRecord(
        createdAt: DateTime.now().toUtc(),
        amount: amount,
        transactionId: transactionId,
        paymentMethod: paymentMethod,
      );

      await upsertDitto(newPaymentRecord);
      await repository.upsert<TransactionPaymentRecord>(
        newPaymentRecord,
        query: brick.Query(action: QueryAction.insert),
      );
    }
  }

  @override
  Future<Pin?> savePin({required Pin pin}) {
    // TODO: implement savePin
    throw UnimplementedError();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }

  @override
  Future<void> sendMessageToIsolate({Map<String, dynamic>? message}) async {
    // TODO: implement sendMessageToIsolate
    throw UnimplementedError();
  }

  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    // TODO: implement sendReport
    throw UnimplementedError();
  }

  @override
  FutureOr<void> setBranchPaymentStatus({
    required String currentBranchId,
    required bool status,
  }) {
    // TODO: implement setBranchPaymentStatus
    throw UnimplementedError();
  }

  @override
  Future<Business?> signup({
    required Map business,
    required HttpClientInterface flipperHttpClient,
  }) {
    // TODO: implement signup
    throw UnimplementedError();
  }

  @override
  Future<int> size<T>({required T object}) {
    // TODO: implement size
    throw UnimplementedError();
  }

  @override
  Stream<SKU?> sku({required String branchId, required String businessId}) {
    // TODO: implement sku
    throw UnimplementedError();
  }

  @override
  Future<void> spawnIsolate(isolateHandler) {
    // TODO: implement spawnIsolate
    throw UnimplementedError();
  }

  @override
  FutureOr<List<Stock>> stocks({required String branchId}) {
    // TODO: implement stocks
    throw UnimplementedError();
  }

  @override
  Stream<List<BusinessAnalytic>> streamRemoteAnalytics({
    required String branchId,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      _talker.error('Ditto not initialized');
      return Stream.value([]);
    }

    final controller = StreamController<List<BusinessAnalytic>>.broadcast();
    dynamic observer;

    observer = ditto.store.registerObserver(
      'SELECT * FROM business_analytics WHERE branchId = :branchId',
      arguments: {'branchId': branchId},
      onChange: (queryResult) {
        if (controller.isClosed) return;

        final analytics = <BusinessAnalytic>[];
        for (final item in queryResult.items) {
          final data = Map<String, dynamic>.from(item.value);
          final analytic = _convertBusinessAnalyticFromDitto(data);
          if (analytic != null) analytics.add(analytic);
        }
        controller.add(analytics);
      },
    );

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  BusinessAnalytic? _convertBusinessAnalyticFromDitto(
    Map<String, dynamic> data,
  ) {
    try {
      return BusinessAnalytic(
        id: data['id'] ?? data['_id'],
        date:
            DateTime.tryParse(data['date']?.toString() ?? '') ?? DateTime.now(),
        itemName: data['itemName'],
        price: data['price']?.toDouble() ?? 0.0,
        profit: data['profit']?.toDouble() ?? 0.0,
        unitsSold: data['unitsSold'] ?? 0,
        stockRemainedAtTheTimeOfSale: data['stockRemainedAtTheTimeOfSale'] ?? 0,
        taxRate: data['taxRate']?.toDouble() ?? 0.0,
        trafficCount: data['trafficCount'] ?? 0,
        branchId: data['branchId'],
        categoryName: data['categoryName'],
        categoryId: data['categoryId'],
        transactionId: data['transactionId'],
        value: data['value']?.toDouble() ?? 0.0,
        supplyPrice: data['supplyPrice']?.toDouble() ?? 0.0,
        retailPrice: data['retailPrice']?.toDouble() ?? 0.0,
        currentStock: data['currentStock']?.toDouble() ?? 0.0,
        stockValue: data['stockValue']?.toDouble() ?? 0.0,
        paymentMethod: data['paymentMethod'],
        customerType: data['customerType'],
        discountAmount: data['discountAmount']?.toDouble() ?? 0.0,
        taxAmount: data['taxAmount']?.toDouble() ?? 0.0,
      );
    } catch (e) {
      _talker.error('Error converting BusinessAnalytic from Ditto: $e');
      return null;
    }
  }

  @override
  Future<({String customerCode, String url, int userId})> subscribe({
    required String businessId,
    required Business business,
    required int agentCode,
    required HttpClientInterface flipperHttpClient,
    required int amount,
  }) {
    // TODO: implement subscribe
    throw UnimplementedError();
  }

  @override
  Future<List<String>> syncOfflineAssets() {
    // TODO: implement syncOfflineAssets
    throw UnimplementedError();
  }

  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) {
    // TODO: implement syncUserWithAwsIncognito
    throw UnimplementedError();
  }

  @override
  Stream<double> totalSales({required String branchId}) {
    // TODO: implement totalSales
    throw UnimplementedError();
  }

  @override
  Future<List<UnversalProduct>> universalProductNames({
    required String branchId,
  }) {
    // TODO: implement universalProductNames
    throw UnimplementedError();
  }

  @override
  void updateAccess({
    required String accessId,
    required String userId,
    required String featureName,
    required String accessLevel,
    required String status,
    required String branchId,
    required String businessId,
    required String userType,
  }) {
    // TODO: implement updateAccess
  }

  @override
  FutureOr<void> updateAcess({
    required String userId,
    String? featureName,
    String? status,
    String? accessLevel,
    String? userType,
  }) {
    // TODO: implement updateAcess
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateAsset({required String assetId, String? assetName}) {
    // TODO: implement updateAsset
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateColor({
    required String colorId,
    String? name,
    bool? active,
  }) {
    // TODO: implement updateColor
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateNotification({
    required String notificationId,
    bool? completed,
  }) {
    // TODO: implement updateNotification
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updatePin({
    required String userId,
    String? phoneNumber,
    String? tokenUid,
  }) {
    // TODO: implement updatePin
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateReport({required String reportId, bool? downloaded}) {
    // TODO: implement updateReport
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateUnit({
    required String unitId,
    String? name,
    bool? active,
    String? branchId,
  }) {
    // TODO: implement updateUnit
    throw UnimplementedError();
  }

  @override
  Future<String> uploadPdfToS3(
    Uint8List pdfData,
    String fileName, {
    required String transactionId,
  }) {
    // TODO: implement uploadPdfToS3
    throw UnimplementedError();
  }

  @override
  Future<CustomerPayments> upsertPayment(CustomerPayments payment) {
    // TODO: implement upsertPayment
    throw UnimplementedError();
  }

  @override
  Future<int> userNameAvailable({
    required String name,
    required HttpClientInterface flipperHttpClient,
  }) {
    // TODO: implement userNameAvailable
    throw UnimplementedError();
  }

  @override
  Future<VariantBranch?> variantBranch({
    required String variantId,
    required String destinationBranchId,
  }) {
    // TODO: implement variantBranch
    throw UnimplementedError();
  }

  @override
  void whoAmI() {
    print("I am the son of Capella ");
  }

  @override
  // TODO: implement apihub
  String get apihub => throw UnimplementedError();

  // @override
  // Future<DatabaseSyncInterface> configureCapella(
  //     {required bool useInMemory, required LocalStorage box}) {
  //   // TODO: implement configureCapella
  //   throw UnimplementedError();
  // }

  // @override
  // Future<DatabaseSyncInterface> configureLocal(
  //     {required bool useInMemory, required LocalStorage box}) async {
  //   return this;
  // }

  final Talker _talker = Talker();

  @override
  Talker get talker => _talker;

  @override
  FutureOr<Pin?> getPinLocal({
    String? userId,
    String? phoneNumber,
    required bool alwaysHydrate,
  }) {
    // TODO: implement getPinLocal
    throw UnimplementedError();
  }

  @override
  Future<void> updateTenant({
    String? tenantId,
    String? name,
    String? phoneNumber,
    String? email,
    String? userId,
    String? businessId,
    String? type,
    String? id,
    int? pin,
    bool? sessionActive,
    String? branchId,
  }) {
    // TODO: implement updateTenant
    throw UnimplementedError();
  }

  @override
  FutureOr<void> updateCategory({
    required String categoryId,
    String? name,
    bool? active,
    bool? focused,
    String? branchId,
  }) async {
    // Native: keep Brick/SQLite authoritative for focus flags (same as pre-Capella-category work).
    // Web: only Ditto path below runs.
    if (!kIsWeb) {
      try {
        await ProxyService.getStrategy(Strategy.cloudSync).updateCategory(
          categoryId: categoryId,
          name: name,
          active: active,
          focused: focused,
          branchId: branchId,
        );
      } catch (e, s) {
        talker.error('updateCategory SQLite/Brick failed: $e', s);
        rethrow;
      }
    }

    final ditto = dittoService.dittoInstance;
    if (ditto == null) return;

    final updates = <String>[];
    final args = <String, dynamic>{'cid': categoryId};

    final whereClause = branchId != null
        ? '(_id = :cid OR id = :cid) AND branchId = :branchId'
        : '(_id = :cid OR id = :cid)';
    if (branchId != null) {
      args['branchId'] = branchId;
    }

    void addIfNonNull(String col, dynamic v) {
      if (v == null) return;
      updates.add('$col = :$col');
      args[col] = v is DateTime ? v.toUtc().toIso8601String() : v;
    }

    addIfNonNull('name', name);
    addIfNonNull('active', active);
    addIfNonNull('focused', focused);
    if (updates.isEmpty) return;
    addIfNonNull('lastTouched', DateTime.now());

    try {
      await ditto.store.execute(
        'UPDATE categories SET ${updates.join(', ')} WHERE $whereClause',
        arguments: args,
      );
    } catch (e, s) {
      talker.warning(
        'Capella updateCategory Ditto mirror failed (non-fatal): $e',
        s,
      );
    }
  }

  @override
  Future<Map<String, dynamic>> sendOtpForSignup(String contact) {
    // TODO: implement sendOtpForSignup
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> verifyOtpForSignup(String contact, String otp) {
    // TODO: implement verifyOtpForSignup
    throw UnimplementedError();
  }
}
