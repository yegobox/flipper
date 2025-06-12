import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/brick/models/variant.model.dart';
import 'package:supabase_models/cache/cache_layer.dart';
import 'package:supabase_models/cache/realm/realm_stock_cache.dart';

/// Cache manager for handling different cache implementations
/// This class provides a unified interface for caching different types of objects
class CacheManager {
  /// Singleton instance
  static final CacheManager _instance = CacheManager._internal();

  /// Factory constructor to return the singleton instance
  factory CacheManager() => _instance;

  /// Private constructor for singleton pattern
  CacheManager._internal();

  /// Stock cache instance
  late CacheLayer<Stock> _stockCache;

  /// Initialize the cache manager
  Future<void> initialize() async {
    // Initialize stock cache with Realm implementation
    _stockCache = RealmStockCache();
    await _stockCache.initialize();
  }

  /// Save a stock to cache
  Future<void> saveStock(Stock stock) async {
    await _stockCache.save(stock);
  }

  /// Save multiple stocks to cache
  Future<void> saveStocks(List<Stock> stocks) async {
    await _stockCache.saveAll(stocks);
  }

  /// Get a stock from cache by ID
  Future<Stock?> getStock(String id) async {
    return await _stockCache.get(id);
  }

  /// Get all stocks from cache
  Future<List<Stock>> getAllStocks() async {
    return await _stockCache.getAll();
  }

  /// Get stocks by variant ID
  Future<List<Stock>> getStocksByVariantId(String variantId) async {
    if (_stockCache is RealmStockCache) {
      return await (_stockCache as RealmStockCache).getByVariantId(variantId);
    }
    return await _stockCache.getAll(filter: {'variantId': variantId});
  }

  /// Get a single stock by variant ID
  Future<Stock?> getStockByVariantId(String variantId) async {
    if (_stockCache is RealmStockCache) {
      // Use the specialized method if available
      return ((_stockCache as RealmStockCache).getByVariantIdSingle(variantId));
    } else {
      // Fallback to the general method
      final stocks = await getStocksByVariantId(variantId);
      return stocks.isNotEmpty ? stocks.first : null;
    }
  }

  /// Watch a stock by variant ID and get updates as a stream
  /// This is useful for UI components that need to react to stock changes
  Stream<Stock?> watchStockByVariantId(String variantId) {
    if (_stockCache is RealmStockCache) {
      // Use the specialized stream method if available
      return (_stockCache as RealmStockCache).watchByVariantId(variantId);
    } else {
      // Fallback to polling if streaming is not supported
      // Create a stream that emits every 5 seconds
      return Stream.periodic(Duration(seconds: 5)).asyncMap((_) async {
        return await getStockByVariantId(variantId);
      });
    }
  }

  /// Get stocks by branch ID
  Future<List<Stock>> getStocksByBranchId(int branchId) async {
    if (_stockCache is RealmStockCache) {
      return await (_stockCache as RealmStockCache).getByBranchId(branchId);
    }
    return await _stockCache.getAll(filter: {'branchId': branchId});
  }

  /// Save stock information for variants
  Future<void> saveStocksForVariants(List<Variant> variants) async {
    if (_stockCache is! RealmStockCache) {
      // If not using RealmStockCache, just save the stocks directly
      final stocks = variants
          .where((v) => v.stock != null && v.stock!.id.isNotEmpty)
          .map((v) => v.stock!)
          .toList();

      if (stocks.isNotEmpty) {
        await saveStocks(stocks);
      }
      return;
    }

    // Using RealmStockCache - we need to associate stocks with their variants
    final realmCache = _stockCache as RealmStockCache;

    for (final variant in variants) {
      if (variant.stock != null &&
          variant.stock!.id.isNotEmpty &&
          variant.id.isNotEmpty) {
        // Save stock with associated variant ID
        await realmCache.saveWithVariantId(variant.stock!, variant.id);
      }
    }
  }

  /// Clear all cached data
  /// This is particularly useful for testing purposes
  Future<void> clear() async {
    // Clear stock cache
    await clearStocks();
    // Add more cache clearing operations here as needed
  }

  /// Clear all stocks from cache
  Future<void> clearStocks() async {
    await _stockCache.clear();
  }

  /// Clear all caches
  Future<void> clearAll() async {
    await _stockCache.clear();
  }

  /// Close all cache connections
  Future<void> close() async {
    await _stockCache.close();
  }
}
