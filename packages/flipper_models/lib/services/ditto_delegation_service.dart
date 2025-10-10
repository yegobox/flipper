import 'dart:async';
import 'package:ditto_live/ditto_live.dart';
import 'package:flutter/foundation.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flipper_services/proxy.dart';

/// Service for managing transaction delegation between mobile and desktop devices
/// using Ditto for real-time cross-device sync
class DittoDelegationService {
  static const String _collectionName = 'transaction_delegations';

  Ditto? _ditto;
  dynamic _observer;
  StreamController<List<Map<String, dynamic>>>? _delegationsController;
  bool _isInitialized = false;

  /// Singleton instance
  static final DittoDelegationService _instance =
      DittoDelegationService._internal();

  /// Factory constructor to return the singleton instance
  factory DittoDelegationService() => _instance;

  /// Private constructor for singleton pattern
  DittoDelegationService._internal();

  /// Initialize the service with Ditto instance from DittoService
  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('⚠️  DittoDelegationService already initialized, skipping');
      return;
    }

    try {
      // Register listener to get Ditto instance when it becomes available
      DittoService.instance.addDittoListener(_onDittoChanged);

      // Try to get existing Ditto instance
      _ditto = DittoService.instance.dittoInstance;

      if (_ditto != null) {
        _isInitialized = true;
        debugPrint(
            '✅ DittoDelegationService initialized with device: ${_ditto!.deviceName}');
      } else {
        debugPrint('⏳ DittoDelegationService waiting for Ditto instance...');
      }
    } catch (e) {
      debugPrint('❌ Error initializing DittoDelegationService: $e');
      rethrow;
    }
  }

  /// Callback when Ditto instance changes in DittoService
  void _onDittoChanged(Ditto? newDitto) {
    if (newDitto != null && _ditto != newDitto) {
      setDitto(newDitto);
    }
  }

  /// Set the Ditto instance directly (alternative initialization method)
  void setDitto(Ditto ditto) {
    _ditto = ditto;
    _isInitialized = true;
    debugPrint(
        '✅ DittoDelegationService Ditto instance set: ${ditto.deviceName}');
  }

  /// Check if the service is ready to use
  bool isReady() {
    return _ditto != null;
  }

  /// Mobile: Create a new delegation request
  /// This saves the delegation to Ditto, which automatically syncs to desktop
  Future<void> createDelegation({
    required String transactionId,
    required int branchId,
    required String receiptType,
    String? customerName,
    String? customerTin,
    String? customerBhfId,
    bool isAutoPrint = false,
    double? subTotal,
    String? paymentType,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      if (_ditto == null) {
        debugPrint('❌ Ditto not initialized, cannot create delegation');
        return;
      }

      final deviceId = _ditto!.deviceName;
      final now = DateTime.now().toIso8601String();

      final delegationData = {
        '_id': transactionId,
        'transactionId': transactionId,
        'branchId': branchId,
        'status': 'delegated',
        'receiptType': receiptType,
        'delegatedAt': now,
        'delegatedFromDevice': deviceId,
        'customerName': customerName,
        'customerTin': customerTin,
        'customerBhfId': customerBhfId,
        'isAutoPrint': isAutoPrint,
        'subTotal': subTotal,
        'paymentType': paymentType,
        'updatedAt': now,
        ...?additionalData,
      };

      // Use DQL INSERT with conflict resolution (upsert)
      await _ditto!.store.execute(
        "INSERT INTO $_collectionName DOCUMENTS (:delegation) ON ID CONFLICT DO UPDATE",
        arguments: {
          "delegation": delegationData,
        },
      );

      debugPrint(
          '✅ Delegation created in Ditto: $transactionId (status: delegated)');
      debugPrint(
          '   Branch: $branchId, Receipt: $receiptType, Device: $deviceId');
    } catch (e) {
      debugPrint('❌ Error creating delegation: $e');
      rethrow;
    }
  }

  /// Desktop: Start monitoring for new delegations in real-time
  /// Uses Ditto's observer pattern for instant notifications
  void startMonitoring({
    required int branchId,
    required Function(Map<String, dynamic>) onNewDelegation,
  }) {
    try {
      if (_ditto == null) {
        debugPrint('❌ Ditto not initialized, cannot start monitoring');
        return;
      }

      // Query for delegations in this branch with status 'delegated'
      final query =
          "SELECT * FROM $_collectionName WHERE branchId = :branchId AND status = :status ORDER BY delegatedAt DESC";

      _delegationsController =
          StreamController<List<Map<String, dynamic>>>.broadcast();

      // Register observer for real-time updates
      _observer = _ditto!.store.registerObserver(
        query,
        arguments: {
          "branchId": branchId,
          "status": "delegated",
        },
        onChange: (queryResult) {
          if (_delegationsController?.isClosed ?? true) {
            return;
          }

          final delegations = queryResult.items
              .map((doc) => Map<String, dynamic>.from(doc.value))
              .toList();

          // Notify about each new delegation
          for (final delegation in delegations) {
            debugPrint(
                '🔔 Desktop received delegation: ${delegation['transactionId']}');
            ProxyService.notification.sendLocalNotification(
                body: "Received new Request for processing");
            onNewDelegation(delegation);
          }

          _delegationsController!.add(delegations);
        },
      );

      debugPrint('✅ Desktop monitoring delegations for branch: $branchId');
      debugPrint('   Waiting for mobile devices to delegate transactions...');
    } catch (e) {
      debugPrint('❌ Error starting delegation monitoring: $e');
    }
  }

  /// Stop monitoring for delegations
  Future<void> stopMonitoring() async {
    try {
      if (_observer != null) {
        await _observer?.cancel();
        _observer = null;
      }

      if (_delegationsController != null && !_delegationsController!.isClosed) {
        await _delegationsController!.close();
        _delegationsController = null;
      }

      debugPrint('✅ Stopped delegation monitoring');
    } catch (e) {
      debugPrint('❌ Error stopping delegation monitoring: $e');
    }
  }

  /// Update delegation status (used by both mobile and desktop)
  /// Status flow: delegated → processing → completed (or error)
  Future<void> updateDelegationStatus({
    required String transactionId,
    required String status,
    String? processingDevice,
    String? errorMessage,
    String? completedAt,
  }) async {
    try {
      if (_ditto == null) {
        debugPrint('❌ Ditto not initialized, cannot update delegation status');
        return;
      }

      final now = DateTime.now().toIso8601String();
      final updateData = <String, dynamic>{
        'status': status,
        'updatedAt': now,
      };

      if (processingDevice != null) {
        updateData['processingDevice'] = processingDevice;
      }

      if (errorMessage != null) {
        updateData['errorMessage'] = errorMessage;
      }

      if (completedAt != null) {
        updateData['completedAt'] = completedAt;
      }

      // Build UPDATE query dynamically
      final setFields = updateData.keys.map((key) => '$key = :$key').join(', ');
      final query =
          "UPDATE $_collectionName SET $setFields WHERE _id = :transactionId";

      await _ditto!.store.execute(
        query,
        arguments: {
          'transactionId': transactionId,
          ...updateData,
        },
      );

      debugPrint('✅ Delegation status updated: $transactionId → $status');
      if (processingDevice != null) {
        debugPrint('   Processing device: $processingDevice');
      }
    } catch (e) {
      debugPrint('❌ Error updating delegation status: $e');
      rethrow;
    }
  }

  /// Get current delegation status (used by mobile to check progress)
  Future<String?> getDelegationStatus(String transactionId) async {
    try {
      if (_ditto == null) {
        debugPrint('❌ Ditto not initialized, cannot get delegation status');
        return null;
      }

      final result = await _ditto!.store.execute(
        "SELECT status FROM $_collectionName WHERE _id = :transactionId",
        arguments: {"transactionId": transactionId},
      );

      if (result.items.isEmpty) {
        debugPrint('ℹ️  No delegation found for transaction: $transactionId');
        return null;
      }

      final status = result.items.first.value['status'] as String?;
      debugPrint('ℹ️  Delegation status for $transactionId: $status');
      return status;
    } catch (e) {
      debugPrint('❌ Error getting delegation status: $e');
      return null;
    }
  }

  /// Get full delegation data
  Future<Map<String, dynamic>?> getDelegation(String transactionId) async {
    try {
      if (_ditto == null) {
        debugPrint('❌ Ditto not initialized, cannot get delegation');
        return null;
      }

      final result = await _ditto!.store.execute(
        "SELECT * FROM $_collectionName WHERE _id = :transactionId",
        arguments: {"transactionId": transactionId},
      );

      if (result.items.isEmpty) {
        return null;
      }

      return Map<String, dynamic>.from(result.items.first.value);
    } catch (e) {
      debugPrint('❌ Error getting delegation: $e');
      return null;
    }
  }

  /// Get all delegations for a branch (useful for debugging/admin)
  Future<List<Map<String, dynamic>>> getDelegationsForBranch({
    required int branchId,
    String? status,
  }) async {
    try {
      if (_ditto == null) {
        debugPrint('❌ Ditto not initialized, cannot get delegations');
        return [];
      }

      String query =
          "SELECT * FROM $_collectionName WHERE branchId = :branchId";
      final arguments = <String, dynamic>{"branchId": branchId};

      if (status != null) {
        query += " AND status = :status";
        arguments["status"] = status;
      }

      query += " ORDER BY delegatedAt DESC";

      final result = await _ditto!.store.execute(query, arguments: arguments);

      return result.items
          .map((doc) => Map<String, dynamic>.from(doc.value))
          .toList();
    } catch (e) {
      debugPrint('❌ Error getting delegations for branch: $e');
      return [];
    }
  }

  /// Delete a delegation (cleanup after processing)
  Future<void> deleteDelegation(String transactionId) async {
    try {
      if (_ditto == null) {
        debugPrint('❌ Ditto not initialized, cannot delete delegation');
        return;
      }

      // Use EVICT instead of REMOVE FROM COLLECTION for DQL compatibility
      await _ditto!.store.execute(
        "EVICT FROM $_collectionName WHERE _id = :transactionId",
        arguments: {"transactionId": transactionId},
      );

      debugPrint('✅ Delegation deleted: $transactionId');
    } catch (e) {
      debugPrint('❌ Error deleting delegation: $e');
    }
  }

  /// Get current device ID
  String? getDeviceId() {
    return _ditto?.deviceName;
  }

  /// Observe delegations stream (alternative to callback-based monitoring)
  Stream<List<Map<String, dynamic>>> observeDelegations({
    required int branchId,
    String? status,
  }) {
    if (_ditto == null) {
      return Stream.value([]);
    }

    String query = "SELECT * FROM $_collectionName WHERE branchId = :branchId";
    final arguments = <String, dynamic>{"branchId": branchId};

    if (status != null) {
      query += " AND status = :status";
      arguments["status"] = status;
    }

    query += " ORDER BY delegatedAt DESC";

    final controller = StreamController<List<Map<String, dynamic>>>.broadcast();
    dynamic observer;

    observer = _ditto!.store.registerObserver(
      query,
      arguments: arguments,
      onChange: (queryResult) {
        if (controller.isClosed) {
          return;
        }

        final delegations = queryResult.items
            .map((doc) => Map<String, dynamic>.from(doc.value))
            .toList();

        controller.add(delegations);
      },
    );

    controller.onCancel = () async {
      await observer?.cancel();
      await controller.close();
    };

    return controller.stream;
  }

  /// Dispose resources
  Future<void> dispose() async {
    // Remove Ditto listener
    DittoService.instance.removeDittoListener(_onDittoChanged);

    // Stop monitoring
    await stopMonitoring();

    // Close stream controller
    await _delegationsController?.close();

    // Clear observer
    _observer = null;

    // Clear Ditto reference
    _ditto = null;
    _isInitialized = false;

    debugPrint('✅ DittoDelegationService disposed');
  }
}
