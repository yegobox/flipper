import 'dart:async';

import 'package:flipper_web/core/business_selection_persistence.dart';
import 'package:flipper_web/core/ditto/ditto_bootstrap.dart';
import 'package:flipper_web/core/session_persistence.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/repositories/user_repository.dart';
import 'package:flipper_web/services/auth_service.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Whether Books can open: explicit in-memory selection or valid persisted choice.
final hasSelectedBusinessAndBranchProvider = FutureProvider<bool>((ref) async {
  final inMemoryBusiness = ref.watch(selectedBusinessProvider);
  final inMemoryBranch = ref.watch(selectedBranchProvider);
  if (inMemoryBusiness != null && inMemoryBranch != null) {
    return true;
  }

  try {
    final profile = await ref.watch(currentUserProfileProvider.future);
    if (profile == null || !profile.hasBusinesses) {
      return false;
    }

    final apiUserId = await SessionPersistence.readApiUserId();
    final persisted = await BusinessSelectionPersistence.readForUserIds([
      profile.id,
      if (apiUserId != null) apiUserId,
    ]);
    if (persisted == null) return false;

    final tenant = _primaryTenant(profile);
    final business = tenant.businesses
        .where((b) => b.id == persisted.businessId)
        .firstOrNull;
    if (business == null) return false;

    final branch = tenant.branches
        .where(
          (b) =>
              b.businessId == business.id && b.id == persisted.branchId,
        )
        .firstOrNull;
    return branch != null;
  } catch (e) {
    debugPrint('Error checking business/branch selection: $e');
    return false;
  }
});

Tenant _primaryTenant(UserProfile profile) {
  for (final t in profile.tenants) {
    if (t.businesses.isNotEmpty) return t;
  }
  return profile.tenants.first;
}

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
      final rawPayload = userRepository.lastFetchedApiPayload;
      if (rawPayload != null) {
        ref.read(userProfileApiPayloadCacheProvider.notifier).state = rawPayload;
      }
      if (pinUserId != userProfile.id) {
        ref.read(sessionApiUserIdProvider.notifier).state = userProfile.id;
        unawaited(SessionPersistence.save(apiUserId: userProfile.id));
      }
    }

    final dittoUserId = (userProfile?.id ?? pinUserId ?? '').trim();
    if (dittoUserId.isNotEmpty) {
      unawaited(DittoBootstrap.ensureInitialized(ref, userId: dittoUserId));
      final rawPayload = ref.read(userProfileApiPayloadCacheProvider);
      if (rawPayload != null && userProfile != null) {
        unawaited(
          ref.read(userRepositoryProvider).persistProfileToDitto(
            apiPayload: rawPayload,
            profile: userProfile,
          ),
        );
      }
    }

    return userProfile;
  } catch (e) {
    debugPrint('CurrentUserProfileProvider - error: $e');
    rethrow;
  }
});
