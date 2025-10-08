import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flipper_services/transaction_delegation_service.dart';
import 'package:flipper_services/proxy.dart';

/// Example initialization for Transaction Delegation feature
///
/// This file demonstrates how to properly initialize the transaction delegation
/// feature in your Flipper application. Copy the relevant parts to your app's
/// initialization code.

class TransactionDelegationInitializer {
  /// Initialize transaction delegation on app startup
  ///
  /// Call this in your main.dart after WidgetsFlutterBinding.ensureInitialized()
  /// but before runApp().
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   WidgetsFlutterBinding.ensureInitialized();
  ///
  ///   // Initialize delegation
  ///   await TransactionDelegationInitializer.initialize();
  ///
  ///   runApp(MyApp());
  /// }
  /// ```
  static Future<void> initialize() async {
    try {
      // Check if we're on desktop platform
      final isDesktop =
          Platform.isWindows || Platform.isMacOS || Platform.isLinux;

      if (isDesktop) {
        // Desktop: Start monitoring service
        await _initializeDesktopMonitoring();
      } else {
        // Mobile: Just verify configuration
        await _verifyMobileConfiguration();
      }

      debugPrint('✅ Transaction Delegation initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to initialize Transaction Delegation: $e');
      debugPrint('Stack trace: $stackTrace');
      // Don't throw - allow app to continue without delegation
    }
  }

  /// Initialize desktop monitoring service
  static Future<void> _initializeDesktopMonitoring() async {
    final delegationService = TransactionDelegationService();

    // Check if feature is enabled
    final isEnabled = ProxyService.box.readBool(
          key: 'enableTransactionDelegation',
        ) ??
        false;

    if (isEnabled) {
      await delegationService.startMonitoring();
      debugPrint('🖥️  Desktop monitoring started');
    } else {
      debugPrint('ℹ️  Transaction delegation is disabled');
    }
  }

  /// Verify mobile configuration
  static Future<void> _verifyMobileConfiguration() async {
    final isEnabled = ProxyService.box.readBool(
          key: 'enableTransactionDelegation',
        ) ??
        false;

    if (isEnabled) {
      debugPrint('📱 Mobile delegation enabled');
    } else {
      debugPrint('ℹ️  Transaction delegation is disabled');
    }
  }

  /// Enable delegation programmatically
  ///
  /// Useful for initial setup or testing
  static Future<void> enable() async {
    await ProxyService.box.writeBool(
      key: 'enableTransactionDelegation',
      value: true,
    );

    // If on desktop, start monitoring
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final delegationService = TransactionDelegationService();
      await delegationService.startMonitoring();
    }

    debugPrint('✅ Transaction delegation enabled');
  }

  /// Disable delegation programmatically
  static Future<void> disable() async {
    await ProxyService.box.writeBool(
      key: 'enableTransactionDelegation',
      value: false,
    );

    // If on desktop, stop monitoring
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      final delegationService = TransactionDelegationService();
      delegationService.stopMonitoring();
    }

    debugPrint('ℹ️  Transaction delegation disabled');
  }

  /// Check if delegation is currently enabled
  static bool isEnabled() {
    return ProxyService.box.readBool(
          key: 'enableTransactionDelegation',
        ) ??
        false;
  }

  /// Get current monitoring status (desktop only)
  static bool isMonitoring() {
    if (!_isDesktop()) {
      return false;
    }

    final delegationService = TransactionDelegationService();
    return delegationService.isMonitoring;
  }

  /// Check if running on desktop
  static bool _isDesktop() {
    return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
  }

  /// Force a manual check for delegated transactions (desktop only)
  ///
  /// Useful for testing or debugging
  static Future<void> checkNow() async {
    if (!_isDesktop()) {
      throw Exception('Manual checks only available on desktop platforms');
    }

    final delegationService = TransactionDelegationService();
    await delegationService.checkNow();
    debugPrint('✅ Manual delegation check completed');
  }
}

/// Widget to add to your app's settings page
/// 
/// Example usage:
/// ```dart
/// import 'package:flipper_dashboard/widgets/transaction_delegation_settings.dart';
/// 
/// class SettingsPage extends StatelessWidget {
///   @override
///   Widget build(BuildContext context) {
///     return Scaffold(
///       appBar: AppBar(title: Text('Settings')),
///       body: ListView(
///         children: [
///           // ... other settings ...
///           TransactionDelegationSettings(),
///           // ... more settings ...
///         ],
///       ),
///     );
///   }
/// }
/// ```

/// Widget to add to transaction displays (optional)
/// 
/// Example usage:
/// ```dart
/// import 'package:flipper_dashboard/widgets/transaction_delegation_status_widget.dart';
/// 
/// class TransactionItem extends StatelessWidget {
///   final ITransaction transaction;
///   
///   @override
///   Widget build(BuildContext context) {
///     return Column(
///       children: [
///         // ... transaction details ...
///         
///         // Show delegation status if applicable
///         TransactionDelegationStatusWidget(
///           transactionId: transaction.id,
///           showActions: true,
///         ),
///       ],
///     );
///   }
/// }
/// ```

/// Example of how to use delegation in your code
/// 
/// The delegation happens automatically in TaxController.printReceipt(),
/// but you can check status manually:
/// 
/// ```dart
/// import 'package:flipper_models/mixins/TaxController.dart';
/// 
/// final taxController = TaxController<ITransaction>(object: transaction);
/// 
/// // Check if transaction was delegated
/// final status = await taxController.getTransactionDelegationStatus(
///   transaction.id,
/// );
/// 
/// if (status == TransactionDelegationStatus.delegated) {
///   print('Transaction is waiting for desktop processing');
/// } else if (status == TransactionDelegationStatus.completed) {
///   print('Desktop has completed processing');
/// } else if (status == TransactionDelegationStatus.error) {
///   final error = await taxController.getDelegationError(transaction.id);
///   print('Error: $error');
///   // Optionally retry
///   await taxController.retryDelegation(transaction.id);
/// }
/// ```
