import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/db_model_export.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'access_provider.g.dart';

@riverpod
Future<List<Access>> userAccesses(Ref ref, int userId) async {
  return await ProxyService.strategy.access(userId: userId);
}

@riverpod
bool featureAccess(Ref ref,
    {required int userId, required String featureName}) {
  try {
    final accesses = ref.watch(userAccessesProvider(userId)).value ?? [];
    final now = DateTime.now();

    talker.info("User wants to access: ${featureName}");

    if (accesses.isEmpty) return false; // Deny access if no accesses exist

    // final isRestrictedToTickets = accesses.any((access) =>
    //     access.featureName == AppFeature.Tickets &&
    //     access.status == 'active' &&
    //     (access.expiresAt == null || access.expiresAt!.isAfter(now)));

    // if (isRestrictedToTickets && featureName != AppFeature.Tickets) {
    //   return false; // Users with Tickets permission can only access Tickets
    // }

    return accesses.any((access) =>
        access.featureName == featureName &&
        access.status == 'active' &&
        (access.expiresAt == null || access.expiresAt!.isAfter(now)));
  } catch (e, s) {
    talker.error(e, s);
    return false; // Ensure fail-safe denial
  }
}

@riverpod
bool featureAccessLevel(Ref ref,
    {required int userId, required String accessLevel}) {
  try {
    final accesses = ref.watch(userAccessesProvider(userId)).value ?? [];
    final now = DateTime.now();

    return accesses.any((access) =>
        access.accessLevel == accessLevel &&
        access.status == 'active' &&
        (access.expiresAt == null || access.expiresAt!.isAfter(now)));
  } catch (e, s) {
    talker.error(e, s);
    return false; // Ensure fail-safe denial
  }
}
