/// Service to manage when navigation is allowed to prevent interrupting user workflows
class NavigationGuardService {
  static final NavigationGuardService _instance =
      NavigationGuardService._internal();
  factory NavigationGuardService() => _instance;
  NavigationGuardService._internal();

  // Track if user is in a critical workflow
  bool _isInCriticalWorkflow = false;
  DateTime _lastUserInteraction = DateTime.now();

  // Critical routes that should not be interrupted
  static const Set<String> _criticalRoutes = {
    'AddProductView',
    'Sell',
    'Payments',
    'PaymentConfirmation',
    'TransactionDetail',
    'CheckOut',
    'NewTicket',
    'AddDiscount',
    'AddToFavorites',
    'ReceiveStock',
  };

  /// Check if navigation is currently allowed
  bool get canNavigate {
    // Don't allow navigation if user is in critical workflow
    if (_isInCriticalWorkflow) return false;

    // Don't allow navigation if user was recently active (within 30 seconds)
    if (DateTime.now().difference(_lastUserInteraction).inSeconds < 30) {
      return false;
    }

    return true;
  }

  /// Mark that user has started a critical workflow
  void startCriticalWorkflow() {
    _isInCriticalWorkflow = true;
  }

  /// Mark that user has finished a critical workflow
  void endCriticalWorkflow() {
    _isInCriticalWorkflow = false;
  }

  /// Update last user interaction time
  void recordUserInteraction() {
    _lastUserInteraction = DateTime.now();
  }

  /// Check if a route is considered critical
  bool isCriticalRoute(String routeName) {
    return _criticalRoutes.contains(routeName);
  }

  /// Reset service state for testing
  void resetForTesting() {
    _isInCriticalWorkflow = false;
    _lastUserInteraction = DateTime.now().subtract(Duration(minutes: 1));
  }
}
