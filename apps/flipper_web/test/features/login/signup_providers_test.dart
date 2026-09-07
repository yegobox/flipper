import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flipper_web/features/login/signup_providers.dart';
import 'package:flipper_web/repositories/signup_repository.dart';
import 'package:flipper_web/models/business_type.dart';
import 'package:flipper_models/ippis_service.dart';

import '../../helpers/fake_product_analytics.dart';

//flutter test test/features/login/signup_providers_test.dart
// Manual mock implementation of SignupRepository
class MockSignupRepository extends SignupRepository {
  MockSignupRepository() : super(analytics: FakeProductAnalytics());

  bool checkUsernameResult = true;
  Map<String, dynamic> registerUserResult = {};
  String? errorMessage;

  /// When set, `registerBusiness` blocks on it so a second submit can be
  /// attempted while the first is still in flight.
  Completer<void>? registerGate;
  int registerCallCount = 0;

  // --- OTP
  String? userIdResult = 'user-1';
  String? sendOtpError;
  bool otpVerifies = true;
  String? verifyOtpError;
  List<String> sentOtpContacts = [];
  List<String> lookedUpContacts = [];
  List<({String contact, String otp})> verifiedOtps = [];

  @override
  Future<String?> lookupOrCreateUserId(String contact) async {
    lookedUpContacts.add(contact);
    return userIdResult;
  }

  @override
  Future<Map<String, dynamic>> sendSignupOtp(String contact) async {
    if (sendOtpError != null) throw Exception(sendOtpError);
    sentOtpContacts.add(contact);
    return {'sent': true};
  }

  @override
  Future<Map<String, dynamic>> verifySignupOtp(
    String contact,
    String otp,
  ) async {
    verifiedOtps.add((contact: contact, otp: otp));
    if (verifyOtpError != null) throw Exception(verifyOtpError);
    return {'verified': otpVerifies, if (!otpVerifies) 'error': 'Wrong code'};
  }

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

    registerCallCount++;
    if (registerGate != null) {
      await registerGate!.future;
    }

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
        tinDetails: IppisBusiness( // Add valid tinDetails to satisfy validation
          tin: '123456789',
          taxPayerName: 'Test Business',
          registrationDate: '2023-01-01',
          isicName: 'Retail Trade',
          numberOfEmployees: 5,
          numberOfFemaleEmployees: 2,
          numberOfMaleEmployees: 3,
          businessType: 'LLC',
          province: 'Kigali',
          district: 'Gasabo',
          sector: 'Gisozi',
          cell: 'Nyakabanda',
          village: 'Ruyenzi',
          phoneNumber: '+250788123456',
          email: 'contact@test.com',
          stateOfEstablishment: 'Active',
          taxAccountStatus: 'Active',
          statusEffectiveDate: '2023-01-01',
          categoryOfEstablishment: 'Small Enterprise',
          registrationAuthority: 'RRA',
          managingDirectorId: 'MD001',
        ),
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
          tinDetails: IppisBusiness( // Add valid tinDetails to satisfy validation
            tin: '123456789',
            taxPayerName: 'Test Business',
            registrationDate: '2023-01-01',
            isicName: 'Retail Trade',
            numberOfEmployees: 5,
            numberOfFemaleEmployees: 2,
            numberOfMaleEmployees: 3,
            businessType: 'LLC',
            province: 'Kigali',
            district: 'Gasabo',
            sector: 'Gisozi',
            cell: 'Nyakabanda',
            village: 'Ruyenzi',
            phoneNumber: '+250788123456',
            email: 'contact@test.com',
            stateOfEstablishment: 'Active',
            taxAccountStatus: 'Active',
            statusEffectiveDate: '2023-01-01',
            categoryOfEstablishment: 'Small Enterprise',
            registrationAuthority: 'RRA',
            managingDirectorId: 'MD001',
          ),
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
        tinDetails: IppisBusiness( // Add valid tinDetails to satisfy validation
          tin: '123456789',
          taxPayerName: 'Test Business',
          registrationDate: '2023-01-01',
          isicName: 'Retail Trade',
          numberOfEmployees: 5,
          numberOfFemaleEmployees: 2,
          numberOfMaleEmployees: 3,
          businessType: 'LLC',
          province: 'Kigali',
          district: 'Gasabo',
          sector: 'Gisozi',
          cell: 'Nyakabanda',
          village: 'Ruyenzi',
          phoneNumber: '+250788123456',
          email: 'contact@test.com',
          stateOfEstablishment: 'Active',
          taxAccountStatus: 'Active',
          statusEffectiveDate: '2023-01-01',
          categoryOfEstablishment: 'Small Enterprise',
          registrationAuthority: 'RRA',
          managingDirectorId: 'MD001',
        ),
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

