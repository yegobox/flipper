// test/features/totp/providers/totp_notifier_test.dart
import 'package:flipper_auth/core/providers.dart';
import 'package:flipper_auth/features/auth/repositories/account_repository.dart';
import 'package:flipper_auth/features/totp/providers/providers/totp_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod/riverpod.dart';
import 'package:flipper_auth/core/services/totp_service.dart';

class MockAccountRepository extends Mock implements AccountRepository {}

class MockTOTPService extends Mock implements TOTPService {}

void main() {
  late MockAccountRepository mockAccountRepository;
  late MockTOTPService mockTOTPService;
  late ProviderContainer container;

  setUp(() {
    mockAccountRepository = MockAccountRepository();
    mockTOTPService = MockTOTPService();
    container = ProviderContainer(
      overrides: [
        accountRepositoryProvider.overrideWithValue(mockAccountRepository),
        totpServiceProvider.overrideWithValue(mockTOTPService),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('TOTPNotifier', () {
    test('loadAccounts succeeds', () async {
      // Arrange
      final accounts = [
        {
          'issuer': 'Test',
          'account_name': 'test@example.com',
          'secret': 'secret'
        },
      ];
      when(() => mockAccountRepository.fetchAccounts())
          .thenAnswer((_) async => accounts);

      // Act
      await container.read(totpNotifierProvider.notifier).loadAccounts();

      // Assert
      expect(container.read(totpNotifierProvider).accounts, accounts);
    });

    test('addAccount succeeds', () async {
      // Arrange
      final account = {
        'issuer': 'Test',
        'account_name': 'test@example.com',
        'secret': 'secret'
      };
      when(() => mockAccountRepository.addAccount(account))
          .thenAnswer((_) async {});
      when(() => mockAccountRepository.fetchAccounts())
          .thenAnswer((_) async => [account]);

      // Act
      await container.read(totpNotifierProvider.notifier).addAccount(account);

      // Assert
      verify(() => mockAccountRepository.addAccount(account)).called(1);
      verify(() => mockAccountRepository.fetchAccounts()).called(1);
      expect(container.read(totpNotifierProvider).accounts, [account]);
    });
  });
}
