import 'package:flipper_models/db_model_export.dart' as models;
import 'package:flipper_services/proxy.dart';
import 'package:flipper_web/core/user_profile_cache.dart';
import 'package:flipper_web/core/utils/ditto_singleton.dart';
import 'package:flipper_web/features/business_selection/business_branch_selector.dart';
import 'package:flipper_web/features/business_selection/session_business_selection.dart';
import 'package:flipper_web/models/user_profile.dart' as web;
import 'package:flipper_web/modules/accounting/data/accounting_providers.dart';
import 'package:flipper_web/services/ditto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Seeds Books (accounting) providers from the native Flipper session
/// ([ProxyService.box]) when the module is opened from the mobile app shell.
Future<void> restoreNativeBooksContext(WidgetRef ref) async {
  final businessId = ProxyService.box.getBusinessId()?.trim();
  final branchId = ProxyService.box.getBranchId()?.trim();
  if (businessId == null ||
      businessId.isEmpty ||
      branchId == null ||
      branchId.isEmpty) {
    debugPrint('[Books] native context skipped — no business/branch in box');
    return;
  }

  final userId = ProxyService.box.getUserId()?.trim();
  if (userId != null && userId.isNotEmpty) {
    ref.read(sessionApiUserIdProvider.notifier).state = userId;
  }

  final existingBusiness = ref.read(selectedBusinessProvider);
  final existingBranch = ref.read(selectedBranchProvider);
  if (existingBusiness?.id == businessId && existingBranch?.id == branchId) {
    _markNativeDittoReady(ref);
    return;
  }

  try {
    final nativeBusiness = await ProxyService.strategy.getBusiness(
      businessId: businessId,
    );
    if (nativeBusiness == null) {
      debugPrint('[Books] native context — business $businessId not found locally');
      return;
    }

    final branches = await ProxyService.strategy.branches(
      businessId: businessId,
      active: true,
    );
    models.Branch? nativeBranch;
    for (final branch in branches) {
      if (branch.id.toString() == branchId) {
        nativeBranch = branch;
        break;
      }
    }
    nativeBranch ??= branches.isNotEmpty ? branches.first : null;
    if (nativeBranch == null) {
      debugPrint('[Books] native context — branch $branchId not found locally');
      return;
    }

    ref.read(selectedBusinessProvider.notifier).set(
          _mapBusiness(nativeBusiness),
        );
    ref.read(selectedBranchProvider.notifier).set(
          _mapBranch(nativeBranch, businessId: businessId),
        );
    lockSessionBranchChoice(ref);
    _markNativeDittoReady(ref);
    debugPrint(
      '[Books] native context restored '
      'business=${nativeBusiness.name} branch=${nativeBranch.name}',
    );
  } catch (e, st) {
    debugPrint('[Books] native context restore failed: $e\n$st');
  }
}

void _markNativeDittoReady(WidgetRef ref) {
  // Books ledger streams use [DittoService], not [ProxyService.ditto].
  final ditto = DittoSingleton.instance.ditto;
  if (ditto != null && !DittoService.instance.isReady()) {
    DittoService.instance.setDitto(ditto);
  }

  if (!DittoService.instance.isReady()) {
    debugPrint('[Books] DittoService not ready — ledger streams deferred');
    return;
  }

  final wasReady = ref.read(dittoReadyProvider);
  ref.read(dittoReadyProvider.notifier).state = true;
  if (!wasReady) {
    // WidgetRef is not a Ref — use the container-based invalidation helper.
    invalidateAccountingDataStreamsInContainer(
      ProviderScope.containerOf(ref.context, listen: false),
    );
    ref.invalidate(accountingPostSyncBootstrapProvider);
  }
}

web.Business _mapBusiness(models.Business business) {
  return web.Business(
    id: business.id,
    name: business.name ?? '',
    country: business.country ?? '',
    currency: business.currency ?? 'RWF',
    latitude: '${business.latitude ?? 0}',
    longitude: '${business.longitude ?? 0}',
    active: business.active ?? true,
    userId: business.userId ?? '',
    phoneNumber: business.phoneNumber ?? '',
    lastSeen: business.lastSeen ?? 0,
    backUpEnabled: business.backUpEnabled ?? false,
    fullName: business.fullName ?? business.name ?? '',
    tinNumber: business.tinNumber ?? 0,
    taxEnabled: business.taxEnabled ?? false,
    businessTypeId: business.businessTypeId ?? 0,
    serverId: business.serverId,
    isDefault: business.isDefault ?? false,
    lastSubscriptionPaymentSucceeded:
        business.isLastSubscriptionPaymentSucceeded ?? false,
  );
}

web.Branch _mapBranch(
  models.Branch branch, {
  required String businessId,
}) {
  return web.Branch(
    id: branch.id,
    description: branch.description ?? branch.location ?? '',
    name: branch.name ?? '',
    longitude: '${branch.longitude ?? 0}',
    latitude: '${branch.latitude ?? 0}',
    businessId: branch.businessId ?? businessId,
    serverId: branch.serverId ?? 0,
    active: true,
    isDefault: branch.isDefault ?? false,
  );
}
