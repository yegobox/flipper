import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/proxy.dart';
import 'package:stacked_services/stacked_services.dart';

/// Exception thrown when internet connection is required.
class InternetConnectionRequiredException implements Exception {
  final String message;
  InternetConnectionRequiredException(this.message);

  @override
  String toString() => message;
}

/// Service responsible for enforcing periodic internet connection requirements.
/// Forces users to connect to the internet every 5 days to continue using the app.
class InternetConnectionService {
  static final InternetConnectionService _instance =
      InternetConnectionService._internal();
  final _routerService = locator<RouterService>();
  Timer? _connectionCheckTimer;

  // Key for storing the last connection timestamp in local storage
  static const String _lastConnectionKey = 'last_internet_connection_timestamp';

  // The number of days after which internet connection is required
  static const int _requiredConnectionIntervalDays = 5;

  /// Singleton instance
  factory InternetConnectionService() {
    return _instance;
  }

  InternetConnectionService._internal();

  /// Starts periodic internet connection check
  /// [intervalHours] defines how often to check (defaults to 6 hours)
  void startPeriodicConnectionCheck({int intervalHours = 6}) {
    stopPeriodicConnectionCheck();

    _connectionCheckTimer = Timer.periodic(
      Duration(hours: intervalHours),
      (_) => checkInternetConnectionRequirement(),
    );

    talker.info(
        'Internet connection check service started with interval of $intervalHours hours');
  }

  /// Stops periodic internet connection check
  void stopPeriodicConnectionCheck() {
    _connectionCheckTimer?.cancel();
    _connectionCheckTimer = null;
  }

  /// Flag to track if we're currently on a connection required screen
  bool _isOnConnectionRequiredScreen = false;

  /// Set when navigating to a connection required screen
  void _setOnConnectionRequiredScreen() {
    _isOnConnectionRequiredScreen = true;
    talker.info('Connection required screen flag set to true');
  }

  /// Set when navigating back to the main app
  void _clearConnectionRequiredScreenFlag() {
    _isOnConnectionRequiredScreen = false;
    talker.info('Connection required screen flag set to false');
  }

  /// Checks if the user needs to connect to the internet based on the last connection time
  /// Returns true if connection requirement is satisfied, otherwise navigates to connection required screen
  /// and returns false
  Future<bool> checkInternetConnectionRequirement() async {
    talker.info('Checking internet connection requirement');

    try {
      // Get the last connection timestamp
      final lastConnectionTimestamp = _getLastConnectionTimestamp();
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      // Calculate days since last connection
      final daysSinceLastConnection =
          _calculateDaysBetween(lastConnectionTimestamp, currentTime);

      talker.info(
          'Days since last internet connection: $daysSinceLastConnection');

      // Check if internet connection is required
      if (daysSinceLastConnection >= _requiredConnectionIntervalDays) {
        // Check current internet connectivity with multiple attempts
        final isConnected = await _checkInternetConnectivity();

        if (isConnected) {
          // If connected, update the last connection timestamp
          _updateLastConnectionTimestamp();

          talker.info('Internet connection requirement satisfied');

          // If we were on a connection required screen, navigate back to the main app
          if (_isOnConnectionRequiredScreen) {
            talker.info(
                'Returning to main app after successful internet connection');
            _clearConnectionRequiredScreenFlag();
            _routerService.navigateTo(FlipperAppRoute());
          }

          return true;
        } else {
          // Not connected and connection is required
          talker.warning('Internet connection required but not available');

          // Only navigate to connection required screen if we're not already there
          if (!_isOnConnectionRequiredScreen) {
            _setOnConnectionRequiredScreen();
            _routerService.navigateTo(NoNetRoute());
          }

          return false;
        }
      }

      // Connection not required yet
      talker.info('Internet connection not required yet');
      return true;
    } catch (e) {
      talker.error('Error during internet connection check: $e');
      return false;
    }
  }

  /// Force immediate internet connection check
  /// This can be called from any part of the app when internet connection verification is needed
  Future<bool> forceInternetConnectionCheck() async {
    talker.info('Forcing internet connection check');
    final isConnected = await _checkInternetConnectivity();

    if (isConnected) {
      _updateLastConnectionTimestamp();
      talker.info('Forced internet connection check successful');
      return true;
    } else {
      talker.warning(
          'Forced internet connection check failed - internet not available');
      return false;
    }
  }

