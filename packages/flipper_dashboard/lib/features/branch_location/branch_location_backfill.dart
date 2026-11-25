import 'dart:convert';

import 'package:flipper_dashboard/features/branch_location/branch_location_picker.dart';
import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/branch_coordinates.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_services/abstractions/location.dart';
import 'package:flipper_services/constants.dart';
import 'package:flutter/material.dart';
import 'package:supabase_models/brick/repository/storage.dart';

const _snoozeKey = 'branchLocationPromptSnooze';
const _notNowSnooze = Duration(days: 7);
const _failureSnooze = Duration(days: 1);

/// Branches created before coordinates were captured carry placeholders
/// (null, 0/0, 1/1 …). When an owner/admin opens Flipper on an Android phone
/// at such a branch, ask whether they are standing at it and, only if they
/// say yes, store the phone's GPS position as the branch location.
///
/// Never throws; every guard that fails just skips the prompt.
Future<void> maybePromptBranchLocationBackfill(
  BuildContext context,
  BranchServices services,
) async {
  try {
    if (!services.isAndroid) return;
    final box = services.box;
    final branchId = box.getBranchId();
    final userId = box.getUserId();
    if (branchId == null || userId == null) return;
    if (_isSnoozed(box, branchId)) return;

    final isAdmin = await services.strategy.isAdmin(
      userId: userId,
      appFeature: AppFeature.Settings,
    );
    if (!isAdmin) return;

    // Read Supabase, not the cache: another device may already have set it,
    // and Ditto `branches` is send-only so the local copy never learns that.
    // Offline returns null, and saving would fail anyway.
    final branch = await services.remoteBranch(branchId);
    if (branch == null) return;
    if (hasRealBranchCoordinates(branch.latitude, branch.longitude)) return;
    if (!context.mounted) return;

    final l10n = context.flipperL10n;
    final branchName = branch.name ?? '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(Icons.storefront_outlined),
        title: Text(l10n.branchLocationPromptTitle(branchName)),
        content: Text(l10n.branchLocationPromptBody(branchName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.branchLocationNotNow),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Icons.my_location, size: 18),
            label: Text(l10n.branchLocationSave),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      await _snooze(box, branchId, _notNowSnooze);
      return;
    }
    if (!context.mounted) return;

    await _captureAndSave(
      context,
      services,
      branchId,
      ScaffoldMessenger.maybeOf(context),
      l10n,
    );
  } catch (e, s) {
    talker.warning('Branch location prompt skipped: $e\n$s');
  }
}

enum _FailureChoice { tryAgain, openSettings, notNow }

/// Reads the position and saves it as the branch location. When there is no
/// fix the user can try again, give up for now, or open the settings screen
/// that fixes it; coming back from settings tries again on its own, so the
/// location still gets saved without waiting for the next prompt.
///
/// [messenger] and [l10n] are taken up front so the result can still be
/// shown after a retry that outlived [context].
Future<void> _captureAndSave(
  BuildContext context,
  BranchServices services,
  String branchId,
  ScaffoldMessengerState? messenger,
  FlipperAppLocalizations l10n,
) async {
  final box = services.box;
  while (true) {
    final outcome = await services.location.currentPosition();
    final failure = outcome.failure;
    if (failure == null) {
      await _saveCoordinates(
        services,
        branchId,
        outcome.latitude!,
        outcome.longitude!,
        messenger,
        l10n,
      );
      return;
    }
    final choice = context.mounted
        ? await _askAfterFailure(context, failure)
        : _FailureChoice.notNow;
    switch (choice) {
      case _FailureChoice.tryAgain:
        continue;
      case _FailureChoice.openSettings:
        // No snooze yet: if Android kills Flipper while the user is in
        // settings, the prompt simply comes back at the next start.
        final cancel = onNextAppResume(() async {
          try {
            await _captureAndSave(context, services, branchId, messenger, l10n);
          } catch (e, s) {
            talker.warning('Branch location retry failed: $e\n$s');
          }
        });
        if (!await services.location.openSettingsFor(failure)) {
          cancel();
          await _snooze(box, branchId, _failureSnooze);
        }
        return;
      case _FailureChoice.notNow:
        // Refusing the system dialog is an answer like "Not now"; anything
        // else (location off, blocked, no fix) is worth another try tomorrow.
        await _snooze(
          box,
          branchId,
          failure == LocationFailure.denied ? _notNowSnooze : _failureSnooze,
        );
        return;
    }
  }
}

/// A dialog rather than a snackbar: the user has to see the way to fix it.
Future<_FailureChoice> _askAfterFailure(
  BuildContext context,
  LocationFailure failure,
) async {
  final l10n = context.flipperL10n;
  final choice = await showDialog<_FailureChoice>(
    context: context,
    builder: (dialogContext) {
      void pick(_FailureChoice c) => Navigator.of(dialogContext).pop(c);
      return AlertDialog(
        icon: const Icon(Icons.location_off_outlined),
        content: Text(locationFailureMessage(context, failure)),
        actions: [
          TextButton(
            onPressed: () => pick(_FailureChoice.notNow),
            child: Text(l10n.branchLocationNotNow),
          ),
          if (locationFailureNeedsSettings(failure)) ...[
            TextButton(
              onPressed: () => pick(_FailureChoice.tryAgain),
              child: Text(l10n.branchLocationTryAgain),
            ),
            FilledButton.icon(
              onPressed: () => pick(_FailureChoice.openSettings),
              icon: const Icon(Icons.settings_outlined, size: 18),
              label: Text(l10n.branchLocationOpenSettings),
            ),
          ] else
            FilledButton(
              onPressed: () => pick(_FailureChoice.tryAgain),
              child: Text(l10n.branchLocationTryAgain),
            ),
        ],
      );
    },
  );
  return choice ?? _FailureChoice.notNow;
}

Future<void> _saveCoordinates(
  BranchServices services,
  String branchId,
  double latitude,
  double longitude,
  ScaffoldMessengerState? messenger,
  FlipperAppLocalizations l10n,
) async {
  try {
    await services.strategy.updateBranchCoordinates(
      branchId: branchId,
      latitude: latitude,
      longitude: longitude,
      flipperHttpClient: services.http,
    );
  } catch (e) {
    talker.warning('Saving branch location failed: $e');
    await _snooze(services.box, branchId, _failureSnooze);
    _showSnack(messenger, l10n.branchLocationSaveFailed);
    return;
  }
  _showSnack(messenger, l10n.branchLocationSaved);
}

Map<String, dynamic> _readSnoozes(LocalStorage box) {
  final raw = box.readString(key: _snoozeKey);
  if (raw == null || raw.isEmpty) return {};
  try {
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  } catch (_) {
    return {};
  }
}

bool _isSnoozed(LocalStorage box, String branchId) {
  final until = DateTime.tryParse('${_readSnoozes(box)[branchId] ?? ''}');
  return until != null && DateTime.now().isBefore(until);
}

Future<void> _snooze(LocalStorage box, String branchId, Duration duration) {
  final snoozes = _readSnoozes(box)
    ..[branchId] = DateTime.now().add(duration).toIso8601String();
  return box.writeString(key: _snoozeKey, value: jsonEncode(snoozes));
}

void _showSnack(ScaffoldMessengerState? messenger, String message) {
  if (messenger == null || !messenger.mounted) return;
  messenger.showSnackBar(SnackBar(content: Text(message)));
}
