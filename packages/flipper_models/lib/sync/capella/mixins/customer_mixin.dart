import 'dart:async';

import 'package:flipper_models/sync/interfaces/customer_interface.dart';
import 'package:flipper_models/sync/dql_for_sync_subscription.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/log_service.dart';
import 'package:talker/talker.dart';

mixin CapellaCustomerMixin implements CustomerInterface {
  DittoService get dittoService => DittoService.instance;
  Talker get talker;

  Customer _customerFromDittoMap(Map<String, dynamic> item) {
    return Customer(
      id: item['id']?.toString(),
      custNm: item['custNm']?.toString(),
      email: item['email']?.toString(),
      telNo: item['telNo']?.toString(),
      adrs: item['adrs']?.toString(),
      branchId: item['branchId']?.toString(),
      updatedAt: item['updatedAt'] != null
          ? DateTime.tryParse(item['updatedAt'].toString())
          : null,
      custNo: item['custNo']?.toString(),
      custTin: item['custTin']?.toString(),
      regrNm: item['regrNm']?.toString(),
      regrId: item['regrId']?.toString(),
      modrNm: item['modrNm']?.toString(),
      modrId: item['modrId']?.toString(),
      ebmSynced: item['ebmSynced'] as bool?,
      bhfId: item['bhfId']?.toString(),
      useYn: item['useYn']?.toString(),
      customerType: item['customerType']?.toString(),
    );
  }

  @override
  Future<Customer?> addCustomer({
    required Customer customer,
    String? transactionId,
  }) async {
    throw UnimplementedError('addCustomer needs to be implemented for Capella');
  }

  /// Returns a list of customers filtered by [branchId], [key], and/or [id].
  ///
  /// - If [key] is provided and not empty:
  ///   - Performs case-insensitive search across 'custNm', 'email', and 'telNo' fields.
  ///   - Uses a single query with OR conditions for efficient searching.
  ///   - Filters by [branchId] and/or [id] if provided.
  /// - If [key] is not provided or empty:
  ///   - Filters by [id] and/or [branchId] if provided.
  ///   - If no filters are provided, returns an empty list.
  ///
  /// This method ensures efficient, case-insensitive customer search.
  @override
  FutureOr<List<Customer>> customers({
    String? branchId,
    String? key,
    String? id,
  }) async {
    final logService = LogService();
    try {
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting customers fetch',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customers',
            'branchId': branchId?.toString() ?? 'null',
            'id': id != null ? '***' : 'null',
            'key': key != null ? '***' : 'null',
          },
        );
      }

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:17');
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Ditto service not initialized',
            type: 'business_fetch',
            tags: {
              'userId':
                  (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'customers',
              'branchId': branchId?.toString() ?? 'null',
            },
          );
        }
        return [];
      }

      /// a work around to first register to whole data instead of subset
      /// this is because after test on new device, it can't pull data using complex query
      /// there is open issue on ditto https://support.ditto.live/hc/en-us/requests/2648?page=1
      ///
      if (branchId != null && branchId.isNotEmpty) {
        final preparedBranch =
            prepareDqlSyncSubscription("SELECT * FROM customers WHERE branchId = :branchId", {
          'branchId': branchId,
        });
        ditto.sync.registerSubscription(
          preparedBranch.dql,
          arguments: preparedBranch.arguments,
        );
      }

      /// end of workaround
      ///

      // Build SQL WHERE clause conditions
      final List<String> whereClauses = [];
      final arguments = <String, dynamic>{};

      // Add branch filter if provided
      if (branchId != null && branchId.isNotEmpty) {
        whereClauses.add('branchId = :branchId');
        arguments['branchId'] = branchId;
      }

      // Add ID filter if provided
      if (id != null && id.isNotEmpty) {
        whereClauses.add('id = :id');
        arguments['id'] = id;
      }

      // Add search filter if key is provided
      if (key != null && key.isNotEmpty) {
        final searchKey = '%$key%';
        whereClauses.add(
          "(UPPER(custNm) LIKE UPPER(:searchKey) OR UPPER(email) LIKE UPPER(:searchKey) OR UPPER(telNo) LIKE UPPER(:searchKey))",
        );
        arguments['searchKey'] = searchKey;
      }

      // If no filters are provided, return an empty list as per documentation
      if (whereClauses.isEmpty) {
        talker.info(
          'No filters provided for customers(), returning empty list',
        );
        return [];
      }

      final whereClause = whereClauses.join(' AND ');
      final query = 'SELECT * FROM customers WHERE $whereClause';

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Prepared Ditto query',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customers',
            'branchId': branchId?.toString() ?? 'null',
            'query_length': query.length.toString(),
            'arguments_keys': arguments.keys.join(','),
          },
        );
      }

      talker.info('Executing Ditto query: $query with args: $arguments');

      // Subscribe to ensure we have the latest data from Ditto mesh
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registering Ditto subscription',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customers',
            'branchId': branchId?.toString() ?? 'null',
          },
          extra: {'query_metadata': 'redacted', 'args_count': arguments.length},
        );
      }
      final preparedCustomers = prepareDqlSyncSubscription(query, arguments);
      await ditto.sync.registerSubscription(
        preparedCustomers.dql,
        arguments: preparedCustomers.arguments,
      );
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registering Ditto observer',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customers',
            'branchId': branchId?.toString() ?? 'null',
          },
          extra: {'query_metadata': 'redacted', 'args_count': arguments.length},
        );
      }
      final completer = Completer<List<dynamic>>();
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            final itemCount = result.items.length;
            // Complete the completer immediately to avoid hanging
            completer.complete(result.items.toList());
            // Log asynchronously without waiting for completion
            if (ProxyService.box.getUserLoggingEnabled() ?? false) {
              logService.logException(
                'Observer onChange triggered with $itemCount items',
                type: 'business_fetch',
                tags: {
                  'userId':
                      (ProxyService.box
                          .getUserId()
                          ?.toString()
                          .hashCode
                          .toString()) ??
                      'unknown',
                  'method': 'customers',
                  'branchId': branchId?.toString() ?? 'null',
                  'itemCount': itemCount.toString(),
                },
              );
            }
          }
        },
      );

      List<dynamic> items = [];
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Waiting for observer data',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customers',
            'branchId': branchId?.toString() ?? 'null',
          },
        );
      }
      try {
        // Wait for data or timeout
        items = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              talker.warning('Timeout waiting for customers list');
              if (ProxyService.box.getUserLoggingEnabled() ?? false) {
                logService.logException(
                  'Observer timeout waiting for customers',
                  type: 'business_fetch',
                  tags: {
                    'userId':
                        (ProxyService.box
                            .getUserId()
                            ?.toString()
                            .hashCode
                            .toString()) ??
                        'unknown',
                    'method': 'customers',
                    'branchId': branchId?.toString() ?? 'null',
                  },
                );
              }
              completer.complete([]);
            }
            return [];
          },
        );
      } finally {
        observer.cancel();
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Received ${items.length} items from observer',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customers',
            'branchId': branchId?.toString() ?? 'null',
            'itemsCount': items.length.toString(),
          },
        );
      }

      // Parse results
      final customers = items
          .map(
            (doc) => _customerFromDittoMap(
              Map<String, dynamic>.from(doc.value as Map),
            ),
          )
          .toList();

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully parsed ${customers.length} customers',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customers',
            'branchId': branchId?.toString() ?? 'null',
            'parsedCustomersCount': customers.length.toString(),
          },
        );
      }

      talker.info('Returning ${customers.length} customers');
      return customers;
    } catch (e, st) {
      talker.error('Error fetching customers from Ditto: $e\n$st');
      await logService.logException(
        'Failed to fetch customers from Ditto',
        stackTrace: st,
        type: 'business_fetch',
        tags: {
          'userId':
              (ProxyService.box.getUserId()?.toString().hashCode.toString()) ??
              'unknown',
          'method': 'customers',
          'error': e.toString(),
        },
      );
      return [];
    }
  }

  @override
  Future<Customer?> customerById(String id) async {
    final logService = LogService();
    try {
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Starting customerById fetch',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customerById',
            'id': '***',
          },
        );
      }

      final ditto = dittoService.dittoInstance;
      if (ditto == null) {
        talker.error('Ditto not initialized:18');
        if (ProxyService.box.getUserLoggingEnabled() ?? false) {
          await logService.logException(
            'Ditto service not initialized',
            type: 'business_fetch',
            tags: {
              'userId':
                  (ProxyService.box
                      .getUserId()
                      ?.toString()
                      .hashCode
                      .toString()) ??
                  'unknown',
              'method': 'customerById',
              'id': '***',
            },
          );
        }
        return null;
      }

      /// a work around to first register to whole data instead of subset
      /// this is because after test on new device, it can't pull data using complex query
      /// there is open issue on ditto https://support.ditto.live/hc/en-us/requests/2648?page=1
      ///
      final preparedAll =
          prepareDqlSyncSubscription("SELECT * FROM customers", null);
      ditto.sync.registerSubscription(
        preparedAll.dql,
        arguments: preparedAll.arguments,
      );

      /// end of workaround
      ///

      String query = 'SELECT * FROM customers WHERE id = :id';
      final arguments = <String, dynamic>{'id': id};

      talker.info('Executing Ditto query: $query with args: $arguments');

      // Subscribe to ensure we have the latest data from Ditto mesh
      final preparedById = prepareDqlSyncSubscription(query, arguments);
      await ditto.sync.registerSubscription(
        preparedById.dql,
        arguments: preparedById.arguments,
      );

      // Use registerObserver to wait for data
      final completer = Completer<List<dynamic>>();
      final observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (result) {
          if (!completer.isCompleted) {
            completer.complete(result.items.toList());
          }
        },
      );

      List<dynamic> items = [];
      try {
        // Wait for data or timeout
        items = await completer.future.timeout(
          const Duration(seconds: 10),
          onTimeout: () {
            if (!completer.isCompleted) {
              talker.warning('Timeout waiting for customer by ID');
              completer.complete([]);
            }
            return [];
          },
        );
      } finally {
        observer.cancel();
      }

      if (items.isEmpty) return null;

      final item = items.first.value;
      final customer = _customerFromDittoMap(
        Map<String, dynamic>.from(item as Map),
      );

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully fetched customer by ID',
          type: 'business_fetch',
          tags: {
            'userId':
                (ProxyService.box
                    .getUserId()
                    ?.toString()
                    .hashCode
                    .toString()) ??
                'unknown',
            'method': 'customerById',
            'id': '***',
          },
        );
      }

      return customer;
    } catch (e, st) {
      talker.error('Error fetching customer by ID from Ditto: $e\n$st');
      await logService.logException(
        'Failed to fetch customer by ID from Ditto',
        stackTrace: st,
        type: 'business_fetch',
        tags: {
          'userId':
              (ProxyService.box.getUserId()?.toString().hashCode.toString()) ??
              'unknown',
          'method': 'customerById',
          'error': e.toString(),
        },
      );
      return null;
    }
  }

  /// Live Ditto-backed customer list; matches [CoreSync.customersStream] cases.
  Stream<List<Customer>> customersStream({
    required String branchId,
    String? key,
    String? id,
  }) {
    if (key != null && key.isNotEmpty) {
      return Stream.fromFuture(
        Future(() async {
          final list = await customers(
            branchId: branchId,
            key: key,
            id: id,
          );
          return List<Customer>.from(list);
        }),
      );
    }

    final ditto = dittoService.dittoInstance;
    if (ditto == null) {
      talker.error('Ditto not initialized: customersStream');
      return Stream.value([]);
    }

    if (id != null && id.isNotEmpty) {
      final query = 'SELECT * FROM customers WHERE id = :id';
      final arguments = <String, dynamic>{'id': id};
      final prepared = prepareDqlSyncSubscription(query, arguments);
      final subscription = ditto.sync.registerSubscription(
        prepared.dql,
        arguments: prepared.arguments,
      );

      final controller = StreamController<List<Customer>>.broadcast();
      dynamic observer;

      void emitFromResult(dynamic queryResult) {
        if (controller.isClosed) return;
        final customers = <Customer>[];
        for (final doc in queryResult.items) {
          try {
            customers.add(
              _customerFromDittoMap(
                Map<String, dynamic>.from(doc.value as Map),
              ),
            );
          } catch (e) {
            talker.error('Error converting customer in stream: $e');
          }
        }
        controller.add(customers);
      }

      observer = ditto.store.registerObserver(
        query,
        arguments: arguments,
        onChange: (queryResult) => emitFromResult(queryResult),
      );

      ditto.store
          .execute(query, arguments: arguments)
          .then(emitFromResult)
          .catchError((Object e) {
            talker.error('Error seeding customers stream (by id): $e');
          });

      controller.onCancel = () async {
        await observer?.cancel();
        subscription.cancel();
        await controller.close();
      };

      return controller.stream;
    }

    if (branchId.isEmpty) {
      return Stream.value([]);
    }

    final preparedBranch = prepareDqlSyncSubscription(
      "SELECT * FROM customers WHERE branchId = :branchId",
      {'branchId': branchId},
    );
    ditto.sync.registerSubscription(
      preparedBranch.dql,
      arguments: preparedBranch.arguments,
    );

    final query = 'SELECT * FROM customers WHERE branchId = :branchId';
    final arguments = <String, dynamic>{'branchId': branchId};
    final prepared = prepareDqlSyncSubscription(query, arguments);
    final subscription = ditto.sync.registerSubscription(
      prepared.dql,
      arguments: prepared.arguments,
    );

    final controller = StreamController<List<Customer>>.broadcast();
    dynamic observer;

    void emitFromResult(dynamic queryResult) {
      if (controller.isClosed) return;
      final customers = <Customer>[];
      for (final doc in queryResult.items) {
        try {
          customers.add(
            _customerFromDittoMap(
              Map<String, dynamic>.from(doc.value as Map),
            ),
          );
        } catch (e) {
          talker.error('Error converting customer in stream: $e');
        }
      }
      controller.add(customers);
    }

    observer = ditto.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) => emitFromResult(queryResult),
    );

    ditto.store
        .execute(query, arguments: arguments)
        .then(emitFromResult)
        .catchError((Object e) {
          talker.error('Error seeding customers stream: $e');
        });

    controller.onCancel = () async {
      await observer?.cancel();
      subscription.cancel();
      await controller.close();
    };

    return controller.stream;
  }
}
