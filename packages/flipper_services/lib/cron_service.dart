import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_models/SyncStrategy.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/isolateHandelr.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/drive_service.dart';
import 'package:flipper_services/proxy.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  /// Constants for timer durations
  // static const int _counterSyncMinutes = 40;
  static const int _isolateMessageSeconds = 40;
  static const int _analyticsSyncMinutes = 1;
  // static const int _databaseBackupMinutes = 30;
  // static const int _queueCleanupMinutes = 40;

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
      await _initializeData();
      _setupPeriodicTasks();
      await _configureServices();
      await _setupConnectivity();
      await _setupFirebaseMessaging();

      talker.info("CronService: All scheduled tasks initialized successfully");
    } catch (e, stackTrace) {
      talker.error("CronService initialization failed: $e", stackTrace);
      // Attempt recovery by at least setting up essential services
      _setupEssentialServices();
    }
  }

  /// Initializes data by hydrating from remote if queue is empty
  Future<void> _initializeData() async {
    try {
      final queueLength = await ProxyService.strategy.queueLength();
      if (queueLength == 0) {
        talker.warning("Empty queue detected, hydrating data from remote");

        final branchId = ProxyService.box.getBranchId();
        if (branchId == null) {
          talker.error("Cannot hydrate data: Branch ID is null");
          return;
        }

        // Hydrate essential data
        try {
          await Future.wait<void>([
            ProxyService.strategy
                .ebm(branchId: branchId, fetchRemote: true)
                .then((_) {}),
            ProxyService.strategy
                .getCounters(branchId: branchId, fetchRemote: true)
                .then((_) {}),
            ProxyService.tax.taxConfigs(branchId: branchId).then((_) {}),
            ProxyService.strategy
                .hydrateDate(
                    branchId: (await ProxyService.strategy.activeBranch()).id)
                .then((_) {}),
            //   ProxyService.strategy
            //       .variants(branchId: branchId, fetchRemote: true)
            //       .then((_) {}),
            //   ProxyService.strategy
            //       .transactions(branchId: branchId, fetchRemote: true)
            //       .then((_) {}),
          ]);
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

  /// Sets up all periodic tasks with appropriate error handling
  void _setupPeriodicTasks() {
    // Setup transaction refresh timer (every 10 minutes)
    // This ensures reports have the latest data from all machines
    _activeTimers.add(Timer.periodic(Duration(minutes: 10), (Timer t) async {
      try {
        final branchId = ProxyService.box.getBranchId();
        if (branchId != null) {
          talker.info("Refreshing transactions for reports");
          await ProxyService.strategy
              .transactions(branchId: branchId, fetchRemote: true);
        } else {
          talker.warning("Skipping transaction refresh: Branch ID is null");
        }
      } catch (e) {
        talker.error("Transaction refresh failed: $e");
      }
    }));

    // Setup counter synchronization timer
    // _activeTimers.add(
    //     Timer.periodic(Duration(minutes: _counterSyncMinutes), (Timer t) async {
    //   try {
    //     final branchId = ProxyService.box.getBranchId();
    //     if (branchId != null) {
    //       await ProxyService.strategy
    //           .getCounters(branchId: branchId, fetchRemote: true);
    //     } else {
    //       talker.warning("Skipping counter sync: Branch ID is null");
    //     }
    //   } catch (e) {
    //     talker.error("Counter sync failed: $e");
    //   }
    // }));

    // Setup isolate message timer
    _activeTimers.add(Timer.periodic(Duration(seconds: _isolateMessageSeconds),
        (Timer t) async {
      if (ProxyService.strategy.sendPort != null) {
        try {
          ProxyService.strategy.sendMessageToIsolate();
        } catch (e, stackTrace) {
          talker.error("Failed to send message to isolate: $e", stackTrace);
        }
      }
    }));

    // Setup analytics and patching timer
    _activeTimers.add(Timer.periodic(Duration(minutes: _analyticsSyncMinutes),
        (Timer t) async {
      await _syncAnalyticsAndPatching();
    }));

    // Setup asset download timer
    _activeTimers.add(Timer.periodic(_getDownloadFileSchedule(), (Timer t) {
      try {
        if (!ProxyService.box.doneDownloadingAsset()) {
          ProxyService.strategy.reDownloadAsset();
        }
      } catch (e) {
        talker.error("Asset download failed: $e");
      }
    }));

    // Setup periodic database backup timer
    // _activeTimers.add(Timer.periodic(Duration(minutes: _databaseBackupMinutes),
    //     (Timer t) async {
    //   try {
    //     // Import Repository dynamically to avoid circular dependencies
    //     // This is needed because Repository is in a different package
    //     await _performPeriodicDatabaseBackup();
    //   } catch (e, stackTrace) {
    //     talker.error("Periodic database backup failed: $e", stackTrace);
    //   }
    // }));

    // Setup periodic failed queue cleanup timer
    // _activeTimers.add(Timer.periodic(Duration(minutes: _queueCleanupMinutes),
    //     (Timer t) async {
    //   try {
    //     await _cleanupFailedQueue();
    //   } catch (e, stackTrace) {
    //     talker.error("Failed queue cleanup failed: $e", stackTrace);
    //   }
    // }));
  }

  /// Synchronizes analytics and handles patching operations
  Future<void> _syncAnalyticsAndPatching() async {
    try {
      final branchId = ProxyService.box.getBranchId();
      if (branchId == null) {
        talker.warning("Skipping analytics sync: Branch ID is null");
        return;
      }

      // Update variants if force upsert is enabled
      if (ProxyService.box.forceUPSERT()) {
        await ProxyService.strategy
            .variants(branchId: branchId, fetchRemote: true);
      }

      // Sync analytics
      await ProxyService.strategy.analytics(branchId: branchId);

      // Handle patching if conditions are met
      await _handlePatching();
    } catch (e, stackTrace) {
      talker.error("Analytics and patching sync failed: $e", stackTrace);
    }
  }

  /// Handles patching operations when conditions are appropriate
  Future<void> _handlePatching() async {
    final isTaxServiceStopped = ProxyService.box.stopTaxService();

    // Only proceed if no transaction is in progress and tax service is not stopped
    if (ProxyService.box.transactionInProgress() ||
        isTaxServiceStopped == null ||
        isTaxServiceStopped) {
      return;
    }
    final uri = await ProxyService.box.getServerUrl();
    if (uri == null) {
      talker.warning("Skipping patching: Server URL is null");
      return;
    }

    // Only proceed if patching is not locked
    if (ProxyService.box.lockPatching()) {
      talker.info("Patching is locked, skipping");
      return;
    }

    // Notification callback for patching operations
    final notificationCallback = (String message) {
      ProxyService.notification.sendLocalNotification(body: message);
    };

    // Patch variants
    try {
      await VariantPatch.patchVariant(
        URI: uri,
        sendPort: notificationCallback,
      );
    } catch (e) {
      talker.error("Variant patching failed: $e");
    }

    // Patch transaction items
    try {
      final tinNumber = ProxyService.box.tin();
      final bhfId = await ProxyService.box.bhfId();

      if (bhfId == null) {
        talker.warning("Skipping transaction item patching: BHF ID is null");
        return;
      }

      await PatchTransactionItem.patchTransactionItem(
        tinNumber: tinNumber,
        bhfId: bhfId,
        URI: uri,
        sendPort: notificationCallback,
      );
    } catch (e) {
      talker.error("Transaction item patching failed: $e");
    }
  }

  /// Configures essential services for the app
  Future<void> _configureServices() async {
    try {
      // Clear any custom phone number for payment
      ProxyService.box.remove(key: "customPhoneNumberForPayment");

      // Configure Capella
      await ProxyService.strategy.configureCapella(
        useInMemory: false,
        box: ProxyService.box,
      );

      // Start replicator
      ProxyService.strategy.startReplicator();

      // Set strategy based on platform
      ProxyService.setStrategy(Strategy.bricks);
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
      List<ConnectivityResult> results =
          await Connectivity().checkConnectivity();
      bool hasConnectivity =
          results.any((result) => result != ConnectivityResult.none);

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
      Business? business = await ProxyService.strategy.getBusiness();
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

  /// Disposes all active timers
  void dispose() {
    for (final timer in _activeTimers) {
      timer.cancel();
    }
    _activeTimers.clear();
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

  /// Returns the duration for file download schedule
  Duration _getDownloadFileSchedule() {
    return const Duration(minutes: 2);
  }

  /// Performs a periodic database backup if enough time has passed since the last backup
  /// Uses a more resilient approach to handle potential database closure issues
  Future<void> _performPeriodicDatabaseBackup() async {
    // Skip backup during active transactions to avoid conflicts
    if (ProxyService.box.transactionInProgress()) {
      talker.info('Skipping database backup: transaction in progress');
      return;
    }

    // try {
    //   // Add a small delay to allow any pending database operations to complete
    //   await Future.delayed(const Duration(milliseconds: 500));

    // Call the performPeriodicBackup method on the Repository instance
    // final result = await repo.Repository().performPeriodicBackup(
    //     // Use a longer interval to reduce backup frequency
    //     minInterval: const Duration(minutes: 30));

    //   if (result == true) {
    //     talker.info('Periodic database backup completed successfully');
    //   } else {
    //     talker.info(
    //         'Periodic database backup skipped (not enough time passed since last backup)');
    //   }
    // } catch (e, stackTrace) {
    //   talker.error('Error during periodic database backup: $e', stackTrace);
    //   // Don't retry immediately if there was an error
    // }
  }

  /// Performs cleanup of failed queue items
  /// This removes requests that have failed to sync with Supabase
  Future<void> _cleanupFailedQueue() async {
    // Skip cleanup during active transactions to avoid conflicts
    if (ProxyService.box.transactionInProgress()) {
      talker.info('Skipping failed queue cleanup: transaction in progress');
      return;
    }

    try {
      // Add a small delay to allow any pending operations to complete
      await Future.delayed(const Duration(milliseconds: 500));

      // Call the cleanupFailedRequests method on the Repository instance
      // final deletedCount = await repo.Repository().cleanupFailedRequests();

      // if (deletedCount > 0) {
      //   talker.info(
      //       'Failed queue cleanup: Deleted $deletedCount failed requests');
      // } else {
      //   talker.info('Failed queue cleanup: No failed requests found');
      // }
    } catch (e, stackTrace) {
      talker.error('Error during failed queue cleanup: $e', stackTrace);
      // Don't retry immediately if there was an error
    }
  }

  /// Platform detection helpers
  bool get isMacOs => Platform.isMacOS;
  bool get isIos => Platform.isIOS;
}