  /// Get the timestamp of the last successful internet connection
  int _getLastConnectionTimestamp() {
    final timestamp = ProxyService.box.readInt(key: _lastConnectionKey) ?? 0;
    talker.info('Retrieved last connection timestamp: $timestamp');
    return timestamp;
  }

  /// Update the timestamp of the last successful internet connection to current time
  void _updateLastConnectionTimestamp() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    ProxyService.box.writeInt(key: _lastConnectionKey, value: currentTime);
    talker.info('Last internet connection timestamp updated: $currentTime');
  }

  /// Calculate the number of days between two timestamps
  int _calculateDaysBetween(int startTimestamp, int endTimestamp) {
    if (startTimestamp == 0) {
      talker.info('First run detected, forcing connection requirement');
      return _requiredConnectionIntervalDays; // Force connection on first run
    }

    final difference = endTimestamp - startTimestamp;
    final daysDifference = difference / (1000 * 60 * 60 * 24);
    final days = daysDifference.floor();

    talker.info(
        'Calculated days difference: $days (from timestamps: $startTimestamp to $endTimestamp)');
    return days;
  }

  /// Check if the device currently has internet connectivity
  /// Uses multiple methods to ensure accurate connectivity detection
  Future<bool> _checkInternetConnectivity() async {
    talker.info('Starting internet connectivity check');

    // List of reliable endpoints to test
    final testUrls = [
      'https://www.google.com',
      'https://www.cloudflare.com',
      'https://www.microsoft.com',
      'https://httpbin.org/status/200',
    ];

    // Try socket connection first (fastest method)
    try {
      talker.info('Attempting socket connection test');
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        talker.info('Socket connection test successful');

        // Verify with HTTP request to be sure
        return await _verifyHttpConnection(testUrls);
      }
    } catch (e) {
      talker.warning('Socket connection test failed: $e');
    }

    // If socket test fails, try HTTP requests
    return await _verifyHttpConnection(testUrls);
  }

  /// Verify internet connection using HTTP requests
  Future<bool> _verifyHttpConnection(List<String> testUrls) async {
    talker.info('Starting HTTP connection verification');

    for (final url in testUrls) {
      try {
        talker.info('Testing connection to: $url');

        final response = await ProxyService.http
            .get(Uri.parse(url))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode >= 200 && response.statusCode < 400) {
          talker.info(
              'HTTP connection test successful for: $url (Status: ${response.statusCode})');
          return true;
        } else {
          talker.warning(
              'HTTP connection test failed for: $url (Status: ${response.statusCode})');
        }
      } catch (e) {
        talker.warning('HTTP connection test error for $url: $e');
        continue; // Try next URL
      }
    }

    talker.error('All HTTP connection tests failed');
    return false;
  }

  /// Get the number of days remaining before internet connection is required
  int getDaysUntilConnectionRequired() {
    final lastConnectionTimestamp = _getLastConnectionTimestamp();
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final daysSinceLastConnection =
        _calculateDaysBetween(lastConnectionTimestamp, currentTime);

    final daysRemaining =
        _requiredConnectionIntervalDays - daysSinceLastConnection;
    return daysRemaining < 0 ? 0 : daysRemaining;
  }

  /// Check if internet connection is currently required
  bool isConnectionRequired() {
    return getDaysUntilConnectionRequired() <= 0;
  }

  /// Reset the connection requirement (for testing purposes)
  void resetConnectionRequirement() {
    ProxyService.box.remove(key: _lastConnectionKey);
    talker.info('Connection requirement reset');
  }

  /// Check if the device currently has an internet connection
  /// Returns true if online, false if offline
  Future<bool> isOnline({bool deepCheck = false}) async {
    talker.info('Checking if device is online (deepCheck: $deepCheck)');

    if (deepCheck) {
      return await _checkInternetConnectivity();
    }

    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (e) {
      talker.warning('Simple connectivity check failed: $e');
      return false;
    }
  }
}
