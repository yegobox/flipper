import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
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
import 'package:flutter/foundation.dart' hide Category;
// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:ditto_live/ditto_live.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_models/sync/ditto_sync_coordinator.dart';

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
    if (!isMobileDevice) {
      // Get branchId and validate it's not null
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        talker.warning(
          'Skipping delegation monitoring: Branch ID is null. Will retry when branch is set.',
        );
      } else {
        try {
          // Get devices for this branch
          final devices = await ProxyService.getStrategy(
            Strategy.capella,
          ).getDevicesByBranch(branchId: branchId);

          // Check if devices list is not empty
          if (devices.isEmpty) {
            talker.warning(
              'Skipping delegation monitoring: No devices found for branch $branchId',
            );
          } else {
            final deviceId = devices.first.id;
            talker.info(
              'Setting up delegation monitoring for device $deviceId on branch $branchId',
            );

            // Cancel any existing subscription to avoid duplicates
            await _delegationsSubscription?.cancel();

            // Create and store the stream subscription
            _delegationsSubscription = ProxyService.getStrategy(Strategy.capella)
                .delegationsStream(
                  branchId: branchId,
                  status: 'delegated',
                  onDeviceId: deviceId,
                )
                .listen((delegations) async {
                  /// show notification of received delegation
                  if (delegations.isNotEmpty && delegations.length > 0) {
                    ProxyService.notification.sendLocalNotification(
                      body: 'Received ${delegations.length} delegations',
                    );
                  }
                  for (TransactionDelegation delegation in delegations) {
                    try {
                      talker.info(
                        "📱 Delegation received: ${delegation.transactionId} from ${delegation.delegatedFromDevice}",
                      );

                      // Fetch the transaction
                      final transactions = await ProxyService.getStrategy(
                        Strategy.capella,
                      ).transactions(id: delegation.transactionId);
                      final transaction = transactions.isNotEmpty
                          ? transactions.first
                          : null;

                      if (transaction == null) {
                        talker.error(
                          "Transaction not found for delegation: ${delegation.transactionId}",
                        );
                        continue;
                      }

                      // Extract parameters from additionalData
                      final additionalData = delegation.additionalData ?? {};
                      final salesSttsCd =
                          additionalData['salesSttsCd'] as String? ?? '02';
                      final purchaseCode =
                          additionalData['purchaseCode'] as String?;
                      List<Counter> _counters = await ProxyService.getStrategy(
                        Strategy.capella,
                      ).getCounters(branchId: branchId, fetchRemote: false);
                      final int highestInvcNo = _counters.fold<int>(
                        0,
                        (prev, c) => math.max(prev, c.invcNo ?? 0),
                      );

                      final sarTyCd = additionalData['sarTyCd'] as String?;

                      // Create TaxController instance
                      final taxController = TaxController<ITransaction>(
                        object: transaction,
                      );

                      talker.info(
                        "🖨️  Processing receipt for delegation: ${delegation.receiptType}",
                      );

                      // update the transaction with new originalInvoiceNumber
                      transaction.invoiceNumber = highestInvcNo;
                      await repository.upsert<ITransaction>(transaction);

                      Customer? customer;
                      try {
                        customer = await ProxyService.strategy.customerById(
                          transaction.customerId!,
                        );
                        talker.info(
                          'Resolved customer from id: ${customer?.id}',
                        );
                      } catch (e) {
                        talker.warning(
                          'Failed to resolve customer for id ${transaction.customerId}: $e',
                        );
                      }
                      String custMblNo = transaction.customerPhone!;
                      String customerName = transaction.customerName!;
                      // Call printReceipt with delegation parameters
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
                      );

                      if (result.response.resultCd == "000") {
                        talker.info(
                          "✅ Receipt printed successfully for delegation: ${delegation.transactionId}",
                        );

                        // Update delegation status to completed
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

                        // Update delegation status to failed
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
                        "❌ Error processing delegation ${delegation.transactionId}: $e",
                        stackTrace,
                      );

                      // Update delegation status to failed
                      try {
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
                    }
                  }
                });
          }
        } catch (e, stackTrace) {
          talker.error('Failed to setup delegation monitoring: $e', stackTrace);
        }
      }
    }
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
      await ProxyService.strategy.hydrateSars(branchId: branchId);
      if (queueLength == 0) {
        talker.warning("Empty queue detected, hydrating data from remote");
        final businessId = ProxyService.box.getBusinessId()!;
        talker.info("Hydrating data for businessId: $businessId");

        /// end of work around
        // Hydrate essential data
        try {
          // Skip fetchNotices if on mobile device and URI is localhost
          if (isMobileDevice && (uri?.contains('localhost') ?? false)) {
            talker.info(
              "Skipping fetchNotices on mobile device with localhost URI",
            );
          } else {
            await ProxyService.tax.fetchNotices(URI: uri!);
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

      // Only setup on supported platforms
      if (!Platform.isWindows && !isMacOs && !isIos) {
        try {
          String? token = await FirebaseMessaging.instance.getToken();
          if (token != null) {
            business.deviceToken = token;
            talker.info("Firebase messaging token registered");
          } else {
            talker.warning("Failed to get Firebase messaging token");
          }
        } catch (e) {
          talker.error("Firebase messaging setup failed: $e");
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

    final momoTransactions = await ProxyService.strategy.transactions(
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
        await ProxyService.strategy.updateTransaction(
          transaction: transaction,
          status: COMPLETE,
          subTotal: transaction.subTotal ?? transaction.cashReceived ?? 0,
          skipDittoSync: true,
        );
      } catch (e) {
        talker.error(
          "Failed to auto-complete transaction ${transaction.id}: $e",
        );
      }
    }

    for (final transaction in transactionsToComplete) {
      unawaited(DittoSyncCoordinator.instance.notifyLocalUpsert(transaction));
    }
  }
}
