import 'package:flipper_models/db_model_export.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_models/cache/cache_export.dart';

void main() {
  group('Stock Cache Tests', () {
    late CacheManager cacheManager;
    
    setUp(() async {
      // Initialize cache manager before each test
      cacheManager = CacheManager();
      await cacheManager.initialize();
      
      // Clear cache to start fresh
      await cacheManager.clear();
    });
    
    tearDown(() async {
      // Clean up after each test
      await cacheManager.clear();
    });
    
    test('Save and retrieve stock by variant ID', () async {
      // Create test data
      final variantId = 'test-variant-123';
      final stock = Stock(
        id: 'test-stock-123',
        currentStock: 10,
        branchId: 1,
      );
      
      // Save stock to cache
      await cacheManager.saveStock(stock);
      
      // Retrieve stock by variant ID
      final retrievedStock = await cacheManager.getStockByVariantId(variantId);
      
      // Verify stock was retrieved correctly
      expect(retrievedStock, isNotNull);
      expect(retrievedStock!.id, equals(stock.id));
      expect(retrievedStock.currentStock, equals(stock.currentStock));
    });
    
    test('Save multiple stocks for variants', () async {
      // Create test data
      final variant1 = Variant(
        id: 'variant-1',
        name: 'Test Variant 1',
        productId: 'product-1',
        stock: Stock(
          id: 'stock-1',
          currentStock: 5,
          branchId: 1,
        ),
      );
      
      final variant2 = Variant(
        id: 'variant-2',
        name: 'Test Variant 2',
        productId: 'product-1',
        stock: Stock(
          id: 'stock-2',
          currentStock: 15,
          branchId: 1,
        ),
      );
      
      final variants = [variant1, variant2];
      
      // Save stocks for variants
      await cacheManager.saveStocksForVariants(variants);
      
      // Retrieve stocks by variant ID
      final stock1 = await cacheManager.getStockByVariantId('variant-1');
      final stock2 = await cacheManager.getStockByVariantId('variant-2');
      
      // Verify stocks were retrieved correctly
      expect(stock1, isNotNull);
      expect(stock1!.id, equals('stock-1'));
      expect(stock1.currentStock, equals(5));
      
      expect(stock2, isNotNull);
      expect(stock2!.id, equals('stock-2'));
      expect(stock2.currentStock, equals(15));
    });
    
    test('Update stock in cache', () async {
      // Create and save initial stock
      final variantId = 'test-variant-update';
      final stock = Stock(
        id: 'test-stock-update',
        currentStock: 10,
        branchId: 1,
      );
      
      await cacheManager.saveStock(stock);
      
      // Update stock
      final updatedStock = Stock(
        id: 'test-stock-update',
        currentStock: 20, // Changed value
        branchId: 1,
      );
      
      await cacheManager.saveStock(updatedStock);
      
      // Retrieve updated stock
      final retrievedStock = await cacheManager.getStockByVariantId(variantId);
      
      // Verify stock was updated
      expect(retrievedStock, isNotNull);
      expect(retrievedStock!.currentStock, equals(20));
    });
  });
}
