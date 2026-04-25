import 'dart:async';

import 'package:flipper_routing/app.dialogs.dart';
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
/// [loaderUseRootNavigator] should be **false** when this runs from another
/// dialog (e.g. stacked logout). Using the root navigator can replace or obscure
/// that dialog so the confirmation never appears.
///
/// Returns `true` if the caller should proceed to login / complete logout.
/// Returns `false` if the user cancelled or an error blocked leaving.
Future<bool> prepareSessionExitAfterShiftHandling({
  required BuildContext context,
  required DialogService dialogService,
  bool confirmWhenNoOpenShift = true,
  bool loaderUseRootNavigator = true,
}) async {
  final userId = ProxyService.box.getUserId();
  if (userId == null) return true;

  _presentBlockingLoader(
    context,
    'Checking your shift…',
    useRootNavigator: loaderUseRootNavigator,
  );
  try {
    final currentShift = await ProxyService.strategy
        .getCurrentShift(userId: userId)
        .timeout(_kGetCurrentShiftTimeout);
    if (context.mounted) {
      _hideBlockingLoader(
        context,
        rootNavigator: loaderUseRootNavigator,
      );
    }
    if (!context.mounted) return false;

    if (currentShift != null) {
      final dialogResponse = await dialogService.showCustomDialog(
        variant: DialogType.closeShift,
        title: 'Close shift to sign out',
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
        await ProxyService.strategy.endShift(
          shiftId: currentShift.id,
          closingBalance: closingBalance,
          note: notes,
        );
      } catch (e) {
        if (context.mounted) {
          await dialogService.showCustomDialog(
            variant: DialogType.info,
            title: 'Could not close shift',
            description: e.toString(),
          );
        }
        return false;
      }

      if (context.mounted) {
        if (confirmWhenNoOpenShift) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Shift closed successfully. Taking you to the login screen…',
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 4),
            ),
          );
        }
        await Future<void>.delayed(kPostShiftCloseLogoutDelay);
      }
      return true;
    }

    if (confirmWhenNoOpenShift) {
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

    if (context.mounted) {
      if (confirmWhenNoOpenShift) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signing out…'),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      }
      await Future<void>.delayed(kNoOpenShiftLogoutDelay);
    }
    return true;
  } on TimeoutException catch (e) {
    if (context.mounted) {
      _hideBlockingLoader(
        context,
        rootNavigator: loaderUseRootNavigator,
      );
      await dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Could not verify shift',
        description:
            'This is taking too long. Check your connection and try again.\n\n$e',
      );
    }
    return false;
  } catch (e) {
    if (context.mounted) {
      _hideBlockingLoader(
        context,
        rootNavigator: loaderUseRootNavigator,
      );
      await dialogService.showCustomDialog(
        variant: DialogType.info,
        title: 'Could not verify shift',
        description:
            'Please try again. If the problem continues, check your connection.\n\n$e',
      );
    }
    return false;
  }
}

