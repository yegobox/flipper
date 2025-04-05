import 'dart:async';

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
      final daysSinceLastConnection = _calculateDaysBetween(
        lastConnectionTimestamp, 
        currentTime
      );
      
      talker.info('Days since last internet connection: $daysSinceLastConnection');
      
      // Check if internet connection is required
      if (daysSinceLastConnection >= _requiredConnectionIntervalDays) {
        // Check current internet connectivity
        final isConnected = await _checkInternetConnectivity();
        
        if (isConnected) {
          // If connected, update the last connection timestamp
          _updateLastConnectionTimestamp();
          
          talker.info('Internet connection requirement satisfied');
          
          // If we were on a connection required screen, navigate back to the main app
          if (_isOnConnectionRequiredScreen) {
            talker.info('Returning to main app after successful internet connection');
            _clearConnectionRequiredScreenFlag();
            _routerService.navigateTo(FlipperAppRoute());
          }
          
          return true;
        } else {
          // Not connected and connection is required
          talker.warning('Internet connection required but not available');
          _setOnConnectionRequiredScreen();
          // Navigate to the internet connection required screen
          // We use NoNetRoute as a temporary solution since it's an existing route for internet connectivity issues
          _routerService.navigateTo(NoNetRoute());
          return false;
        }
      }
      
      // Connection not required yet
      return true;
    } catch (e) {
      talker.error('Error during internet connection check: $e');
      return false;
    }
  }

  /// Force immediate internet connection check
  /// This can be called from any part of the app when internet connection verification is needed
  Future<bool> forceInternetConnectionCheck() async {
    final isConnected = await _checkInternetConnectivity();
    
    if (isConnected) {
      _updateLastConnectionTimestamp();
      talker.info('Forced internet connection check successful');
      return true;
    } else {
      talker.warning('Forced internet connection check failed - internet not available');
      return false;
    }
  }
  
  /// Get the timestamp of the last successful internet connection
  int _getLastConnectionTimestamp() {
    return ProxyService.box.readInt(key: _lastConnectionKey) ?? 0;
  }
  
  /// Update the timestamp of the last successful internet connection to current time
  void _updateLastConnectionTimestamp() {
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    ProxyService.box.writeInt(key: _lastConnectionKey, value: currentTime);
    talker.info('Last internet connection timestamp updated: $currentTime');
  }
  
  /// Calculate the number of days between two timestamps
  int _calculateDaysBetween(int startTimestamp, int endTimestamp) {
    if (startTimestamp == 0) return _requiredConnectionIntervalDays; // Force connection on first run
    
    final difference = endTimestamp - startTimestamp;
    final daysDifference = difference / (1000 * 60 * 60 * 24);
    return daysDifference.floor();
  }
  
  /// Check if the device currently has internet connectivity
  Future<bool> _checkInternetConnectivity() async {
    try {
      // Use the ProxyService.http client to make a simple request to check connectivity
      final response = await ProxyService.http.get(Uri.parse('https://google.com'));
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      talker.error('Internet connectivity check failed: $e');
      return false;
    }
  }
}
