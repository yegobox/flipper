import 'package:flipper_web/core/session_persistence.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/foundation.dart' hide Category;
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

/// Provider for the current user profile.
/// Checks the in-memory cache first (populated right after login), then
/// falls back to Ditto / API for page-reload scenarios.
final currentUserProfileProvider = FutureProvider<UserProfile?>((ref) async {
  // Fast path: profile was cached during this session's login flow.
  final cached = ref.watch(userProfileCacheProvider);
  if (cached != null && cached.hasBusinesses) {
    debugPrint('CurrentUserProfileProvider - returning cached profile');
    return cached;
  }

  try {
    final authService = ref.watch(authServiceProvider);
    final userRepository = ref.watch(userRepositoryProvider);

    final session = await authService.getCurrentSession();
    if (session == null) {
      debugPrint('CurrentUserProfileProvider - no active session');
      return null;
    }

    // Restore login identity after page reload (in-memory providers are empty).
    var loginKey = ref.read(sessionLoginKeyProvider);
    var pinUserId = ref.read(sessionApiUserIdProvider);
    if (pinUserId == null || pinUserId.isEmpty) {
      pinUserId = await SessionPersistence.readApiUserId();
      if (pinUserId != null && pinUserId.isNotEmpty) {
        ref.read(sessionApiUserIdProvider.notifier).state = pinUserId;
      }
    }
    if (loginKey == null || loginKey.isEmpty) {
      loginKey = await SessionPersistence.readLoginKey();
      if (loginKey != null && loginKey.isNotEmpty) {
        ref.read(sessionLoginKeyProvider.notifier).state = loginKey;
      }
    }

    final userProfile = await userRepository.getUserProfileWithFallback(
      session,
      loginKey: loginKey,
      pinUserId: pinUserId,
    );
    debugPrint(
      'CurrentUserProfileProvider - profile ${userProfile != null ? 'found' : 'not found'} via Ditto/API',
    );

    // Warm the cache so subsequent reads are instant.
    if (userProfile != null && userProfile.hasBusinesses) {
      ref.read(userProfileCacheProvider.notifier).state = userProfile;
    }

    return userProfile;
  } catch (e) {
    debugPrint('CurrentUserProfileProvider - error: $e');
    rethrow;
  }
});
