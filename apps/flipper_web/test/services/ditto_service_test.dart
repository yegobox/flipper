import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/services/ditto_service.dart';

// Mock the DittoService directly since we can't easily mock the underlying Ditto SDK
class MockDittoService extends Mock implements DittoService {}

// Sample test data
final sampleUserProfileData = {
  'id': "75060",
  'phoneNumber': '+250783054884',
  'token': 'Bearer token',
  'tenants': [
    {
      'id': 'tenant-id',
      'name': 'Test Tenant',
      'phoneNumber': '+250783054884',
      'email': 'null',
      'imageUrl': 'null',
      'permissions': [],
      'branches': [
        {
          'id': 'branch-id',
          'description': 'Test Branch',
          'name': 'Test',
          'longitude': '1',
          'latitude': '1',
          'businessId': 24862400,
          'serverId': 24862400,
        },
      ],
      'businesses': [
        {
          'id': 'business-id',
          'name': 'Test Business',
          'country': 'Rwanda',
          'currency': 'RWF',
          'latitude': '1',
          'longitude': '1',
          'active': false,
          'userId': '75060',
          'phoneNumber': '+250783054884',
          'lastSeen': 0,
          'backUpEnabled': false,
          'fullName': 'Test User',
          'tinNumber': 0,
          'taxEnabled': false,
          'businessTypeId': 2,
          'serverId': 24862400,
          'is_default': false,
          'lastSubscriptionPaymentSucceeded': false,
        },
      ],
      'businessId': 24862400,
      'nfcEnabled': false,
      'userId': 75060,
      'pin': 75060,
      'is_default': true,
      'type': 'Admin',
    },
  ],
  'pin': 75060,
};

void main() {
  // Since we can't easily mock the underlying Ditto SDK components,
  // we'll test our user repository that uses the DittoService instead
  group('DittoService Integration', () {
    test('UserProfile model can serialize/deserialize properly', () {
      // Create a user profile from the sample data
      final userProfile = UserProfile.fromJson(
        sampleUserProfileData,
        id: "75060",
      );

      // Verify that the deserialization worked correctly
      expect(userProfile.id, equals("75060"));
      expect(userProfile.phoneNumber, equals('+250783054884'));
      expect(userProfile.tenants.length, equals(1));
      expect(userProfile.tenants[0].businesses.length, equals(1));
      expect(userProfile.tenants[0].branches.length, equals(1));

      // Test serialization by converting back to JSON
      final serialized = userProfile.toJson();
      expect(
        serialized['id'],
        equals("75060"),
      ); // Fix: Change the expected type to match the actual string type
      expect(serialized['phoneNumber'], equals('+250783054884'));

      // Create a new user profile from the serialized data to ensure round-trip works
      final roundTrip = UserProfile.fromJson(serialized, id: "75060");
      expect(roundTrip.id, equals(userProfile.id));
      expect(roundTrip.tenants.length, equals(userProfile.tenants.length));
    });
  });
}
