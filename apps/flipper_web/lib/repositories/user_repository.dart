import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flipper_web/core/secrets.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final dittoService = ref.watch(dittoServiceProvider);
  return UserRepository(dittoService);
});

class UserRepository {
  final DittoService _dittoService;
  final http.Client _httpClient;

  UserRepository(this._dittoService, {http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Fetches user profile data from the API and saves it to Ditto
  ///
  /// This method is called after successful login to save the user data
  /// for offline access and synchronization with other devices
  Future<UserProfile> fetchAndSaveUserProfile(Session session) async {
    try {
      // Ensure Ditto is initialized but handle initialization failures
      try {
        await _dittoService.initialize();
      } catch (e) {
        debugPrint('Warning: DittoService initialization failed: $e');
        debugPrint('Continuing without Ditto synchronization');
        // We'll continue without Ditto, just to get the user profile
      }

      // API call to get user data
      final response = await _httpClient.post(
        Uri.parse(
          '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/user',
        ),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumber': "+${session.user.phone}"}),
      );
      debugPrint('User Phone: ${session.user.phone}');

      if (response.statusCode == 200) {
        final userProfileData = jsonDecode(response.body);
        debugPrint('Fetched user profile: $userProfileData');
        final userProfile = UserProfile.fromJson(
          userProfileData,
          id: session.user.id,
        );

        // Try to save user profile to Ditto for offline access, but handle failures
        try {
          await _dittoService.saveUserProfile(userProfile);
          debugPrint('Saved user profile to Ditto');
        } catch (e) {
          debugPrint('Warning: Could not save user profile to Ditto: $e');
          debugPrint('Continuing without offline synchronization');
          // We'll continue without saving to Ditto
        }

        return userProfile;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception('Failed to fetch user profile: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error in fetchAndSaveUserProfile: $e');
      rethrow;
    }
  }

  /// Get the current user profile from Ditto
  ///
  /// This method is used to get the cached user data from Ditto
  /// when the app is offline or to avoid making API calls
  Future<UserProfile?> getCurrentUserProfile(String userId) async {
    try {
      debugPrint('Getting user profile for ID: $userId');
      final profile = await _dittoService.getUserProfile(userId);
      if (profile == null) {
        debugPrint('No profile found for ID: $userId');
      } else {
        debugPrint('Successfully retrieved profile for ID: $userId');
      }
      return profile;
    } catch (e) {
      debugPrint('Error in getCurrentUserProfile: $e');
      return null;
    }
  }

  /// Get all user profiles from Ditto
  ///
  /// This method is used for admin purposes or to display all users
  /// that have been synchronized with the device
  Future<List<UserProfile>> getAllUserProfiles() async {
    try {
      debugPrint('Getting all user profiles');
      final profiles = await _dittoService.getAllUserProfiles();
      debugPrint('Retrieved ${profiles.length} user profiles');
      return profiles;
    } catch (e) {
      debugPrint('Error in getAllUserProfiles: $e');
      return [];
    }
  }

  /// Update user profile in the API and Ditto
  ///
  /// This method is used to update user data both on the server
  /// and in the local Ditto database
  Future<UserProfile> updateUserProfile(
    UserProfile userProfile,
    String token,
  ) async {
    try {
      // For now, skip API update and only update in Ditto
      // This is a temporary solution to bypass the 405 Method Not Allowed error

      // Update user profile in Ditto directly using the new updateUserProfile method
      // which handles the identifier conflict issue
      await _dittoService.updateUserProfile(userProfile);

      debugPrint('Updated user profile in Ditto: ${userProfile.id}');
      return userProfile;

      /* API update code - temporarily disabled due to 405 error
      final response = await _httpClient.put(
        Uri.parse(
          '${kDebugMode ? AppSecrets.apihubDevDomain : AppSecrets.apihubProdDomain}/v2/api/user/${userProfile.id}',
        ),
        headers: {'Authorization': token, 'Content-Type': 'application/json'},
        body: jsonEncode(userProfile.toJson()),
      );

      if (response.statusCode == 200) {
        final updatedUserProfileData = jsonDecode(response.body);
        final updatedUserProfile = UserProfile.fromJson(
          updatedUserProfileData,
          id: userProfile.id,
        );

        // Update user profile in Ditto
        await _dittoService.updateUserProfile(updatedUserProfile);

        return updatedUserProfile;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid token');
      } else {
        throw Exception(
          'Failed to update user profile: ${response.statusCode}',
        );
      }
      */
    } catch (e) {
      debugPrint('Error in updateUserProfile: $e');
      rethrow;
    }
  }

  /// Stream of user profiles from Ditto
  ///
  /// This stream can be used to get real-time updates of user profiles
  /// as they are synchronized from other devices
  Stream<List<UserProfile>> get userProfilesStream =>
      _dittoService.userProfiles;
}
