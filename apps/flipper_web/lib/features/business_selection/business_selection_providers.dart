import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider to check if the user has selected a default business and branch in Ditto
final hasSelectedBusinessAndBranchProvider = FutureProvider<bool>((ref) async {
  try {
    final userRepository = ref.watch(userRepositoryProvider);
    final authService = ref.watch(authServiceProvider);

    // Get current authenticated user
    final currentUser = await authService.getCurrentUser();
    if (currentUser == null) {
      return false;
    }

    // Get businesses for this user
    final businesses = await userRepository.getBusinessesForUser(
      currentUser.id,
    );
    final defaultBusiness = businesses.where((b) => b.isDefault).toList();

    if (defaultBusiness.isEmpty) {
      return false;
    }

    // Get branches for the default business
    final branches = await userRepository.getBranchesForBusiness(
      defaultBusiness.first.id,
    );
    final defaultBranch = branches.where((b) => b.isDefault).toList();

    return defaultBranch.isNotEmpty;
  } catch (e) {
    // If there's an error, assume no selection has been made
    debugPrint('Error checking business/branch selection: $e');
    return false;
  }
});

/// Provider for the current user profile
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  try {
    final authService = ref.watch(authServiceProvider);
    final userRepository = ref.watch(userRepositoryProvider);

    // Get current authenticated user
    final currentUser = await authService.getCurrentUser();
    debugPrint(
      'CurrentUserProfileProvider - Current user: ${currentUser?.id ?? 'null'}',
    );

    if (currentUser == null) {
      debugPrint(
        'CurrentUserProfileProvider - No current user found in Supabase',
      );
      return null;
    }

    // Get user profile from Ditto
    try {
      final userProfile = await userRepository.getCurrentUserProfile(
        currentUser.id,
      );

      debugPrint(
        'CurrentUserProfileProvider - User profile from Ditto: ${userProfile != null ? 'found' : 'not found'}',
      );

      if (userProfile == null) {
        // If profile is not found in Ditto, try to fetch it from API
        debugPrint(
          'CurrentUserProfileProvider - Profile not found in Ditto, fetching from API',
        );

        // Get current session to fetch user profile
        final session = await authService.getCurrentSession();
        if (session != null) {
          // This will fetch and save the profile to Ditto
          try {
            final apiProfile = await userRepository.fetchAndSaveUserProfile(
              session,
            );
            debugPrint(
              'CurrentUserProfileProvider - Successfully fetched profile from API',
            );
            // Return the profile directly from API instead of trying to get it from Ditto again
            return apiProfile;
          } catch (apiError) {
            debugPrint(
              'CurrentUserProfileProvider - API fetch error: $apiError',
            );
            // If we fail to get from API, return null
            return null;
          }
        }
      }

      return userProfile;
    } catch (innerError) {
      debugPrint(
        'CurrentUserProfileProvider - Error getting user profile from Ditto: $innerError',
      );
      rethrow;
    }
  } catch (e) {
    debugPrint('CurrentUserProfileProvider - Error: $e');
    rethrow;
  }
});
