import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_provider.g.dart';

@riverpod
Future<List<Access>> userAccesses(Ref ref, int userId,
    {required String featureName}) async {
  return await ProxyService.strategy
      .access(userId: userId, featureName: featureName, fetchRemote: false);
}

@riverpod
Future<List<Access>> allAccesses(Ref ref, int userId) async {
  return await ProxyService.strategy.allAccess(userId: userId);
}

@riverpod
Future<Tenant?> tenant(Ref ref, int userId) async {
  return await ProxyService.strategy.tenant(userId: userId, fetchRemote: false);
}

@riverpod
bool featureAccess(Ref ref,
    {required int userId, required String featureName}) {
  try {
    final accesses = ref
            .watch(userAccessesProvider(userId, featureName: featureName))
            .value ??
        [];
    final now = DateTime.now();

    talker.info("User wants to access!: $featureName");

    if (accesses.isEmpty) {
      talker.info(
          "Access DENIED for userId: $userId, feature: $featureName (no access records)");
      return false; // Deny access if no accesses exist
    }

    final granted = accesses.any((access) =>
        access.featureName == featureName &&
        (access.accessLevel?.capitalized == "Write" ||
            access.accessLevel?.capitalized == "Admin") &&
        access.status == 'active' &&
        (access.expiresAt == null || access.expiresAt!.isAfter(now)));

    if (granted) {
      talker.info(
          "Access GRANTED for userId: $userId, feature: $featureName | Accesses: ${accesses.map((a) => '{id: ${a.id}, status: ${a.status}, expiresAt: ${a.expiresAt}}').toList()}");
    } else {
      talker.info(
          "Access DENIED for userId: $userId, feature: $featureName | Accesses: ${accesses.map((a) => '{id: ${a.id}, status: ${a.status}, expiresAt: ${a.expiresAt}}').toList()}");
    }

    return granted;
  } catch (e, s) {
    talker.error(e, s);
    return false; // Ensure fail-safe denial
  }
}

/// this check if a user has one accessLevel required to grant him access regardles of the feature
/// e.g if a fature Requires Write, or Admin it will check if a user has these permission in one of the feature and grant them access
/// to whatever he is trying to access
@riverpod
bool featureAccessLevel(Ref ref,
    {required int userId, required String accessLevel}) {
  try {
    Tenant? accesses = ref.watch(tenantProvider(userId)).value;
    final granted = accesses?.type?.toLowerCase() == accessLevel.toLowerCase();

    if (granted) {
      talker.info(
          "AccessLevel GRANTED for userId: $userId, accessLevel: $accessLevel | Accesses: ${accesses?.type}");
    } else {
      talker.info(accesses?.type);
      talker.info(accessLevel);
      talker.info(
          "AccessLevel DENIED for userId: $userId, accessLevel: $accessLevel | Accesses: ${accesses?.type}");
    }

    return granted;
  } catch (e, s) {
    talker.error(e, s);
    return false; // Ensure fail-safe denial
  }
}
