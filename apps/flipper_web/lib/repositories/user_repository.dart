import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
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
          // Save user profile (without embedded data)
          final userOnlyProfile = UserProfile(
            id: userProfile.id,
            phoneNumber: userProfile.phoneNumber,
            token: userProfile.token,
            tenants: [], // We'll save tenants separately
            pin: userProfile.pin,
          );
          await _dittoService.saveUserProfile(userOnlyProfile);

          // Save tenants, businesses, and branches separately
          for (final tenant in userProfile.tenants) {
            await _dittoService.saveTenant(tenant);
            for (final business in tenant.businesses) {
              await _dittoService.saveBusiness(business);
            }
            for (final branch in tenant.branches) {
              await _dittoService.saveBranch(branch);
            }
          }

          debugPrint(
            'Saved user profile and related data to Ditto in normalized form',
          );
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

  /// Get user profile with fallback to API if not in Ditto
  ///
  /// This method first tries to get data from Ditto, and if not available,
  /// fetches from API and saves to Ditto
  Future<UserProfile?> getUserProfileWithFallback(Session session) async {
    try {
      // First try to get from Ditto
      final cachedProfile = await getCurrentUserProfile(session.user.id);
      if (cachedProfile != null && cachedProfile.tenants.isNotEmpty) {
        debugPrint('Using cached profile from Ditto');
        return cachedProfile;
      }

      // If not in Ditto or empty, fetch from API
      debugPrint('No cached profile found, fetching from API');
      return await fetchAndSaveUserProfile(session);
    } catch (e) {
      debugPrint('Error in getUserProfileWithFallback: $e');
      return null;
    }
  }

  /// Get the current user profile from Ditto
  ///
  /// This method is used to get the cached user data from Ditto
  /// when the app is offline or to avoid making API calls
  Future<UserProfile?> getCurrentUserProfile(String userId) async {
    try {
      debugPrint('Getting user profile for ID: $userId');

      // Get the base user profile
      final baseProfile = await _dittoService.getUserProfile(userId);
      if (baseProfile == null) {
        debugPrint('No base profile found for ID: $userId');
        return null;
      }

      // Get tenants for this user
      final tenants = await _dittoService.getTenantsForUser(userId);

      // For each tenant, populate businesses and branches
      final populatedTenants = <Tenant>[];
      for (final tenant in tenants) {
        // Get businesses for this user
        final businesses = await _dittoService.getBusinessesForUser(userId);
        final populatedBusinesses =
            businesses; // No need to modify businesses here

        // Create populated tenant
        final populatedTenant = Tenant(
          id: tenant.id,
          name: tenant.name,
          phoneNumber: tenant.phoneNumber,
          email: tenant.email,
          imageUrl: tenant.imageUrl,
          permissions: tenant.permissions,
          branches: await _getBranchesForTenantBusinesses(populatedBusinesses),
          businesses: populatedBusinesses,
          businessId: tenant.businessId,
          nfcEnabled: tenant.nfcEnabled,
          userId: tenant.userId,
          pin: tenant.pin,
          isDefault: tenant.isDefault,
          type: tenant.type,
        );
        populatedTenants.add(populatedTenant);
      }

      // Create the complete user profile
      final completeProfile = UserProfile(
        id: baseProfile.id,
        phoneNumber: baseProfile.phoneNumber,
        token: baseProfile.token,
        tenants: populatedTenants,
        pin: baseProfile.pin,
      );

      debugPrint('Successfully retrieved complete profile for ID: $userId');
      return completeProfile;
    } catch (e) {
      debugPrint('Error in getCurrentUserProfile: $e');
      return null;
    }
  }

  /// Helper method to get all branches for a tenant's businesses
  Future<List<Branch>> _getBranchesForTenantBusinesses(
    List<Business> businesses,
  ) async {
    final allBranches = <Branch>[];
    for (final business in businesses) {
      final branches = await _dittoService.getBranchesForBusiness(business.id);
      allBranches.addAll(branches);
    }
    return allBranches;
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

  /// Get all businesses for a specific user
  Future<List<Business>> getBusinessesForUser(String userId) async {
    try {
      return await _dittoService.getBusinessesForUser(userId);
    } catch (e) {
      debugPrint('Error getting businesses for user $userId: $e');
      return [];
    }
  }

  /// Get all branches for a specific business
  Future<List<Branch>> getBranchesForBusiness(String businessId) async {
    try {
      return await _dittoService.getBranchesForBusiness(businessId);
    } catch (e) {
      debugPrint('Error getting branches for business $businessId: $e');
      return [];
    }
  }

  /// Get all tenants for a specific user
  Future<List<Tenant>> getTenantsForUser(String userId) async {
    try {
      return await _dittoService.getTenantsForUser(userId);
    } catch (e) {
      debugPrint('Error getting tenants for user $userId: $e');
      return [];
    }
  }

  /// Update a business
  Future<void> updateBusiness(Business business) async {
    try {
      await _dittoService.updateBusiness(business);
      debugPrint('Updated business: ${business.name}');
    } catch (e) {
      debugPrint('Error updating business: $e');
      rethrow;
    }
  }

  /// Update a branch
  Future<void> updateBranch(Branch branch) async {
    try {
      await _dittoService.updateBranch(branch);
      debugPrint('Updated branch: ${branch.name}');
    } catch (e) {
      debugPrint('Error updating branch: $e');
      rethrow;
    }
  }

  /// Update a tenant
  Future<void> updateTenant(Tenant tenant) async {
    try {
      await _dittoService.updateTenant(tenant);
      debugPrint('Updated tenant: ${tenant.name}');
    } catch (e) {
      debugPrint('Error updating tenant: $e');
      rethrow;
    }
  }
}
