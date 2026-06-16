import 'package:flipper_dashboard/logout/shift_before_logout.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flipper_services/Miscellaneous.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

const Duration _kLogoutOperationTimeout = Duration(seconds: 45);

void _presentSigningOutLoader(BuildContext context) {
  // Do not await showDialog — it completes only when popped, which deadlocks if
  // you await it before running logout.
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    useRootNavigator: true,
    builder: (_) => Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
            SizedBox(height: 20),
            Text(
              'Signing you out…',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ),
  );
}

void _hideSigningOutLoader(BuildContext context) {
  final nav = Navigator.of(context, rootNavigator: true);
  if (nav.mounted && nav.canPop()) {
    nav.pop();
  }
}

/// Closes the signed-in agent's shift when needed, signs out, and navigates to
/// login with a cleared stack.
Future<bool> completeDashboardSignOut({
  required BuildContext context,
  required DialogService dialogService,
  required RouterService routerService,
  bool loaderUseRootNavigator = true,
}) async {
  final proceed = await prepareSessionExitAfterShiftHandling(
    context: context,
    dialogService: dialogService,
    confirmWhenNoOpenShift: true,
    loaderUseRootNavigator: loaderUseRootNavigator,
  );
  if (!proceed || !context.mounted) return false;

  _presentSigningOutLoader(context);
  try {
    await CoreMiscellaneous.logoutStatic().timeout(_kLogoutOperationTimeout);
  } catch (_) {
    // Still navigate to login — local session keys are cleared best-effort.
  } finally {
    if (context.mounted) {
      _hideSigningOutLoader(context);
    }
  }

  routerService.clearStackAndShow(const LoginRoute());
  return true;
}
