// test/features/auth/providers/auth_notifier_test.dart
import 'package:flipper_auth/core/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flipper_auth/core/services/auth_service.dart';
import 'package:flipper_auth/features/auth/providers/auth_notifier.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockAuthService mockAuthService;
  late ProviderContainer container;

  setUp(() {
    mockAuthService = MockAuthService();
    container = ProviderContainer(
      overrides: [
        authServiceProvider.overrideWithValue(mockAuthService),
      ],
    );
  });

  group('AuthNotifier', () {
    test('signIn succeeds', () async {
      // Arrange
      when(() => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => AuthResponse());

      // Act
      await container.read(authNotifierProvider.notifier).signIn(
            email: 'test@example.com',
            password: 'password',
          );

      // Assert
      expect(container.read(authNotifierProvider).isAuthenticated, true);
    });

    test('signIn fails', () async {
      // Arrange
      when(() => mockAuthService.signIn(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception('Login failed'));

      // Act
      await container.read(authNotifierProvider.notifier).signIn(
            email: 'test@example.com',
            password: 'password',
          );

      // Assert
      expect(container.read(authNotifierProvider).error,
          'Exception: Login failed');
    });
  });
}
