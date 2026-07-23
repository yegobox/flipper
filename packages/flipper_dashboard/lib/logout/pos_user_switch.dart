import 'dart:async';

import 'package:flipper_dashboard/logout/pos_switch_user_dialog.dart';
import 'package:flipper_dashboard/logout/pos_user_switch_lock_provider.dart';
import 'package:flipper_dashboard/logout/shift_before_logout.dart';
import 'package:flipper_dashboard/providers/navigation_providers.dart';
import 'package:flipper_dashboard/widgets/pos_shift_gate.dart';
import 'package:flipper_models/helperModels/pin.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/providers/access_provider.dart';
import 'package:flipper_models/providers/optimistic_cart_provider.dart';
import 'package:flipper_models/providers/scan_mode_provider.dart';
import 'package:flipper_models/providers/transactions_provider.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_services/constants.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:supabase_models/brick/models/pin.model.dart';
import 'package:supabase_models/brick/models/tenant.model.dart';

const Duration _kSwitchUserLoginTimeout = Duration(seconds: 45);

/// Sentinel so [clearPendingSaleCartsExcept] deletes every pending cart for
/// the outgoing agent (no transaction is excluded).
const String _kExcludeNoneTransactionId = '__pos_switch_user_clear_all__';

void _invalidateAccessProviders(WidgetRef ref, String? userId) {
  if (userId == null || userId.isEmpty) return;
  ref.invalidate(allAccessesProvider(userId));
  for (final f in features) {
    ref.invalidate(userAccessesProvider(userId, featureName: f));
  }
}

void _refreshPosStateAfterUserSwitch(WidgetRef ref) {
  ref.invalidate(currentOpenShiftProvider);
  ref.invalidate(pendingTransactionStreamProvider(isExpense: false));
  ref.invalidate(optimisticCartProvider);
  ref.read(searchStringProvider.notifier).emitString(value: 'search');
  ref.read(searchStringProvider.notifier).emitString(value: '');
}

Future<bool> _shouldForceOfflineLogin(String enteredPin, int? cachedPin) async {
  final online = await ProxyService.status.isInternetAvailable();
  if (online) return false;
  final entered = int.tryParse(enteredPin);
  if (entered == null || cachedPin == null) return false;
  return cachedPin == entered;
}

Pin _pinFromRecord({
  required Tenant tenant,
  required String enteredPin,
  required IPin? pinRecord,
}) {
  final parsed = int.tryParse(enteredPin) ?? tenant.pin ?? 0;
  if (pinRecord != null) {
    return Pin(
      userId: pinRecord.userId.isNotEmpty ? pinRecord.userId : tenant.userId,
      pin: pinRecord.pin,
      businessId: pinRecord.businessId.isNotEmpty
          ? pinRecord.businessId
          : (tenant.businessId ?? ProxyService.box.getBusinessId()),
      branchId: pinRecord.branchId.isNotEmpty
          ? pinRecord.branchId
          : ProxyService.box.getBranchId(),
      ownerName: (pinRecord.ownerName?.isNotEmpty == true)
          ? pinRecord.ownerName
          : (tenant.name ?? ''),
      phoneNumber: pinRecord.phoneNumber.isNotEmpty
          ? pinRecord.phoneNumber
          : (tenant.phoneNumber ?? tenant.email ?? ''),
      tokenUid: pinRecord.tokenUid,
    );
  }
  return Pin(
    userId: tenant.userId,
    pin: parsed,
    businessId: tenant.businessId ?? ProxyService.box.getBusinessId(),
    branchId: ProxyService.box.getBranchId(),
    ownerName: tenant.name ?? '',
    phoneNumber: tenant.phoneNumber ?? tenant.email ?? '',
  );
}

Future<void> _clearOutgoingCartSilently({
  required String? outgoingUserId,
  required String? branchId,
}) async {
  if (outgoingUserId == null ||
      outgoingUserId.isEmpty ||
      branchId == null ||
      branchId.isEmpty) {
    return;
  }
  try {
    await ProxyService.strategy.clearPendingSaleCartsExcept(
      branchId: branchId,
      agentId: outgoingUserId,
      excludeTransactionId: _kExcludeNoneTransactionId,
    );
  } catch (e, s) {
    talker.warning('clearPendingSaleCartsExcept during user switch: $e\n$s');
  }
}

