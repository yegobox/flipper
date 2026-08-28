import 'dart:async';

import 'package:flipper_routing/app.dialogs.dart';
import 'package:flipper_models/helperModels/talker.dart';
import 'package:flipper_models/sync/shift_sync.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

/// Pause after a successful shift close so the user can read feedback.
const Duration kPostShiftCloseLogoutDelay = Duration(milliseconds: 1800);

/// Pause before navigation when there was no open shift (mobile sign-out).
const Duration kNoOpenShiftLogoutDelay = Duration(milliseconds: 1200);

const Duration _kGetCurrentShiftTimeout = Duration(seconds: 25);

/// Shows a blocking dialog. Do **not** `await` the [Future] from [showDialog] here:
/// that future completes only when the route is popped, which would deadlock if
/// you await it before fetching shift data.
void _presentBlockingLoader(
  BuildContext context,
  String message, {
  required bool useRootNavigator,
}) {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: useRootNavigator,
    builder: (ctx) => PopScope(
      canPop: false,
      child: AlertDialog(
        content: Row(
          children: [
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 20),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    ),
  );
}

void _hideBlockingLoader(
  BuildContext context, {
  required bool rootNavigator,
}) {
  final nav = Navigator.of(context, rootNavigator: rootNavigator);
  if (nav.canPop()) nav.pop();
}

/// Offers "sign out anyway" when the shift could not be verified or closed.
///
/// Blocking sign-out on a shift failure is worse than leaving a shift open:
/// it strands the previous agent's session on a shared device, which is the
/// exact thing tapping Sign out was meant to prevent — and on a flaky mobile
/// connection [_kGetCurrentShiftTimeout] fires often enough that sign-out can
/// become unreachable. An open shift is recoverable (it stays in the ledger and
/// can be closed on the next sign in); a session that refuses to end is not.
///
/// A user *switch* keeps the hard block: aborting it drops back into a working
/// session, so there is nothing to strand.
Future<bool> _confirmExitWithoutClosingShift({
  required BuildContext context,
  required String title,
  required String description,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    useRootNavigator: true,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(child: Text(description)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Sign out anyway'),
        ),
      ],
    ),
  );
  return confirmed == true;
}

double _parseClosingBalance(dynamic raw) {
  if (raw is num) return raw.toDouble();
  if (raw is String) return double.tryParse(raw) ?? 0.0;
  return 0.0;
}

