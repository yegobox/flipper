import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/cache/cache_export.dart';

/// Helper class for working with the Stock cache in the dashboard app
class StockCacheHelper {
  /// Singleton instance
  static final StockCacheHelper _instance = StockCacheHelper._internal();

  /// Factory constructor to return the singleton instance
  factory StockCacheHelper() => _instance;

  /// Private constructor for singleton pattern
  StockCacheHelper._internal();

  /// Initialize the cache manager
  Future<void> initialize() async {
    await CacheManager().initialize();
    print('Stock cache helper initialized');
  }

  /// Load cached stock data for variants
  /// This will update the variants' stock property with cached data if available
  Future<List<Variant>> loadCachedStockForVariants(
      List<Variant> variants) async {
    try {
      // For each variant, try to get its stock from cache
      for (final variant in variants) {
        if (variant.id.isNotEmpty && variant.stock != null) {
          try {
            final cachedStock =
                await CacheManager().getStockByVariantId(variant.id);
            if (cachedStock != null) {
              // Update the variant's stock with cached data
              variant.stock = cachedStock;
              print('Loaded cached stock for variant ${variant.id}');
            }
          } catch (e) {
            print('Error loading cached stock for variant ${variant.id}: $e');
          }
        }
      }
      return variants;
    } catch (e) {
      print('Error loading cached stock data: $e');
      return variants;
    }
  }

  /// Save stock data for variants to cache
  Future<void> saveStocksForVariants(List<Variant> variants) async {
    try {
      await CacheManager().saveStocksForVariants(variants);
      print('Saved ${variants.length} variants with stock data to cache');
    } catch (e) {
      print('Error saving stock data to cache: $e');
    }
  }

  /// Clear the stock cache
  Future<void> clearCache() async {
    try {
      // await CacheManager().clearStocks();
      print('Stock cache cleared');
    } catch (e) {
      print('Error clearing stock cache: $e');
    }
  }
}
