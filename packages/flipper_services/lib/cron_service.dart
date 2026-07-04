import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:brick_core/query.dart';
import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/log_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/firebase_messaging.dart';
import 'package:flipper_services/notifications/notification_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' hide Category;
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:ditto_live/ditto_live.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_models/brick/models/transaction.model.dart';

/// A service class that manages scheduled tasks and periodic operations for the Flipper app.
///
/// This service handles data synchronization, device publishing, and other periodic operations
/// that need to run in the background to keep the app's data up-to-date.
class CronService {
  /// Google Drive service instance for file operations
  final GoogleDrive drive = GoogleDrive();

  /// Flag to track if initial data pull has been completed
  bool _doneInitializingDataPull = false;

  /// List to keep track of active timers for proper cleanup
  final List<Timer> _activeTimers = [];

  /// Whether an exclusive cron task is currently running.
  /// Only one DB-touching task can execute at a time; others are skipped.
  bool _cronTaskRunning = false;

  /// Stream subscription for delegation monitoring (desktop only)
  StreamSubscription<List<TransactionDelegation>>? _delegationsSubscription;

  /// Device id currently being monitored; used to skip redundant re-setup.
  String? _delegationMonitoringDeviceId;

  /// Prevents concurrent or duplicate processing of the same delegation.
  final Set<String> _processingDelegationIds = {};

  /// Delegation IDs we already notified for (avoids duplicate banners).
  final Set<String> _notifiedDelegationIds = {};

  /// Resolves cart lines for a delegated receipt. The delegation payload must
  /// carry [itemSnapshots]; Ditto/Supabase are optional fallbacks for legacy jobs.
  Future<List<TransactionItem>> _resolveDelegationLineItems({
    required dynamic capella,
    required String transactionId,
    required Map<String, dynamic> additionalData,
  }) async {
    final rawSnapshots = additionalData['itemSnapshots'];
    if (rawSnapshots is List && rawSnapshots.isNotEmpty) {
      final snapshotItems =
          capella.transactionItemsFromDelegationSnapshots(rawSnapshots);
      if (snapshotItems.isNotEmpty) {
        talker.info(
          'Resolved ${snapshotItems.length} delegation item(s) from embedded '
          'snapshots for $transactionId',
        );
        return snapshotItems;
      }
    }

    List<String>? itemIdsFromDelegation;
    final rawItemIds = additionalData['items'];
    if (rawItemIds is List && rawItemIds.isNotEmpty) {
      itemIdsFromDelegation = rawItemIds.map((e) => e.toString()).toList();
    }

    if (itemIdsFromDelegation != null && itemIdsFromDelegation.isNotEmpty) {
      final byIds = await capella.transactionItems(
        itemIds: itemIdsFromDelegation,
      );
      if (byIds.isNotEmpty) {
        talker.info(
          'Resolved ${byIds.length} delegation item(s) from Ditto by id '
          'for $transactionId',
        );
        return byIds;
      }
    }

    final byTransaction = await capella.transactionItems(
      transactionId: transactionId,
    );
    if (byTransaction.isNotEmpty) {
      talker.info(
        'Resolved ${byTransaction.length} delegation item(s) from Ditto for '
        '$transactionId',
      );
      return byTransaction;
    }

    final fromRepository = await _fetchDelegationLineItemsFromRepository(
      transactionId: transactionId,
      itemIds: itemIdsFromDelegation,
    );
    if (fromRepository.isNotEmpty) {
      talker.info(
        'Resolved ${fromRepository.length} delegation item(s) from Supabase '
        'for $transactionId',
      );
      return fromRepository;
    }

    return [];
  }

  Future<List<TransactionItem>> _fetchDelegationLineItemsFromRepository({
    required String transactionId,
    List<String>? itemIds,
  }) async {
    try {
      if (itemIds != null && itemIds.isNotEmpty) {
        final byIds = await repository.get<TransactionItem>(
          query: Query(where: [Where('id').isIn(itemIds)]),
          policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
        );
        if (byIds.isNotEmpty) return byIds;
      }

      return await repository.get<TransactionItem>(
        query: Query(
          where: [Where('transactionId').isExactly(transactionId)],
        ),
        policy: OfflineFirstGetPolicy.awaitRemoteWhenNoneExist,
      );
    } catch (e, stackTrace) {
      talker.warning(
        'Supabase fallback for delegation items failed: $e',
        stackTrace,
      );
      return [];
    }
  }

