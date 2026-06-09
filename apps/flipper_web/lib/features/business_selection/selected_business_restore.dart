import 'dart:async';

import 'package:flipper_web/core/business_selection_persistence.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/business_selection_providers.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/modules/accounting/data/accounting_diagnostics.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Restores [selectedBusinessProvider] / [selectedBranchProvider] after reload
/// or hot restart when in-memory selection was cleared.
final selectedBusinessRestoreProvider = Provider<void>((ref) {
  void scheduleRestore(UserProfile? profile) {
    if (profile == null || !profile.hasBusinesses) return;
    unawaited(
      Future.microtask(() async {
        if (!ref.mounted) return;
        await restoreSelectedBusinessFromProfile(ref, profile);
      }),
    );
  }

  ref.listen(userProfileCacheProvider, (_, profile) => scheduleRestore(profile));
  ref.listen(currentUserProfileProvider, (_, asyncProfile) {
    scheduleRestore(asyncProfile.value);
  });

  // Ensures profile fetch runs on /accounting even when cache is empty.
  ref.watch(currentUserProfileProvider);

  scheduleRestore(ref.read(userProfileCacheProvider));
});

/// Applies persisted or default business/branch from [profile] when selection
/// is missing.
Future<void> restoreSelectedBusinessFromProfile(
  Ref ref,
  UserProfile profile,
) async {
  if (!profile.hasBusinesses) return;

  final currentBusiness = ref.read(selectedBusinessProvider);
  final currentBranch = ref.read(selectedBranchProvider);
  if (currentBusiness != null && currentBranch != null) return;

  final tenant = _primaryTenant(profile);
  final businesses = tenant.businesses;
  if (businesses.isEmpty) return;

  Business? business = currentBusiness;
  Branch? branch = currentBranch;

  if (business == null || branch == null) {
    final persisted = await BusinessSelectionPersistence.read(
      userId: profile.id,
    );
    if (persisted != null) {
      business ??= _findBusiness(businesses, persisted.businessId);
      if (business != null) {
        final branches =
            tenant.branches.where((b) => b.businessId == business!.id).toList();
        branch ??= _findBranch(branches, persisted.branchId);
      }
    }
  }

  final resolvedBusiness = business ?? _defaultBusiness(businesses);
  if (resolvedBusiness == null) return;

  if (branch == null) {
    final branches = tenant.branches
        .where((b) => b.businessId == resolvedBusiness.id)
        .toList();
    branch = _defaultBranch(branches);
  }

  var restored = false;
  if (currentBusiness == null) {
    ref.read(selectedBusinessProvider.notifier).set(resolvedBusiness);
    restored = true;
    debugPrint(
      '[Business] restored business name=${resolvedBusiness.name} id=${resolvedBusiness.id}',
    );
  }

  if (currentBranch == null && branch != null) {
    ref.read(selectedBranchProvider.notifier).set(branch);
    restored = true;
    debugPrint(
      '[Business] restored branch name=${branch.name} id=${branch.id}',
    );
  }

  if (restored && branch != null) {
    await BusinessSelectionPersistence.save(
      userId: profile.id,
      businessId: resolvedBusiness.id,
      branchId: branch.id,
    );
    ref.read(bankRecLocalLinesProvider.notifier).state = null;
    ref.read(bankRecFinishedProvider.notifier).state = false;
    ref.invalidate(chartOfAccountsStreamProvider);
    ref.invalidate(journalEntriesStreamProvider);
    ref.invalidate(bankLinesStreamProvider);
    ref.invalidate(rawTransactionStreamProvider);
    ref.invalidate(rawTransactionItemsProvider);
    ref.invalidate(accountingStartupDiagnosticsProvider);
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

Business? _defaultBusiness(List<Business> businesses) {
  for (final b in businesses) {
    if (b.isDefault) return b;
  }
  return businesses.first;
}

Branch? _defaultBranch(List<Branch> branches) {
  if (branches.isEmpty) return null;
  for (final b in branches) {
    if (b.isDefault) return b;
  }
  return branches.first;
}
