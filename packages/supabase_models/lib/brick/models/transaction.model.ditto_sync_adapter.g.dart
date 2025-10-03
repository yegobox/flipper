// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.model.dart';

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************

// **************************************************************************
// DittoSyncAdapterGenerator
// **************************************************************************
//
// REQUIRED IMPORTS in parent file (itransaction.model.dart):
// - import 'package:brick_core/query.dart';
// - import 'package:brick_offline_first/brick_offline_first.dart';
// - import 'package:flipper_services/proxy.dart';
// - import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
// - import 'package:supabase_models/sync/ditto_sync_adapter.dart';
// - import 'package:supabase_models/sync/ditto_sync_coordinator.dart';
// - import 'package:supabase_models/sync/ditto_sync_generated.dart';
// - import 'package:supabase_models/brick/repository.dart';
// **************************************************************************
//
// Sync Direction: sendOnly
// This adapter sends data to Ditto but does NOT receive remote updates.
// **************************************************************************

class ITransactionDittoAdapter extends DittoSyncAdapter<ITransaction> {
  ITransactionDittoAdapter._internal();

  static final ITransactionDittoAdapter instance =
      ITransactionDittoAdapter._internal();

  static int? Function()? _branchIdProviderOverride;
  static int? Function()? _businessIdProviderOverride;

  /// Allows tests to override how the current branch ID is resolved.
  void overrideBranchIdProvider(int? Function()? provider) {
    _branchIdProviderOverride = provider;
  }

  /// Allows tests to override how the current business ID is resolved.
  void overrideBusinessIdProvider(int? Function()? provider) {
    _businessIdProviderOverride = provider;
  }

  /// Clears any provider overrides (intended for tests).
  void resetOverrides() {
    _branchIdProviderOverride = null;
    _businessIdProviderOverride = null;
  }

  String get collectionName => "transactions";

  @override
  Future<DittoSyncQuery?> buildObserverQuery() async {
    // Send-only mode: no remote observation
    return null;
  }

  @override
  Future<String?> documentIdForModel(ITransaction model) async => model.id;

  @override
  Future<Map<String, dynamic>> toDittoDocument(ITransaction model) async {
    return {
      "id": model.id,
      "reference": model.reference,
      "categoryId": model.categoryId,
      "transactionNumber": model.transactionNumber,
      "branchId": model.branchId,
      "status": model.status,
      "transactionType": model.transactionType,
      "subTotal": model.subTotal,
      "paymentType": model.paymentType,
      "cashReceived": model.cashReceived,
      "customerChangeDue": model.customerChangeDue,
      "createdAt": model.createdAt?.toIso8601String(),
      "receiptType": model.receiptType,
      "updatedAt": model.updatedAt?.toIso8601String(),
      "customerId": model.customerId,
      "customerType": model.customerType,
      "note": model.note,
      "lastTouched": model.lastTouched?.toIso8601String(),
      "ticketName": model.ticketName,
      "supplierId": model.supplierId,
      "ebmSynced": model.ebmSynced,
      "isIncome": model.isIncome,
      "isExpense": model.isExpense,
      "isRefunded": model.isRefunded,
      "customerName": model.customerName,
      "customerTin": model.customerTin,
      "remark": model.remark,
      "customerBhfId": model.customerBhfId,
      "sarTyCd": model.sarTyCd,
      "receiptNumber": model.receiptNumber,
      "totalReceiptNumber": model.totalReceiptNumber,
      "invoiceNumber": model.invoiceNumber,
      "isDigitalReceiptGenerated": model.isDigitalReceiptGenerated,
      "receiptFileName": model.receiptFileName,
      "currentSaleCustomerPhoneNumber": model.currentSaleCustomerPhoneNumber,
      "sarNo": model.sarNo,
      "orgSarNo": model.orgSarNo,
      "shiftId": model.shiftId,
      "isLoan": model.isLoan,
      "dueDate": model.dueDate?.toIso8601String(),
      "isAutoBilled": model.isAutoBilled,
      "nextBillingDate": model.nextBillingDate?.toIso8601String(),
      "billingFrequency": model.billingFrequency,
      "billingAmount": model.billingAmount,
      "totalInstallments": model.totalInstallments,
      "paidInstallments": model.paidInstallments,
      "lastBilledDate": model.lastBilledDate?.toIso8601String(),
      "originalLoanAmount": model.originalLoanAmount,
      "remainingBalance": model.remainingBalance,
      "lastPaymentDate": model.lastPaymentDate?.toIso8601String(),
      "lastPaymentAmount": model.lastPaymentAmount,
      "originalTransactionId": model.originalTransactionId,
      "isOriginalTransaction": model.isOriginalTransaction,
      "taxAmount": model.taxAmount,
      "numberOfItems": model.numberOfItems,
      "discountAmount": model.discountAmount,
      "items": model.items,
      "customerPhone": model.customerPhone,
    };
  }

