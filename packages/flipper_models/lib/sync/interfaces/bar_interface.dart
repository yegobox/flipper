import 'dart:async';

import 'package:flipper_models/models/bar_branch_settings.dart';
import 'package:flipper_models/models/bar_table.dart';
import 'package:flipper_models/helperModels/sale_completion_helpers.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Bar Mode table service (Capella + Ditto implementation).
abstract class BarInterface {
  // --- Branch settings (synced across devices) ---

  Future<BarBranchSettings?> barBranchSettings({required String branchId});

  Stream<BarBranchSettings?> barBranchSettingsStream({
    required String branchId,
  });

  Future<void> saveBarBranchSettings(BarBranchSettings settings);

  // --- Floor plan ---

  Stream<List<BarTable>> barTablesStream({required String branchId});

  Future<List<BarTable>> barTables({required String branchId});

  Future<void> saveBarTable(BarTable table);

  Future<void> deleteBarTable({required String id, required String branchId});

  Future<void> seedDefaultFloorPlan({required String branchId});

  // --- Tabs (PARKED transactions with tableId) ---

  Stream<List<ITransaction>> barTabsStream({required String branchId});

  Future<ITransaction?> barTabForTable({
    required String branchId,
    required String tableId,
  });

  Future<List<TransactionItem>> barTabLines({required String transactionId});

  /// Create or resume a tab for [tableId]; never resets opener/time on resume.
  Future<ITransaction> openBarTab({
    required String branchId,
    required BarTable table,
    required String cashierTenantId,
    required String cashierName,
  });

  Future<void> addLineToBarTab({
    required String transactionId,
    required String branchId,
    required String variantId,
    required String productName,
    required num defaultPrice,
    required num stock,
    required String cashierTenantId,
    required String cashierName,
    String? color,
    String? sku,
  });

  Future<void> setBarTabLineQty({
    required String lineId,
    required String transactionId,
    required num qty,
    required num stockCap,
  });

  Future<void> setBarTabLinePrice({
    required String lineId,
    required String transactionId,
    required num price,
  });

  Future<void> deleteBarTabLine({
    required String lineId,
    required String transactionId,
  });

  Future<void> refreshBarTabSubTotal({required String transactionId});

  /// Complete payment and free the table.
  ///
  /// [lines] are the tab's own lines. They are required because the completed
  /// transaction has to carry the tax the ledger splits revenue by — see
  /// `applySaleAccountingFields`.
  Future<ITransaction> settleBarTab({
    required ITransaction transaction,
    required List<TransactionItem> lines,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  });

  // --- Credit (tabs the guest will pay later) ---

  /// Turns [transaction] into a loan owed by the customer and frees its table.
  ///
  /// It stays PARKED, as a POS loan does, so POS Tickets → Loans lists it too.
  Future<ITransaction> parkBarTabAsLoan({
    required ITransaction transaction,
    required List<TransactionItem> lines,
    required String customerId,
    required String customerName,
    String? customerPhone,
    required DateTime dueDate,
  });

  /// Every open loan in the branch, bar or POS: a debt is collected wherever
  /// the customer turns up.
  Stream<List<ITransaction>> barCreditTabsStream({required String branchId});

  /// Records one installment against a loan; completes it once it is paid.
  ///
  /// Writes no receipt and moves no stock: both happened when the loan was
  /// given.
  Future<ITransaction> collectBarCreditPayment({
    required ITransaction transaction,
    required List<PaymentLineForSaleCompletion> payments,
  });
}