    test('submitForm refuses to run twice concurrently', () async {
      // Two taps on "Create account" used to register two businesses,
      // because isSubmitting was only set after the username re-check awaited.
      final gate = Completer<void>();
      mockRepository
        ..checkUsernameResult = true
        ..registerGate = gate;

      notifier.state = SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: BusinessType(id: '2', typeName: 'Individual'),
        country: 'Rwanda',
        isUsernameAvailable: true,
      );

      final first = notifier.submitForm();
      await Future<void>.delayed(Duration.zero);

      expect(await notifier.submitForm(), equals(false),
          reason: 'second submit must be refused while the first is running');

      gate.complete();
      expect(await first, equals(true));
      expect(mockRepository.registerCallCount, equals(1));
    });
  });

  group('SignupFormState TIN relaxation', () {
    SignupFormState retailerState({
      String tinNumber = '107148510',
      bool relaxed = false,
      String? tinError,
    }) {
      return SignupFormState(
        username: 'testuser',
        fullName: 'Test User',
        businessType: BusinessType(id: '1', typeName: 'Flipper Retailer'),
        tinNumber: tinNumber,
        country: 'Rwanda',
        isUsernameAvailable: true,
        isTinValidationRelaxed: relaxed,
        tinError: tinError,
      );
    }

    test('an unreachable IPPIS does not block a non-Individual signup', () {
      // ippis.rw refuses browser origins, so the lookup can never succeed on
      // web. Mobile relaxes the same way when IPPIS is down.
      expect(retailerState(relaxed: true).isValid, equals(true));
    });

    test('a TIN IPPIS actively rejected still blocks', () {
      expect(
        retailerState(tinError: 'No data found for this TIN').isValid,
        equals(false),
      );
    });

    test('relaxation does not waive the TIN length requirement', () {
      expect(retailerState(tinNumber: '1234', relaxed: true).isValid,
          equals(false));
    });
  });

  group('signup OTP', () {
    late ProviderContainer container;
    late MockSignupRepository mockRepository;
    late SignupForm notifier;

    setUp(() {
      mockRepository = MockSignupRepository();
      container = ProviderContainer(
        overrides: [signupRepositoryProvider.overrideWithValue(mockRepository)],
      );
      notifier = container.read(signupFormProvider.notifier);
    });

    tearDown(() => container.dispose());

    SignupFormState readyState() => SignupFormState(
          username: 'testuser',
          fullName: 'Test User',
          businessType: BusinessType(id: '2', typeName: 'Individual'),
          country: 'Rwanda',
          isUsernameAvailable: true,
          phoneNumber: '+250788517078',
        );

    test('requestOtp creates the user before asking for a code', () async {
      notifier.updatePhoneNumber('788517078');

      expect(await notifier.requestOtp(), isTrue);

      // apihub wants the user to exist first — the mobile bloc calls
      // sendLoginRequest before sendOtpForSignup for the same reason.
      expect(mockRepository.lookedUpContacts, equals(['+250788517078']));
      expect(mockRepository.sentOtpContacts, equals(['+250788517078']));
      expect(notifier.state.isOtpRequested, isTrue);
    });

    test('a rejected contact surfaces the error and enables no code field',
        () async {
      mockRepository.sendOtpError = 'Contact already exists';
      notifier.updatePhoneNumber('788517078');

      expect(await notifier.requestOtp(), isFalse);
      expect(notifier.state.otpError, equals('Contact already exists'));
      expect(notifier.state.isOtpRequested, isFalse);
    });

    test('a complete code verifies itself', () async {
      notifier.updatePhoneNumber('788517078');
      await notifier.requestOtp();

      await notifier.updateOtpCode('12345');
      expect(mockRepository.verifiedOtps, isEmpty,
          reason: 'a partial code must not be sent');

      await notifier.updateOtpCode('123456');

      expect(mockRepository.verifiedOtps.single.otp, equals('123456'));
      expect(notifier.state.isPhoneVerified, isTrue);
    });

    test('a wrong code leaves the contact unverified', () async {
      mockRepository.otpVerifies = false;
      notifier.updatePhoneNumber('788517078');
      await notifier.requestOtp();

      expect(await notifier.verifyOtp('000000'), isFalse);
      expect(notifier.state.isPhoneVerified, isFalse);
      expect(notifier.state.otpError, equals('Wrong code'));
    });

    test('editing the contact drops an existing verification', () async {
      notifier.updatePhoneNumber('788517078');
      await notifier.requestOtp();
      await notifier.verifyOtp('123456');
      expect(notifier.state.isPhoneVerified, isTrue);

      notifier.updatePhoneNumber('788517079');

      expect(notifier.state.isPhoneVerified, isFalse);
      expect(notifier.state.isOtpRequested, isFalse);
      expect(notifier.state.otpCode, equals(''));
    });

    test('switching country re-applies the dial code and drops verification',
        () async {
      notifier.updatePhoneNumber('788517078');
      await notifier.requestOtp();
      await notifier.verifyOtp('123456');

      notifier.updateCountry('Kenya');

      expect(notifier.state.phoneNumber, equals('+254788517078'));
      expect(notifier.state.isPhoneVerified, isFalse);
    });

    test('an unverified contact is not a valid form', () {
      final state = readyState();
      expect(state.isPhoneVerified, isFalse);
      expect(state.isValid, isFalse);
    });

    test('the same form is valid once the contact is verified', () {
      final state = readyState().copyWith(verifiedContact: '+250788517078');
      expect(state.isValid, isTrue);
    });

    test('submitForm refuses an unverified contact', () async {
      notifier.state = readyState();

      expect(await notifier.submitForm(), isFalse);
      expect(notifier.state.errorMessage, contains('Send code'));
      expect(mockRepository.registeredUsers, isEmpty);
    });

    test('submitForm registers once the contact is verified', () async {
      notifier.state =
          readyState().copyWith(verifiedContact: '+250788517078');

      expect(await notifier.submitForm(), isTrue);
      expect(mockRepository.registeredUsers.single.phoneNumber,
          equals('+250788517078'));
      expect(mockRepository.registeredUsers.single.userId, equals('user-1'));
    });
  });

  group('buildBusinessRegistrationPayload', () {
    Map<String, dynamic> payloadFor(String businessTypeId, String tin) {
      return buildBusinessRegistrationPayload(
        username: 'ecobe',
        fullName: 'SISSI Ernest',
        businessTypeId: businessTypeId,
        tinNumber: tin,
        country: 'Rwanda',
        phoneNumber: '+250788517078',
        userId: 42,
      );
    }

    test('omits businessTypeId, as CoreSync.signup does', () {
      // Sending it made web businesses land on business_type_id = 2, which
      // skips the subscription check AuthMixin waives for individuals.
      expect(payloadFor('1', '107148510').containsKey('businessTypeId'),
          isFalse);
    });

    test("sends the literal type 'Business' mobile sends", () {
      expect(payloadFor('3', '107148510')['type'], equals('Business'));
      expect(payloadFor('2', '')['type'], equals('Business'));
    });

    test('sends tinNumber as an int', () {
      expect(payloadFor('1', '107148510')['tinNumber'], equals(107148510));
    });

    test("falls back to mobile's placeholder TIN for individuals", () {
      expect(payloadFor('2', '107148510')['tinNumber'], equals(999909695));
      expect(payloadFor('1', '')['tinNumber'], equals(999909695));
    });

    test('carries the fields mobile sends', () {
      final payload = payloadFor('1', '107148510');
      expect(payload['referredBy'], equals('Organic'));
      expect(payload['latitude'], equals('1'));
      expect(payload['longitude'], equals('1'));
      expect(payload['bhfid'], equals('00'));
      expect(payload['currency'], equals('RWF'));
      expect(payload['userId'], equals('42'));
      expect(payload['createdAt'], isNotNull);
    });
  });
}
