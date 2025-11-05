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

    // Get current session
    final session = await authService.getCurrentSession();
    if (session == null) {
      debugPrint('CurrentUserProfileProvider - No current session found');
      return null;
    }

    // Use the fallback method that handles Ditto cache and API fallback
    final userProfile = await userRepository.getUserProfileWithFallback(
      session,
    );
    debugPrint(
      'CurrentUserProfileProvider - Profile ${userProfile != null ? 'found' : 'not found'}',
    );

    return userProfile;
  } catch (e) {
    debugPrint('CurrentUserProfileProvider - Error: $e');
    rethrow;
  }
});
