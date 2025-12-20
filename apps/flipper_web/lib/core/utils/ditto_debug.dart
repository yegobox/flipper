import 'package:flipper_web/services/ditto_service.dart';
import 'ditto_singleton.dart';

/// Debug utility to help diagnose Ditto initialization issues
class DittoDebug {
  /// Comprehensive check of Ditto initialization state
  static void checkInitializationState() {
    print('🔍=== Ditto Debug State Check ===');
    
    // Check singleton state
    final singletonStatus = DittoSingleton.instance.getInitializationStatus();
    print('Singleton Status: $singletonStatus');
    print('Singleton Ditto Instance: ${DittoSingleton.instance.ditto != null ? "Available" : "NULL"}');
    
    // Check service state
    final serviceHasInstance = DittoService.instance.dittoInstance != null;
    final serviceIsReady = DittoService.instance.isReady();
    final serviceIsActuallyReady = DittoService.instance.isActuallyReady();
    print('Service Ditto Instance: ${serviceHasInstance ? "Available" : "NULL"}');
    print('Service isReady(): $serviceIsReady');
    print('Service isActuallyReady(): $serviceIsActuallyReady');
    
    print('🔍=== End Ditto Debug State Check ===\n');
  }
  
  /// Check if Ditto is properly initialized across both singleton and service
  static bool isFullyInitialized() {
    final singletonReady = DittoSingleton.instance.isReady;
    final serviceReady = DittoService.instance.isReady();
    final serviceActuallyReady = DittoService.instance.isActuallyReady();
    
    return singletonReady && serviceReady && serviceActuallyReady;
  }
  
  /// Print detailed debug information when Ditto is not initialized
  static void printInitializationError(String context) {
    print('❌ Ditto not initialized - Debug information for: $context');
    checkInitializationState();
  }
}