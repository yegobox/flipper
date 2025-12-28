import 'dart:async';
import 'package:supabase_models/brick/models/stock_recount.model.dart';
import 'package:supabase_models/brick/models/stock_recount_item.model.dart';

/// Interface for stock recount operations
/// Handles physical stock counting with P2P sync via Ditto
abstract class StockRecountInterface {
  /// Start a new recount session
  /// Returns the created StockRecount with 'draft' status
  Future<StockRecount> startRecountSession({
    required String branchId,
    String? userId,
    String? deviceId,
    String? deviceName,
    String? notes,
  });

  /// Get all recount sessions for a branch
  /// [status] - Optional filter: 'draft', 'submitted', 'synced'
  Future<List<StockRecount>> getRecounts({
    required String branchId,
    String? status,
  });

  /// Get a specific recount by ID
  Future<StockRecount?> getRecount({required String recountId});

  /// Get all items in a recount session
  Future<List<StockRecountItem>> getRecountItems({
    required String recountId,
  });

  /// Add or update an item in the recount
  /// Fetches current stock quantity and validates
  Future<StockRecountItem> addOrUpdateRecountItem({
    required String recountId,
    required String variantId,
    required double countedQuantity,
    String? notes,
  });

  /// Remove an item from the recount
  Future<void> removeRecountItem({
    required String itemId,
  });

  /// Submit the recount for processing
  /// Validates all items, updates Stock records, triggers RRA sync
  /// Returns updated StockRecount with 'submitted' status
  Future<StockRecount> submitRecount({
    required String recountId,
  });

  /// Mark recount as synced (called after Ditto P2P sync completes)
  /// Returns updated StockRecount with 'synced' status
  Future<StockRecount> markRecountSynced({
    required String recountId,
  });

  /// Delete a draft recount (only allowed for draft status)
  Future<void> deleteRecount({
    required String recountId,
  });

  /// Stream of recounts for real-time updates
  Stream<List<StockRecount>> recountsStream({
    required String branchId,
    String? status,
  });

  /// Get stock summary for recount
  /// Returns current stock quantities for variants in the branch
  Future<Map<String, double>> getStockSummary({
    required String branchId,
    List<String>? variantIds,
  });
}
