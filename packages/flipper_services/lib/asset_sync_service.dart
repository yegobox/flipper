import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:flipper_services/proxy.dart';

/// Service responsible for automatically synchronizing offline assets
/// when connectivity is restored.
class AssetSyncService {
  static final AssetSyncService _instance = AssetSyncService._internal();
  factory AssetSyncService() => _instance;

  AssetSyncService._internal();

  final talker = TalkerFlutter.init();

  // Connectivity subscription
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  // Timer for periodic sync attempts
  Timer? _syncTimer;

  // Flag to prevent multiple syncs running simultaneously
  bool _isSyncing = false;

  // Stream controller for sync status updates
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  /// Initialize the service and start listening for connectivity changes
  void initialize() {
    talker.info('AssetSyncService: Initializing');

    // Start listening for connectivity changes
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen(_handleConnectivityChange);

    // Check initial connectivity
    Connectivity().checkConnectivity().then((results) {
      _handleConnectivityChange(results);
    });

    // Start periodic sync timer (every 15 minutes)
    _syncTimer = Timer.periodic(const Duration(minutes: 15), (_) {
      _checkAndSyncAssets();
    });
  }

  /// Handle connectivity changes
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    // Check if we have any active connection
    final hasConnection =
        results.any((result) => result != ConnectivityResult.none);

    if (hasConnection) {
      talker.info(
          'AssetSyncService: Connectivity restored, checking for pending uploads');
      _checkAndSyncAssets();
    }
  }

  /// Check for pending uploads and sync if needed
  Future<void> _checkAndSyncAssets() async {
    // Prevent multiple syncs running simultaneously
    if (_isSyncing) {
      talker.info('AssetSyncService: Sync already in progress, skipping');
      return;
    }

    try {
      _isSyncing = true;

      // Check if there are any offline assets
      final hasOfflineAssets = await ProxyService.strategy.hasOfflineAssets();

      if (!hasOfflineAssets) {
        _isSyncing = false;
        return;
      }

      // Check for internet connectivity
      final connectivityResults = await Connectivity().checkConnectivity();
      final hasConnection = connectivityResults
          .any((result) => result != ConnectivityResult.none);

      if (!hasConnection) {
        _isSyncing = false;
        return;
      }

      // Notify listeners that sync is starting
      _syncStatusController.add(SyncStatus(
        status: SyncState.inProgress,
        message: 'Syncing offline assets...',
      ));

      // Sync offline assets
      final uploadedAssets = await ProxyService.strategy.syncOfflineAssets();

      // Notify listeners that sync is complete
      _syncStatusController.add(SyncStatus(
        status: SyncState.completed,
        message: 'Synced ${uploadedAssets.length} assets',
        count: uploadedAssets.length,
      ));

      talker.info(
          'AssetSyncService: Successfully synced ${uploadedAssets.length} assets');
    } catch (e, s) {
      talker.error('AssetSyncService: Error syncing assets: $e');
      talker.error(s);

      // Notify listeners of error
      _syncStatusController.add(SyncStatus(
        status: SyncState.error,
        message: 'Error syncing assets: $e',
      ));
    } finally {
      _isSyncing = false;
    }
  }

  /// Manually trigger a sync (can be called from UI)
  Future<void> syncNow() async {
    talker.info('AssetSyncService: Manual sync triggered');
    return _checkAndSyncAssets();
  }

  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _syncTimer?.cancel();
    _syncStatusController.close();
  }
}

/// Enum representing the current state of sync
enum SyncState {
  idle,
  inProgress,
  completed,
  error,
}

/// Class representing the current status of sync
class SyncStatus {
  final SyncState status;
  final String message;
  final int count;

  SyncStatus({
    required this.status,
    required this.message,
    this.count = 0,
  });
}
