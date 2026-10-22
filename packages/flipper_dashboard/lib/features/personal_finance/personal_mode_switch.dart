import 'package:flipper_dashboard/theme/pos_tokens.dart';
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/account_mode/account_mode.dart';
import 'package:flipper_models/account_mode/account_mode_providers.dart';
import 'package:flipper_models/services/payment_verification_navigator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Where the app goes after a switch. Tests override it.
typedef AccountModeAfterSwitch = Future<void> Function(AccountMode mode);

final accountModeAfterSwitchProvider = Provider<AccountModeAfterSwitch>(
  (ref) => (mode) async {
    if (mode.isPersonal) {
      await PaymentVerificationNavigator.navigateToAuthenticatedHome(
        clearStack: true,
      );
    } else {
      // Back to a shop: the normal plan check decides between the POS and
      // the plan screen.
      await PaymentVerificationNavigator.verifyAndNavigate(userInitiated: true);
    }
  },
);

/// Asks, switches the active business to [target] on the server, then moves
/// the app into the matching shell. Owner/admin only — callers show the entry
/// point only to them; the server also acts only for this device's business.
Future<void> confirmAndSwitchAccountMode(
  BuildContext context,
  WidgetRef ref,
  AccountMode target,
) async {
  final l10n = context.flipperL10n;
  final toPersonal = target.isPersonal;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      key: const ValueKey('account-mode-switch-dialog'),
      title: Text(
        toPersonal
            ? l10n.personalMoneySwitchToPersonal
            : l10n.personalMoneySwitchToBusiness,
      ),
      content: Text(
        toPersonal
            ? l10n.personalMoneySwitchToPersonalBody
            : l10n.personalMoneySwitchToBusinessBody,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          key: const ValueKey('account-mode-switch-confirm'),
          style: FilledButton.styleFrom(backgroundColor: PosTokens.blue),
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(l10n.personalMoneySwitch),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  final messenger = ScaffoldMessenger.maybeOf(context);
  final navigator = Navigator.of(context, rootNavigator: true);
  // Everything `ref` is needed for, taken now: the switch swaps the shell
  // (FlipperApp's gate) and the page that opened this goes with it.
  final store = ref.read(accountModeStoreProvider);
  final afterSwitch = ref.read(accountModeAfterSwitchProvider);
  final container = ProviderScope.containerOf(context, listen: false);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );
  try {
    final result = await store.switchTo(target);
    if (navigator.mounted) navigator.pop();
    container.invalidate(accountModeProvider);
    if (result.cardSubscriptionPaused == false) {
      messenger?.showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 8),
          content: Text(l10n.personalMoneyCardStillActive),
        ),
      );
    }
    await afterSwitch(result.mode);
  } catch (e) {
    if (navigator.mounted) navigator.pop();
    messenger?.showSnackBar(
      SnackBar(content: Text(l10n.personalMoneySwitchFailed('$e'))),
    );
  }
}
