import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_services/navigation_guard_service.dart';
// flutter test test/navigation_guard_service_test.dart
void main() {
  group('NavigationGuardService', () {
    late NavigationGuardService service;

    setUp(() {
      service = NavigationGuardService();
      service.resetForTesting();
    });

    test('should be singleton', () {
      final service1 = NavigationGuardService();
      final service2 = NavigationGuardService();
      expect(service1, same(service2));
    });

    test('should allow navigation by default', () {
      expect(service.canNavigate, isTrue);
    });

    test('should block navigation during critical workflow', () {
      service.startCriticalWorkflow();
      expect(service.canNavigate, isFalse);
      
      service.endCriticalWorkflow();
      expect(service.canNavigate, isTrue);
    });

    test('should block navigation for recent user interaction', () {
      service.recordUserInteraction();
      expect(service.canNavigate, isFalse);
    });

    test('should identify critical routes correctly', () {
      expect(service.isCriticalRoute('CheckOut'), isTrue);
      expect(service.isCriticalRoute('Payments'), isTrue);
      expect(service.isCriticalRoute('Home'), isFalse);
    });
  });
}