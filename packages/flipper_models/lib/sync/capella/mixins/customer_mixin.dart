import 'dart:async';

import 'package:flipper_models/sync/interfaces/customer_interface.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/log_service.dart';
import 'package:talker/talker.dart';

mixin CapellaCustomerMixin implements CustomerInterface {
  DittoService get dittoService => DittoService.instance;
  Talker get talker;

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
            'userId': (ProxyService.box
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
              'userId': (ProxyService.box
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
        ditto.sync.registerSubscription(
          "SELECT * FROM customers WHERE branchId = :branchId",
          arguments: {'branchId': branchId},
        );
        ditto.store.registerObserver(
          "SELECT * FROM customers WHERE branchId = :branchId",
          arguments: {'branchId': branchId},
        );
      }

      /// end of workaround
      ///

      // Base query
      String query = 'SELECT * FROM customers WHERE 1=1';
      final arguments = <String, dynamic>{};

      // Add branch filter if provided
      if (branchId != null && branchId.isNotEmpty) {
        query += ' AND branchId = :branchId';
        arguments['branchId'] = branchId;
      }

      // Add ID filter if provided
      if (id != null && id.isNotEmpty) {
        query += ' AND id = :id';
        arguments['id'] = id;
      }

      // Add search filter if key is provided
      if (key != null && key.isNotEmpty) {
        final searchKey = '%$key%';
        query +=
            " AND (UPPER(custNm) LIKE UPPER(:searchKey) OR UPPER(email) LIKE UPPER(:searchKey) OR UPPER(telNo) LIKE UPPER(:searchKey))";
        arguments['searchKey'] = searchKey;
      }

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Prepared Ditto query',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
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
            'userId': (ProxyService.box
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
      await ditto.sync.registerSubscription(query, arguments: arguments);

      // Use registerObserver to wait for data
      final completer = Completer<List<dynamic>>();
      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Registering Ditto observer',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
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
                  'userId': (ProxyService.box
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
            'userId': (ProxyService.box
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
                    'userId': (ProxyService.box
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
            'userId': (ProxyService.box
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
          .map((doc) => Customer(
                id: doc.value['id']?.toString(),
                custNm: doc.value['custNm']?.toString(),
                email: doc.value['email']?.toString(),
                telNo: doc.value['telNo']?.toString(),
                adrs: doc.value['adrs']?.toString(),
                branchId: doc.value['branchId']?.toString(),
                updatedAt: doc.value['updatedAt'] != null
                    ? DateTime.tryParse(doc.value['updatedAt'].toString())
                    : null,
                custNo: doc.value['custNo']?.toString(),
                custTin: doc.value['custTin']?.toString(),
                regrNm: doc.value['regrNm']?.toString(),
                regrId: doc.value['regrId']?.toString(),
                modrNm: doc.value['modrNm']?.toString(),
                modrId: doc.value['modrId']?.toString(),
                ebmSynced: doc.value['ebmSynced'] as bool?,
                bhfId: doc.value['bhfId']?.toString(),
                useYn: doc.value['useYn']?.toString(),
                customerType: doc.value['customerType']?.toString(),
              ))
          .toList();

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully parsed ${customers.length} customers',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
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
            'userId': (ProxyService.box
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
              'userId': (ProxyService.box
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
      ditto.sync.registerSubscription(
        "SELECT * FROM customers",
      );
      ditto.store.registerObserver(
        "SELECT * FROM customers",
      );

      /// end of workaround
      ///

      String query = 'SELECT * FROM customers WHERE id = :id';
      final arguments = <String, dynamic>{'id': id};

      talker.info('Executing Ditto query: $query with args: $arguments');

      // Subscribe to ensure we have the latest data from Ditto mesh
      await ditto.sync.registerSubscription(query, arguments: arguments);

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
      final customer = Customer(
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

      if (ProxyService.box.getUserLoggingEnabled() ?? false) {
        await logService.logException(
          'Successfully fetched customer by ID',
          type: 'business_fetch',
          tags: {
            'userId': (ProxyService.box
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
}
