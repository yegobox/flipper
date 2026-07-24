import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_models/helpers/agent_session_helper.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// ignore: unused_import
import 'package:flutter/foundation.dart' hide Category; // kDebugMode — kept for the commented-out bypass below, see featureAccess
part 'access_provider.g.dart';

@riverpod
Future<bool> isAdmin(
  Ref ref,
  String userId, {
  required String featureName,
}) async {
  return await ProxyService.strategy.isAdmin(
    userId: userId,
    appFeature: featureName,
  );
}

@riverpod
Future<List<Access>> userAccesses(
  Ref ref,
  String userId, {
  required String featureName,
}) async {
  return await ProxyService.strategy.access(
    userId: userId,
    featureName: featureName,
    fetchRemote: false,
  );
}

@riverpod
Future<List<Access>> allAccesses(Ref ref, String userId) async {
  return await ProxyService.strategy.allAccess(userId: userId);
}

@riverpod
Future<Tenant?> tenant(Ref ref, String userId) async {
  return await ProxyService.strategy.tenant(userId: userId, fetchRemote: false);
}

@riverpod
bool featureAccess(
  Ref ref, {
  required String userId,
  required String featureName,
}) {
  try {
    final accesses =
        ref
            .watch(userAccessesProvider(userId, featureName: featureName))
            .value ??
        [];
    final now = DateTime.now();

    if (isCommissionOnlySession()) {
      return featureName == AppFeature.Commission;
    }
    // TEMP (local QA only): disabled so real Access grants are enforced in
    // debug builds while testing the Ticket Review + Handover permission
    // gating. Restore this bypass before committing — other debug-mode
    // workflows in this app rely on it.
    // if (kDebugMode) {
    //   return true;
    // }
    if (accesses.isEmpty) {
      talker.info(
        "Access DENIED for userId: $userId, feature: $featureName (no access records)",
      );
      return false; // Deny access if no accesses exist
    }

    final granted = accesses.any(
      (access) =>
          access.featureName == featureName &&
          (access.accessLevel?.capitalized == "Write" ||
              access.accessLevel?.capitalized == "Admin") &&
          access.status == 'active' &&
          (access.expiresAt == null || access.expiresAt!.isAfter(now)),
    );

    if (granted) {
      talker.info(
        "Access GRANTED for userId: $userId, feature: $featureName | Accesses: ${accesses.map((a) => '{id: ${a.id}, status: ${a.status}, expiresAt: ${a.expiresAt}}').toList()}",
      );
    } else {
      talker.info(
        "Access DENIED for userId: $userId, feature: $featureName | Accesses: ${accesses.map((a) => '{id: ${a.id}, status: ${a.status}, expiresAt: ${a.expiresAt}}').toList()}",
      );
    }

    return granted;
  } catch (e, s) {
    talker.error(e, s);
    return false; // Ensure fail-safe denial
  }
}

/// True when the user has ANY active, non-expired grant for [featureName]
/// (read / read_write / write / admin) — i.e. the user may VIEW the feature.
///
/// Contrast with [featureAccess], which requires write/admin (may EDIT). Gate a
/// feature's tile/screen *visibility* on this so read-only staff can see it;
/// every mutating action inside that screen must still gate on [featureAccess].
/// Fails closed (denies view) on error so a lookup failure never leaks a screen.
@riverpod
bool featureViewAccess(
  Ref ref, {
  required String userId,
  required String featureName,
}) {
  try {
    final accesses =
        ref
            .watch(userAccessesProvider(userId, featureName: featureName))
            .value ??
        [];
    final now = DateTime.now();

    if (isCommissionOnlySession()) {
      return featureName == AppFeature.Commission;
    }

    // Any active, non-expired grant for this feature counts as at least read.
    return accesses.any(
      (access) =>
          access.featureName == featureName &&
          access.status == 'active' &&
          (access.expiresAt == null || access.expiresAt!.isAfter(now)),
    );
  } catch (e, s) {
    talker.error(e, s);
    return false; // Fail-safe: deny view on error
  }
}

/// this check if a user has one accessLevel required to grant him access regardles of the feature
/// e.g if a fature Requires Write, or Admin it will check if a user has these permission in one of the feature and grant them access
/// to whatever he is trying to access
@riverpod
bool featureAccessLevel(
  Ref ref, {
  required String userId,
  required String accessLevel,
}) {
  try {
    final accesses = ref.watch(allAccessesProvider(userId)).value ?? [];
    final now = DateTime.now();
    final normalizedAccessLevel = accessLevel.toLowerCase();
    final granted = accesses.any(
      (access) =>
          access.accessLevel?.toLowerCase() == normalizedAccessLevel &&
          access.status == 'active' &&
          (access.expiresAt == null || access.expiresAt!.isAfter(now)),
    );
    final accessLevelCounts = <String, int>{};
    final userTypeCounts = <String, int>{};

    for (final access in accesses) {
      final accessLevelKey = access.accessLevel ?? 'null';
      final userTypeKey = access.userType ?? 'null';
      accessLevelCounts[accessLevelKey] =
          (accessLevelCounts[accessLevelKey] ?? 0) + 1;
      userTypeCounts[userTypeKey] = (userTypeCounts[userTypeKey] ?? 0) + 1;
    }

    if (granted) {
      talker.info(
        "AccessLevel GRANTED for userId: $userId, accessLevel: $accessLevel | total records: ${accesses.length}, access levels: $accessLevelCounts, user types: $userTypeCounts",
      );
    } else {
      talker.info(
        "AccessLevel DENIED for userId: $userId, accessLevel: $accessLevel | total records: ${accesses.length}, access levels: $accessLevelCounts, user types: $userTypeCounts",
      );
    }

    return granted;
  } catch (e, s) {
    talker.error(e, s);
    return false; // Ensure fail-safe denial
  }
}