  /// Resolves the sale header for a delegated receipt. Prefer Ditto when the
  /// transaction already replicated; otherwise rebuild from [transactionSnapshot].
  Future<ITransaction?> _resolveDelegationTransaction({
    required dynamic capella,
    required String transactionId,
    required Map<String, dynamic> additionalData,
  }) async {
    final transactions = await capella.transactions(
      id: transactionId,
    );
    if (transactions.isNotEmpty) {
      return transactions.first;
    }

    final rawSnapshot = additionalData['transactionSnapshot'];
    if (rawSnapshot is! Map) {
      return null;
    }

    final transaction = await ITransactionDittoAdapter.instance.fromDittoDocument(
      Map<String, dynamic>.from(rawSnapshot),
    );
    if (transaction != null) {
      talker.info(
        'Resolved delegation transaction from embedded snapshot for '
        '$transactionId',
      );
    }
    return transaction;
  }

  void _applyDelegationFieldsToTransaction({
    required ITransaction transaction,
    required TransactionDelegation delegation,
    required Map<String, dynamic> additionalData,
  }) {
    if (delegation.customerName != null && delegation.customerName!.isNotEmpty) {
      transaction.customerName = delegation.customerName;
    }
    if (delegation.customerTin != null) {
      transaction.customerTin = delegation.customerTin;
    }
    if (delegation.customerBhfId != null) {
      transaction.customerBhfId = delegation.customerBhfId;
    }
    if (delegation.subTotal > 0) {
      transaction.subTotal = delegation.subTotal;
    }
    transaction.paymentType = delegation.paymentType;
    transaction.receiptType = delegation.receiptType;

    final rawSnapshot = additionalData['transactionSnapshot'];
    if (rawSnapshot is Map) {
      final snap = Map<String, dynamic>.from(rawSnapshot);
      final phone = snap['customerPhone'] ?? snap['currentSaleCustomerPhoneNumber'];
      if (phone != null && phone.toString().isNotEmpty) {
        transaction.customerPhone = phone.toString();
      }
      if (snap['sarTyCd'] != null) {
        transaction.sarTyCd = snap['sarTyCd']?.toString();
      }
      if (snap['taxAmount'] != null) {
        transaction.taxAmount = (snap['taxAmount'] as num?)?.toDouble();
      }
    }
  }

  /// Constants for timer durations
  static const int _isolateMessageSeconds = 40;

  /// Runs [task] only if no other exclusive cron task is active.
  /// If another task is running, this invocation is silently skipped
  /// so that periodic timers never queue up work.
  Future<void> _runExclusiveTask(
    String name,
    Future<void> Function() task,
  ) async {
    if (_cronTaskRunning) {
      talker.debug("Skipping '$name': another cron task is running");
      return;
    }
    _cronTaskRunning = true;
    try {
      await task();
    } catch (e, stackTrace) {
      talker.error("Cron task '$name' failed: $e", stackTrace);
    } finally {
      _cronTaskRunning = false;
    }
  }

  /// Schedules various tasks and timers to handle data synchronization, device publishing,
  /// and other periodic operations.
  ///
  /// This method sets up the following scheduled tasks:
  /// - Initializes Firebase messaging and subscribes to business notifications
  /// - Periodically pulls data from Realm
  /// - Periodically pushes data to the server
  /// - Periodically synchronizes Firestore data
  /// - Periodically pulls data from the server
  /// - Periodically attempts to publish the device to the server
  Future<void> schedule() async {
    try {
      await ProxyService.strategy.businesses(
        userId: ProxyService.box.getUserId() ?? "",
        fetchOnline: true,
      );
      await _initializeData();
      await _configureServices();
      await _setupConnectivity();
      await _setupFirebaseMessaging();

      // Start periodic timers only after every initialization step has
      // finished so that background timers never compete with init work.
      _setupPeriodicTasks();

      talker.info("CronService: All scheduled tasks initialized successfully");
    } catch (e, stackTrace) {
      talker.error("CronService initialization failed: $e", stackTrace);
      // Attempt recovery by at least setting up essential services
      _setupEssentialServices();
    }
  }

  bool get isMobileDevice {
    return Platform.isAndroid || Platform.isIOS;
  }

