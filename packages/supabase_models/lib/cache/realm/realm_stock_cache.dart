import 'package:realm/realm.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/cache/cache_layer.dart';
import 'package:supabase_models/cache/realm/stock_realm_model.dart';

/// Realm implementation of CacheLayer for Stock objects
class RealmStockCache implements CacheLayer<Stock> {
  late Realm _realm;
  bool _isInitialized = false;

  /// Singleton instance
  static final RealmStockCache _instance = RealmStockCache._internal();
  
  /// Factory constructor to return the singleton instance
  factory RealmStockCache() => _instance;
  
  /// Private constructor for singleton pattern
  RealmStockCache._internal();

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // Define the schema for the Realm database
    final config = Configuration.local([StockRealm.schema]);
    _realm = Realm(config);
    _isInitialized = true;
  }

  /// Ensure the Realm instance is initialized
  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
    _checkInitialized();
  }

  @override
  Future<void> save(Stock stock) async {
    try {
      await _ensureInitialized();
      
      // Convert to Realm model
      final realmItem = _convertToRealmModel(stock);
      
      // Save to Realm
      await _realm.writeAsync(() {
        _realm.add(realmItem, update: true);
      });
    } catch (e) {
      print('Error saving stock to cache: $e');
      rethrow;
    }
  }
  
  /// Save a stock with an associated variant ID
  Future<void> saveWithVariantId(Stock item, String variantId) async {
    try {
      await _ensureInitialized();
      
      // Convert to Realm model with variant ID
      final realmItem = _convertToRealmModel(item, variantId: variantId);
      
      // Save to Realm
      await _realm.writeAsync(() {
        _realm.add(realmItem, update: true);
      });
    } catch (e) {
      print('Error saving stock with variant ID to cache: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveAll(List<Stock> stocks) async {
    _checkInitialized();
    
    // Convert all Stock models to StockRealm models
    final stockRealms = stocks.map(_convertToRealmModel).toList();
    
    // Write all to Realm database
    _realm.write(() {
      for (final stockRealm in stockRealms) {
        _realm.add(stockRealm, update: true);
      }
    });
  }

  @override
  Future<Stock?> get(String id) async {
    _checkInitialized();
    
    // Find StockRealm by ID
    final stockRealm = _realm.find<StockRealm>(id);
    
    // Convert to Stock model if found
    return stockRealm != null ? _convertFromRealmModel(stockRealm) : null;
  }
  
  /// Get a single stock by variant ID
  Stock? getByVariantIdSingle(String variantId) {
    _checkInitialized();
    
    // Query for stocks with matching variant ID
    final results = _realm.query<StockRealm>('variantId == \$0', [variantId]);
    
    // Return the first result if any
    return results.isNotEmpty ? _convertFromRealmModel(results.first) : null;
  }
  
  /// Watch a stock by variant ID and get updates as a stream
  Stream<Stock?> watchByVariantId(String variantId) {
    _checkInitialized();
    
    // Query for stocks with matching variant ID
    final results = _realm.query<StockRealm>('variantId == \$0', [variantId]);
    
    // Create a stream from the RealmResults
    return results.changes.map((change) {
      if (change.results.isNotEmpty) {
        return _convertFromRealmModel(change.results.first);
      }
      return null;
    });
  }

  @override
  Future<List<Stock>> getAll({Map<String, dynamic>? filter}) async {
    _checkInitialized();
    
    // Get all StockRealm objects
    RealmResults<StockRealm> results;
    
    if (filter != null && filter.containsKey('variantId')) {
      // Filter by variant ID if provided
      results = _realm.query<StockRealm>('variantId == \$0', [filter['variantId']]);
    } else if (filter != null && filter.containsKey('branchId')) {
      // Filter by branch ID if provided
      results = _realm.query<StockRealm>('branchId == \$0', [filter['branchId']]);
    } else {
      // Get all stocks
      results = _realm.all<StockRealm>();
    }
    
    // Convert all to Stock models
    return results.map(_convertFromRealmModel).toList();
  }

  @override
  Future<void> clear() async {
    _checkInitialized();
    
    // Delete all StockRealm objects
    _realm.write(() {
      _realm.deleteAll<StockRealm>();
    });
  }

  @override
  Future<void> close() async {
    if (_isInitialized) {
      _realm.close();
      _isInitialized = false;
    }
  }

  /// Helper method to convert Stock model to StockRealm model
  StockRealm _convertToRealmModel(Stock stock, {String? variantId}) {
    final stockRealm = StockRealm(stock.id);
    stockRealm.id = stock.id;
    stockRealm.tin = stock.tin;
    stockRealm.bhfId = stock.bhfId;
    stockRealm.branchId = stock.branchId;
    stockRealm.currentStock = stock.currentStock;
    stockRealm.lowStock = stock.lowStock;
    stockRealm.canTrackingStock = stock.canTrackingStock;
    stockRealm.showLowStockAlert = stock.showLowStockAlert;
    stockRealm.active = stock.active;
    stockRealm.value = stock.value;
    stockRealm.rsdQty = stock.rsdQty;
    stockRealm.lastTouched = stock.lastTouched?.toIso8601String();
    stockRealm.ebmSynced = stock.ebmSynced;
    stockRealm.initialStock = stock.initialStock;
    stockRealm.variantId = variantId;
    return stockRealm;
  }

  /// Helper method to convert StockRealm model to Stock model
  Stock _convertFromRealmModel(StockRealm stockRealm) {
    return Stock(
      id: stockRealm.id,
      tin: stockRealm.tin,
      bhfId: stockRealm.bhfId,
      branchId: stockRealm.branchId ?? 0,
      currentStock: stockRealm.currentStock,
      lowStock: stockRealm.lowStock,
      canTrackingStock: stockRealm.canTrackingStock,
      showLowStockAlert: stockRealm.showLowStockAlert,
      active: stockRealm.active,
      value: stockRealm.value,
      rsdQty: stockRealm.rsdQty,
      lastTouched: stockRealm.lastTouched != null 
          ? DateTime.parse(stockRealm.lastTouched!) 
          : null,
      ebmSynced: stockRealm.ebmSynced,
      initialStock: stockRealm.initialStock,
    );
  }

  /// Helper method to check if the cache is initialized
  void _checkInitialized() {
    if (!_isInitialized) {
      throw StateError('RealmStockCache not initialized. Call initialize() first.');
    }
  }
  
  /// Get stocks by variant ID
  Future<List<Stock>> getByVariantId(String variantId) async {
    return getAll(filter: {'variantId': variantId});
  }
  
  /// Get stocks by branch ID
  Future<List<Stock>> getByBranchId(int branchId) async {
    return getAll(filter: {'branchId': branchId});
  }
}
