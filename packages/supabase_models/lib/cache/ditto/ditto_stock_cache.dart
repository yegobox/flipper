import 'dart:async';
import 'package:ditto_live/ditto_live.dart';
import 'package:supabase_models/brick/models/stock.model.dart';
import 'package:supabase_models/cache/cache_layer.dart';
import 'package:flipper_web/services/ditto_service.dart';

/// Ditto implementation of CacheLayer for Stock objects
class DittoStockCache implements CacheLayer<Stock> {
  Ditto? _ditto;
  bool _isInitialized = false;

  /// Singleton instance
  static final DittoStockCache _instance = DittoStockCache._internal();

  /// Factory constructor to return the singleton instance
  factory DittoStockCache() => _instance;

  /// Private constructor for singleton pattern
  DittoStockCache._internal();

  @override
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Get Ditto instance from DittoService
    _ditto = DittoService.instance.dittoInstance;
    _isInitialized = true;
  }

  /// Set the Ditto instance (called from external initialization)
  void setDitto(Ditto ditto) {
    _ditto = ditto;
  }

  /// Ensure the Ditto instance is initialized
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

      if (_ditto == null) {
        throw StateError('Ditto not initialized. Call setDitto() first.');
      }

      // Use DQL INSERT syntax to insert/update document
      await _ditto!.store.execute(
        "INSERT INTO stocks DOCUMENTS (:stock) ON ID CONFLICT DO UPDATE",
        arguments: {
          "stock": {"_id": stock.id, ..._stockToJson(stock)},
        },
      );
    } catch (e) {
      print('Error saving stock to Ditto cache: $e');
      rethrow;
    }
  }

  /// Save a stock with an associated variant ID
  Future<void> saveWithVariantId(Stock stock, String variantId) async {
    try {
      await _ensureInitialized();

      if (_ditto == null) {
        throw StateError('Ditto not initialized. Call setDitto() first.');
      }

      // Include variantId in the document
      final stockData = _stockToJson(stock);
      stockData['variantId'] = variantId;

      await _ditto!.store.execute(
        "INSERT INTO stocks DOCUMENTS (:stock) ON ID CONFLICT DO UPDATE",
        arguments: {
          "stock": {"_id": stock.id, ...stockData},
        },
      );
    } catch (e) {
      print('Error saving stock with variant ID to Ditto cache: $e');
      rethrow;
    }
  }

  @override
  Future<void> saveAll(List<Stock> stocks) async {
    try {
      await _ensureInitialized();

      if (_ditto == null) {
        throw StateError('Ditto not initialized. Call setDitto() first.');
      }

      // Process each stock individually
      for (final stock in stocks) {
        if (stock.id.isNotEmpty) {
          await save(stock);
        }
      }
    } catch (e) {
      print('Error saving stocks to Ditto cache: $e');
      rethrow;
    }
  }

  @override
  Future<Stock?> get(String id) async {
    try {
      await _ensureInitialized();

      if (_ditto == null) {
        throw StateError('Ditto not initialized. Call setDitto() first.');
      }

      // Use DQL to get a single document by ID
      final result = await _ditto!.store.execute(
        "SELECT * FROM stocks WHERE _id = :id",
        arguments: {"id": id},
      );

      if (result.items.isEmpty) {
        return null;
      }

      return _convertFromDittoDocument(result.items.first.value);
    } catch (e) {
      print('Error getting stock from Ditto cache: $e');
      return null;
    }
  }

  @override
  Future<List<Stock>> getAll({Map<String, dynamic>? filter}) async {
    try {
      await _ensureInitialized();

      if (_ditto == null) {
        throw StateError('Ditto not initialized. Call setDitto() first.');
      }

      String query = "SELECT * FROM stocks";
      final arguments = <String, dynamic>{};

      if (filter != null) {
        if (filter.containsKey('variantId')) {
          query += " WHERE variantId = :variantId";
          arguments["variantId"] = filter['variantId'];
        } else if (filter.containsKey('branchId')) {
          query += " WHERE branchId = :branchId";
          arguments["branchId"] = filter['branchId'];
        }
      }

      final result = await _ditto!.store.execute(query, arguments: arguments);

      return result.items
          .map((doc) => _convertFromDittoDocument(doc.value))
          .whereType<Stock>()
          .toList();
    } catch (e) {
      print('Error getting all stocks from Ditto cache: $e');
      return [];
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _ensureInitialized();

      if (_ditto == null) {
        throw StateError('Ditto not initialized. Call setDitto() first.');
      }

      // Remove all documents from stocks collection
      await _ditto!.store.execute("REMOVE FROM COLLECTION stocks");
    } catch (e) {
      print('Error clearing stocks from Ditto cache: $e');
      rethrow;
    }
  }

  @override
  Future<void> close() async {
    // Ditto instance is managed externally, so we don't close it here
    _isInitialized = false;
  }

  /// Helper method to check if the cache is initialized
  void _checkInitialized() {
    if (!_isInitialized || _ditto == null) {
      throw StateError(
          'DittoStockCache not initialized. Call initialize() and setDitto() first.');
    }
  }

  /// Convert Ditto document to Stock model
  Stock _convertFromDittoDocument(dynamic doc) {
    try {
      final Map<String, dynamic> data = Map<String, dynamic>.from(doc);

      // Handle DateTime parsing for lastTouched
      DateTime? lastTouched;
      if (data['lastTouched'] != null) {
        if (data['lastTouched'] is String) {
          lastTouched = DateTime.parse(data['lastTouched']);
        } else {
          lastTouched = data['lastTouched'];
        }
      }

      return Stock(
        id: data['_id'] ?? data['id'],
        tin: data['tin'],
        bhfId: data['bhfId'],
        branchId: data['branchId'],
        currentStock: (data['currentStock'] as num?)?.toDouble(),
        lowStock: (data['lowStock'] as num?)?.toDouble(),
        canTrackingStock: data['canTrackingStock'],
        showLowStockAlert: data['showLowStockAlert'],
        active: data['active'],
        value: (data['value'] as num?)?.toDouble(),
        rsdQty: (data['rsdQty'] as num?)?.toDouble(),
        lastTouched: lastTouched,
        ebmSynced: data['ebmSynced'],
        initialStock: (data['initialStock'] as num?)?.toDouble(),
      );
    } catch (e) {
      print('Error converting Ditto document to Stock: $e');
      rethrow;
    }
  }

  /// Get stocks by variant ID
  Future<List<Stock>> getByVariantId(String variantId) async {
    return getAll(filter: {'variantId': variantId});
  }

  /// Get a single stock by variant ID
  Future<Stock?> getByVariantIdSingle(String variantId) async {
    final stocks = await getByVariantId(variantId);
    return stocks.isNotEmpty ? stocks.first : null;
  }

  /// Watch a stock by variant ID and get updates as a stream
  Stream<Stock?> watchByVariantId(String variantId) {
    if (_ditto == null) {
      return Stream.value(null);
    }

    final controller = StreamController<Stock?>.broadcast();

    final observer = _ditto!.store.registerObserver(
      "SELECT * FROM stocks WHERE variantId = :variantId",
      arguments: {"variantId": variantId},
      onChange: (queryResult) {
        if (queryResult.items.isNotEmpty) {
          final stock =
              _convertFromDittoDocument(queryResult.items.first.value);
          controller.add(stock);
        } else {
          controller.add(null);
        }
      },
    );

    // Handle stream cancellation
    controller.onCancel = () {
      observer.cancel();
      controller.close();
    };

    return controller.stream;
  }

  /// Get stocks by branch ID
  Future<List<Stock>> getByBranchId(int branchId) async {
    return getAll(filter: {'branchId': branchId});
  }

  /// Convert Stock to JSON Map
  Map<String, dynamic> _stockToJson(Stock stock) {
    return {
      'id': stock.id,
      'tin': stock.tin,
      'bhfId': stock.bhfId,
      'branchId': stock.branchId,
      'currentStock': stock.currentStock,
      'lowStock': stock.lowStock,
      'canTrackingStock': stock.canTrackingStock,
      'showLowStockAlert': stock.showLowStockAlert,
      'active': stock.active,
      'value': stock.value,
      'rsdQty': stock.rsdQty,
      'lastTouched': stock.lastTouched?.toIso8601String(),
      'ebmSynced': stock.ebmSynced,
      'initialStock': stock.initialStock,
    };
  }
}
