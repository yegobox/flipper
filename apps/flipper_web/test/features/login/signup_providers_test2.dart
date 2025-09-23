import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flipper_web/features/login/signup_providers.dart';
import 'package:flipper_web/repositories/signup_repository.dart';
import 'package:flipper_web/models/business_type.dart';

// Mock repository for testing
class MockSignupRepository extends SignupRepository {
  bool checkUsernameResult = true;
  Map<String, dynamic> registerUserResult = {};
  String? errorMessage;

  List<String> checkedUsernames = [];
  List<RegisteredUser> registeredUsers = [];

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    checkedUsernames.add(username);
    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
    return checkUsernameResult;
  }

  @override
  Future<Map<String, dynamic>> registerBusiness({
    required String username,
    required String fullName,
    required String businessTypeId,
    required String tinNumber,
    required String country,
    String? phoneNumber,
    Object? userId,
  }) async {
    registeredUsers.add(
      RegisteredUser(
        username: username,
        fullName: fullName,
        businessTypeId: businessTypeId,
        tinNumber: tinNumber,
        country: country,
      ),
    );

    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
    return registerUserResult;
  }
}

class RegisteredUser {
  final String username;
  final String fullName;
  final String businessTypeId;
  final String tinNumber;
  final String country;

  RegisteredUser({
    required this.username,
    required this.fullName,
    required this.businessTypeId,
    required this.tinNumber,
    required this.country,
  });
}

// Custom test wrapper that provides the overriden providers
class TestWrapper extends StatelessWidget {
  final Widget child;
  final MockSignupRepository mockRepository;

  const TestWrapper({
    super.key,
    required this.child,
    required this.mockRepository,
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        signupRepositoryProvider.overrideWithValue(mockRepository),
        businessTypesProvider.overrideWithValue([
          BusinessType(id: '1', typeName: 'Flipper Retailer'),
          BusinessType(id: '2', typeName: 'Individual'),
        ]),
        countriesProvider.overrideWithValue(['Rwanda', 'Kenya', 'Uganda']),
      ],
      child: MaterialApp(home: child),
    );
  }
}

void main() {
  late MockSignupRepository mockRepository;

  setUp(() {
    mockRepository = MockSignupRepository();
    // Ignore overflow errors in tests
    debugDisableShadows = true;
    debugPaintSizeEnabled = false;
  });

  // Tests for signup repository
  group('SignupRepository', () {
    test('checkUsernameAvailability returns repository result', () async {
      mockRepository.checkUsernameResult = true;
      final result = await mockRepository.checkUsernameAvailability(
        'test_user',
      );
      expect(result, isTrue);
      expect(mockRepository.checkedUsernames, contains('test_user'));
    });

    test('registerUser adds user to registered users list', () async {
      mockRepository.registerUserResult = {
        'id': '123',
        'username': 'test_user',
      };
      final result = await mockRepository.registerBusiness(
        username: 'test_user',
        fullName: 'Test User',
        businessTypeId: '1',
        tinNumber: '123456789',
        country: 'Rwanda',
      );

      expect(result, isTrue);
      expect(mockRepository.registeredUsers.length, 1);
      expect(
        mockRepository.registeredUsers.first.username,
        equals('test_user'),
      );
    });

    test(
      'repository methods throw exception when errorMessage is set',
      () async {
        mockRepository.errorMessage = 'Test error';

        expect(
          () => mockRepository.checkUsernameAvailability('test_user'),
          throwsException,
        );

        expect(
          () => mockRepository.registerBusiness(
            username: 'test_user',
            fullName: 'Test User',
            businessTypeId: '1',
            tinNumber: '123456789',
            country: 'Rwanda',
          ),
          throwsException,
        );
      },
    );
  });

  // Tests for username validation in the model
  group('Username validation', () {
    test('isValid returns false when username is empty', () {
      final state = SignupFormState(
        username: '',
        fullName: 'Test User',
        businessType: BusinessType(id: '1', typeName: 'Flipper Retailer'),
        tinNumber: '123456789',
        isUsernameAvailable: true,
      );

      expect(state.isValid, isFalse);
    });

    test('isValid returns false when username is too short', () {
      final state = SignupFormState(
        username: 'abc', // too short
        fullName: 'Test User',
        businessType: BusinessType(id: '1', typeName: 'Flipper Retailer'),
        tinNumber: '123456789',
        isUsernameAvailable: true,
      );

      expect(state.isValid, isFalse);
    });

    test('isValid returns false when username is not available', () {
      final state = SignupFormState(
        username: 'validusername',
        fullName: 'Test User',
        businessType: BusinessType(id: '1', typeName: 'Flipper Retailer'),
        tinNumber: '123456789',
        isUsernameAvailable: false,
      );

      expect(state.isValid, isFalse);
    });
  });
}
