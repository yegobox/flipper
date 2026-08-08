import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:flipper_models/DatabaseSyncInterface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/sync/transaction_payment_records_sync.dart';
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
import 'package:flipper_models/models/subscription_plan_template.dart';
import 'package:talker/talker.dart';
import 'package:flipper_models/services/loan_customer_linker.dart';
import 'package:flipper_models/sync/capella/capella_brick_mirror.dart';
import 'package:flipper_models/sync/utils/stock_qty_milli.dart';
import 'package:flipper_models/sync/capella/reference_data_ditto.dart';
import 'package:uuid/uuid.dart';
import 'package:flipper_models/sync/capella/mixins/auth_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/branch_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/category_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/business_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/conversation_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/customer_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/daily_report_files_mixin.dart';
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
import 'package:flipper_models/sync/shift_operations.dart';
import 'package:flipper_models/sync/utils/sale_line_pricing.dart';
import 'package:flipper_models/sync/capella/mixins/stock_recount_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/counter_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/personal_goals_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/bar_mixin.dart';
import 'package:flipper_models/sync/capella/mixins/settings_mixin.dart';
import 'package:flipper_services/ai_strategy_impl.dart';
import 'package:flipper_models/sync/mixins/purchase_mixin.dart';
import 'package:flipper_models/sync/mixins/stock_recount_mixin.dart';
import 'package:supabase_models/brick/models/all_models.dart' hide BusinessType;
import 'package:flipper_models/sync/capella/mixins/production_output_mixin.dart';
import 'package:flipper_models/sync/mixins/bulk_process_item_mixin.dart';
import 'package:flipper_web/services/ditto_service.dart';

import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;

import 'package:flipper_models/SyncStrategy.dart';

import 'package:flipper_services/constants.dart';

String? _nonEmptyCustomerField(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return trimmed;
}

