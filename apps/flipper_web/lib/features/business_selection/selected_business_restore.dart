import 'package:flipper_web/core/ditto/ditto_bootstrap.dart';
import 'package:flipper_web/core/business_selection_persistence.dart';
import 'package:flipper_web/core/session_persistence.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/features/business_selection/session_business_selection.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Restores [selectedBusinessProvider] / [selectedBranchProvider] after reload
/// or navigation before Books reads [accountingBusinessIdProvider].
final selectedBusinessRestoreProvider = FutureProvider<void>((ref) async {
  // Read (not watch) — watching would re-run this provider when restore sets
  // selectedBusinessProvider / selectedBranchProvider (circular dependency).
  ref.read(selectedBusinessProvider);
  ref.read(selectedBranchProvider);

  // Native Flipper shell seeds selection from ProxyService.box before Books opens.
  if (ref.read(selectedBusinessProvider) != null &&
      ref.read(selectedBranchProvider) != null) {
    await DittoBootstrap.kickoffIfNeeded(ref);
    final businessId = ref.read(selectedBusinessProvider)!.id;
    kickoffAccountingBootstrapFromRef(ref, businessId);
    return;
  }

  final cached = ref.read(userProfileCacheProvider);
  if (cached != null && cached.hasBusinesses) {
    await restoreSelectedBusinessFromProfile(ref, cached);
    await DittoBootstrap.kickoffIfNeeded(ref);
    return;
  }

  final profile = await ref.read(currentUserProfileProvider.future);
  if (profile != null && profile.hasBusinesses) {
    await restoreSelectedBusinessFromProfile(ref, profile);
  }
  await DittoBootstrap.kickoffIfNeeded(ref);
});

/// Applies persisted business/branch from [profile] when selection is missing.
/// Does not pick defaults — fresh logins must use Login Choices.
Future<void> restoreSelectedBusinessFromProfile(
  Ref ref,
  UserProfile profile,
) async {
  if (!profile.hasBusinesses) return;

  if (ref.read(sessionBranchChoiceLockedProvider)) {
    debugPrint(
      '[Business] restore skipped — branch locked by login choices '
      '(branch=${ref.read(selectedBranchProvider)?.name})',
    );
    return;
  }

  final currentBusiness = ref.read(selectedBusinessProvider);
  final currentBranch = ref.read(selectedBranchProvider);
  if (currentBusiness != null && currentBranch != null) {
    debugPrint(
      '[Business] restore skipped — already selected '
      'business=${currentBusiness.name} branch=${currentBranch.name}',
    );
    return;
  }

  final tenant = _primaryTenant(profile);
  final businesses = tenant.businesses;
  if (businesses.isEmpty) return;

  Business? business = currentBusiness;
  Branch? branch = currentBranch;

  if (business == null || branch == null) {
    final apiUserId = await SessionPersistence.readApiUserId();
    final persisted = await BusinessSelectionPersistence.readForUserIds([
      profile.id,
      if (apiUserId != null) apiUserId,
    ]);
    if (persisted != null) {
      business ??= _findBusiness(businesses, persisted.businessId);
      if (business != null) {
        final branches =
            tenant.branches.where((b) => b.businessId == business!.id).toList();
        branch ??= _findBranch(branches, persisted.branchId);
      }
    }
  }

  if (business == null || branch == null) {
    debugPrint(
      '[Business] restore skipped — no persisted selection '
      '(login choices required)',
    );
    return;
  }

  final resolvedBusiness = business;

  // Re-read after async persistence lookup — login choices may have run meanwhile.
  final liveBusiness = ref.read(selectedBusinessProvider);
  final liveBranch = ref.read(selectedBranchProvider);
  if (liveBusiness != null && liveBranch != null) {
    debugPrint(
      '[Business] restore aborted — selection set during restore '
      '(branch=${liveBranch.name} id=${liveBranch.id})',
    );
    return;
  }

  var restored = false;
  if (liveBusiness == null) {
    ref.read(selectedBusinessProvider.notifier).set(resolvedBusiness);
    restored = true;
    debugPrint(
      '[Business] restored business name=${resolvedBusiness.name} id=${resolvedBusiness.id}',
    );
  }

  if (liveBranch == null && branch != null) {
    ref.read(selectedBranchProvider.notifier).set(branch);
    restored = true;
    debugPrint(
      '[Business] restored branch name=${branch.name} id=${branch.id}',
    );
  }

  if (restored && branch != null) {
    final apiUserId = await SessionPersistence.readApiUserId();
    await BusinessSelectionPersistence.save(
      userId: apiUserId ?? profile.id,
      businessId: resolvedBusiness.id,
      branchId: branch.id,
    );
    ref.read(bankRecLocalLinesProvider.notifier).state = null;
    ref.read(bankRecFinishedProvider.notifier).state = false;
    kickoffAccountingBootstrapFromRef(ref, resolvedBusiness.id);
    // Streams rebuild via accountingBusinessIdProvider when selection is set.
  }
}

Tenant _primaryTenant(UserProfile profile) {
  for (final t in profile.tenants) {
    if (t.businesses.isNotEmpty) return t;
  }
  return profile.tenants.first;
}

Business? _findBusiness(List<Business> businesses, String id) {
  for (final b in businesses) {
    if (b.id == id) return b;
  }
  return null;
}

Branch? _findBranch(List<Branch> branches, String id) {
  for (final b in branches) {
    if (b.id == id) return b;
  }
  return null;
}
