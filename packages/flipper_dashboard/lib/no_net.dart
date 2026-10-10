import 'package:flipper_design_system/flipper_design_system.dart'
    show FlipperColors;
import 'package:flipper_localize/flipper_localize.dart';
import 'package:flipper_models/services/internet_connection_service.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class NoNetViewModel extends BaseViewModel {
  /// The defaults talk to [InternetConnectionService] and the router; tests
  /// pass fakes so the screen can be pumped without the locator.
  NoNetViewModel({
    Future<bool> Function()? checkConnection,
    int? Function()? daysSinceLastConnection,
    void Function()? goToLogin,
  }) : _checkConnection =
           checkConnection ??
           (() => InternetConnectionService()
               .checkInternetConnectionRequirement()),
       _goToLogin =
           goToLogin ??
           (() => locator<RouterService>().clearStackAndShow(LoginRoute())),
       daysOffline =
           (daysSinceLastConnection ??
           () => InternetConnectionService().daysSinceLastConnection())();

  final Future<bool> Function() _checkConnection;
  final void Function() _goToLogin;

  /// Days since this device last reached the internet; `null` on first run.
  final int? daysOffline;

  /// Set when the last check finished and the device was still offline.
  bool stillOffline = false;

  Future<void> checkInternetConnection() async {
    if (isBusy) return;
    stillOffline = false;
    setBusy(true);
    try {
      // On success the service navigates back into the app itself.
      final isConnected = await _checkConnection();
      stillOffline = !isConnected;
    } catch (e) {
      final _snackbarService = locator<SnackbarService>();
      _snackbarService.showSnackbar(
        message: FlipperL10n.current.noNetErrorCheckingConnection(e.toString()),
        duration: const Duration(seconds: 2),
      );
    } finally {
      setBusy(false);
    }
  }

  void goToLogin() => _goToLogin();
}

/// The gate shown when the device has not been online for the check-in
/// interval (see [InternetConnectionService]). Same canvas, halo and mark as
/// the startup screen, so the two read as one flow.
class NoNet extends StatelessWidget {
  NoNet({Key? key, this.viewModelBuilder}) : super(key: key);

  /// Overrides the view model, for tests.
  final NoNetViewModel Function()? viewModelBuilder;

  static const double contentWidth = 320;

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    final canvas = isLight ? Colors.white : FlipperColors.surfaceDark;
    final ink = isLight ? const Color(0xFF10161C) : Colors.white;
    final muted = isLight
        ? const Color(0xFF6B7580)
        : FlipperColors.onSurfaceDark;
    final halo = Color.alphaBlend(
      FlipperColors.primary.withValues(alpha: isLight ? 0.10 : 0.22),
      canvas,
    );
    final l10n = context.flipperL10n;

    return ViewModelBuilder<NoNetViewModel>.reactive(
      viewModelBuilder: viewModelBuilder ?? () => NoNetViewModel(),
      builder: (context, model, child) => PopScope(
        // This is a gate: back must not drop the user into the app offline.
        canPop: false,
        child: Scaffold(
          backgroundColor: canvas,
          body: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.35),
                radius: 0.75,
                colors: [halo, canvas],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 24,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: contentWidth),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _Mark(isLight: isLight),
                          const SizedBox(height: 26),
                          Text(
                            l10n.noNetTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.6,
                              height: 1.15,
                              color: ink,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            l10n.internetRequiredBody,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: muted,
                            ),
                          ),
                          if (model.daysOffline != null) ...[
                            const SizedBox(height: 16),
                            _LastOnlineChip(
                              label: l10n.noNetLastOnline(model.daysOffline!),
                              isLight: isLight,
                              muted: muted,
                            ),
                          ],
                          const SizedBox(height: 30),
                          _CheckButton(
                            busy: model.isBusy,
                            label: model.isBusy
                                ? l10n.noNetChecking
                                : l10n.noNetCheckConnection,
                            onPressed: model.checkInternetConnection,
                          ),
                          Semantics(
                            liveRegion: true,
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              child: model.stillOffline
                                  ? _StillOffline(
                                      key: const ValueKey('still-offline'),
                                      label: l10n.noNetStillOffline,
                                    )
                                  : const SizedBox(
                                      key: ValueKey('none'),
                                      height: 12,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          TextButton(
                            onPressed: model.isBusy ? null : model.goToLogin,
                            style: TextButton.styleFrom(foregroundColor: muted),
                            child: Text(
                              l10n.noNetGoToLogin,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The startup screen's rounded tile, holding the wifi-off glyph instead of
/// the logo. Static: there is nothing in progress to breathe for.
class _Mark extends StatelessWidget {
  const _Mark({required this.isLight});

  final bool isLight;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF232B36),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isLight ? FlipperColors.border : FlipperColors.borderDark,
        ),
        boxShadow: [
          BoxShadow(
            color: FlipperColors.primary.withValues(alpha: 0.16),
            blurRadius: 30,
            spreadRadius: -2,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Icon(
        FluentIcons.wifi_off_24_regular,
        size: 36,
        color: FlipperColors.primary,
      ),
    );
  }
}

class _LastOnlineChip extends StatelessWidget {
  const _LastOnlineChip({
    required this.label,
    required this.isLight,
    required this.muted,
  });

  final String label;
  final bool isLight;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isLight ? Colors.white : const Color(0xFF232B36),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: isLight ? FlipperColors.border : FlipperColors.borderDark,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(FluentIcons.clock_24_regular, size: 14, color: muted),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: muted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckButton extends StatelessWidget {
  const _CheckButton({
    required this.busy,
    required this.label,
    required this.onPressed,
  });

  final bool busy;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: busy ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: FlipperColors.primary,
          foregroundColor: Colors.white,
          // Keep the brand fill while checking; the spinner says "busy".
          disabledBackgroundColor: FlipperColors.primary.withValues(
            alpha: 0.75,
          ),
          disabledForegroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (busy)
              const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            else
              const Icon(FluentIcons.arrow_sync_24_regular, size: 18),
            const SizedBox(width: 9),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StillOffline extends StatelessWidget {
  const _StillOffline({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(
              FluentIcons.warning_24_regular,
              size: 15,
              color: FlipperColors.error,
            ),
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
                height: 1.4,
                fontWeight: FontWeight.w500,
                color: FlipperColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