/// Verifies shift state, closes an open shift when needed, and shows clear
/// feedback before the caller navigates away or runs full [logOut].
///
/// When [confirmWhenNoOpenShift] is true, the user must confirm leaving when
/// no shift is open (sidebar and mobile after they chose Logout).
///
/// When [forUserSwitch] is true, uses switch-user copy, skips login-screen
/// snackbars/delays, and does not ask to confirm when no shift is open.
///
/// [loaderUseRootNavigator] should be **false** when this runs from another
/// dialog (e.g. stacked logout). Using the root navigator can replace or obscure
/// that dialog so the confirmation never appears.
///
/// Returns `true` if the caller should proceed to login / complete logout.
/// Returns `false` only when the user chose to stay — or, for [forUserSwitch],
/// when the shift could not be verified or closed.
///
/// A failure to verify or close a shift never silently cancels a *sign-out*:
/// the user is offered "Sign out anyway", because a session that cannot be
/// ended leaves the previous agent signed in on a shared device. Choosing it
/// leaves the shift open (recoverable on the next sign in) and logs a warning.
Future<bool> prepareSessionExitAfterShiftHandling({
  required BuildContext context,
  required DialogService dialogService,
  bool confirmWhenNoOpenShift = true,
  bool loaderUseRootNavigator = true,
  bool forUserSwitch = false,
}) async {
  final userId = ProxyService.box.getUserId();
  if (userId == null) return true;

  final askConfirmNoShift = confirmWhenNoOpenShift && !forUserSwitch;

  if (!forUserSwitch) {
    _presentBlockingLoader(
      context,
      'Checking your shift…',
      useRootNavigator: loaderUseRootNavigator,
    );
  }
  try {
    final currentShift = await shiftSync
        .getCurrentShift(userId: userId)
        .timeout(_kGetCurrentShiftTimeout);
    if (!forUserSwitch && context.mounted) {
      _hideBlockingLoader(
        context,
        rootNavigator: loaderUseRootNavigator,
      );
    }
    if (!context.mounted) return false;

    if (currentShift != null) {
      // Only close a shift owned by the signed-in agent.
      if (currentShift.userId != userId) {
        if (!context.mounted) return false;
        if (forUserSwitch) {
          await dialogService.showCustomDialog(
            variant: DialogType.info,
            title: 'Cannot close shift',
            description: 'The open shift belongs to another user. Ask that '
                'agent to close their shift first, then try switching again.',
          );
          return false;
        }
        // The old copy already told the user they could "sign out without
        // closing it" — but the code returned false, so they could not.
        final proceed = await _confirmExitWithoutClosingShift(
          context: context,
          title: 'Shift belongs to another user',
          description: 'The open shift was started by another agent, so it '
              'cannot be closed from here.\n\nYou can still sign out. The '
              'shift stays open for that agent to close.',
        );
        if (proceed) {
          talker.warning(
            'Signing out with shift ${currentShift.id} left open '
            '(owned by ${currentShift.userId}, not $userId)',
          );
        }
        return proceed;
      }

      final cashSales = currentShift.cashSales ?? 0.0;

      // Shift has no sales — close it silently, no reconciliation needed
      if (cashSales <= 0) {
        try {
          await shiftSync.endShift(
            shiftId: currentShift.id,
            closingBalance: currentShift.openingBalance.toDouble(),
          );
        } catch (_) {
          // Proceed to logout even if close fails — no transactions to reconcile
        }
        return true;
      }

      final dialogResponse = await dialogService.showCustomDialog(
        variant: DialogType.closeShift,
        title: forUserSwitch
            ? 'Close shift to switch user'
            : 'Close shift to sign out',
        data: {
          'openingBalance': currentShift.openingBalance,
          'cashSales': currentShift.cashSales,
          'expectedCash': currentShift.expectedCash,
        },
      );

      if (dialogResponse?.confirmed != true || dialogResponse?.data == null) {
        return false;
      }

      final map = dialogResponse!.data as Map<dynamic, dynamic>;
      final closingBalance = _parseClosingBalance(map['closingBalance']);
      final notes = map['notes'] as String?;

      try {
        await shiftSync.endShift(
          shiftId: currentShift.id,
          closingBalance: closingBalance,
          note: notes,
        );
      } catch (e) {
        if (!context.mounted) return false;
        if (forUserSwitch) {
          await dialogService.showCustomDialog(
            variant: DialogType.info,
            title: 'Could not close shift',
            description: e.toString(),
          );
          return false;
        }
        final proceed = await _confirmExitWithoutClosingShift(
          context: context,
          title: 'Could not close shift',
          description: 'The shift could not be closed:\n\n$e\n\nYou can '
              'sign out anyway. The shift stays open and can be closed the '
              'next time you sign in.',
        );
        if (proceed) {
          talker.warning(
            'Signing out with shift ${currentShift.id} left open: $e',
          );
        }
        return proceed;
      }

      if (context.mounted) {
        if (askConfirmNoShift) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Shift closed successfully. Taking you to the login screen…',
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 4),
            ),
          );
          await Future<void>.delayed(kPostShiftCloseLogoutDelay);
        }
      }
      return true;
    }

    if (askConfirmNoShift) {
      final confirmed = await showDialog<bool>(
        context: context,
        useRootNavigator: true,
        builder: (ctx) => AlertDialog(
          title: const Text('Sign out'),
          content: const Text(
            'You do not have an open shift. Continue to the login screen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Continue'),
            ),
          ],
        ),
      );
      if (confirmed != true) return false;
    }

    if (context.mounted && askConfirmNoShift) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Signing out…'),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
      await Future<void>.delayed(kNoOpenShiftLogoutDelay);
    }
    return true;
  } on TimeoutException catch (e) {
    return _handleShiftVerificationFailure(
      context: context,
      dialogService: dialogService,
      forUserSwitch: forUserSwitch,
      loaderUseRootNavigator: loaderUseRootNavigator,
      userId: userId,
      blockedDescription:
          'This is taking too long. Check your connection and try again.\n\n$e',
      signOutAnywayDescription:
          'Checking your shift is taking too long — you may be offline.\n\n'
          'You can sign out anyway. Any open shift stays open and can be '
          'closed the next time you sign in.',
      logDetail: 'timed out: $e',
    );
  } catch (e) {
    return _handleShiftVerificationFailure(
      context: context,
      dialogService: dialogService,
      forUserSwitch: forUserSwitch,
      loaderUseRootNavigator: loaderUseRootNavigator,
      userId: userId,
      blockedDescription:
          'Please try again. If the problem continues, check your connection.\n\n$e',
      signOutAnywayDescription:
          'Your shift could not be checked:\n\n$e\n\nYou can sign out '
          'anyway. Any open shift stays open and can be closed the next time '
          'you sign in.',
      logDetail: 'failed: $e',
    );
  }
}

/// Shared tail for the two "could not verify the shift" handlers.
///
/// A switch-user attempt still hard-stops (it falls back into a live session);
/// a sign-out offers the escape hatch, because refusing it is what leaves the
/// device signed in as the previous agent.
Future<bool> _handleShiftVerificationFailure({
  required BuildContext context,
  required DialogService dialogService,
  required bool forUserSwitch,
  required bool loaderUseRootNavigator,
  required String userId,
  required String blockedDescription,
  required String signOutAnywayDescription,
  required String logDetail,
}) async {
  if (!context.mounted) return false;
  if (!forUserSwitch) {
    _hideBlockingLoader(context, rootNavigator: loaderUseRootNavigator);
  }
  if (!context.mounted) return false;

  if (forUserSwitch) {
    await dialogService.showCustomDialog(
      variant: DialogType.info,
      title: 'Could not verify shift',
      description: blockedDescription,
    );
    return false;
  }

  final proceed = await _confirmExitWithoutClosingShift(
    context: context,
    title: 'Could not verify shift',
    description: signOutAnywayDescription,
  );
  if (proceed) {
    talker.warning(
      'Signing out $userId without verifying the shift — lookup $logDetail',
    );
  }
  return proceed;
}