  /// Polls for this device's own stable id. Desktop self-registration
  /// (which sets it) runs later in the login flow than this cron setup, so
  /// give it a bounded window to finish before giving up for this session.
  Future<String?> _waitForThisDeviceId({
    int maxAttempts = 10,
    Duration retryDelay = const Duration(seconds: 3),
  }) async {
    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      final deviceId = ProxyService.box.getThisDeviceId();
      if (deviceId != null) return deviceId;
      await Future.delayed(retryDelay);
    }
    return ProxyService.box.getThisDeviceId();
  }

  /// Registers Ditto subscriptions and starts processing delegated receipts.
  ///
  /// Safe to call multiple times (e.g. after [AppService.appInit] or desktop
  /// device self-registration). Idempotent when already monitoring the same
  /// device on the current branch.
  Future<void> setupDelegationMonitoringIfNeeded() async {
    if (isMobileDevice) return;

    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      talker.warning(
        'Skipping delegation monitoring: Branch ID is null.',
      );
      return;
    }

    if (!ProxyService.ditto.isReady()) {
      talker.warning(
        'Skipping delegation monitoring: Ditto is not ready yet.',
      );
      return;
    }

    final deviceId = await _waitForThisDeviceId(
      maxAttempts: 5,
      retryDelay: const Duration(seconds: 1),
    );
    if (deviceId == null) {
      talker.warning(
        'Skipping delegation monitoring: this device did not finish '
        'registering for branch $branchId.',
      );
      return;
    }

    if (_delegationMonitoringDeviceId == deviceId &&
        _delegationsSubscription != null) {
      return;
    }

    try {
      talker.info(
        '[delegation-cron] setupDelegationMonitoringIfNeeded params: '
        'branchId=$branchId '
        'thisDeviceId(onDeviceId)=$deviceId '
        'selectedDelegationDeviceId(setting)=${ProxyService.box.selectedDelegationDeviceId()} '
        'dittoReady=${ProxyService.ditto.isReady()} '
        'dittoDeviceName=${ProxyService.ditto.dittoInstance?.deviceName} '
        'status=delegated '
        'compare SQL: SELECT * FROM transaction_delegations WHERE branchId = '
        "'$branchId' AND status = 'delegated' AND selectedDelegationDeviceId = '$deviceId'",
      );

      await _delegationsSubscription?.cancel();

      _delegationsSubscription = ProxyService.getStrategy(Strategy.capella)
          .delegationsStream(
            branchId: branchId,
            status: 'delegated',
            onDeviceId: deviceId,
          )
          .listen((delegations) async {
            await _handleIncomingDelegations(
              delegations: delegations,
              branchId: branchId,
            );
          });

      _delegationMonitoringDeviceId = deviceId;
    } catch (e, stackTrace) {
      talker.error('Failed to setup delegation monitoring: $e', stackTrace);
    }
  }

  Future<void> _notifyDelegationReceived(
    TransactionDelegation delegation,
  ) async {
    final id = delegation.transactionId;
    if (!_notifiedDelegationIds.add(id)) return;

    talker.info('[delegation-notify] notifying for $id');
    try {
      await NotificationHandler().showDelegationNotification(delegation);
    } catch (e, stackTrace) {
      talker.error('Failed to show delegation notification: $e', stackTrace);
    }
  }

  Future<void> _handleIncomingDelegations({
    required List<TransactionDelegation> delegations,
    required String branchId,
  }) async {
    final capella = ProxyService.getStrategy(Strategy.capella);

    for (final delegation in delegations) {
      final delegationId = delegation.transactionId;
      if (_processingDelegationIds.contains(delegationId)) {
        continue;
      }
      _processingDelegationIds.add(delegationId);

      // Notify as soon as we pick up the job (before print work).
      await _notifyDelegationReceived(delegation);

      try {
        talker.info(
          "📱 Delegation received: $delegationId from ${delegation.delegatedFromDevice}",
        );

        await capella.updateDelegationStatus(
          transactionId: delegationId,
          status: 'processing',
        );

        final additionalData = delegation.additionalData ?? {};
        final transaction = await _resolveDelegationTransaction(
          capella: capella,
          transactionId: delegationId,
          additionalData: additionalData,
        );

        if (transaction == null) {
          talker.error(
            "Transaction not found for delegation: $delegationId",
          );
          await capella.updateDelegationStatus(
            transactionId: delegationId,
            status: 'failed',
            errorMessage: 'Transaction not found',
          );
          continue;
        }
        final salesSttsCd =
            additionalData['salesSttsCd'] as String? ?? '02';
        final purchaseCode = additionalData['purchaseCode'] as String?;
        final counters = await capella.getCounters(
          branchId: branchId,
          fetchRemote: false,
        );
        final int highestInvcNo = counters.fold<int>(
          0,
          (prev, c) => math.max(prev, c.invcNo ?? 0),
        );

        final sarTyCd = additionalData['sarTyCd'] as String?;

        final lineItems = await _resolveDelegationLineItems(
          capella: capella,
          transactionId: delegationId,
          additionalData: additionalData,
        );
        if (lineItems.isEmpty) {
          const errorMessage =
              'Missing line items in delegation payload. '
              'Re-send the sale from the POS device (delegation '
              'must include item snapshots).';
          talker.error(
            'Delegation $delegationId failed: $errorMessage',
          );
          await capella.updateDelegationStatus(
            transactionId: delegationId,
            status: 'failed',
            errorMessage: errorMessage,
          );
          final failedDelegation = delegation.copyWith(
            status: 'failed',
            updatedAt: DateTime.now().toUtc(),
          );
          await repository.upsert<TransactionDelegation>(
            failedDelegation,
          );
          continue;
        }

        _applyDelegationFieldsToTransaction(
          transaction: transaction,
          delegation: delegation,
          additionalData: additionalData,
        );

        final taxController = TaxController<ITransaction>(
          object: transaction,
        );

        talker.info(
          "🖨️  Processing receipt for delegation: ${delegation.receiptType}",
        );

        transaction.invoiceNumber = highestInvcNo;
        await repository.upsert<ITransaction>(transaction);

        final customer = await resolveCustomerForReceipt(
          transaction: transaction,
          purchaseCode: purchaseCode,
        );
        final custMblNo =
            transaction.customerPhone ?? delegation.customerName ?? '';
        final customerName =
            transaction.customerName ?? delegation.customerName ?? '';
        final result = await taxController.printReceipt(
          custMblNo: custMblNo,
          customerName: customerName,
          customer: customer,
          receiptType: delegation.receiptType,
          transaction: transaction,
          salesSttsCd: salesSttsCd,
          purchaseCode: purchaseCode,
          originalInvoiceNumber: highestInvcNo,
          sarTyCd: sarTyCd,
          skiGenerateRRAReceiptSignature: false,
          allowDelegationFallback: false,
          transactionItems: lineItems,
        );

        if (result.response.resultCd == "000") {
          talker.info(
            "✅ Receipt printed successfully for delegation: $delegationId",
          );

          await capella.updateDelegationStatus(
            transactionId: delegationId,
            status: 'completed',
          );

          final updatedDelegation = delegation.copyWith(
            status: 'completed',
            updatedAt: DateTime.now().toUtc(),
          );
          await repository.upsert<TransactionDelegation>(
            updatedDelegation,
          );
        } else {
          talker.error(
            "❌ Receipt printing failed: ${result.response.resultMsg}",
          );

          await capella.updateDelegationStatus(
            transactionId: delegationId,
            status: 'failed',
            errorMessage: result.response.resultMsg,
          );

          final updatedDelegation = delegation.copyWith(
            status: 'failed',
            updatedAt: DateTime.now().toUtc(),
          );
          await repository.upsert<TransactionDelegation>(
            updatedDelegation,
          );
        }
      } catch (e, stackTrace) {
        talker.error(
          "❌ Error processing delegation $delegationId: $e",
          stackTrace,
        );

        try {
          await capella.updateDelegationStatus(
            transactionId: delegationId,
            status: 'failed',
            errorMessage: e.toString(),
          );
          final updatedDelegation = delegation.copyWith(
            status: 'failed',
            updatedAt: DateTime.now().toUtc(),
          );
          await repository.upsert<TransactionDelegation>(
            updatedDelegation,
          );
        } catch (updateError) {
          talker.error(
            "Failed to update delegation status: $updateError",
          );
        }
      } finally {
        _processingDelegationIds.remove(delegationId);
      }
    }
  }

  /// Initializes data by hydrating from remote if queue is empty
  Future<void> _initializeData() async {
    final platform = Ditto.currentPlatform;
    if (platform case SupportedPlatform.android || SupportedPlatform.ios) {
      final logService = LogService();
      // Request all necessary permissions
      [
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
        Permission.nearbyWifiDevices,
        Permission.bluetoothScan,
      ].request().then((statuses) async {
        // Check if location permission was granted (especially important for Android)
        if (platform == SupportedPlatform.android) {
          // Check all requested permissions
          final allPermissions = [
            Permission.bluetoothConnect,
            Permission.bluetoothAdvertise,
            Permission.nearbyWifiDevices,
            Permission.bluetoothScan,
          ];

          bool allPermissionsGranted = true;
          List<String> deniedPermissions = [];

          for (var permission in allPermissions) {
            final status = await permission.status;
            if (status != PermissionStatus.granted) {
              allPermissionsGranted = false;
              deniedPermissions.add(permission.toString());
            }
          }

          if (!allPermissionsGranted) {
            debugPrint(
              '⚠️ Some permissions not granted. Ditto sync may not work properly on Android. Denied: ${deniedPermissions.join(", ")}',
            );
            debugPrint(
              'Please ensure all requested permissions are granted for proper sync functionality.',
            );

            if (ProxyService.box.getUserLoggingEnabled() ?? false) {
              await logService.logException(
                'Some permissions not granted: ${deniedPermissions.join(", ")}',
                type: 'cron_service',
                tags: {
                  'userId':
                      ProxyService.box.getUserId()?.toString() ?? 'unknown',
                  'method': 'cron_service',
                  'platform': platform.toString(),
                  'denied_permissions': deniedPermissions.join(", "),
                },
              );
            }
          } else {
            debugPrint(
              '✅ All required permissions granted for Ditto sync on Android.',
            );
            if (ProxyService.box.getUserLoggingEnabled() ?? false) {
              await logService.logException(
                'All permissions granted',
                type: 'cron_service',
                tags: {
                  'userId':
                      ProxyService.box.getUserId()?.toString() ?? 'unknown',
                  'method': 'cron_service',
                  'platform': platform.toString(),
                  'all_permissions_granted': 'true',
                },
              );
            }
          }
        }
      });
    }

    // Listen for delegated transactions from mobile devices
    /// the script should run on desktop apps only
    await setupDelegationMonitoringIfNeeded();
    // get counters touch them

    try {
      if (ProxyService.box.getBranchId() != null) {
        List<Counter> counters = await ProxyService.strategy.getCounters(
          branchId: ProxyService.box.getBranchId()!,
          fetchRemote: false,
        );
        // Batch update counters in a single transaction to avoid DB locks
        final now = DateTime.now();
        for (final counter in counters) {
          counter.lastTouched = now;
        }
        // Removing sqliteProvider.transaction wrapper to avoid deadlocks
        for (final counter in counters) {
          await repository.upsert(counter, skipDittoSync: true);
        }
      }
      final uri = await ProxyService.box.getServerUrl();
      if (uri != null && uri.isNotEmpty) {
        await ProxyService.http.getUniversalProducts(
          Uri.parse('${uri}itemClass/selectItemsClass'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "tin": "999909695",
            "bhfId": "00",
            "lastReqDt": "20190523000000",
          }),
        );
      } else {
        talker.warning(
          'Skipping getUniversalProducts: server URL is not configured',
        );
      }
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        talker.error("Cannot hydrate data: Branch ID is null");
        return;
      }

      await ProxyService.strategy.ebm(branchId: branchId, fetchRemote: true);
      final queueLength = await ProxyService.strategy.queueLength();

      await ProxyService.tax.taxConfigs(branchId: branchId);

      final activeBranch = await ProxyService.strategy.activeBranch(
        branchId: ProxyService.box.getBranchId()!,
      );
      await ProxyService.strategy.hydrateDate(branchId: activeBranch.id);

      await ProxyService.strategy.access(
        userId: ProxyService.box.getUserId()!,
        fetchRemote: true,
      );

      try {
        await ProxyService.strategy.deleteTenantsWithNullPin(
          businessId: ProxyService.box.getBusinessId(),
        );
      } catch (e) {
        talker.error('Failed to delete tenants with null pin: $e');
      }

      await ProxyService.strategy.hydrateCodes(branchId: branchId);
      // Registers Ditto cloud pull for `sars` + hydrates SQLite mirror (Brick).
      await ProxyService.strategy.hydrateSars(branchId: branchId);
      if (queueLength == 0) {
        talker.warning("Empty queue detected, hydrating data from remote");
        final businessId = ProxyService.box.getBusinessId()!;
        talker.info("Hydrating data for businessId: $businessId");

        /// end of work around
        // Hydrate essential data
        try {
          // Skip fetchNotices when the server URL is unset, or on mobile with a
          // localhost URI. Force-unwrapping `uri` here crashed hydration when
          // the server URL was not yet configured.
          if (uri == null || uri.isEmpty) {
            talker.info(
              "Skipping fetchNotices: server URL is not configured",
            );
          } else if (isMobileDevice && uri.contains('localhost')) {
            talker.info(
              "Skipping fetchNotices on mobile device with localhost URI",
            );
          } else {
            await ProxyService.tax.fetchNotices(URI: uri);
          }
        } catch (e) {
          talker.error("Error hydrating initial data: $e");
        }
      }

      // Initialize isolate for background processing
      await ProxyService.strategy.spawnIsolate(IsolateHandler.handler);
    } catch (e, stackTrace) {
      talker.error("Data initialization failed: $e", stackTrace);
      rethrow;
    }
  }

  /// Sets up all periodic tasks with appropriate error handling.
  ///
  /// Periodic DB work: **legacy** MoMo auto-complete runs on a timer for rows
  /// still in [WAITING_MOMO_COMPLETE] from older app builds. New Cash Book
  /// MoMo/Airtel flows complete immediately in the UI; this timer is only a
  /// safety net. Other former crons (transaction refresh, analytics, sales sync,
  /// asset download) are disabled to avoid [_cronTaskRunning] contention and
  /// SQLite lock warnings.
  void _setupPeriodicTasks() {
    // Isolate heartbeat – lightweight send, no DB work, runs independently
    _activeTimers.add(
      Timer.periodic(Duration(seconds: _isolateMessageSeconds), (_) {
        if (ProxyService.strategy.sendPort != null) {
          try {
            ProxyService.strategy.sendMessageToIsolate();
          } catch (e, stackTrace) {
            talker.error("Failed to send message to isolate: $e", stackTrace);
          }
        }
      }),
    );

    _activeTimers.add(
      Timer.periodic(const Duration(minutes: 5), (_) {
        _runExclusiveTask('momoAutoComplete', _autoCompleteMomoTransactions);
      }),
    );
  }

  /// Configures essential services for the app
  Future<void> _configureServices() async {
    try {
      // Clear any custom phone number for payment
      ProxyService.box.remove(key: "customPhoneNumberForPayment");

      // Start replicator
      ProxyService.strategy.startReplicator();

      // Set strategy based on platform
      ProxyService.setStrategy(Strategy.cloudSync);
      ProxyService.strategy.whoAmI();

      // Get payment plan
      final businessId = ProxyService.box.getBusinessId();
      if (businessId != null) {
        await ProxyService.strategy.getPaymentPlan(businessId: businessId);
      } else {
        talker.warning("Skipping payment plan fetch: Business ID is null");
      }

      // Reset ordering state
      ProxyService.box.writeBool(key: 'isOrdering', value: false);

      // Handle force upsert if needed
      if (ProxyService.box.forceUPSERT()) {
        ProxyService.strategy.startReplicator();
      }
    } catch (e, stackTrace) {
      talker.error("Service configuration failed: $e", stackTrace);
      rethrow;
    }
  }

  /// Sets up connectivity-dependent operations
  Future<void> _setupConnectivity() async {
    try {
      List<ConnectivityResult> results = await Connectivity()
          .checkConnectivity();
      bool hasConnectivity = results.any(
        (result) => result != ConnectivityResult.none,
      );

      if (hasConnectivity) {
        // Handle Firebase login if needed
        if (!isTestEnvironment() && FirebaseAuth.instance.currentUser == null) {
          try {
            await ProxyService.strategy.firebaseLogin();
          } catch (e) {
            talker.error("Firebase login failed: $e");
          }
        }

        talker.info("Connectivity check completed: $_doneInitializingDataPull");

        if (!_doneInitializingDataPull) {
          talker.warning("Starting initial data pull");
          _doneInitializingDataPull = true;
        }
      } else {
        talker.warning("No connectivity detected, skipping online operations");
      }
    } catch (e, stackTrace) {
      talker.error("Connectivity setup failed: $e", stackTrace);
    }
  }

  /// Sets up essential services in case of initialization failure
  void _setupEssentialServices() {
    try {
      ProxyService.box.writeBool(key: 'isOrdering', value: false);
      ProxyService.strategy.startReplicator();
      talker.warning("Essential services initialized in recovery mode");
    } catch (e) {
      talker.error("Essential services initialization failed: $e");
    }
  }

  /// Sets up Firebase messaging for notifications
  Future<void> _setupFirebaseMessaging() async {
    try {
      Business? business = await ProxyService.strategy.getBusiness(
        businessId: ProxyService.box.getBusinessId()!,
      );
      if (business == null) {
        talker.warning("Skipping Firebase messaging setup: Business is null");
        return;
      }

      // Android + iOS (macOS/Windows skip FCM).
      if (!Platform.isWindows && !isMacOs) {
        try {
          final messaging = FirebaseMessagingService();
          await messaging
              .initializeFirebaseMessagingAndSubscribeToBusinessNotifications();

          final token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            business.deviceToken = token;
            final businessId = business.id;
            if (businessId.isNotEmpty) {
              await Supabase.instance.client.from('businesses').update({
                'device_token': token,
              }).eq('id', businessId);
            }
            talker.info('Firebase messaging token registered');
          } else {
            talker.warning('Failed to get Firebase messaging token');
          }
        } catch (e) {
          talker.error('Firebase messaging setup failed: $e');
        }
      }
    } catch (e, stackTrace) {
      talker.error("Firebase messaging initialization failed: $e", stackTrace);
    }
  }

  /// Disposes all active timers and stream subscriptions
  void dispose() {
    // Cancel all timers
    for (final timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();

    // Cancel delegation stream subscription
    _delegationsSubscription?.cancel();
    _delegationsSubscription = null;
    _delegationMonitoringDeviceId = null;

    talker.info("CronService disposed");
  }

  /// Checks if running in a test environment
  bool isTestEnvironment() {
    return const bool.fromEnvironment('FLUTTER_TEST_ENV') == true;
  }

  /// Converts camelCase to snake_case
  static String camelToSnakeCase(String input) {
    if (input.isEmpty) {
      return input;
    }

    return input.replaceAllMapped(
      RegExp(r'([A-Z])'),
      (Match match) => '_${match.group(1)!.toLowerCase()}',
    );
  }

  /// Platform detection helpers
  bool get isMacOs => defaultTargetPlatform == TargetPlatform.macOS;
  bool get isIos => defaultTargetPlatform == TargetPlatform.iOS;

  /// Legacy: auto-completes MoMo transactions stuck in [WAITING_MOMO_COMPLETE]
  /// long enough. New saves use [COMPLETE] immediately; this clears backlog only.
  /// Concurrency is already guarded by [_runExclusiveTask].
  Future<void> _autoCompleteMomoTransactions() async {
    final branchId = ProxyService.box.getBranchId();
    if (branchId == null) {
      talker.warning("Skipping MoMo auto-complete: Branch ID is null");
      return;
    }

    final momoTransactions = await ProxyService.getStrategy(Strategy.capella)
        .transactions(
      branchId: branchId,
      status: WAITING_MOMO_COMPLETE,
      isExpense: null,
      skipOriginalTransactionCheck: true,
      includeZeroSubTotal: true,
    );

    if (momoTransactions.isEmpty) {
      talker.debug("No MoMo transactions waiting for completion");
      return;
    }

    final now = DateTime.now();
    final transactionsToComplete = momoTransactions
        .where((transaction) {
          if (transaction.createdAt == null) return false;
          return now.difference(transaction.createdAt!).inMinutes >= 1;
        })
        .take(2)
        .toList();

    if (transactionsToComplete.isEmpty) return;

    talker.info(
      "Auto-completing ${transactionsToComplete.length} MoMo transaction(s)",
    );

    for (final transaction in transactionsToComplete) {
      try {
        await ProxyService.getStrategy(Strategy.capella).updateTransaction(
          transaction: transaction,
          status: COMPLETE,
          subTotal: transaction.subTotal ?? transaction.cashReceived ?? 0,
        );
      } catch (e) {
        talker.error(
          "Failed to auto-complete transaction ${transaction.id}: $e",
        );
      }
    }
  }
}