  @override
  Future<ITransaction?> fromDittoDocument(Map<String, dynamic> document) async {
    final id = document["_id"] ?? document["id"];
    if (id == null) return null;

    // Branch filtering
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    final docBranch = document["branchId"];
    if (currentBranch != null && docBranch != currentBranch) {
      return null;
    }

    return ITransaction(
      id: id,
      reference: document["reference"],
      categoryId: document["categoryId"],
      transactionNumber: document["transactionNumber"],
      branchId: document["branchId"],
      status: document["status"],
      transactionType: document["transactionType"],
      subTotal: document["subTotal"],
      paymentType: document["paymentType"],
      cashReceived: document["cashReceived"],
      customerChangeDue: document["customerChangeDue"],
      createdAt: DateTime.tryParse(document["createdAt"]?.toString() ?? ""),
      receiptType: document["receiptType"],
      updatedAt: DateTime.tryParse(document["updatedAt"]?.toString() ?? ""),
      customerId: document["customerId"],
      customerType: document["customerType"],
      note: document["note"],
      lastTouched: DateTime.tryParse(document["lastTouched"]?.toString() ?? ""),
      ticketName: document["ticketName"],
      supplierId: document["supplierId"],
      ebmSynced: document["ebmSynced"],
      isIncome: document["isIncome"],
      isExpense: document["isExpense"],
      isRefunded: document["isRefunded"],
      customerName: document["customerName"],
      customerTin: document["customerTin"],
      remark: document["remark"],
      customerBhfId: document["customerBhfId"],
      sarTyCd: document["sarTyCd"],
      receiptNumber: document["receiptNumber"],
      totalReceiptNumber: document["totalReceiptNumber"],
      invoiceNumber: document["invoiceNumber"],
      isDigitalReceiptGenerated: document["isDigitalReceiptGenerated"],
      receiptFileName: document["receiptFileName"],
      currentSaleCustomerPhoneNumber:
          document["currentSaleCustomerPhoneNumber"],
      sarNo: document["sarNo"],
      orgSarNo: document["orgSarNo"],
      shiftId: document["shiftId"],
      isLoan: document["isLoan"],
      dueDate: DateTime.tryParse(document["dueDate"]?.toString() ?? ""),
      isAutoBilled: document["isAutoBilled"],
      nextBillingDate:
          DateTime.tryParse(document["nextBillingDate"]?.toString() ?? ""),
      billingFrequency: document["billingFrequency"],
      billingAmount: document["billingAmount"],
      totalInstallments: document["totalInstallments"],
      paidInstallments: document["paidInstallments"],
      lastBilledDate:
          DateTime.tryParse(document["lastBilledDate"]?.toString() ?? ""),
      originalLoanAmount: document["originalLoanAmount"],
      remainingBalance: document["remainingBalance"],
      lastPaymentDate:
          DateTime.tryParse(document["lastPaymentDate"]?.toString() ?? ""),
      lastPaymentAmount: document["lastPaymentAmount"],
      originalTransactionId: document["originalTransactionId"],
      isOriginalTransaction: document["isOriginalTransaction"],
      taxAmount: document["taxAmount"],
      numberOfItems: document["numberOfItems"],
      discountAmount: document["discountAmount"],
      items: document["items"],
      customerPhone: document["customerPhone"],
    );
  }

  @override
  Future<bool> shouldApplyRemote(Map<String, dynamic> document) async {
    final currentBranch =
        _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
    if (currentBranch == null) return true;
    final docBranch = document["branchId"];
    return docBranch == currentBranch;
  }

  static bool _seeded = false;

  static void _resetSeedFlag() {
    _seeded = false;
  }

  static Future<void> _seed(DittoSyncCoordinator coordinator) async {
    if (_seeded) {
      if (kDebugMode) {
        debugPrint('Ditto seeding skipped for ITransaction (already seeded)');
      }
      return;
    }

    try {
      Query? query;
      final branchId =
          _branchIdProviderOverride?.call() ?? ProxyService.box.getBranchId();
      if (branchId != null) {
        query = Query(where: [Where('branchId').isExactly(branchId)]);
      }

      final models = await Repository().get<ITransaction>(
        query: query,
        policy: OfflineFirstGetPolicy.alwaysHydrate,
      );
      var seededCount = 0;
      for (final model in models) {
        await coordinator.notifyLocalUpsert<ITransaction>(model);
        seededCount++;
      }
      if (kDebugMode) {
        debugPrint('Ditto seeded ' +
            seededCount.toString() +
            ' ITransaction record' +
            (seededCount == 1 ? '' : 's'));
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('Ditto seeding failed for ITransaction: $error\n$stack');
      }
    }

    _seeded = true;
  }

  static final int _$ITransactionDittoAdapterRegistryToken =
      DittoSyncGeneratedRegistry.register((coordinator) async {
    await coordinator
        .registerAdapter<ITransaction>(ITransactionDittoAdapter.instance);
  }, seed: (coordinator) async {
    await _seed(coordinator);
  }, reset: _resetSeedFlag);

  /// Public accessor to ensure static initializer runs
  static int get registryToken => _$ITransactionDittoAdapterRegistryToken;
}
