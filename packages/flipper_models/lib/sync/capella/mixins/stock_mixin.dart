import 'dart:async';
import 'package:flipper_models/ebm_helper.dart';
import 'package:flipper_models/helper_models.dart';
import 'package:flipper_models/sync/interfaces/stock_interface.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:uuid/uuid.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:supabase_models/brick/repository.dart';
import 'package:talker/talker.dart';

mixin CapellaStockMixin implements StockInterface {
  Repository get repository;
  Talker get talker;
  DittoService get dittoService => DittoService.instance;

  @override
  Future<String> createStockRequest(
    List<TransactionItem> items, {
    required String mainBranchId,
    required String subBranchId,
    String? deliveryNote,
    String? orderNote,
    String? financingId,
  }) async {
    try {
      final String requestId = const Uuid().v4();
      final String? bhfId = await ProxyService.box.bhfId();
      int? tin = await effectiveTin(branchId: ProxyService.box.getBranchId()!);

      FinanceProvider? provider;
      if (financingId != null) {
        provider = (await repository.get<FinanceProvider>(
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
          query: Query(where: [Where('id').isExactly(financingId)]),
        )).firstOrNull;
      }

      final financing = Financing(
        id: provider?.id,
        provider: provider,
        requested: true,
        amount: items.fold(
          0,
          (previousValue, element) => previousValue! + element.price,
        ),
        status: 'pending',
        financeProviderId: provider?.id,
        approvalDate: DateTime.now().toUtc(),
      );

      // await repository.upsert(financing);

      final InventoryRequest request = InventoryRequest(
        id: requestId,
        mainBranchId: mainBranchId,
        subBranchId: subBranchId,
        financing: financing,
        createdAt: DateTime.now().toUtc(),
        status: RequestStatus.pending,
        deliveryNote: deliveryNote,
        orderNote: orderNote,
        bhfId: bhfId,
        tinNumber: tin!.toString(),
        branchId: (await ProxyService.strategy.activeBranch(
          branchId: ProxyService.box.getBranchId()!,
        )).id,
        financingId: financingId,
        itemCounts: items.length,
        transactionItems: items
            .map((item) => item.copyWith(inventoryRequestId: requestId))
            .toList(),
      );

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        throw Exception('Ditto not initialized:004');
      }

      final requestDoc = {
        '_id': request.id,
        'mainBranchId': request.mainBranchId,
        'subBranchId': request.subBranchId,
        'branchId': request.branchId,
        'createdAt': request.createdAt?.toIso8601String(),
        'status': request.status,
        'deliveryDate': request.deliveryDate?.toIso8601String(),
        'deliveryNote': request.deliveryNote,
        'orderNote': request.orderNote,
        'customerReceivedOrder': request.customerReceivedOrder,
        'driverRequestDeliveryConfirmation':
            request.driverRequestDeliveryConfirmation,
        'driverId': request.driverId,
        'updatedAt': request.updatedAt?.toIso8601String(),
        'itemCounts': request.itemCounts,
        'bhfId': request.bhfId,
        'tinNumber': request.tinNumber,
        'financingId': request.financingId,
        'transactionItems': request.transactionItems
            ?.map(
              (item) => {
                'id': item.id,
                'name': item.name,
                'qty': item.qty,
                'price': item.price,
                'discount': item.discount,
                'prc': item.prc,
                'ttCatCd': item.ttCatCd,
                'quantityRequested': item.qty,
                'quantityApproved': 0,
                'quantityShipped': 0,
                'transactionId': item.transactionId,
                'variantId': item.variantId,
                'inventoryRequestId': item.inventoryRequestId,
              },
            )
            .toList(),
      };

      await ditto.store.execute(
        '''
  INSERT INTO stock_requests
  DOCUMENTS (:request)
  ON ID CONFLICT DO UPDATE
  ''',
        arguments: {'request': requestDoc},
      );

      // update the items to have the request id
      for (var item in items) {
        await ditto.store.execute(
          'UPDATE transaction_items SET inventoryRequestId = :requestId WHERE _id = :id',
          arguments: {'requestId': requestId, 'id': item.id},
        );
      }

      return requestId;
    } catch (e) {
      talker.error('Error in createStockRequest: $e');
      rethrow;
    }
  }

  @override
  Future<Stock> getStockById({required String id}) async {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:3');
        throw Exception('Ditto not initialized:4');
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
        branchId: "",
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
        query: Query(where: [Where('id').isExactly(id)]),
      );
      if (stock.isNotEmpty) {
        //upsert this so it is saved into ditto next time
        repository.upsert<Stock>(stock.first);
        return stock.first;
      }
      talker.error('Error getting stock by ID: $e');
      // Return default stock for composite products that don't track inventory
      return Stock(
        branchId: "",
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
        talker.error('Ditto not initialized:5');
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
                final stockData = Map<String, dynamic>.from(
                  queryResult.items.first.value,
                );
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
        talker.error('Ditto not initialized:6');
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

      final existingData = Map<String, dynamic>.from(
        existingResult.items.first.value,
      );
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
  Future<Stock> saveStock({
    Variant? variant,
    required double rsdQty,
    required String productId,
    required String variantId,
    required String branchId,
    String? id,
    required double currentStock,
    required double value,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized:7');
    }
    final stockId = id ?? const Uuid().v4();
    final stock = Stock(
      id: stockId,
      rsdQty: rsdQty,
      branchId: branchId,
      currentStock: currentStock,
      value: value,
      active: true,
      lastTouched: DateTime.now().toUtc(),
      ebmSynced: false,
      initialStock: currentStock,
      showLowStockAlert: true,
      canTrackingStock: true,
      lowStock: 0,
    );
    // Ensure existing stock is synced
    await ditto.store.execute(
      "INSERT INTO stocks DOCUMENTS (:doc) ON ID CONFLICT DO REPLACE",
      arguments: {'doc': stock.toJson()},
    );
    await repository.upsert<Stock>(stock);
    return stock;
  }

  @override
  Future<List<InventoryRequest>> requests({required String requestId}) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      throw Exception('Ditto not initialized:7');
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

  @override
  Stream<List<InventoryRequest>> requestsStream({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized');
      return Stream.value([]);
    }

    final controller = StreamController<List<InventoryRequest>>.broadcast();
    dynamic observer;

    // Use a basic query for stock requests where we are the main branch (supplier)
    String query =
        'SELECT * FROM stock_requests WHERE mainBranchId = :branchId';
    final arguments = {'branchId': branchId, 'status': filter, 'limit': limit};

    // Add status filter if provided
    // When 'pending' is selected, include both 'pending' and 'processing' orders
    // so that orders in production remain visible (with modified UI)
    if (filter == RequestStatus.pending) {
      query +=
          " AND (status = '${RequestStatus.pending}' OR status = '${RequestStatus.processing}')";
    } else if (filter != 'all') {
      query += ' AND status = :status';
    }

    // Add ordering and limit
    query += ' ORDER BY createdAt DESC LIMIT :limit';

    // Register subscription
    ditto.sync.registerSubscription(query, arguments: arguments);

    observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) async {
        if (controller.isClosed) return;

        try {
          final requests = <InventoryRequest>[];
          for (final item in queryResult.items) {
            final data = Map<String, dynamic>.from(item.value);
            final request = _convertInventoryRequestFromDitto(data);

            // Fetch requester branch details (subBranchId)
            if (request.subBranchId != null) {
              // Ensure we subscribe to this branch data so it syncs to this device
              ditto.sync.registerSubscription(
                "SELECT * FROM branches WHERE _id = '${request.subBranchId}'",
              );

              talker.info(
                'Fetching branch details for subBranchId: ${request.subBranchId}',
              );
              final branchResult = await ditto.store.execute(
                'SELECT * FROM branches WHERE _id = :id',
                arguments: {'id': request.subBranchId},
              );

              if (branchResult.items.isNotEmpty) {
                talker.info('Branch found for ${request.subBranchId}');
                request.branch = Branch.fromMap(
                  Map<String, dynamic>.from(branchResult.items.first.value),
                );
              } else {
                talker.error('Branch NOT found for ${request.subBranchId}');
              }
            }
            requests.add(request);
          }
          controller.add(requests);
        } catch (e) {
          talker.error('Error processing requests stream: $e');
        }
      },
    );

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  @override
  Stream<List<InventoryRequest>> requestsStreamOutgoing({
    required String branchId,
    String filter = RequestStatus.pending,
    String? search,
    int limit = 50,
  }) {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized');
      return Stream.value([]);
    }

    final controller = StreamController<List<InventoryRequest>>.broadcast();
    dynamic observer;

    // Query for requests where we are the subBranch (requester)
    String query = 'SELECT * FROM stock_requests WHERE subBranchId = :branchId';
    // Note: 'status' isn't in arguments yet, need to add it conditionally or always
    final arguments = {'branchId': branchId, 'status': filter, 'limit': limit};

    // Add status filter if provided
    // When 'pending' is selected, include both 'pending' and 'processing' orders
    if (filter == RequestStatus.pending) {
      query +=
          " AND (status = '${RequestStatus.pending}' OR status = '${RequestStatus.processing}')";
    } else if (filter != 'all') {
      query += ' AND status = :status';
    }

    // Add ordering and limit
    query += ' ORDER BY createdAt DESC LIMIT :limit';

    // Register subscription
    ditto.sync.registerSubscription(query, arguments: arguments);

    observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) async {
        if (controller.isClosed) return;

        try {
          final requests = <InventoryRequest>[];
          for (final item in queryResult.items) {
            final data = Map<String, dynamic>.from(item.value);
            final request = _convertInventoryRequestFromDitto(data);

            // Fetch supplier branch details (mainBranchId)
            if (request.mainBranchId != null) {
              // Ensure subscription
              ditto.sync.registerSubscription(
                "SELECT * FROM branches WHERE _id = '${request.mainBranchId}'",
              );

              final branchResult = await ditto.store.execute(
                'SELECT * FROM branches WHERE _id = :id',
                arguments: {'id': request.mainBranchId},
              );

              if (branchResult.items.isNotEmpty) {
                request.branch = Branch.fromMap(
                  Map<String, dynamic>.from(branchResult.items.first.value),
                );
              }
            }
            requests.add(request);
          }
          controller.add(requests);
        } catch (e) {
          talker.error('Error processing outgoing requests stream: $e');
        }
      },
    );

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  InventoryRequest _convertInventoryRequestFromDitto(
    Map<String, dynamic> data,
  ) {
    // Parse transactionItems from embedded data
    List<TransactionItem>? items;
    if (data['transactionItems'] != null) {
      if (data['transactionItems'] is List) {
        talker.info(
          'Parsing ${data['transactionItems'].length} embedded items for Request ${data['_id']}',
        );
        try {
          items = (data['transactionItems'] as List).map((itemData) {
            final itemMap = Map<String, dynamic>.from(itemData);
            return TransactionItem(
              id: itemMap['id'],
              name: itemMap['name'],
              qty: (itemMap['qty'] as num?)?.toDouble() ?? 0.0,
              price: (itemMap['price'] as num?)?.toDouble() ?? 0.0,
              discount: (itemMap['discount'] as num?)?.toDouble() ?? 0.0,
              prc: (itemMap['prc'] as num?)?.toDouble() ?? 0.0,
              ttCatCd: itemMap['ttCatCd'],
              quantityRequested:
                  (itemMap['quantityRequested'] as num?)?.toInt() ?? 0,
              quantityApproved:
                  (itemMap['quantityApproved'] as num?)?.toInt() ?? 0,
              quantityShipped:
                  (itemMap['quantityShipped'] as num?)?.toInt() ?? 0,
              transactionId: itemMap['transactionId'],
              variantId: itemMap['variantId'],
              inventoryRequestId: itemMap['inventoryRequestId'],
            );
          }).toList();
        } catch (e) {
          talker.error('Error parsing embedded items: $e');
        }
      } else {
        talker.error(
          'transactionItems is not a List: ${data['transactionItems'].runtimeType}',
        );
      }
    } else {
      talker.warning('No transactionItems found in request ${data['_id']}');
    }

    return InventoryRequest(
      id: data['_id'] ?? data['id'],
      mainBranchId: data['mainBranchId'],
      subBranchId: data['subBranchId'],
      branchId: data['branchId'],
      createdAt: data['createdAt'] != null
          ? DateTime.tryParse(data['createdAt'])
          : null,
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
      updatedAt: data['updatedAt'] != null
          ? DateTime.tryParse(data['updatedAt'])
          : null,
      itemCounts: data['itemCounts'],
      bhfId: data['bhfId'],
      tinNumber: data['tinNumber'],
      financingId: data['financingId'],
      transactionItems: items,
      approvedBy: data['approvedBy'],
      approvedAt: data['approvedAt'] != null
          ? DateTime.tryParse(data['approvedAt'])
          : null,
    );
  }

  @override
  Stream<Stock?> watchStockByVariantId({required String stockId}) {
    try {
      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:8');
        return Stream.value(null);
      }

      final controller = StreamController<Stock?>.broadcast();
      dynamic observer;
      ditto.sync.registerSubscription(
        "SELECT * FROM stocks WHERE id = :id",
        arguments: {'id': stockId},
      );
      observer = ditto.store.registerObserver(
        'SELECT * FROM stocks WHERE id = :id',
        arguments: {'id': stockId},
        onChange: (queryResult) {
          if (controller.isClosed) return;

          if (queryResult.items.isNotEmpty) {
            final stockData = Map<String, dynamic>.from(
              queryResult.items.first.value,
            );
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

  @override
  FutureOr<void> updateStockRequest({
    required String stockRequestId,
    DateTime? updatedAt,
    String? status,
    String? approvedBy,
    DateTime? approvedAt,
    String? deliveryNote,
    String? orderNote,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized:9');
      return;
    }

    final updateData = <String, dynamic>{};
    if (updatedAt != null) {
      updateData['updatedAt'] = updatedAt.toIso8601String();
    }
    if (status != null) {
      updateData['status'] = status;
    }
    if (approvedBy != null) {
      updateData['approvedBy'] = approvedBy;
    }
    if (approvedAt != null) {
      updateData['approvedAt'] = approvedAt.toIso8601String();
    }
    if (deliveryNote != null) {
      updateData['deliveryNote'] = deliveryNote;
    }
    if (orderNote != null) {
      updateData['orderNote'] = orderNote;
    }

    if (updateData.isNotEmpty) {
      await ditto.store.execute(
        'UPDATE stock_requests SET ${updateData.keys.map((key) => '$key = :$key').join(', ')} WHERE _id = :id',
        arguments: {...updateData, 'id': stockRequestId},
      );
    }
  }

  @override
  Future<void> updateStockRequestItem({
    required String requestId,
    required String transactionItemId,
    int? quantityApproved,
    int? quantityRequested,
    bool? ignoreForReport,
  }) async {
    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized:10');
      throw Exception('Ditto not initialized:10');
    }

    try {
      // 1. Fetch the stock request
      final result = await ditto.store.execute(
        'SELECT * FROM stock_requests WHERE _id = :id',
        arguments: {'id': requestId},
      );

      if (result.items.isEmpty) {
        talker.error('Stock request not found: $requestId');
        return;
      }

      final requestData = Map<String, dynamic>.from(result.items.first.value);
      final List<dynamic> transactionItems = List.from(
        requestData['transactionItems'] ?? [],
      );

      bool itemFound = false;
      final updatedItems = transactionItems.map((item) {
        final itemMap = Map<String, dynamic>.from(item);
        if (itemMap['id'] == transactionItemId) {
          itemFound = true;
          if (quantityApproved != null) {
            itemMap['quantityApproved'] = quantityApproved;
          }
          if (quantityRequested != null) {
            itemMap['qty'] = quantityRequested;
            itemMap['quantityRequested'] = quantityRequested;
          }
        }
        return itemMap;
      }).toList();

      if (!itemFound) {
        talker.warning('Item not found in stock request: $transactionItemId');
        return;
      }

      // 2. Update stock request with modified items
      await ditto.store.execute(
        'UPDATE stock_requests SET transactionItems = :items WHERE _id = :id',
        arguments: {'items': updatedItems, 'id': requestId},
      );

      // 3. Update the actual transaction item in the table
      if (quantityRequested != null) {
        await ditto.store.execute(
          'UPDATE transaction_items SET qty = :qty, quantityRequested = :qty WHERE _id = :id',
          arguments: {'qty': quantityRequested, 'id': transactionItemId},
        );
      }
      if (quantityApproved != null) {
        await ditto.store.execute(
          'UPDATE transaction_items SET quantityApproved = :quantityApproved WHERE _id = :id',
          arguments: {
            'quantityApproved': quantityApproved,
            'id': transactionItemId,
          },
        );
      }
    } catch (e) {
      talker.error('Error updating stock request item: $e');
      rethrow;
    }
  }
}