/// Closes the outgoing shift, clears their cart, and shows the PIN lock
/// (POS is hidden — same handoff feel as Bar Mode).
///
/// Returns `true` when the lock screen should be shown.
Future<bool> beginPosUserSwitchLock({
  required BuildContext context,
  required WidgetRef ref,
  required DialogService dialogService,
}) async {
  if (ref.read(posUserSwitchLockProvider)) return true;

  final outgoingUserId = ProxyService.box.getUserId();
  final branchId = ProxyService.box.getBranchId();

  final proceed = await prepareSessionExitAfterShiftHandling(
    context: context,
    dialogService: dialogService,
    confirmWhenNoOpenShift: false,
    loaderUseRootNavigator: true,
    forUserSwitch: true,
  );
  if (!proceed || !context.mounted) return false;

  // Flip to the lock immediately — no blocking "Preparing…" dialog.
  ref.read(selectedMenuItemProvider.notifier).state = 0;
  ref.read(posUserSwitchLockProvider.notifier).state = true;
  _refreshPosStateAfterUserSwitch(ref);

  // Cart cleanup can finish while staff pick themselves on the lock screen.
  unawaited(
    _clearOutgoingCartSilently(
      outgoingUserId: outgoingUserId,
      branchId: branchId,
    ),
  );
  return true;
}

/// Completes the session switch after staff + PIN on the lock screen.
///
/// Callers should show their own inline busy state — this does not present
/// a blocking progress dialog.
///
/// Returns `true` when the new user is signed in (caller clears the lock).
Future<bool> completePosUserSwitchAfterPin({
  required BuildContext context,
  required WidgetRef ref,
  required DialogService dialogService,
  required PosSwitchUserSelection selection,
}) async {
  final tenant = selection.tenant;
  final enteredPin = selection.pin.trim();
  final expectedUserId = tenant.userId?.trim();
  if (expectedUserId == null || expectedUserId.isEmpty) {
    if (context.mounted) {
      await dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Cannot switch user',
        description: 'This staff member has no linked user account.',
      );
    }
    return false;
  }

  final outgoingUserId = ProxyService.box.getUserId();

  try {
    IPin? pinRecord;
    try {
      pinRecord = await ProxyService.strategy.getPin(
        pinString: enteredPin,
        flipperHttpClient: ProxyService.http,
      );
    } catch (e, s) {
      talker.warning('completePosUserSwitchAfterPin getPin failed: $e\n$s');
    }

    if (pinRecord != null &&
        pinRecord.userId.trim().isNotEmpty &&
        pinRecord.userId.trim() != expectedUserId) {
      throw StateError('PIN does not match the selected staff member.');
    }

    final forceOffline = await _shouldForceOfflineLogin(
      enteredPin,
      pinRecord?.pin ?? tenant.pin,
    );

    if (pinRecord == null && !forceOffline) {
      final localMatch = int.tryParse(enteredPin) != null &&
          tenant.pin != null &&
          int.tryParse(enteredPin) == tenant.pin;
      if (!localMatch) {
        throw StateError('Could not resolve PIN for the selected staff member.');
      }
    }

    final pin = _pinFromRecord(
      tenant: tenant,
      enteredPin: enteredPin,
      pinRecord: pinRecord,
    );

    final userPhone = (pin.phoneNumber != null && pin.phoneNumber!.isNotEmpty)
        ? pin.phoneNumber!
        : (tenant.phoneNumber ?? tenant.email ?? expectedUserId);

    await ProxyService.strategy
        .login(
          userPhone: userPhone,
          isInSignUpProgress: false,
          skipDefaultAppSetup: true,
          stopAfterConfigure: true,
          forceOffline: forceOffline,
          pin: pin,
          flipperHttpClient: ProxyService.http,
        )
        .timeout(_kSwitchUserLoginTimeout);

    await ProxyService.box.writeBool(key: 'authComplete', value: true);

    final displayName = tenant.name?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      await ProxyService.box.writeString(key: 'userName', value: displayName);
    }

    _invalidateAccessProviders(ref, outgoingUserId);
    _invalidateAccessProviders(ref, ProxyService.box.getUserId());
    _refreshPosStateAfterUserSwitch(ref);
  } catch (e, s) {
    talker.error('completePosUserSwitchAfterPin failed: $e', s);
    if (context.mounted) {
      await dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Could not switch user',
        description: e.toString(),
      );
    }
    return false;
  }

  if (!context.mounted) return true;

  final response = await dialogService.showCustomDialog(
    variant: DialogType.startShift,
    title: 'Start New Shift',
  );
  if (response != null && response.confirmed) {
    ref.invalidate(currentOpenShiftProvider);
  }

  return true;
}
