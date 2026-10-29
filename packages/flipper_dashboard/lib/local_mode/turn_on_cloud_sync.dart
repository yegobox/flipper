import 'package:flipper_dashboard/local_mode/local_mode_access_gate.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/services/local_mode_controller.dart';
import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

/// Opts a local-mode device in to cloud sync, after the user confirms.
///
/// One-way. The user signs in again to finish: the next login reopens the
/// Ditto store with the cloud connect, uploads its documents, and startup's
/// payment check shows the plan picker like any new business. The standard
/// sign-out dialog does the sign-out, so open shifts are handled as usual.
Future<void> confirmAndTurnOnCloudSync(BuildContext context) async {
  final l10n = context.flipperL10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: Text(l10n.localModeOptInTitle),
      content: Text(l10n.localModeOptInBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.localModeOptInConfirm),
        ),
      ],
    ),
  );
  if (confirmed != true) return;

  final result = await LocalModeController.optInToSync(
    sessionBusinessId: LocalModeAccessGate.passedFor,
  );
  if (result != CloudSyncOptIn.done) {
    if (!context.mounted) return;
    final message = result == CloudSyncOptIn.notOwner
        ? l10n.localModeDeviceHeldBody
        : l10n.localModeOptInOffline;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
    return;
  }

  await locator<DialogService>().showCustomDialog(
    variant: DialogType.logOut,
    title: l10n.localModeTurnOnSync,
  );
}
