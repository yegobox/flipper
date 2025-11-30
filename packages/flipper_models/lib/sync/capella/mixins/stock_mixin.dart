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
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        throw Exception('Ditto not initialized');
      }
      final result = await ditto.store.execute(
        'SELECT * FROM stocks WHERE _id = :id LIMIT 1',
        arguments: {'id': id},
      );

      if (result.items.isNotEmpty) {
        final stockData = Map<String, dynamic>.from(result.items.first.value);
        return _convertFromDittoDocument(stockData);
      }
      // For composite products (services), return a default stock with zero values
      // since they don't track physical inventory
      return Stock(
        branchId: 1,
        id: id,
        currentStock: 0,
        lowStock: 0,
        canTrackingStock: false,
        showLowStockAlert: false,
        active: true,
        value: 0,
        rsdQty: 0,
        lastTouched: DateTime.now().toUtc(),
        ebmSynced: true,
        initialStock: 0,
      );
    } catch (e) {
      // find it in sqlite then update ditto to have it next time
      final stock = await repository.get<Stock>(
          query: Query(where: [
        Where('id').isExactly(id),
      ]));
      if (stock.isNotEmpty) {
        //upsert this so it is saved into ditto next time
        repository.upsert<Stock>(stock.first);
        return stock.first;
      }
      talker.error('Error getting stock by ID: $e');
      // Return default stock for composite products that don't track inventory
      return Stock(
        branchId: 1,
        id: id,
        currentStock: 0,
        lowStock: 0,
        canTrackingStock: false,
        showLowStockAlert: false,
        active: true,
        value: 0,
        rsdQty: 0,
        lastTouched: DateTime.now().toUtc(),
        ebmSynced: true,
        initialStock: 0,
      );
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

      // Initialize async to register subscription first
      () async {
        try {
          final query = 'SELECT * FROM stocks WHERE _id = :id';
          final arguments = {'id': id};

          // Subscribe to ensure we have the latest data from Ditto mesh
          await ditto.sync.registerSubscription(query, arguments: arguments);

          // Use registerObserver with initial data fetch
          final completer = Completer<Stock?>();
          observer = ditto.store.registerObserver(
            query,
            arguments: arguments,
            onChange: (queryResult) {
              if (controller.isClosed) return;

              if (queryResult.items.isNotEmpty) {
                final stockData =
                    Map<String, dynamic>.from(queryResult.items.first.value);
                final stock = _convertFromDittoDocument(stockData);

                // Complete on first data if not yet completed
                if (!completer.isCompleted) {
                  completer.complete(stock);
                }

                controller.add(stock);
              } else {
                if (!completer.isCompleted) {
                  completer.complete(null);
                }
                controller.add(null);
              }
            },
          );

          // Wait for initial data or timeout
          await completer.future.timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              if (!completer.isCompleted) {
                talker.warning('Timeout waiting for stock: $id');
                completer.complete(null);
              }
              return null;
            },
          );
        } catch (e) {
          talker.error('Error setting up stock observer: $e');
          controller.add(null);
        }
      }();

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
      currentStock: _parseDouble(data['currentStock']),
      lowStock: _parseDouble(data['lowStock']),
      canTrackingStock: data['canTrackingStock'],
      showLowStockAlert: data['showLowStockAlert'],
      active: data['active'],
      value: _parseDouble(data['value']),
      rsdQty: _parseDouble(data['rsdQty']),
      lastTouched: lastTouched,
      ebmSynced: data['ebmSynced'],
      initialStock: _parseDouble(data['initialStock']),
    );
  }

  double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
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
  }) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return;
      }

      // Get existing stock
      final existingResult = await ditto.store.execute(
        'SELECT * FROM stocks WHERE _id = :stockId LIMIT 1',
        arguments: {'stockId': stockId},
      );

      if (existingResult.items.isEmpty) {
        talker.error('Stock with ID $stockId not found');
        return;
      }

      final existingData =
          Map<String, dynamic>.from(existingResult.items.first.value);
      final updateData = <String, dynamic>{};

      // Handle appending vs replacing values
      if (currentStock != null) {
        updateData['currentStock'] = appending
            ? ((existingData['currentStock'] as num?)?.toDouble() ?? 0) +
                currentStock
            : currentStock;
      }
      if (rsdQty != null) {
        updateData['rsdQty'] = appending
            ? ((existingData['rsdQty'] as num?)?.toDouble() ?? 0) + rsdQty
            : rsdQty;
      }
      if (initialStock != null) {
        updateData['initialStock'] = appending
            ? ((existingData['initialStock'] as num?)?.toDouble() ?? 0) +
                initialStock
            : initialStock;
      }
      if (value != null) {
        updateData['value'] = value;
      }
      if (ebmSynced != null) {
        updateData['ebmSynced'] = ebmSynced;
      }
      if (lastTouched != null) {
        updateData['lastTouched'] = lastTouched.toIso8601String();
      }

      if (updateData.isNotEmpty) {
        await ditto.store.execute(
          'UPDATE stocks SET ${updateData.keys.map((key) => '$key = :$key').join(', ')} WHERE _id = :stockId',
          arguments: {...updateData, 'stockId': stockId},
        );
      }
    } catch (e) {
      talker.error('Error updating stock: $e');
      rethrow;
    }
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
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized');
    }

    final result = await ditto.store.execute(
      'SELECT * FROM stock_requests WHERE _id = :requestId',
      arguments: {'requestId': requestId},
    );

    return result.items.map((item) {
      final data = Map<String, dynamic>.from(item.value);
      return _convertInventoryRequestFromDitto(data);
    }).toList();
  }

  InventoryRequest _convertInventoryRequestFromDitto(
      Map<String, dynamic> data) {
    // Parse transactionItems from embedded data
    List<TransactionItem>? items;
    if (data['transactionItems'] != null && data['transactionItems'] is List) {
      items = (data['transactionItems'] as List).map((itemData) {
        final itemMap = Map<String, dynamic>.from(itemData);
        return TransactionItem(
          id: itemMap['id'],
          name: itemMap['name'],
          qty: itemMap['qty'] ?? 0,
          price: itemMap['price'] ?? 0,
          discount: itemMap['discount'] ?? 0,
          prc: itemMap['prc'] ?? 0,
          ttCatCd: itemMap['ttCatCd'],
          quantityRequested: itemMap['quantityRequested'],
          quantityApproved: itemMap['quantityApproved'],
          quantityShipped: itemMap['quantityShipped'],
          transactionId: itemMap['transactionId'],
          variantId: itemMap['variantId'],
          inventoryRequestId: itemMap['inventoryRequestId'],
        );
      }).toList();
    }

    return InventoryRequest(
      id: data['_id'] ?? data['id'],
      mainBranchId: data['mainBranchId'],
      subBranchId: data['subBranchId'],
      branchId: data['branchId'],
      createdAt:
          data['createdAt'] != null ? DateTime.tryParse(data['createdAt']) : null,
      status: data['status'],
      deliveryDate: data['deliveryDate'] != null
          ? DateTime.tryParse(data['deliveryDate'])
          : null,
      deliveryNote: data['deliveryNote'],
      orderNote: data['orderNote'],
      customerReceivedOrder: data['customerReceivedOrder'],
      driverRequestDeliveryConfirmation:
          data['driverRequestDeliveryConfirmation'],
      driverId: data['driverId'],
      updatedAt:
          data['updatedAt'] != null ? DateTime.tryParse(data['updatedAt']) : null,
      itemCounts: data['itemCounts'],
      bhfId: data['bhfId'],
      tinNumber: data['tinNumber'],
      financingId: data['financingId'],
      transactionItems: items,
    );
  }

  @override
  Stream<Stock?> watchStockByVariantId({required String stockId}) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized');
        return Stream.value(null);
      }

      final controller = StreamController<Stock?>.broadcast();
      dynamic observer;

      observer = ditto.store.registerObserver(
        'SELECT * FROM stocks WHERE id = :id',
        arguments: {'id': stockId},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          if (queryResult.items.isNotEmpty) {
            final stockData =
                Map<String, dynamic>.from(queryResult.items.first.value);
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
