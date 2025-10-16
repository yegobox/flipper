import 'dart:async';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:talker/talker.dart';

mixin CapellaStockMixin implements StockInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Future<Stock> getStockById({required String id}) async {
    throw UnimplementedError(
        'getStockById needs to be implemented for Capella');
  }

  @override
  Future<Stock?> getStockByVariantId(String variantId) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return null;
      }

      final result = await ditto.store.execute(
        'SELECT * FROM stocks WHERE variantId = :variantId LIMIT 1',
        arguments: {'variantId': variantId},
      );

      if (result.items.isNotEmpty) {
        final stockData = Map<String, dynamic>.from(result.items.first.value);
        return _convertFromDittoDocument(stockData);
      }
      return null;
    } catch (e) {
      talker.error('Error getting stock by variant ID: $e');
      return null;
    }
  }

  /// Watch stock by ID and get updates as a stream
  Stream<Stock?> watchStockById(String id) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return Stream.value(null);
      }

      final controller = StreamController<Stock?>.broadcast();
      dynamic observer;

      observer = ditto.store.registerObserver(
        'SELECT * FROM stocks WHERE _id = :id',
        arguments: {'id': id},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          if (queryResult.items.isNotEmpty) {
            final stockData = Map<String, dynamic>.from(queryResult.items.first.value);
            final stock = _convertFromDittoDocument(stockData);
            controller.add(stock);
          } else {
            controller.add(null);
          }
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error watching stock by ID: $e');
      return Stream.value(null);
    }
  }

  /// Convert Ditto document to Stock model
  Stock _convertFromDittoDocument(Map<String, dynamic> data) {
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
  }

  @override
  Future<void> updateStock({
    required String stockId,
    double? qty,
    double? rsdQty,
    double? initialStock,
    bool? ebmSynced,
    double? currentStock,
    double? value,
    bool appending = false,
    DateTime? lastTouched,
  }) {
    throw UnimplementedError('updateStock needs to be implemented for Capella');
  }

  @override
  Future<Stock> saveStock(
      {Variant? variant,
      required double rsdQty,
      required String productId,
      required String variantId,
      required int branchId,
      required double currentStock,
      required double value}) {
    throw UnimplementedError('saveStock needs to be implemented for Capella');
  }

  @override
  Future<List<InventoryRequest>> requests({required String requestId}) async {
    throw UnimplementedError('requests needs to be implemented for Capella');
  }

  @override
  Stream<Stock?> watchStockByVariantId(String variantId) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return Stream.value(null);
      }

      final controller = StreamController<Stock?>.broadcast();
      dynamic observer;

      observer = ditto.store.registerObserver(
        'SELECT * FROM stocks WHERE variantId = :variantId',
        arguments: {'variantId': variantId},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          if (queryResult.items.isNotEmpty) {
            final stockData = Map<String, dynamic>.from(queryResult.items.first.value);
            final stock = _convertFromDittoDocument(stockData);
            controller.add(stock);
          } else {
            controller.add(null);
          }
        },
      );

      controller.onCancel = () async {
        await observer?.cancel();
        await controller.close();
      };

      return controller.stream;
    } catch (e) {
      talker.error('Error watching stock by variant ID: $e');
      return Stream.value(null);
    }
  }
}