/// (business|branch) keys whose ebms Ditto subscription is already registered
/// this session. Guards [CapellaSync.isTaxEnabled] against re-subscribing on
/// every call (bulk import calls it once per row).
final Set<String> _capellaTaxEnabledSubscribed = <String>{};

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
        PurchaseMixin,
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
        CapellaCategoryDittoMixin,
        CapellaDelegationMixin,
        StockRecountMixin,
        CapellaStockRecountMixin,
        CapellaSettingsMixin,
        CapellaProductionOutputMixin,
        CapellaPersonalGoalsMixin,
        CapellaBarMixin,
        CapellaDailyReportFilesMixin,
        BulkProcessItemMixin
    implements DatabaseSyncInterface {
  CapellaSync();

  DittoService get dittoService => DittoService.instance;

  /// The legacy Brick/SQLite implementation.
  ///
  /// The app now runs on Ditto only — [CapellaSync] is the single
  /// [DatabaseSyncInterface] the rest of the codebase ever sees. Operations
  /// that do not have a Ditto-native implementation yet are forwarded here so
  /// that collapsing the two strategies into one is behaviour-preserving.
  ///
  /// Every forwarding member is tagged `TODO(ditto-migration)`. Porting one to
  /// Ditto means replacing that body and deleting the tag; when no tags remain
  /// this getter — and Brick — can be deleted.
  DatabaseSyncInterface get _legacy => ProxyService.legacyStrategy;
  @override
  Future<void> initCollections() async {
    throw UnimplementedError('initCollections needs to be implemented');
  }

  // TODO(ditto-migration): port `downloadAsset` to Ditto.
  @override
  Future<Stream<double>> downloadAsset({
    required String branchId,
    required String assetName,
    required String subPath,
  }) async {
    return _legacy.downloadAsset(branchId: branchId, assetName: assetName, subPath: subPath);
  }

  // TODO(ditto-migration): port `upsertPlan` to Ditto.
  @override
  Future<void> upsertPlan({
    required String businessId,
    required Plan selectedPlan,
  }) async {
    return _legacy.upsertPlan(businessId: businessId, selectedPlan: selectedPlan);
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

  // TODO(ditto-migration): port `downloadAssetSave` to Ditto.
  @override
  Future<Stream<double>> downloadAssetSave({
    String? assetName,
    String? subPath = "branch",
  }) async {
    return _legacy.downloadAssetSave(assetName: assetName, subPath: subPath);
  }

  // TODO(ditto-migration): port `startReplicator` to Ditto.
  @override
  Future<void> startReplicator() async {
    return _legacy.startReplicator();
  }

  // TODO(ditto-migration): port `businessTypes` to Ditto.
  @override
  Future<List<BusinessType>> businessTypes() {
    return _legacy.businessTypes();
  }

  // TODO(ditto-migration): port `tenant` to Ditto.
  @override
  Future<Tenant?> tenant({
    String? businessId,
    String? userId,
    String? tenantId,
    required bool fetchRemote,
  }) {
    return _legacy.tenant(businessId: businessId, userId: userId, tenantId: tenantId, fetchRemote: fetchRemote);
  }

  @override
  ReceivePort? receivePort;

  @override
  SendPort? sendPort;

  // TODO(ditto-migration): port `access` to Ditto.
  @override
  Future<List<Access>> access({
    required String userId,
    String? featureName,
    required bool fetchRemote,
  }) {
    return _legacy.access(userId: userId, featureName: featureName, fetchRemote: fetchRemote);
  }

  // TODO(ditto-migration): port `addAccess` to Ditto.
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
    return _legacy.addAccess(userId: userId, featureName: featureName, accessLevel: accessLevel, userType: userType, status: status, branchId: branchId, businessId: businessId, createdAt: createdAt);
  }

  // TODO(ditto-migration): port `addAsset` to Ditto.
  @override
  FutureOr<void> addAsset({
    required String productId,
    required assetName,
    required String branchId,
    required String businessId,
    String? variantId,
  }) {
    return _legacy.addAsset(productId: productId, assetName: assetName, branchId: branchId, businessId: businessId, variantId: variantId);
  }

  // TODO(ditto-migration): port `addBranch` to Ditto.
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
    return _legacy.addBranch(name: name, businessId: businessId, location: location, userOwnerPhoneNumber: userOwnerPhoneNumber, flipperHttpClient: flipperHttpClient ?? ProxyService.http, serverId: serverId, description: description, longitude: longitude, latitude: latitude, isDefault: isDefault, active: active, lastTouched: lastTouched, deletedAt: deletedAt, id: id);
  }

  @override
  FutureOr<void> addColor({required String name, required String branchId}) async {
    final color = PColor(name: name, active: false, branchId: branchId);
    final ditto = dittoService.dittoInstance;
    if (ditto != null) {
      await upsertReferenceDoc(ditto, colorsCollection, colorToDittoDoc(color));
    }
    // Brick is still what carries `colors` to Supabase.
    scheduleCapellaBrickMirror(repository, color);
  }

  // TODO(ditto-migration): port `allAccess` to Ditto.
  @override
  Future<List<Access>> allAccess({required String userId}) {
    return _legacy.allAccess(userId: userId);
  }

  // TODO(ditto-migration): port `amplifyLogout` to Ditto.
  @override
  Future<void> amplifyLogout() {
    return _legacy.amplifyLogout();
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

  // TODO(ditto-migration): port `authState` to Ditto.
  @override
  Stream<Tenant?> authState({required String branchId}) {
    return _legacy.authState(branchId: branchId);
  }

  // TODO(ditto-migration): port `bindProduct` to Ditto.
  @override
  Future<bool> bindProduct({
    required String productId,
    required String tenantId,
  }) {
    return _legacy.bindProduct(productId: productId, tenantId: tenantId);
  }

  // TODO(ditto-migration): port `cleanDuplicatePlans` to Ditto.
  @override
  Future<void> cleanDuplicatePlans() {
    return _legacy.cleanDuplicatePlans();
  }

  // TODO(ditto-migration): port `clearOldLogs` to Ditto.
  @override
  Future<int> clearOldLogs({required Duration olderThan, String? businessId}) {
    return _legacy.clearOldLogs(olderThan: olderThan, businessId: businessId);
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

    /// Status to use for personal-goal/shift financial-sweep eligibility,
    /// when it must differ from the *persisted* [completionStatus] (e.g. the
    /// Ticket Review + Handover workflow persists `pendingReview` but the
    /// goal sweep must still fire as if the sale completed normally).
    /// Defaults to [completionStatus] when omitted, so every other existing
    /// caller is unaffected.
    String? financialCompletionStatus,
    List<TransactionItem>? preloadedLineItems,
    bool isUtilityCashbookMovement = false,
    bool skipPersonalGoalAutoSweep = false,
    bool skipTransactionPersist = false,
    bool skipCashMutation = false,
  }) async {
    if (transaction == null) {
      throw Exception('transaction is null');
    }

    try {
      if (note != null) transaction.note = note;

      final userId = ProxyService.box.getUserId();
      transaction.customerTin = customerTin;

      final resolvedSalePhone = _nonEmptyCustomerField(customerPhone) ??
          _nonEmptyCustomerField(
            ProxyService.box.currentSaleCustomerPhoneNumber(),
          ) ??
          _nonEmptyCustomerField(transaction.customerPhone);
      if (countryCode != "N/A" &&
          countryCode != "" &&
          resolvedSalePhone != null) {
        transaction.currentSaleCustomerPhoneNumber =
            countryCode + resolvedSalePhone;
      }
      if (resolvedSalePhone != null) {
        transaction.customerPhone = resolvedSalePhone;
      }
      final resolvedCustomerName = _nonEmptyCustomerField(customerName) ??
          _nonEmptyCustomerField(ProxyService.box.customerName()) ??
          _nonEmptyCustomerField(transaction.customerName);
      if (resolvedCustomerName != null) {
        transaction.customerName = resolvedCustomerName;
      }

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
          : SaleLinePricing.cartNetSubtotal([
              for (final b in items)
                (
                  unitPrice: b.price.toDouble(),
                  qty: b.qty.toDouble(),
                  dcAmt: b.dcAmt?.toDouble(),
                  dcRt: b.dcRt?.toDouble(),
                ),
            ]);
      transaction.subTotal = computedSubTotal;

      transaction.customerChangeDue =
          cashReceived - (transaction.subTotal ?? 0);

      // Update shift totals in Ditto after [transaction.subTotal] is known.
      Future<void> updateOpenShiftTotals() async {
        if (userId == null) return;
        try {
          final shiftOps = ShiftOperations();
          final currentShift = await shiftOps.getCurrentShift(userId: userId);
          if (currentShift != null) {
            num saleAmount = transaction.subTotal ?? 0.0;
            if (!isIncome) {
              saleAmount = -saleAmount;
            }

            final updatedCashSales = (currentShift.cashSales ?? 0) + saleAmount;
            final updatedExpectedCash =
                currentShift.openingBalance + updatedCashSales;

            await shiftOps.saveShift(
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

      if (skipTransactionPersist && skipCashMutation) {
        await updateOpenShiftTotals();
      } else if (skipTransactionPersist) {
        unawaited(updateOpenShiftTotals());
      } else {
        await updateOpenShiftTotals();
      }

      if (!skipCashMutation) {
        if (transaction.isLoan == true) {
          transaction.originalLoanAmount ??= computedSubTotal;
          final totalPaidSoFar =
              (transaction.cashReceived ?? 0.0) + cashReceived;
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
      }

      transaction.transactionType = transactionType;
      transaction.categoryId = categoryId;
      transaction.isIncome = isIncome;
      transaction.isExpense = !isIncome;
      transaction.paymentType = ProxyService.box.paymentType() ?? paymentType;

      // Attach (match-by-phone or create) the customer to the in-memory
      // transaction BEFORE persisting completed status, so the data-connector
      // never posts a journal for a sale with no customer linked yet.
      // updateTransaction persists customerId via its `transaction.customerId`
      // fallback. Best-effort: the fire-and-forget linker below backfills if
      // this is skipped/times out.
      await LoanCustomerLinker.attachBeforeCompletion(
        transaction: transaction,
        branchId: branchId,
      );

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

      if (skipTransactionPersist && skipCashMutation) {
        try {
          final resolvedCompletionForGoals =
              financialCompletionStatus ?? completionStatus ?? transaction.status;
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
          talker.warning(
            'collectPayment: personal goal auto-sweep failed: $e\n$s',
          );
        }
      } else if (skipTransactionPersist) {
        final resolvedCompletionForGoals =
            financialCompletionStatus ?? completionStatus ?? transaction.status;
        final sweepItems = List<TransactionItem>.from(items);
        unawaited(
          applyPersonalGoalAutoSweepIfEligible(
            branchId: branchId,
            transactionId: transaction.id,
            completionStatus: resolvedCompletionForGoals,
            isIncome: isIncome,
            isProformaMode: isProformaMode,
            isTrainingMode: isTrainingMode,
            transactionType: transactionType,
            items: sweepItems,
            isUtilityCashbookMovement: isUtilityCashbookMovement,
            skipPersonalGoalAutoSweep: skipPersonalGoalAutoSweep,
          ).catchError((e, s) {
            talker.warning(
              'collectPayment: deferred personal goal auto-sweep failed: $e\n$s',
            );
          }),
        );
      } else {
        try {
          final resolvedCompletionForGoals =
              financialCompletionStatus ?? completionStatus ?? transaction.status;
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
          talker.warning(
            'collectPayment: personal goal auto-sweep skipped: $e\n$s',
          );
        }
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

      // Accounting journal posting now happens server-side in data-connector
      // (listens on completed transactions and posts the balanced entry,
      // including COGS). The POS no longer posts journal entries.

      // Link (or auto-create) the canonical customer record for loans so
      // accounting tracks debtors by customer id — runs in the background,
      // adds no latency to checkout. A parked sale is a loan even before
      // markTransactionAsCompleted persists isLoan.
      unawaited(
        LoanCustomerLinker.ensureLinked(
          transaction: transaction,
          branchId: branchId,
          markAsLoan: transaction.isLoan == true || completionStatus == PARKED,
        ),
      );

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
  Future<List<PColor>> colors({required String branchId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return _legacy.colors(branchId: branchId);

    await ensureReferenceSubscription(ditto, colorsCollection, branchId);
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM $colorsCollection WHERE branchId = :branchId',
        arguments: {'branchId': branchId},
      );
      if (result.items.isNotEmpty) {
        return result.items
            .map((d) => colorFromDittoDoc(Map<String, dynamic>.from(d.value)))
            .toList();
      }
    } catch (e, s) {
      talker.error('Ditto colors read failed, falling back to Brick: $e', e, s);
      return _legacy.colors(branchId: branchId);
    }

    // Empty in Ditto: this branch's colours predate the migration and still
    // live in SQLite only. Seed Ditto from Brick so the next read is native.
    final existing = await _legacy.colors(branchId: branchId);
    for (final color in existing) {
      await upsertReferenceDoc(ditto, colorsCollection, colorToDittoDoc(color));
    }
    return existing;
  }

  @override
  FutureOr<List<Composite>> composites({
    String? productId,
    String? variantId,
  }) async {
    return repository.get<Composite>(
      policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: brick.Query(
        where: [
          if (productId != null) brick.Where('productId').isExactly(productId),
          if (variantId != null) brick.Where('variantId').isExactly(variantId),
        ],
      ),
    );
  }

  // TODO(ditto-migration): port `conversations` to Ditto.
  @override
  conversations({int? conversationId}) {
    return _legacy.conversations(conversationId: conversationId);
  }

  // TODO(ditto-migration): port `countries` to Ditto.
  @override
  Future<List<Country>> countries() {
    return _legacy.countries();
  }

  @override
  FutureOr<T?> create<T>({required T data}) async {
    // Ditto-first create. Writing the document into Ditto synchronously (before
    // this future completes) is what removes the branch-transfer read-back race:
    // callers immediately re-read the new variant via Capella/Ditto, and the
    // Brick path only mirrored to Ditto asynchronously (unawaited coordinator).
    // When Ditto wrote the doc, mirror to Brick in the background (skipDittoSync)
    // so POS/transfer hot paths are not blocked on Turso/SQLite.
    final ditto = dittoService.dittoInstance;

    if (data is Variant) {
      if (ditto != null) {
        await ditto.store.execute(
          "INSERT INTO variants DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
          arguments: {'doc': data.toFlipperJson()},
        );
        scheduleCapellaBrickMirror<Variant>(repository, data);
      } else {
        await repository.upsert<Variant>(data);
      }
      return data as T;
    }

    if (data is Stock) {
      if (ditto != null) {
        await ditto.store.execute(
          "INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
          arguments: {'doc': data.toJson()},
        );
        await seedStockMilliIfAbsentOnStore(
          ditto.store,
          stockId: data.id,
          qty: data.currentStock ?? 0,
        );
        scheduleCapellaBrickMirror<Stock>(repository, data);
      } else {
        await repository.upsert<Stock>(data);
      }
      return data as T;
    }

    if (data is VariantBranch) {
      if (ditto != null) {
        await ditto.store.execute(
          "INSERT INTO variants_branches DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE",
          arguments: {
            'doc': {
              '_id': data.id,
              'id': data.id,
              'variantId': data.variantId,
              'newVariantId': data.newVariantId,
              'sourceBranchId': data.sourceBranchId,
              'destinationBranchId': data.destinationBranchId,
            },
          },
        );
        scheduleCapellaBrickMirror<VariantBranch>(repository, data);
      } else {
        await repository.upsert<VariantBranch>(data);
      }
      return data as T;
    }

    // TODO(ditto-migration): port the remaining model types to Ditto. Until
    // then they keep their Brick write path — Capella is now the only strategy
    // callers can reach, so throwing here would break every other model.
    return _legacy.create<T>(data: data);
  }

  // TODO(ditto-migration): port `upsertDevice` to Ditto.
  @override
  Future<Device> upsertDevice(Device device) {
    return _legacy.upsertDevice(device);
  }

  @override
  Future<void> createNewStock({
    required Variant variant,
    required TransactionItem item,
    required String subBranchId,
  }) async {
    final requested = item.quantityRequested!.toDouble();
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized: createNewStock');
    }
    final stock = Stock(
      id: const Uuid().v4(),
      lastTouched: DateTime.now().toUtc(),
      branchId: subBranchId,
      currentStock: requested,
      rsdQty: requested,
      value: requested * variant.retailPrice!,
      // Inbound transfer stock stays inactive until the receiving branch
      // approves it — same as the Brick implementation.
      active: false,
    );
    await ditto.store.execute(
      'INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO UPDATE',
      arguments: {'doc': stock.toJson()},
    );
    await seedStockMilliIfAbsentOnStore(
      ditto.store,
      stockId: stock.id,
      qty: requested,
    );
    scheduleCapellaBrickMirror(repository, stock);
  }

  // TODO(ditto-migration): port `createOrUpdateBranchOnCloud` to Ditto.
  @override
  Future<void> createOrUpdateBranchOnCloud({
    required Branch branch,
    required bool isOnline,
  }) {
    return _legacy.createOrUpdateBranchOnCloud(branch: branch, isOnline: isOnline);
  }

  // TODO(ditto-migration): port `createVariant` to Ditto.
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
    return _legacy.createVariant(barCode: barCode, sku: sku, productId: productId, branchId: branchId, retailPrice: retailPrice, supplierPrice: supplierPrice, qty: qty, taxTypes: taxTypes, itemClasses: itemClasses, itemTypes: itemTypes, color: color, tinNumber: tinNumber, itemSeq: itemSeq, name: name, taxType: taxType);
  }

  // TODO(ditto-migration): port `credit` to Ditto.
  @override
  Stream<Credit?> credit({required String branchId}) {
    return _legacy.credit(branchId: branchId);
  }

  // TODO(ditto-migration): port `defaultBranch` to Ditto.
  @override
  FutureOr<Branch?> defaultBranch() {
    return _legacy.defaultBranch();
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

  // TODO(ditto-migration): port `deleteAll` to Ditto.
  @override
  FutureOr<void> deleteAll<T extends Object>({required String tableName}) {
    return _legacy.deleteAll<T>(tableName: tableName);
  }

  // TODO(ditto-migration): port `deleteFailedQueue` to Ditto.
  @override
  Future<void> deleteFailedQueue() {
    return _legacy.deleteFailedQueue();
  }

  // TODO(ditto-migration): port `deletePaymentById` to Ditto.
  @override
  Future<void> deletePaymentById(String id) {
    return _legacy.deletePaymentById(id);
  }

  // TODO(ditto-migration): port `deleteTransactionItemAndResequence` to Ditto.
  @override
  Future<void> deleteTransactionItemAndResequence({required String id}) {
    return _legacy.deleteTransactionItemAndResequence(id: id);
  }

  // TODO(ditto-migration): port `fetchCost` to Ditto.
  @override
  Future<double> fetchCost(String branchId) {
    return _legacy.fetchCost(branchId);
  }

  // TODO(ditto-migration): port `fetchProfit` to Ditto.
  @override
  Future<double> fetchProfit(String branchId) {
    return _legacy.fetchProfit(branchId);
  }

  // TODO(ditto-migration): port `financeProviders` to Ditto.
  @override
  Future<List<FinanceProvider>> financeProviders() {
    return _legacy.financeProviders();
  }

  // TODO(ditto-migration): port `geVariantStreamByProductId` to Ditto.
  @override
  Stream<List<Variant>> geVariantStreamByProductId({
    required String productId,
  }) {
    return _legacy.geVariantStreamByProductId(productId: productId);
  }

  @override
  Future<Response> get(Uri url, {Map<String, String>? headers}) {
    // TODO: implement get
    throw UnimplementedError();
  }

  // TODO(ditto-migration): port `getAllPayments` to Ditto.
  @override
  Future<List<CustomerPayments>> getAllPayments() {
    return _legacy.getAllPayments();
  }

  // TODO(ditto-migration): port `getAsset` to Ditto.
  @override
  FutureOr<Assets?> getAsset({
    String? assetName,
    String? productId,
    String? variantId,
  }) {
    return _legacy.getAsset(assetName: assetName, productId: productId, variantId: variantId);
  }

  @override
  Future<PColor?> getColor({required String id}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) return _legacy.getColor(id: id);
    try {
      final result = await ditto.store.execute(
        'SELECT * FROM $colorsCollection WHERE _id = :id LIMIT 1',
        arguments: {'id': id},
      );
      if (result.items.isNotEmpty) {
        return colorFromDittoDoc(
          Map<String, dynamic>.from(result.items.first.value),
        );
      }
    } catch (e, s) {
      talker.error('Ditto getColor($id) failed: $e', e, s);
    }
    // Not mirrored into Ditto yet — fall back and seed on the way through.
    final color = await _legacy.getColor(id: id);
    if (color != null) {
      await upsertReferenceDoc(ditto, colorsCollection, colorToDittoDoc(color));
    }
    return color;
  }

  // TODO(ditto-migration): port `getContacts` to Ditto.
  @override
  Future<List<Business>> getContacts() {
    return _legacy.getContacts();
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

  // TODO(ditto-migration): port `getCustomVariant` to Ditto.
  @override
  Future<Variant?> getCustomVariant({
    required String businessId,
    required String branchId,
    required int tinNumber,
    required String bhFId,
  }) {
    return _legacy.getCustomVariant(businessId: businessId, branchId: branchId, tinNumber: tinNumber, bhFId: bhFId);
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
      // TODO(ditto-migration): Brick fallback for the utility-cash variant.
      return await ProxyService.legacyStrategy.getUtilityVariant(name: name, branchId: branchId);
    } catch (e, st) {
      talker.error('getUtilityVariant fallback failed: $e\n$st');
      return null;
    }
  }

  // TODO(ditto-migration): port `getLogs` to Ditto.
  @override
  Future<List<Log>> getLogs({
    String? type,
    String? businessId,
    int limit = 100,
  }) {
    return _legacy.getLogs(type: type, businessId: businessId, limit: limit);
  }

  // TODO(ditto-migration): port `getPayment` to Ditto.
  @override
  Future<CustomerPayments?> getPayment({required String paymentReference}) {
    return _legacy.getPayment(paymentReference: paymentReference);
  }

  // TODO(ditto-migration): port `getPaymentById` to Ditto.
  @override
  Future<CustomerPayments?> getPaymentById(String id) {
    return _legacy.getPaymentById(id);
  }

  // TODO(ditto-migration): port `getTop5RecentConversations` to Ditto.
  @override
  getTop5RecentConversations() {
    return _legacy.getTop5RecentConversations();
  }

  // TODO(ditto-migration): port `getUniversalProducts` to Ditto.
  @override
  Future<Response> getUniversalProducts(
    Uri url, {
    Map<String, String>? headers,
    Object? body,
    Encoding? encoding,
  }) {
    return _legacy.getUniversalProducts(url, headers: headers, body: body, encoding: encoding);
  }

  // TODO(ditto-migration): port `hasOfflineAssets` to Ditto.
  @override
  Future<bool> hasOfflineAssets() {
    return _legacy.hasOfflineAssets();
  }

  // TODO(ditto-migration): port `initializeEbm` to Ditto.
  @override
  Future<BusinessInfo> initializeEbm({
    required String tin,
    required String bhfId,
    required String dvcSrlNo,
  }) {
    return _legacy.initializeEbm(tin: tin, bhfId: bhfId, dvcSrlNo: dvcSrlNo);
  }

  @override
  DatabaseSyncInterface instance() {
    // TODO: implement instance
    throw UnimplementedError();
  }

  // TODO(ditto-migration): port `isAdmin` to Ditto.
  @override
  FutureOr<bool> isAdmin({required String userId, required String appFeature}) {
    return _legacy.isAdmin(userId: userId, appFeature: appFeature);
  }

  @override
  FutureOr<bool> isBranchEnableForPayment({
    required String currentBranchId,
    bool fetchRemote = false,
  }) async {
    final paymentStatus = await repository.get<BranchPaymentIntegration>(
      policy: fetchRemote
          ? OfflineFirstGetPolicy.alwaysHydrate
          : OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      query: brick.Query(
        where: [brick.Where('branchId').isExactly(currentBranchId)],
      ),
    );
    return paymentStatus.firstOrNull?.isEnabled ?? false;
  }

  // TODO(ditto-migration): port `isSubscribed` to Ditto.
  @override
  bool isSubscribed({required String feature, required String businessId}) {
    return _legacy.isSubscribed(feature: feature, businessId: businessId);
  }

  @override
  Future<bool> isTaxEnabled({
    required String businessId,
    required String branchId,
  }) async {
    // Ported verbatim from the brick (CoreSync) Ditto-backed implementation so
    // the Capella strategy resolves tax-enabled state identically (no regression).
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:001');
        return false;
      }
      // Query the ebms table using Ditto
      String query =
          'SELECT * FROM ebms WHERE businessId = :businessId AND branchId = :branchId';
      final arguments = <String, dynamic>{
        'businessId': businessId,
        'branchId': branchId,
      };

      // Register the ebms subscription only once per (business, branch).
      // isTaxEnabled runs once per row during bulk import; re-registering the
      // same subscription every call leaks subscriptions and stalls Ditto sync.
      if (_capellaTaxEnabledSubscribed.add('$businessId|$branchId')) {
        final preparedEbm = prepareDqlSyncSubscription(query, arguments);
        await ditto.sync.registerSubscription(
          preparedEbm.dql,
          arguments: preparedEbm.arguments,
        );
      }

      // Use registerObserver to wait for data
      final completer = Completer<List<dynamic>>();
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            completer.complete(result.items.toList());
          }
        },
      );

      List<dynamic> items = [];
      try {
        // Wait for data or timeout
        items = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              talker.warning('Timeout waiting for ebms data');
              completer.complete([]);
            }
            return [];
          },
        );
      } finally {
        observer.cancel();
      }

      // Check if any EBM configuration exists and if VAT is enabled
      if (items.isNotEmpty) {
        final ebmData = items.first.value as Map<String, dynamic>;
        final vatEnabled = ebmData['vatEnabled'] as bool?;
        final taxServerUrl = ebmData['taxServerUrl'] as String?;

        final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
            defaultTargetPlatform == TargetPlatform.android;

        if (isMobile &&
            taxServerUrl != null &&
            taxServerUrl.contains('localhost')) {
          talker.info('Tax disabled on mobile with localhost tax server');
          return false;
        }

        return vatEnabled ==
            true; // Return true if vatEnabled is true, false otherwise
      }

      // If no EBM configuration found, tax is not enabled
      return false;
    } catch (e, st) {
      talker.error('Error checking if tax is enabled from Ditto: $e\n$st');
      return false;
    }
  }

  // TODO(ditto-migration): port `loadConversations` to Ditto.
  @override
  Future<void> loadConversations({
    required String businessId,
    int? pageSize = 10,
    String? pk,
    String? sk,
  }) {
    return _legacy.loadConversations(businessId: businessId, pageSize: pageSize, pk: pk, sk: sk);
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

  // TODO(ditto-migration): port `permission` to Ditto.
  @override
  @override
  FutureOr<LPermission?> permission({required String userId}) {
    return _legacy.permission(userId: userId);
  }

  // TODO(ditto-migration): port `permissions` to Ditto.
  @override
  FutureOr<List<LPermission>> permissions({required String userId}) {
    return _legacy.permissions(userId: userId);
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

  // TODO(ditto-migration): port `productsFuture` to Ditto.
  @override
  Future<List<Product>> productsFuture({required String branchId}) {
    return _legacy.productsFuture(branchId: branchId);
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

  // TODO(ditto-migration): port `queueLength` to Ditto.
  @override
  Future<int> queueLength() {
    return _legacy.queueLength();
  }

  // TODO(ditto-migration): port `reDownloadAsset` to Ditto.
  @override
  Future<void> reDownloadAsset() {
    return _legacy.reDownloadAsset();
  }

  // TODO(ditto-migration): port `refreshSession` to Ditto.
  @override
  Future<void> refreshSession({
    required String branchId,
    int? refreshRate = 5,
  }) {
    return _legacy.refreshSession(branchId: branchId, refreshRate: refreshRate);
  }

  // TODO(ditto-migration): port `refund` to Ditto.
  @override
  Future<void> refund({required int itemId}) {
    return _legacy.refund(itemId: itemId);
  }

  // TODO(ditto-migration): port `removeS3File` to Ditto.
  @override
  Future<bool> removeS3File({required String fileName}) {
    return _legacy.removeS3File(fileName: fileName);
  }

  // TODO(ditto-migration): port `report` to Ditto.
  @override
  Report report({required int id}) {
    return _legacy.report(id: id);
  }

  // TODO(ditto-migration): port `reports` to Ditto.
  @override
  Stream<List<Report>> reports({required String branchId}) {
    return _legacy.reports(branchId: branchId);
  }

  // TODO(ditto-migration): port `saveComposite` to Ditto.
  @override
  Future<void> saveComposite({required Composite composite}) {
    return _legacy.saveComposite(composite: composite);
  }

  // TODO(ditto-migration): port `saveDiscount` to Ditto.
  @override
  Future<void> saveDiscount({
    required String branchId,
    required name,
    double? amount,
  }) {
    return _legacy.saveDiscount(branchId: branchId, name: name, amount: amount);
  }

  // TODO(ditto-migration): port `saveImageLocally` to Ditto.
  @override
  Future<Assets> saveImageLocally({
    required File imageFile,
    required String productId,
    required String branchId,
    required String businessId,
    String subPath = 'branch',
    String? variantId,
  }) {
    return _legacy.saveImageLocally(imageFile: imageFile, productId: productId, branchId: branchId, businessId: businessId, subPath: subPath, variantId: variantId);
  }

  // TODO(ditto-migration): port `saveLog` to Ditto.
  @override
  Future<void> saveLog(Log log) {
    return _legacy.saveLog(log);
  }

  // TODO(ditto-migration): port `saveOrUpdatePaymentPlan` to Ditto.
  @override
  FutureOr<Plan?> saveOrUpdatePaymentPlan({
    required String businessId,
    List<String>? addons,
    required String selectedPlan,
    String? planTemplateId,
    required int additionalDevices,
    required bool isYearlyPlan,
    required double totalPrice,
    required String paymentMethod,
    String? customerCode,
    Plan? plan,
    int numberOfPayments = 1,
    required HttpClientInterface flipperHttpClient,
  }) {
    return _legacy.saveOrUpdatePaymentPlan(businessId: businessId, addons: addons, selectedPlan: selectedPlan, planTemplateId: planTemplateId, additionalDevices: additionalDevices, isYearlyPlan: isYearlyPlan, totalPrice: totalPrice, paymentMethod: paymentMethod, customerCode: customerCode, plan: plan, numberOfPayments: numberOfPayments, flipperHttpClient: flipperHttpClient);
  }

  @override
  Future<SubscriptionPlanCatalog> getSubscriptionPlanCatalog() {
    return SubscriptionPlanCatalog.fetchFromSupabase();
  }

  @override
  FutureOr<void> savePaymentType({
    TransactionPaymentRecord? paymentRecord,
    String? transactionId,
    double amount = 0.0,
    String? paymentMethod,
    required bool singlePaymentOnly,
    bool saleCompletionFastPath = false,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized for savePaymentType');
      return;
    }

    ensureTransactionPaymentRecordsSyncSubscription(ditto);

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
    if (!saleCompletionFastPath) {
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
    }

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

    Future<void> mirrorToSqlite(TransactionPaymentRecord r) {
      return repository.upsert<TransactionPaymentRecord>(
        r,
        query: brick.Query(action: QueryAction.insert),
      );
    }

    if (paymentRecord != null) {
      await upsertDitto(paymentRecord);
      if (saleCompletionFastPath) {
        unawaited(
          mirrorToSqlite(paymentRecord).catchError((e, s) {
            talker.warning(
              'savePaymentType: deferred SQLite mirror failed: $e',
              s,
            );
          }),
        );
      } else {
        await mirrorToSqlite(paymentRecord);
      }
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
      if (saleCompletionFastPath) {
        unawaited(
          mirrorToSqlite(newPaymentRecord).catchError((e, s) {
            talker.warning(
              'savePaymentType: deferred SQLite mirror failed: $e',
              s,
            );
          }),
        );
      } else {
        await mirrorToSqlite(newPaymentRecord);
      }
    }
  }

  // TODO(ditto-migration): port `savePin` to Ditto.
  @override
  Future<Pin?> savePin({required Pin pin}) {
    return _legacy.savePin(pin: pin);
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    // TODO: implement send
    throw UnimplementedError();
  }

  // TODO(ditto-migration): port `sendMessageToIsolate` to Ditto.
  @override
  Future<void> sendMessageToIsolate({Map<String, dynamic>? message}) async {
    return _legacy.sendMessageToIsolate(message: message);
  }

  // TODO(ditto-migration): port `sendReport` to Ditto.
  @override
  Future<int> sendReport({required List<TransactionItem> transactionItems}) {
    return _legacy.sendReport(transactionItems: transactionItems);
  }

  // TODO(ditto-migration): port `setBranchPaymentStatus` to Ditto.
  @override
  FutureOr<void> setBranchPaymentStatus({
    required String currentBranchId,
    required bool status,
  }) {
    return _legacy.setBranchPaymentStatus(currentBranchId: currentBranchId, status: status);
  }

  // TODO(ditto-migration): port `signup` to Ditto.
  @override
  Future<Business?> signup({
    required Map business,
    required HttpClientInterface flipperHttpClient,
  }) {
    return _legacy.signup(business: business, flipperHttpClient: flipperHttpClient);
  }

  // TODO(ditto-migration): port `size` to Ditto.
  @override
  Future<int> size<T>({required T object}) {
    return _legacy.size<T>(object: object);
  }

  // TODO(ditto-migration): port `sku` to Ditto.
  @override
  Stream<SKU?> sku({required String branchId, required String businessId}) {
    return _legacy.sku(branchId: branchId, businessId: businessId);
  }

  // TODO(ditto-migration): port `spawnIsolate` to Ditto.
  @override
  Future<void> spawnIsolate(isolateHandler) {
    return _legacy.spawnIsolate(isolateHandler);
  }

  // TODO(ditto-migration): port `stocks` to Ditto.
  @override
  FutureOr<List<Stock>> stocks({required String branchId}) {
    return _legacy.stocks(branchId: branchId);
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

  // TODO(ditto-migration): port `subscribe` to Ditto.
  @override
  Future<({String customerCode, String url, int userId})> subscribe({
    required String businessId,
    required Business business,
    required int agentCode,
    required HttpClientInterface flipperHttpClient,
    required int amount,
  }) {
    return _legacy.subscribe(businessId: businessId, business: business, agentCode: agentCode, flipperHttpClient: flipperHttpClient, amount: amount);
  }

  // TODO(ditto-migration): port `syncOfflineAssets` to Ditto.
  @override
  Future<List<String>> syncOfflineAssets() {
    return _legacy.syncOfflineAssets();
  }

  // TODO(ditto-migration): port `syncUserWithAwsIncognito` to Ditto.
  @override
  Future<void> syncUserWithAwsIncognito({required String identifier}) {
    return _legacy.syncUserWithAwsIncognito(identifier: identifier);
  }

  // TODO(ditto-migration): port `totalSales` to Ditto.
  @override
  Stream<double> totalSales({required String branchId}) {
    return _legacy.totalSales(branchId: branchId);
  }

  // TODO(ditto-migration): port `universalProductNames` to Ditto.
  @override
  Future<List<UnversalProduct>> universalProductNames({
    required String branchId,
  }) {
    return _legacy.universalProductNames(branchId: branchId);
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

  // TODO(ditto-migration): port `updateAcess` to Ditto.
  @override
  FutureOr<void> updateAcess({
    required String userId,
    String? featureName,
    String? status,
    String? accessLevel,
    String? userType,
  }) {
    return _legacy.updateAcess(userId: userId, featureName: featureName, status: status, accessLevel: accessLevel, userType: userType);
  }

  // TODO(ditto-migration): port `updateAsset` to Ditto.
  @override
  FutureOr<void> updateAsset({required String assetId, String? assetName}) {
    return _legacy.updateAsset(assetId: assetId, assetName: assetName);
  }

  /// Note: this had no implementation on either database — CoreSync threw
  /// `UnimplementedError` from a synchronous body, so picking a colour in the
  /// product editor threw into the caller. Implemented here on Ditto.
  @override
  FutureOr<void> updateColor({
    required String colorId,
    String? name,
    bool? active,
  }) async {
    final color = await getColor(id: colorId);
    if (color == null) {
      talker.warning('updateColor: no colour $colorId');
      return;
    }
    if (name != null) color.name = name;
    if (active != null) color.active = active;
    color.lastTouched = DateTime.now().toUtc();

    final ditto = dittoService.dittoInstance;
    if (ditto != null) {
      await upsertReferenceDoc(ditto, colorsCollection, colorToDittoDoc(color));
    }
    scheduleCapellaBrickMirror(repository, color);
  }

  // TODO(ditto-migration): port `updateNotification` to Ditto.
  @override
  FutureOr<void> updateNotification({
    required String notificationId,
    bool? completed,
  }) {
    return _legacy.updateNotification(notificationId: notificationId, completed: completed);
  }

  // TODO(ditto-migration): port `updatePin` to Ditto.
  @override
  FutureOr<void> updatePin({
    required String userId,
    String? phoneNumber,
    String? tokenUid,
  }) {
    return _legacy.updatePin(userId: userId, phoneNumber: phoneNumber, tokenUid: tokenUid);
  }

  // TODO(ditto-migration): port `updateReport` to Ditto.
  @override
  FutureOr<void> updateReport({required String reportId, bool? downloaded}) {
    return _legacy.updateReport(reportId: reportId, downloaded: downloaded);
  }

  /// Note: like [updateColor], this threw `UnimplementedError` on CoreSync —
  /// selecting a unit in the product editor threw into the caller. Implemented
  /// here on Ditto.
  @override
  FutureOr<void> updateUnit({
    required String unitId,
    String? name,
    bool? active,
    String? branchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.warning('updateUnit: Ditto not initialized');
      return;
    }

    final result = await ditto.store.execute(
      'SELECT * FROM $unitsCollection WHERE _id = :id LIMIT 1',
      arguments: {'id': unitId},
    );
    if (result.items.isEmpty) {
      talker.warning('updateUnit: no unit $unitId');
      return;
    }

    final unit =
        unitFromDittoDoc(Map<String, dynamic>.from(result.items.first.value));
    if (name != null) unit.name = name;
    if (active != null) unit.active = active;
    if (branchId != null) unit.branchId = branchId;
    unit.lastTouched = DateTime.now().toUtc();

    await upsertReferenceDoc(ditto, unitsCollection, unitToDittoDoc(unit));
    scheduleCapellaBrickMirror(repository, unit);
  }

  // TODO(ditto-migration): port `uploadPdfToS3` to Ditto.
  @override
  Future<String> uploadPdfToS3(
    Uint8List pdfData,
    String fileName, {
    required String transactionId,
  }) {
    return _legacy.uploadPdfToS3(pdfData, fileName, transactionId: transactionId);
  }

  // TODO(ditto-migration): port `upsertPayment` to Ditto.
  @override
  Future<CustomerPayments> upsertPayment(CustomerPayments payment) {
    return _legacy.upsertPayment(payment);
  }

  // TODO(ditto-migration): port `userNameAvailable` to Ditto.
  @override
  Future<int> userNameAvailable({
    required String name,
    required HttpClientInterface flipperHttpClient,
  }) {
    return _legacy.userNameAvailable(name: name, flipperHttpClient: flipperHttpClient);
  }

  @override
  Future<VariantBranch?> variantBranch({
    required String variantId,
    required String destinationBranchId,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto != null) {
      try {
        final result = await ditto.store.execute(
          'SELECT * FROM variants_branches '
          'WHERE variantId = :variantId '
          'AND destinationBranchId = :destinationBranchId LIMIT 1',
          arguments: {
            'variantId': variantId,
            'destinationBranchId': destinationBranchId,
          },
        );
        if (result.items.isNotEmpty) {
          final data = Map<String, dynamic>.from(result.items.first.value);
          return VariantBranch(
            id: (data['id'] ?? data['_id'])?.toString(),
            variantId: data['variantId']?.toString(),
            newVariantId: data['newVariantId']?.toString(),
            sourceBranchId: data['sourceBranchId']?.toString(),
            destinationBranchId: data['destinationBranchId']?.toString(),
          );
        }
      } catch (e, st) {
        talker.warning('Capella variantBranch Ditto read failed: $e\n$st');
      }
    }

    // Fallback: local SQLite (Brick). localOnly (not awaitRemoteWhenNoneExist)
    // keeps the branch-transfer hot path off a Supabase round-trip; the mapping
    // is dual-written to Ditto + Brick on create, so local is authoritative for
    // repeat transfers from this device.
    final local = await repository.get<VariantBranch>(
      query: brick.Query(
        where: [
          brick.Where('destinationBranchId').isExactly(destinationBranchId),
          brick.Where('variantId').isExactly(variantId),
        ],
      ),
      policy: OfflineFirstGetPolicy.localOnly,
    );
    return local.isEmpty ? null : local.first;
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

  // TODO(ditto-migration): port `getPinLocal` to Ditto.
  @override
  FutureOr<Pin?> getPinLocal({
    String? userId,
    String? phoneNumber,
    required bool alwaysHydrate,
  }) {
    return _legacy.getPinLocal(userId: userId, phoneNumber: phoneNumber, alwaysHydrate: alwaysHydrate);
  }

  // TODO(ditto-migration): port `updateTenant` to Ditto.
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
    return _legacy.updateTenant(tenantId: tenantId, name: name, phoneNumber: phoneNumber, email: email, userId: userId, businessId: businessId, type: type, id: id, pin: pin, sessionActive: sessionActive, branchId: branchId);
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
        await ProxyService.legacyStrategy.updateCategory(
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

  // TODO(ditto-migration): port `sendOtpForSignup` to Ditto.
  @override
  Future<Map<String, dynamic>> sendOtpForSignup(String contact) {
    return _legacy.sendOtpForSignup(contact);
  }

  // TODO(ditto-migration): port `verifyOtpForSignup` to Ditto.
  @override
  Future<Map<String, dynamic>> verifyOtpForSignup(String contact, String otp) {
    return _legacy.verifyOtpForSignup(contact, otp);
  }
}
