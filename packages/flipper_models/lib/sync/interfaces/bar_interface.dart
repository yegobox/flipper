import 'dart:async';

import 'package:flipper_models/models/bar_table.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';
import 'package:supabase_models/brick/models/transactionItem.model.dart';

/// Bar Mode table service (Capella + Ditto implementation).
abstract class BarInterface {
  // --- Floor plan ---

  Stream<List<BarTable>> barTablesStream({required String branchId});

  Future<List<BarTable>> barTables({required String branchId});

  Future<void> saveBarTable(BarTable table);

  Future<void> deleteBarTable({
    required String id,
    required String branchId,
  });

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

  /// Complete payment and free the table (delegates to transaction completion).
  Future<ITransaction> settleBarTab({
    required ITransaction transaction,
    required String paymentType,
    required double cashReceived,
    required double customerChangeDue,
  });
}
