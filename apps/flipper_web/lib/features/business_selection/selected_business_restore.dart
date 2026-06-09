import 'dart:async';

import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/models/user_profile.dart';
import 'package:flipper_web/modules/accounting/data/accounting_diagnostics.dart';
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Restores [selectedBusinessProvider] / [selectedBranchProvider] from the
/// cached user profile when in-memory selection was lost (page reload or
/// AuthWrapper redirect straight to `/accounting`).
final selectedBusinessRestoreProvider = Provider<void>((ref) {
  void scheduleRestore(UserProfile? profile) {
    if (profile == null || !profile.hasBusinesses) return;
    unawaited(
      Future.microtask(() {
        if (!ref.mounted) return;
        restoreSelectedBusinessFromProfile(ref, profile);
      }),
    );
  }

  ref.listen(userProfileCacheProvider, (_, profile) => scheduleRestore(profile));
  scheduleRestore(ref.read(userProfileCacheProvider));
});

/// Applies default business/branch from [profile] when selection is missing.
void restoreSelectedBusinessFromProfile(Ref ref, UserProfile profile) {
  if (!profile.hasBusinesses) return;

  final currentBusiness = ref.read(selectedBusinessProvider);
  final currentBranch = ref.read(selectedBranchProvider);
  if (currentBusiness != null && currentBranch != null) return;

  Tenant tenant = profile.tenants.first;
  for (final t in profile.tenants) {
    if (t.businesses.isNotEmpty) {
      tenant = t;
      break;
    }
  }

  final businesses = tenant.businesses;
  if (businesses.isEmpty) return;

  Business? defaultBusiness;
  for (final b in businesses) {
    if (b.isDefault) {
      defaultBusiness = b;
      break;
    }
  }
  final business = currentBusiness ?? defaultBusiness ?? businesses.first;

  var restored = false;
  if (currentBusiness == null) {
    ref.read(selectedBusinessProvider.notifier).set(business);
    restored = true;
    debugPrint(
      '[Business] restored business name=${business.name} id=${business.id}',
    );
  }

  if (currentBranch == null) {
    final branches =
        tenant.branches.where((b) => b.businessId == business.id).toList();
    Branch? defaultBranch;
    for (final b in branches) {
      if (b.isDefault) {
        defaultBranch = b;
        break;
      }
    }
    final branch =
        defaultBranch ?? (branches.isNotEmpty ? branches.first : null);
    if (branch != null) {
      ref.read(selectedBranchProvider.notifier).set(branch);
      restored = true;
      debugPrint(
        '[Business] restored branch name=${branch.name} id=${branch.id}',
      );
    }
  }

  if (restored) {
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
