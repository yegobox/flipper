import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/login/signup_providers.dart';
import 'package:flipper_web/repositories/signup_repository.dart';
import 'package:flipper_web/models/business_type.dart';

// Manual mock implementation of SignupRepository
class MockSignupRepository extends SignupRepository {
  bool checkUsernameResult = true;
  Map<String, dynamic> registerUserResult = {};
  String? errorMessage;

  List<String> checkedUsernames = [];
  Map<String, dynamic> lastRegistrationParams = {};

  // Keep track of registered users
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
    lastRegistrationParams = {
      'username': username,
      'fullName': fullName,
      'businessTypeId': businessTypeId,
      'tinNumber': tinNumber,
      'country': country,
      'phoneNumber': phoneNumber,
      'userId': userId,
    };

    registeredUsers.add(
      RegisteredUser(
        username: username,
        fullName: fullName,
        businessTypeId: businessTypeId,
        tinNumber: tinNumber,
        country: country,
        phoneNumber: phoneNumber,
        userId: userId,
      ),
    );

    if (errorMessage != null) {
      throw Exception(errorMessage);
    }
    return registerUserResult;
  }
}

// Helper class to store registration parameters
class RegisteredUser {
  final String username;
  final String fullName;
  final String businessTypeId;
  final String tinNumber;
  final String country;
  final String? phoneNumber;
  final Object? userId;

  RegisteredUser({
    required this.username,
    required this.fullName,
    required this.businessTypeId,
    required this.tinNumber,
    required this.country,
    this.phoneNumber,
    this.userId,
  });
}

