import 'dart:convert';

import 'package:flipper_dashboard/features/branch_location/branch_services.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/helpers/branch_coordinates.dart';
import 'package:flipper_models/helperModels/talker.dart';
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

    final position = await services.location.currentPosition();
    if (position == null) {
      await _snooze(box, branchId, _failureSnooze);
      if (context.mounted) _showSnack(context, l10n.branchLocationUnavailable);
      return;
    }
    try {
      await services.strategy.updateBranchCoordinates(
        branchId: branchId,
        latitude: position.latitude,
        longitude: position.longitude,
        flipperHttpClient: services.http,
      );
    } catch (e) {
      talker.warning('Saving branch location failed: $e');
      await _snooze(box, branchId, _failureSnooze);
      if (context.mounted) _showSnack(context, l10n.branchLocationSaveFailed);
      return;
    }
    if (context.mounted) _showSnack(context, l10n.branchLocationSaved);
  } catch (e, s) {
    talker.warning('Branch location prompt skipped: $e\n$s');
  }
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

void _showSnack(BuildContext context, String message) {
  ScaffoldMessenger.maybeOf(
    context,
  )?.showSnackBar(SnackBar(content: Text(message)));
}
