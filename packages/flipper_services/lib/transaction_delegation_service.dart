import 'dart:async';
import 'dart:io';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/db_model_export.dart';

/// Service to monitor and process delegated transactions on desktop
/// This service runs in the background on desktop machines and watches
/// for transactions that mobile devices have delegated for processing
class TransactionDelegationService {
  Timer? _monitoringTimer;
  bool _isMonitoring = false;
  static const Duration _checkInterval = Duration(seconds: 10);

  static final TransactionDelegationService _instance =
      TransactionDelegationService._internal();

  factory TransactionDelegationService() => _instance;

  TransactionDelegationService._internal();

  /// Start monitoring for delegated transactions
  /// Only runs on desktop platforms (Windows, macOS, Linux)
  Future<void> startMonitoring() async {
    // Only monitor on desktop platforms
    if (!_isDesktopPlatform()) {
      return;
    }

    // Check if feature is enabled
    final enabled = ProxyService.box.readBool(
      key: 'enableTransactionDelegation',
    );

    if (enabled != true) {
      return;
    }

    if (_isMonitoring) {
      return; // Already monitoring
    }

    _isMonitoring = true;

    // Initial check
    await _checkForDelegatedTransactions();

    // Set up periodic checking
    _monitoringTimer = Timer.periodic(_checkInterval, (_) async {
      await _checkForDelegatedTransactions();
    });
  }

  /// Stop monitoring
  void stopMonitoring() {
    _monitoringTimer?.cancel();
    _monitoringTimer = null;
    _isMonitoring = false;
  }

  /// Check for delegated transactions and process them
  Future<void> _checkForDelegatedTransactions() async {
    try {
      final taxController = TaxController<ITransaction>();
      await taxController.monitorDelegatedTransactions();
    } catch (e) {
      // Log error but continue monitoring
      ProxyService.notie.sendData(
        'Error checking delegated transactions: $e',
      );
    }
  }

  /// Check if running on desktop platform
  bool _isDesktopPlatform() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Get monitoring status
  bool get isMonitoring => _isMonitoring;

  /// Manually trigger a check (useful for testing or forcing a check)
  Future<void> checkNow() async {
    if (!_isDesktopPlatform()) {
      throw Exception('Manual checks only available on desktop platforms');
    }

    await _checkForDelegatedTransactions();
  }
}
