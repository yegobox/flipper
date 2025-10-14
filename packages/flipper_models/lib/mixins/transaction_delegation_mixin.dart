import 'dart:io';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/services/ditto_delegation_service.dart';
import 'package:flutter/foundation.dart';

/// Status values for transaction delegation
enum TransactionDelegationStatus {
  /// Transaction is pending delegation
  pending('pending'),

  /// Transaction has been delegated to desktop for processing
  delegated('delegated'),

  /// Desktop is currently processing the transaction
  processing('processing'),

  /// Desktop has completed processing (receipt printed)
  completed('completed'),

  /// An error occurred during processing
  error('error'),

  /// Transaction was cancelled
  cancelled('cancelled');

  final String value;
  const TransactionDelegationStatus(this.value);

  static TransactionDelegationStatus fromString(String value) {
    return TransactionDelegationStatus.values.firstWhere(
      (status) => status.value == value,
      orElse: () => TransactionDelegationStatus.pending,
    );
  }
}

/// Mixin to handle transaction delegation from mobile to desktop
/// This allows mobile devices to offload receipt printing and EBM
/// server communication to desktop machines via Ditto sync
mixin TransactionDelegationMixin {
  // Ditto delegation service singleton
  final DittoDelegationService _delegationService = DittoDelegationService();

  // Timeout and retry configuration
  static const Duration _delegationTimeout = Duration(minutes: 5);
  static const int _maxRetries = 3;
  static const Duration _retryDelay = Duration(seconds: 30);

  /// Helper method to ensure delegation service is ready
  /// Automatically initializes and waits for Ditto connection
  Future<bool> _ensureDelegationServiceReady({int maxRetries = 10}) async {
    if (_delegationService.isReady()) {
      return true;
    }

    debugPrint('⏳ Ensuring delegation service is ready...');
    await _delegationService.initialize();

    var retries = 0;
    while (!_delegationService.isReady() && retries < maxRetries) {
      await Future.delayed(const Duration(milliseconds: 500));
      retries++;
    }

    final isReady = _delegationService.isReady();
    if (!isReady) {
      debugPrint('❌ Delegation service not ready after $maxRetries retries');
    }

    return isReady;
  }

  /// Initialize the delegation service
  /// Note: This is now optional as methods will auto-initialize if needed
  Future<void> initializeDelegation() async {
    final isReady = await _ensureDelegationServiceReady(maxRetries: 20);

    if (isReady) {
      debugPrint('✅ Transaction delegation initialized');
    } else {
      debugPrint(
          '⚠️  Transaction delegation initialized but Ditto not ready yet');
      debugPrint('   Service will auto-connect when Ditto becomes available');
    }
  }

  /// Mobile: Check delegation status for a transaction
  /// Returns current status: delegated, processing, completed, error, etc.
  Future<TransactionDelegationStatus?> checkDelegationStatus(
      String transactionId) async {
    try {
      if (!await _ensureDelegationServiceReady(maxRetries: 5)) {
        debugPrint('⚠️  Delegation service not ready');
        return null;
      }

      final statusStr =
          await _delegationService.getDelegationStatus(transactionId);

      if (statusStr == null) {
        debugPrint('ℹ️  No delegation found for transaction: $transactionId');
        return null;
      }

      final status = TransactionDelegationStatus.fromString(statusStr);
      debugPrint('ℹ️  Delegation status for $transactionId: ${status.value}');
      return status;
    } catch (e) {
      debugPrint('❌ Error checking delegation status: $e');
      return null;
    }
  }

  /// Mobile: Get full delegation data for a transaction
  Future<Map<String, dynamic>?> getDelegationData(String transactionId) async {
    try {
      if (!await _ensureDelegationServiceReady(maxRetries: 5)) {
        return null;
      }

      return await _delegationService.getDelegation(transactionId);
    } catch (e) {
      debugPrint('❌ Error getting delegation data: $e');
      return null;
    }
  }

  /// Check if the current device can handle EBM operations
  /// Desktop (Windows, macOS, Linux) can handle EBM, mobile typically cannot
  bool get canHandleEBMOperations {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return true;
    }
    return false;
  }

  /// Check if the current device is mobile
  bool get isMobileDevice {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Check if transaction delegation is enabled for this business/branch
  Future<bool> isDelegationEnabled() async {
    // Check if feature is enabled in settings
    final enabled = ProxyService.box.readBool(
      key: 'enableTransactionDelegation',
    );
    return enabled ?? false;
  }

  /// Mark a transaction for desktop processing
  /// This is called by mobile when it cannot complete the transaction locally
  Future<void> delegateTransactionToDesktop({
    required ITransaction transaction,
    required String receiptType,
    String? purchaseCode,
    required String salesSttsCd,
    int? originalInvoiceNumber,
    String? sarTyCd,
    List<TransactionItem>? items,
  }) async {
    try {
      // Ensure delegation service is initialized and ready
      if (!await _ensureDelegationServiceReady(maxRetries: 10)) {
        throw Exception(
            'Delegation service could not connect to Ditto. Please ensure Ditto is running and try again.');
      }

      // Create delegation in Ditto (syncs automatically to desktop)
      await _delegationService.createDelegation(
        transactionId: transaction.id,
        branchId: transaction.branchId!,
        receiptType: receiptType,
        customerName: transaction.customerName,
        customerTin: transaction.customerTin,
        customerBhfId: transaction.customerBhfId,
        isAutoPrint: ProxyService.box.isAutoPrintEnabled(),
        subTotal: transaction.subTotal,
        paymentType: transaction.paymentType,
        additionalData: {
          'salesSttsCd': salesSttsCd,
          'purchaseCode': purchaseCode,
          'originalInvoiceNumber': originalInvoiceNumber,
          'sarTyCd': sarTyCd,
          'businessId': ProxyService.box.getBusinessId(),
          'items': items?.map((item) => item.id).toList() ?? [],
        },
      );

      // Also save locally for UI status tracking
      await ProxyService.box.writeString(
        key: 'local_delegation_status_${transaction.id}',
        value: TransactionDelegationStatus.delegated.value,
      );

      // Update transaction with delegation flag
      await _markTransactionAsDelegated(transaction);

      debugPrint('✅ Transaction delegated to desktop: ${transaction.id}');
      debugPrint(
          '   Receipt type: $receiptType, Branch: ${transaction.branchId}');
    } catch (e) {
      debugPrint('❌ Error delegating transaction: $e');
      rethrow;
    }
  }

  /// Desktop: Start real-time monitoring for delegated transactions
  /// This runs on desktop devices to watch for transactions that need processing
  Future<void> startMonitoringDelegations() async {
    if (!canHandleEBMOperations) {
      debugPrint('⚠️  Not a desktop device, skipping delegation monitoring');
      return; // Only desktop should monitor
    }

    if (!await isDelegationEnabled()) {
      debugPrint('⚠️  Transaction delegation not enabled');
      return; // Feature not enabled
    }

    // Ensure delegation service is ready
    if (!await _ensureDelegationServiceReady(maxRetries: 20)) {
      debugPrint('❌ Delegation service not ready after initialization');
      return;
    }

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      debugPrint('❌ No branch ID found');
      return;
    }

    // Start real-time monitoring using Ditto observers
    _delegationService.startMonitoring(
      branchId: branchId,
      onNewDelegation: (delegationData) async {
        await _handleNewDelegation(delegationData);
      },
    );

    debugPrint(
        '✅ Desktop now monitoring for delegated transactions (branch: $branchId)');
  }

  /// Stop monitoring for delegations (cleanup)
  Future<void> stopMonitoringDelegations() async {
    await _delegationService.stopMonitoring();
    debugPrint('✅ Stopped monitoring delegations');
  }

  /// Handle a new delegation received from mobile device
  Future<void> _handleNewDelegation(Map<String, dynamic> delegationData) async {
    final transactionId = delegationData['transactionId'] as String;
    final branchId = delegationData['branchId'] as String;
    final itemIds =
        (delegationData['additionalData']?['items'] as List?)?.cast<String>() ??
            [];

    try {
      debugPrint('🔔 Desktop processing new delegation: $transactionId');

      // Update status to 'processing'
      await _delegationService.updateDelegationStatus(
        transactionId: transactionId,
        status: TransactionDelegationStatus.processing.value,
        processingDevice: _delegationService.getDeviceId(),
      );

      // Fetch fresh transaction data from repository using awaitRemote
      final transaction = await ProxyService.strategy.getTransaction(
        id: transactionId,
        branchId: int.parse(branchId),
        awaitRemote: true,
      );

      if (transaction == null) {
        throw Exception('Transaction not found: $transactionId');
      }

      // Fetch fresh transaction items from repository using awaitRemote
      List<TransactionItem> items = [];
      if (itemIds.isNotEmpty) {
        items = await ProxyService.strategy.transactionItems(
          itemIds: itemIds,
          fetchRemote: true,
        );
      } else {
        // Fallback to get all items for the transaction
        items = await ProxyService.strategy.transactionItems(
          transactionId: transactionId,
          fetchRemote: true,
        );
      }

      // Process the transaction (generate receipt, print, EBM sync)
      await _completeTransactionOnDesktop(
        transaction: transaction,
        delegationData: delegationData,
        items: items,
      );

      // Update status to 'completed'
      await _delegationService.updateDelegationStatus(
        transactionId: transactionId,
        status: TransactionDelegationStatus.completed.value,
        completedAt: DateTime.now().toIso8601String(),
      );

      debugPrint('✅ Desktop completed delegation: $transactionId');

      // Notify mobile device
      await _notifyMobileOfCompletion(transactionId);
    } catch (e) {
      debugPrint('❌ Error processing delegation $transactionId: $e');

      // Update status to 'error'
      await _delegationService.updateDelegationStatus(
        transactionId: transactionId,
        status: TransactionDelegationStatus.error.value,
        errorMessage: e.toString(),
      );
    }
  }

  /// Desktop: Monitor for delegated transactions and process them (DEPRECATED - use startMonitoringDelegations)
  @Deprecated(
      'Use startMonitoringDelegations() for real-time monitoring instead')
  Future<void> monitorDelegatedTransactions() async {
    if (!canHandleEBMOperations) {
      return; // Only desktop should monitor
    }

    if (!await isDelegationEnabled()) {
      return; // Feature not enabled
    }

    try {
      // Get all transactions with delegation status
      final transactions = await _getPendingDelegatedTransactions();

      for (final transaction in transactions) {
        // Check if transaction has timed out
        final hasTimedOut = await _checkDelegationTimeout(transaction.id);
        if (hasTimedOut) {
          await _handleDelegationTimeout(transaction.id);
          continue;
        }

        await _processDelgatedTransaction(transaction);
      }

      // Clean up old completed delegations
      await _cleanupOldDelegations();
    } catch (e) {
      // Log error but don't throw to allow continuous monitoring
      ProxyService.notie
          .sendData('Error monitoring delegated transactions: $e');
    }
  }

  /// Process a delegated transaction on desktop
  Future<void> _processDelgatedTransaction(ITransaction transaction) async {
    try {
      // Get delegation metadata from Ditto
      final delegationData =
          await _delegationService.getDelegation(transaction.id);

      if (delegationData == null) {
        return;
      }

      final status = TransactionDelegationStatus.fromString(
        delegationData['status'] as String,
      );

      // Only process if delegated (not already processing or completed)
      if (status != TransactionDelegationStatus.delegated) {
        return;
      }

      // Update status to processing
      await _delegationService.updateDelegationStatus(
        transactionId: transaction.id,
        status: TransactionDelegationStatus.processing.value,
        processingDevice: _delegationService.getDeviceId(),
      );

      // Fetch transaction items for processing
      final items = await ProxyService.strategy.transactionItems(
        transactionId: transaction.id,
        fetchRemote: true,
      );

      // Process the transaction (generate receipt, print, etc.)
      await _completeTransactionOnDesktop(
        transaction: transaction,
        delegationData: delegationData,
        items: items,
      );

      // Mark as completed
      await _delegationService.updateDelegationStatus(
        transactionId: transaction.id,
        status: TransactionDelegationStatus.completed.value,
        completedAt: DateTime.now().toIso8601String(),
      );

      // Notify mobile device (via Ditto sync)
      await _notifyMobileOfCompletion(transaction.id);
    } catch (e) {
      // Mark as error
      await _delegationService.updateDelegationStatus(
        transactionId: transaction.id,
        status: TransactionDelegationStatus.error.value,
        errorMessage: e.toString(),
      );

      rethrow;
    }
  }

  /// Complete the transaction on desktop (generate receipt, print, etc.)
  Future<void> _completeTransactionOnDesktop({
    required ITransaction transaction,
    required Map<String, dynamic> delegationData,
    required List<TransactionItem> items,
  }) async {
    // Create a new TaxController instance for this transaction
    // We use late import to avoid circular dependency
    final taxController = createTaxController(transaction);

    // Generate receipt signature and print
    await taxController.printReceipt(
      receiptType: delegationData['receiptType'] as String,
      transaction: transaction,
      purchaseCode:
          delegationData['additionalData']?['purchaseCode'] as String?,
      salesSttsCd:
          delegationData['additionalData']?['salesSttsCd'] as String? ?? '11',
      originalInvoiceNumber:
          delegationData['additionalData']?['originalInvoiceNumber'] as int?,
      sarTyCd: delegationData['additionalData']?['sarTyCd'] as String?,
      items: items,
    );
  }

  /// Create TaxController - must be implemented by the class using this mixin
  /// Override this method in your class to return a TaxController instance
  dynamic createTaxController(ITransaction transaction) {
    throw UnimplementedError(
      'createTaxController must be implemented by the class using TransactionDelegationMixin',
    );
  }

  /// Get all transactions that are pending desktop processing
  Future<List<ITransaction>> _getPendingDelegatedTransactions() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      return [];
    }

    // Query transactions with delegation status
    final transactions = await ProxyService.strategy.transactions(
      branchId: branchId,
      status: 'complete', // Only look at completed transactions
    );

    // Filter for those with pending delegation
    final pendingDelegated = <ITransaction>[];
    for (final transaction in transactions) {
      final delegationDataStr = ProxyService.box.readString(
        key: 'delegation_${transaction.id}',
      );

      if (delegationDataStr != null) {
        final delegationData = _decodeDelegationData(delegationDataStr);
        final status = TransactionDelegationStatus.fromString(
          delegationData['status'] as String,
        );

        if (status == TransactionDelegationStatus.delegated) {
          pendingDelegated.add(transaction);
        }
      }
    }

    return pendingDelegated;
  }

  /// Mark transaction as delegated in the database
  Future<void> _markTransactionAsDelegated(ITransaction transaction) async {
    // Update transaction metadata to indicate it's delegated
    // The transaction itself doesn't change, we just track delegation status separately
    // This is synced via Ditto
  }

  /// Notify mobile device that desktop has completed processing
  Future<void> _notifyMobileOfCompletion(String transactionId) async {
    // Notification is handled via Ditto sync - mobile will see the updated status
    // in ProxyService.box when it syncs
    ProxyService.notie.sendData(
      'Desktop completed processing transaction $transactionId',
    );
  }

  /// Get current device ID
  Future<String> _getCurrentDeviceId() async {
    final branchId = ProxyService.box.getBranchId();
    final businessId = ProxyService.box.getBusinessId();

    if (branchId == null || businessId == null) {
      return 'unknown';
    }

    // Get device info
    final devices = await ProxyService.strategy.getDevices(
      businessId: businessId,
    );

    // Find current device (simplified - you may want more sophisticated logic)
    if (devices.isNotEmpty) {
      return devices.first.id;
    }

    return 'unknown';
  }

  /// Encode delegation data to string for storage
  String _encodeDelegationData(Map<String, dynamic> data) {
    // Simple JSON encoding - could use more sophisticated serialization
    final buffer = StringBuffer();
    data.forEach((key, value) {
      buffer.write('$key:${value?.toString() ?? 'null'}|');
    });
    return buffer.toString();
  }

  /// Decode delegation data from stored string
  Map<String, dynamic> _decodeDelegationData(String data) {
    final result = <String, dynamic>{};
    final parts = data.split('|');

    for (final part in parts) {
      if (part.isEmpty) continue;
      final keyValue = part.split(':');
      if (keyValue.length == 2) {
        final key = keyValue[0];
        final value = keyValue[1] == 'null' ? null : keyValue[1];

        // Try to parse as int if possible
        if (value != null && int.tryParse(value) != null) {
          result[key] = int.parse(value);
        } else {
          result[key] = value;
        }
      }
    }

    return result;
  }

  /// Check delegation status for a transaction (for UI display)
  Future<TransactionDelegationStatus?> getTransactionDelegationStatus(
    String transactionId,
  ) async {
    final delegationDataStr = ProxyService.box.readString(
      key: 'delegation_$transactionId',
    );

    if (delegationDataStr == null) {
      return null;
    }

    final delegationData = _decodeDelegationData(delegationDataStr);
    return TransactionDelegationStatus.fromString(
      delegationData['status'] as String,
    );
  }

  /// Cancel a delegated transaction
  Future<void> cancelDelegation(String transactionId) async {
    final delegationDataStr = ProxyService.box.readString(
      key: 'delegation_$transactionId',
    );

    if (delegationDataStr == null) {
      return;
    }

    final delegationData = _decodeDelegationData(delegationDataStr);
    delegationData['status'] = TransactionDelegationStatus.cancelled.value;
    delegationData['cancelledAt'] = DateTime.now().toIso8601String();

    await ProxyService.box.writeString(
      key: 'delegation_$transactionId',
      value: _encodeDelegationData(delegationData),
    );
  }

  /// Check if a delegation has timed out
  Future<bool> _checkDelegationTimeout(String transactionId) async {
    final delegationDataStr = ProxyService.box.readString(
      key: 'delegation_$transactionId',
    );

    if (delegationDataStr == null) {
      return false;
    }

    final delegationData = _decodeDelegationData(delegationDataStr);
    final delegatedAtStr = delegationData['delegatedAt'] as String?;

    if (delegatedAtStr == null) {
      return false;
    }

    final delegatedAt = DateTime.parse(delegatedAtStr);
    final now = DateTime.now();
    final elapsed = now.difference(delegatedAt);

    return elapsed > _delegationTimeout;
  }

  /// Handle a delegation that has timed out
  Future<void> _handleDelegationTimeout(String transactionId) async {
    final delegationDataStr = ProxyService.box.readString(
      key: 'delegation_$transactionId',
    );

    if (delegationDataStr == null) {
      return;
    }

    final delegationData = _decodeDelegationData(delegationDataStr);
    final retryCount = (delegationData['retryCount'] as int?) ?? 0;

    if (retryCount < _maxRetries) {
      // Retry: Reset to delegated status
      delegationData['status'] = TransactionDelegationStatus.delegated.value;
      delegationData['retryCount'] = retryCount + 1;
      delegationData['lastRetryAt'] = DateTime.now().toIso8601String();

      await ProxyService.box.writeString(
        key: 'delegation_$transactionId',
        value: _encodeDelegationData(delegationData),
      );

      ProxyService.notie.sendData(
        'Retrying delegated transaction (attempt ${retryCount + 1}/$_maxRetries)',
      );
    } else {
      // Max retries reached, mark as error
      delegationData['status'] = TransactionDelegationStatus.error.value;
      delegationData['error'] = 'Delegation timeout after $_maxRetries retries';
      delegationData['errorAt'] = DateTime.now().toIso8601String();

      await ProxyService.box.writeString(
        key: 'delegation_$transactionId',
        value: _encodeDelegationData(delegationData),
      );

      ProxyService.notie.sendData(
        'Transaction delegation failed after $_maxRetries retries',
      );
    }
  }

  /// Clean up old completed or error delegations (older than 24 hours)
  Future<void> _cleanupOldDelegations() async {
    try {
      // Get all keys with delegation prefix
      final allKeys = <String>[]; // ProxyService.box doesn't expose key listing
      // This is a simplified implementation - you may need to track delegation keys separately

      // For now, we'll skip cleanup as it requires additional infrastructure
      // In a production system, you'd want to:
      // 1. Maintain a list of active delegation IDs
      // 2. Periodically check and clean up old ones
      // 3. Store delegation metadata in a proper collection/table
    } catch (e) {
      // Non-critical operation, just log
      ProxyService.notie.sendData('Error cleaning up delegations: $e');
    }
  }

  /// Get delegation error details for display
  Future<String?> getDelegationError(String transactionId) async {
    final delegationDataStr = ProxyService.box.readString(
      key: 'delegation_$transactionId',
    );

    if (delegationDataStr == null) {
      return null;
    }

    final delegationData = _decodeDelegationData(delegationDataStr);
    return delegationData['error'] as String?;
  }

  /// Retry a failed delegation manually
  Future<void> retryDelegation(String transactionId) async {
    final delegationDataStr = ProxyService.box.readString(
      key: 'delegation_$transactionId',
    );

    if (delegationDataStr == null) {
      throw Exception('No delegation found for transaction');
    }

    final delegationData = _decodeDelegationData(delegationDataStr);
    final currentStatus = TransactionDelegationStatus.fromString(
      delegationData['status'] as String,
    );

    // Only allow retry for error or cancelled status
    if (currentStatus != TransactionDelegationStatus.error &&
        currentStatus != TransactionDelegationStatus.cancelled) {
      throw Exception('Can only retry failed or cancelled delegations');
    }

    // Reset to delegated status
    delegationData['status'] = TransactionDelegationStatus.delegated.value;
    delegationData['retryCount'] = 0;
    delegationData['error'] = null;
    delegationData['manualRetryAt'] = DateTime.now().toIso8601String();

    await ProxyService.box.writeString(
      key: 'delegation_$transactionId',
      value: _encodeDelegationData(delegationData),
    );

    ProxyService.notie.sendData('Delegation retry initiated');
  }
}
