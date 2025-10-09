import 'dart:io';
import 'package:flipper_models/mixins/transaction_delegation_mixin.dart';
import 'package:flipper_models/mixins/TaxController.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flutter/foundation.dart';

/// Real-time transaction delegation service using Ditto observers
/// This replaces the polling-based TransactionDelegationService
class RealtimeDelegationService with TransactionDelegationMixin {
  static final RealtimeDelegationService _instance =
      RealtimeDelegationService._internal();

  factory RealtimeDelegationService() => _instance;

  RealtimeDelegationService._internal();

  bool _isMonitoring = false;

  /// Initialize real-time delegation monitoring
  /// Only runs on desktop platforms and auto-initializes Ditto connection
  Future<void> initialize() async {
    // Only monitor on desktop platforms
    if (!_isDesktopPlatform()) {
      debugPrint('⏭️  Skipping delegation monitoring (not a desktop device)');
      return;
    }

    if (_isMonitoring) {
      debugPrint('⚠️  Delegation monitoring already active');
      return;
    }

    try {
      debugPrint('🚀 Initializing real-time transaction delegation...');

      // Start real-time monitoring (auto-initializes Ditto and waits for connection)
      await startMonitoringDelegations();

      _isMonitoring = true;
      debugPrint('✅ Real-time delegation monitoring active');
    } catch (e) {
      debugPrint('❌ Failed to initialize delegation monitoring: $e');
      rethrow;
    }
  }

  /// Stop monitoring (cleanup)
  Future<void> dispose() async {
    if (!_isMonitoring) {
      return;
    }

    try {
      await stopMonitoringDelegations();
      _isMonitoring = false;
      debugPrint('✅ Delegation monitoring stopped');
    } catch (e) {
      debugPrint('❌ Error stopping delegation monitoring: $e');
    }
  }

  /// Check if running on desktop platform
  bool _isDesktopPlatform() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Get monitoring status
  bool get isMonitoring => _isMonitoring;

  @override
  dynamic createTaxController(ITransaction transaction) {
    // Create and return TaxController instance
    // TaxController is a generic class, we pass the transaction type
    return TaxController<ITransaction>();
  }
}
