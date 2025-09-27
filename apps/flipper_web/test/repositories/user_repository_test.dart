import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flipper_web/services/ditto_service.dart';

// Create mocks
class MockDittoService extends Mock implements DittoService {}

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class MockSession extends Mock implements Session {}

class MockUser extends Mock implements User {}

// Create fakes for Mocktail registerFallbackValue
class FakeUri extends Fake implements Uri {}

class FakeUserProfile extends Fake implements UserProfile {}

void main() {
  // Register fallback values for Mocktail
  setUpAll(() {
    registerFallbackValue(FakeUri());
    registerFallbackValue(FakeUserProfile());
  });

  late UserRepository userRepository;
  late MockDittoService mockDittoService;
  late MockHttpClient mockHttpClient;
  late MockSession mockSession;
  late MockUser mockUser;

  // Sample user profile data for testing
  final testUserProfileJson = {
    "id": "75060",
    "phoneNumber": "+250783054884",
    "token":
        "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiI3NTA2MCIsImlhdCI6MTc1ODY0MDk4OCwiZXhwIjoxNzU4NjQ0NTg4LCJncm91cHMiOlsiVXNlciIsIkFkbWluIl0sImJpcnRoZGF0ZSI6Ijc1MDYwIn0.1Rq_9TcfGB0y7Q4lVKB28HeZcMPRY6dBgo9ch7t3sSs",
    "tenants": [
      {
        "id": "840d9aae-3029-434c-bbe5-21be358b2e15",
        "name": "New Tenant",
        "phoneNumber": "+250783054884",
        "email": "null",
        "imageUrl": "null",
        "permissions": [],
        "branches": [
          {
            "id": "5efbf694-6ae4-437d-b6af-14586c961d6b",
            "description": "Default branch for this business",
            "name": "Muri",
            "longitude": "1",
            "latitude": "1",
            "businessId": 24862400,
            "serverId": 24862400,
          },
        ],
        "businesses": [
          {
            "id": "6330e99b-39c3-4e95-9186-9322974bd95e",
            "name": "Muri",
            "country": "Rwanda",
            "currency": "RWF",
            "latitude": "1",
            "longitude": "1",
            "active": false,
            "userId": "75060",
            "phoneNumber": "+250783054884",
            "lastSeen": 0,
            "backUpEnabled": false,
            "fullName": "Mur M",
            "tinNumber": 0,
            "taxEnabled": false,
            "businessTypeId": 2,
            "serverId": 24862400,
            "is_default": false,
            "lastSubscriptionPaymentSucceeded": false,
          },
        ],
        "businessId": 24862400,
        "nfcEnabled": false,
        "userId": 75060,
        "pin": 75060,
        "is_default": true,
        "type": "Admin",
      },
    ],
    "pin": 75060,
  };

  final testUserProfile = UserProfile.fromJson(
    testUserProfileJson,
    id: '75060',
  );

  setUp(() {
    mockDittoService = MockDittoService();
    mockHttpClient = MockHttpClient();
    mockSession = MockSession();
    mockUser = MockUser();

    // Setup mock session and user
    when(() => mockSession.user).thenReturn(mockUser);
    when(() => mockUser.phone).thenReturn('+250783054884');
    when(
      () => mockUser.id,
    ).thenReturn('75060'); // Add this line to fix the null id issue

    // Initialize the repository with mocks
    userRepository = UserRepository(
      mockDittoService,
      httpClient: mockHttpClient,
    );
  });

  group('UserRepository', () {
    test('fetchAndSaveUserProfile calls API and saves to Ditto', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn(jsonEncode(testUserProfileJson));

      when(
        () => mockDittoService.saveUserProfile(any()),
      ).thenAnswer((_) async => Future.value(null));

      when(
        () => mockHttpClient.post(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await userRepository.fetchAndSaveUserProfile(mockSession);

      // Assert
      expect(result.id, equals(testUserProfile.id));
      expect(result.phoneNumber, equals(testUserProfile.phoneNumber));
      verify(
        () => mockUser.phone,
      ).called(2); // Verify phone number was accessed
    });

    test('getCurrentUserProfile calls DittoService.getUserProfile', () async {
      // Arrange
      when(
        () => mockDittoService.getUserProfile(any()),
      ).thenAnswer((_) async => testUserProfile);

      // Mock the additional methods called by getCurrentUserProfile
      when(
        () => mockDittoService.getTenantsForUser(any()),
      ).thenAnswer((_) async => testUserProfile.tenants);

      when(
        () => mockDittoService.getBusinessesForUser(any()),
      ).thenAnswer((_) async => testUserProfile.tenants.first.businesses);

      when(
        () => mockDittoService.getBranchesForBusiness(any()),
      ).thenAnswer((_) async => testUserProfile.tenants.first.branches);

      // Act
      final result = await userRepository.getCurrentUserProfile("75060");

      // Assert
      expect(result, isNotNull);
      expect(result!.id, equals(testUserProfile.id));
      expect(result.phoneNumber, equals(testUserProfile.phoneNumber));
      expect(result.token, equals(testUserProfile.token));
      expect(result.tenants.length, equals(testUserProfile.tenants.length));
      expect(result.pin, equals(testUserProfile.pin));
      verify(() => mockDittoService.getUserProfile('75060')).called(1);
    });

    test('getAllUserProfiles calls DittoService.getAllUserProfiles', () async {
      // Arrange
      when(
        () => mockDittoService.getAllUserProfiles(),
      ).thenAnswer((_) async => [testUserProfile]);

      // Act
      final result = await userRepository.getAllUserProfiles();

      // Assert
      expect(result.length, equals(1));
      expect(result.first.id, equals(testUserProfile.id));
      verify(() => mockDittoService.getAllUserProfiles()).called(1);
    });

    test('updateUserProfile calls API and updates in Ditto', () async {
      // Arrange
      final mockResponse = MockResponse();
      when(() => mockResponse.statusCode).thenReturn(200);
      when(() => mockResponse.body).thenReturn(jsonEncode(testUserProfileJson));

      // Fix: Mock the updateUserProfile method to return a Future<void>
      when(
        () => mockDittoService.updateUserProfile(any()),
      ).thenAnswer((_) async => Future.value(null));

      when(
        () => mockHttpClient.put(
          any(),
          headers: any(named: 'headers'),
          body: any(named: 'body'),
        ),
      ).thenAnswer((_) async => mockResponse);

      // Act
      final result = await userRepository.updateUserProfile(
        testUserProfile,
        'test-token',
      );

      // Assert
      expect(result.id, equals(testUserProfile.id));
      verify(
        () => mockDittoService.updateUserProfile(any()),
      ).called(1); // Changed from saveUserProfile to updateUserProfile
    });
  });
}