void main() {
  late SignupFormNotifier notifier;
  late MockSignupRepository mockRepository;

  late ProviderContainer container;

  setUp(() {
    mockRepository = MockSignupRepository();
    container = ProviderContainer(
      overrides: [signupRepositoryProvider.overrideWithValue(mockRepository)],
    );
    // Keep the provider alive since it is autoDispose
    container.listen(signupFormProvider, (previous, next) {});
    notifier = container.read(signupFormProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  group('SignupFormState', () {
    test('initial state has correct default values', () {
      final state = SignupFormState();
      expect(state.username, equals(''));
      expect(state.fullName, equals(''));
      expect(state.businessType, isNull);
      expect(state.tinNumber, equals(''));
      expect(state.country, equals('Rwanda'));
      expect(state.phoneNumber, isNull);
      expect(state.isSubmitting, equals(false));
      expect(state.errorMessage, isNull);
      expect(state.isCheckingUsername, equals(false));
      expect(state.isUsernameAvailable, isNull);
      expect(state.isValid, equals(false));
    });

    test('copyWith creates a new state with updated values', () {
      final initialState = SignupFormState();
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');

      final updatedState = initialState.copyWith(
        username: 'testuser',
        fullName: 'Test User',
        businessType: businessType,
        tinNumber: '123456789',
        country: 'Kenya',
        isSubmitting: true,
        errorMessage: 'Test error',
        isCheckingUsername: true,
        isUsernameAvailable: true,
      );

      expect(updatedState.username, equals('testuser'));
      expect(updatedState.fullName, equals('Test User'));
      expect(updatedState.businessType, equals(businessType));
      expect(updatedState.tinNumber, equals('123456789'));
      expect(updatedState.country, equals('Kenya'));
      expect(updatedState.isSubmitting, equals(true));
      expect(updatedState.errorMessage, equals('Test error'));
      expect(updatedState.isCheckingUsername, equals(true));
      expect(updatedState.isUsernameAvailable, equals(true));
    });

    test('isValid returns true when all conditions are met', () {
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');

      final state = SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: businessType,
        tinNumber: '123456789',
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      expect(state.isValid, equals(true));
    });

    test('isValid returns false when username is unavailable', () {
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');

      final state = SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: businessType,
        tinNumber: '123456789',
        country: 'Rwanda',
        isUsernameAvailable: false,
      );

      expect(state.isValid, equals(false));
    });

    test('isValid returns false when username is too short', () {
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');

      final state = SignupFormState(
        username: 'usr', // Too short
        fullName: 'Test User',
        businessType: businessType,
        tinNumber: '123456789',
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      expect(state.isValid, equals(false));
    });

    test('isValid returns false when fullName does not have two parts', () {
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');

      final state = SignupFormState(
        username: 'testuser',
        fullName: 'User', // Only one name
        businessType: businessType,
        tinNumber: '123456789',
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      expect(state.isValid, equals(false));
    });

    test('isValid returns false when businessType is null', () {
      final state = SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: null, // Missing business type
        tinNumber: '123456789',
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      expect(state.isValid, equals(false));
    });

    test('isValid accepts empty tinNumber for Individual business type', () {
      final businessType = BusinessType(id: '2', typeName: 'Individual');

      final state = SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: businessType,
        tinNumber: '', // Empty for individual business type is valid
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      expect(state.isValid, equals(true));
    });

    test('isValid requires tinNumber for non-Individual business type', () {
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');

      final state = SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: businessType,
        tinNumber: '', // Empty for non-individual business type is invalid
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      expect(state.isValid, equals(false));
    });
  });

  group('SignupFormNotifier', () {
    test('updateUsername calls repository and updates state', () async {
      // Setup
      mockRepository.checkUsernameResult = true;

      // Pre-check
      expect(notifier.state.username, equals(''));
      expect(notifier.state.isCheckingUsername, equals(false));
      expect(notifier.state.isUsernameAvailable, isNull);

      // Execute
      final future = notifier.updateUsername('testuser');

      // First state update - just the username
      expect(notifier.state.username, equals('testuser'));
      expect(notifier.state.isUsernameAvailable, isNull);

      // Wait for the debounce and API call to complete
      await future;

      // Now the availability check should have been triggered
      expect(mockRepository.checkedUsernames, contains('testuser'));

      // The state should reflect the availability result
      expect(notifier.state.isCheckingUsername, equals(false));
      expect(notifier.state.isUsernameAvailable, equals(true));
    });

    test('updateFullName updates the state', () {
      notifier.updateFullName('Test User');
      expect(notifier.state.fullName, equals('Test User'));
    });

    test('updateBusinessType updates the state', () {
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');
      notifier.updateBusinessType(businessType);
      expect(notifier.state.businessType, equals(businessType));
    });

    test('updateTinNumber updates the state', () {
      notifier.updateTinNumber('123456789');
      expect(notifier.state.tinNumber, equals('123456789'));
    });

    test('updateCountry updates the state', () {
      notifier.updateCountry('Kenya');
      expect(notifier.state.country, equals('Kenya'));
    });

    test('updatePhoneNumber updates the state', () {
      notifier.updatePhoneNumber('+250789123456');
      expect(notifier.state.phoneNumber, equals('+250789123456'));
    });

    test('submitForm returns false when form is invalid', () async {
      // With default empty state, form should be invalid
      final result = await notifier.submitForm();
      expect(result, equals(false));
      expect(notifier.state.errorMessage, isNotNull);
    });

    test('submitForm checks username availability before submitting', () async {
      // Setup a valid form state but with unknown username availability
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');
      notifier.updateUsername('testuser');
      notifier.updateFullName('Test User');
      notifier.updateBusinessType(businessType);
      notifier.updateTinNumber('123456789');

      // Mock the repository response
      mockRepository.checkUsernameResult = false;

      // Try to submit
      final result = await notifier.submitForm();

      // Verify that availability was checked
      expect(mockRepository.checkedUsernames, contains('testuser'));

      // The form submission should fail
      expect(result, equals(false));
      expect(
        notifier.state.errorMessage,
        contains('Username is not available'),
      );
    });

    test(
      'submitForm calls repository.registerUser when form is valid',
      () async {
        // Setup a valid form state
        final businessType = BusinessType(
          id: '1',
          typeName: 'Flipper Retailer',
        );

        final validState = SignupFormState(
          username: 'testuser',
          fullName: 'Test User',
          businessType: businessType,
          tinNumber: '123456789',
          country: 'Rwanda',
          isUsernameAvailable: true,
        );

        // Configure mock responses
        mockRepository.checkUsernameResult = true;
        mockRepository.registerUserResult = {};

        // Set the initial state
        notifier.state = validState;

        // Submit the form
        final result = await notifier.submitForm();

        // Verify that the registration was attempted with correct parameters
        expect(
          mockRepository.lastRegistrationParams['username'],
          equals('testuser'),
        );
        expect(
          mockRepository.lastRegistrationParams['fullName'],
          equals('Test User'),
        );
        expect(
          mockRepository.lastRegistrationParams['businessTypeId'],
          equals('1'),
        );
        expect(
          mockRepository.lastRegistrationParams['tinNumber'],
          equals('123456789'),
        );
        expect(
          mockRepository.lastRegistrationParams['country'],
          equals('Rwanda'),
        );

        // Check that the result is successful
        expect(result, equals(true));
        expect(notifier.state.isSubmitting, equals(false));
      },
    );

    test('submitForm handles repository exceptions', () async {
      // Setup a valid form state
      final businessType = BusinessType(id: '1', typeName: 'Flipper Retailer');

      // Set state manually to bypass async username check

      final validState = SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: businessType,
        tinNumber: '123456789',
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      // Mock an error in the repository
      mockRepository.checkUsernameResult = true;
      mockRepository.errorMessage = 'Test error';

      // Set the initial state
      notifier.state = validState;

      // Submit the form
      final result = await notifier.submitForm();

      // Check that the error was handled
      expect(result, equals(false));
      expect(notifier.state.isSubmitting, equals(false));
      expect(notifier.state.errorMessage, contains('Test error'));
    });
  });
}
