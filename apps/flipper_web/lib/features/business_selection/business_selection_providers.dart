import 'package:flipper_web/models/mutable_user_profile.dart';
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

    // Get the user profile from Ditto using the user ID
    final userProfile = await userRepository.getCurrentUserProfile(
      currentUser.id,
    );

    if (userProfile == null) {
      return false;
    }

    // Create a mutable version to check if it has default selections
    final mutableProfile = MutableUserProfile.fromUserProfile(userProfile);
    return mutableProfile.hasDefaultBusinessAndBranch();
  } catch (e) {
    // If there's an error, assume no selection has been made
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
          'CurrentUserProfileProvider - Attempting to fetch user profile from API',
        );

        // Get current session to fetch user profile
        final session = await authService.getCurrentSession();
        if (session != null) {
          // This will fetch and save the profile to Ditto
          await userRepository.fetchAndSaveUserProfile(session);

          // Try getting the profile from Ditto again
          return await userRepository.getCurrentUserProfile(currentUser.id);
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
