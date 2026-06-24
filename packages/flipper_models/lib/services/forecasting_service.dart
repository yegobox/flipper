import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_dashboard/features/production_output/services/production_output_service.dart';

class ForecastingService {
  final _productionService = ProductionOutputService();

  /// Calculates the average daily usage of a variant based on past 30 days of WorkOrders.
  ///
  /// Returns usage quantity per day.
  /// Now supports deducing usage for Raw Materials via Recipes (Composites).
  Future<double> calculateDailyUsage(String variantId) async {
    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));

      // 1. Fetch completed work orders for the last 30 days
      final workOrders = await _productionService.getWorkOrders(
        startDate: thirtyDaysAgo,
        endDate: now,
      );

      final completedOrders = workOrders
          .where((wo) => wo.status == 'completed')
          .toList();

      if (completedOrders.isEmpty) return 0.0;

      double totalUsage = 0;

      // 2. Iterate through orders to find usage of this variant
      for (final wo in completedOrders) {
        // Case A: formatted as "Produced Item" (Direct usage)
        if (wo.variantId == variantId) {
          // If we are tracking the finished good itself (less likely for "Running Low", but possible)
          // For finished goods, "Usage" = "Sales" usually.
          // But here we are looking at Production Output.
          // If I produce Bread, do I "use" Bread? No, I produce it.
          // usage comes from SALES for finished goods.
          // However, if this variant is an intermediate part, maybe.
          // Let's assume for now, if it monitors Raw Material, we shouldn't count production as usage.
          // BUT, if we are producing "Burger" using "Bun", "Bun" is used.
          // So we need to check if 'variantId' is an INGREDIENT of wo.variantId.
        }

        // Case B: This variant is an INGREDIENT in the produced item
        // We need to check if the produced item (wo.variantId) has a recipe containing our variantId.

        // This makes the loop O(N * M) where N = orders, M = fetch recipe.
        // Optimization: Cache recipes.

        // Note: ProductionOutputService logic implies Composites are linked via ProductID?
        // "final composites = await ProxyService.strategy.composites(productId: product.id);"
        // We need the product ID of the produced item.
        // wo.variantId is known. getVariant(wo.variantId) -> productID.

        // Let's try to fetch composites for the produced item.
        // We need the variant first to get productId
        final producedVariant = await ProxyService.strategy.getVariant(
          id: wo.variantId,
        );
        if (producedVariant == null) continue;

        // Fetch composites for the PRODUCT of the produced variant
        final composites = await ProxyService.strategy.composites(
          productId: producedVariant.productId,
        );

        // Check if OUR variant (the one we are calculating usage for) is in the ingredients
        for (final composite in composites) {
          if (composite.variantId == variantId) {
            // FOUND IT! This order used our raw material.
            // Usage = Quantity Produced * Qty Per Unit
            final qtyPerUnit = composite.qty ?? 0.0;
            final qtyProduced = wo.actualQuantity;
            totalUsage += (qtyProduced * qtyPerUnit);
          }
        }
      }

      // Calculate daily average (30 days)
      return totalUsage / 30.0;
    } catch (e) {
      print('Error calculating daily usage: $e');
      return 0.0;
    }
  }

  /// Calculates the estimated date when stock will run out.
  ///
  /// Returns null if usage is 0 (infinite stock).
  Future<DateTime?> getStockoutDate(
    String variantId,
    double currentStock,
  ) async {
    final dailyUsage = await calculateDailyUsage(variantId);

    if (dailyUsage <= 0) return null;

    final daysRemaining = currentStock / dailyUsage;
    return DateTime.now().add(Duration(days: daysRemaining.floor()));
  }

  /// Returns a list of variants that are predicted to run out within [daysThreshold].
  ///
  /// This is an expensive operation if we iterate all variants.
  /// Optimization: Only check variants with recent activity or active flag.
  Future<List<LowStockPrediction>> getLowStockItems({
    int daysThreshold = 7,
    List<Variant>?
    candidates, // Optional list to check, otherwise fetches from branch
  }) async {
    final List<LowStockPrediction> predictions = [];

    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) return [];

      final paged = await ProxyService.strategy.variants(
        branchId: branchId,
        // taxTyCds: ['A', 'B', 'C', 'D'], // Fetch all taxable types
        itemTyCd:
            '1', // Raw materials only? Or all? Let's assume raw materials '1'
      );
      final variantsToCheck = candidates ?? paged.variants.cast<Variant>();

      for (final variant in variantsToCheck) {
        // Fetch current stock
        // If Model doesn't have currentStock, we need to fetch it.
        final currentStock = await ProxyService.strategy.totalStock(
          variantId: variant.id,
        );

        final dailyUsage = await calculateDailyUsage(variant.id);

        if (dailyUsage > 0) {
          final daysRemaining = currentStock / dailyUsage;

          if (daysRemaining <= daysThreshold) {
            predictions.add(
              LowStockPrediction(
                variant: variant,
                currentStock: currentStock,
                dailyUsage: dailyUsage,
                daysRemaining: daysRemaining.toInt(),
                stockoutDate: DateTime.now().add(
                  Duration(days: daysRemaining.toInt()),
                ),
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error predicting low stock: $e');
    }

    return predictions;
  }
}

class LowStockPrediction {
  final Variant variant;
  final double currentStock;
  final double dailyUsage;
  final int daysRemaining;
  final DateTime stockoutDate;

  LowStockPrediction({
    required this.variant,
    required this.currentStock,
    required this.dailyUsage,
    required this.daysRemaining,
    required this.stockoutDate,
  });
}
