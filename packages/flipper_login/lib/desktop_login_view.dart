import 'dart:async';

import 'package:flipper_login/loginCode.dart';
import 'package:flipper_models/sync/mixins/auth_mixin.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper_services/desktop_login_status.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flipper_services/app_service.dart';

// Once open time someone else solved issue: https://github.com/ente-io/ente/commit/be7f4b71073c8a1086d654c01f61925ffbf6abe5#diff-5ca3a4f36b6e5b25b9776be6945ade02382219f8f0a7c8ec1ecd1ccc018c73aaR19
//

class DesktopLoginView extends StatefulHookConsumerWidget {
  const DesktopLoginView({Key? key}) : super(key: key);

  @override
  _DesktopLoginViewState createState() => _DesktopLoginViewState();
}

class _DesktopLoginViewState extends ConsumerState<DesktopLoginView> {
  final _routerService = locator<RouterService>();
  final double qrSize = 200.0;
  final String logoAsset = 'assets/logo.png';
  final double logoSize = 100.0;
  late final String _loginCode;
  late final Stream<DesktopLoginStatus> _loginStatusStream;
  late final Stream<List<ConnectivityResult>> _connectivityStream;
  bool _loginSetupScheduled = false;
  bool _switchingToPinLogin = false;

  /// Cache the QR widget to avoid expensive re-builds
  late final Widget _qrWidget;

  @override
  void initState() {
    super.initState();
    _loginCode = ref.read(loginCodeProvider);
    _loginStatusStream = ProxyService.event.desktopLoginStatusStream();
    _connectivityStream = Connectivity().onConnectivityChanged;

    _qrWidget = RepaintBoundary(
      child: QrImageView(
        data: _loginCode,
        version: QrVersions.auto,
        size: qrSize,
        gapless: true,
        errorCorrectionLevel: QrErrorCorrectLevel.L,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_ensureDesktopLoginSetup());
    });
  }

  /// Ditto + subscription once; avoids [ViewModelBuilder.reactive] rebuild churn on resize.
  Future<void> _ensureDesktopLoginSetup() async {
    if (_loginSetupScheduled || !mounted || _switchingToPinLogin) return;
    _loginSetupScheduled = true;

    await ProxyService.box.clear();
    if (!mounted || _switchingToPinLogin) return;

    final appService = locator<AppService>();
    if (!ProxyService.ditto.isReady()) {
      await appService.initDittoForLogin(_loginCode);
    }
    if (!mounted || _switchingToPinLogin) return;

    ProxyService.event.subscribeLoginEvent(channel: _loginCode.split('-')[1]);
  }

  Future<void> _switchToPinLogin() async {
    if (_switchingToPinLogin) return;

    _switchingToPinLogin = true;
    ProxyService.event.unsubscribeLoginEvent();
    AuthMixin.resetDittoInitializationStatic();
    await locator<AppService>().disposeQrLoginDitto();
    LoginInfo().redirecting = true;
    await _routerService.replaceWith(PinLoginRoute());
  }

  @override
  void dispose() {
    ProxyService.event.unsubscribeLoginEvent();
    super.dispose();
  }

  Widget _qrStatusOverlay(DesktopLoginStatus? status) {
    if (status == null || status.state == DesktopLoginState.idle) {
      return const SizedBox.shrink();
    }
    if (status.state == DesktopLoginState.loading) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const RepaintBoundary(
              child: CircularProgressIndicator(
                color: Color(0xff006AFE),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Logging in...',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: const Color(0xff006AFE),
              ),
            ),
          ],
        ),
      );
    }
    if (status.state == DesktopLoginState.failure) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 32),
            const SizedBox(height: 12),
            Text(
              'Login failed',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Please try again or use PIN login',
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                ProxyService.event.resetLoginStatus();
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (mounted) {
                    ProxyService.event.subscribeLoginEvent(
                      channel: _loginCode.split('-')[1],
                    );
                  }
                });
              },
              child: const Text('Retry',
                  style: TextStyle(color: Color(0xff006AFE))),
            ),
          ],
        ),
      );
    }
    if (status.state == DesktopLoginState.success) {
      return Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 32),
            const SizedBox(height: 12),
            Text(
              'Login successful!',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _loginStatusBanner(DesktopLoginStatus? status) {
    if (status == null || status.state == DesktopLoginState.idle) {
      return const SizedBox.shrink();
    }
    if (status.state == DesktopLoginState.loading) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Text(
            'QR Code scanned! Completing login...',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.green,
            ),
          ),
        ),
      );
    }
    if (status.state == DesktopLoginState.failure) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
          ),
          child: Text(
            'Login failed. Please try again.',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.red,
            ),
          ),
        ),
      );
    }
    if (status.state == DesktopLoginState.success) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
          ),
          child: Text(
            'Login successful! Redirecting...',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.green,
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          color: Colors.white,
          child: Column(
            children: [
              const Spacer(),
              SizedBox(
                height: 250.0,
                width: 250.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: _qrWidget,
                    ),
                    StreamBuilder<DesktopLoginStatus>(
                      stream: _loginStatusStream,
                      builder: (context, statusSnapshot) {
                        return _qrStatusOverlay(statusSnapshot.data);
                      },
                    ),
                  ],
                ),
              ),
              StreamBuilder<DesktopLoginStatus>(
                stream: _loginStatusStream,
                builder: (context, statusSnapshot) {
                  return _loginStatusBanner(statusSnapshot.data);
                },
              ),
              SizedBox(
                width: 380,
                child: Text(
                  'Log in to Flipper by QR Code',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                      color: Colors.black),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 380,
                child: Text('1. Open Flipper on your phone',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: Colors.black)),
              ),
              SizedBox(
                  width: 380,
                  child: Text('2. Go to Profile Icon > LongPress on it.',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black))),
              SizedBox(
                  width: 380,
                  child: Text(
                      '3. Point your phone at this screen to confirm login',
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 15,
                          color: Colors.black))),
              const SizedBox(height: 30),
              // Companion app download section
              SizedBox(
                width: 340,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Don't have the Flipper app? Download it:",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // App Store button with visual feedback
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              splashColor: Colors.blue.withValues(alpha: 0.3),
                              hoverColor: Colors.grey.withValues(alpha: 0.1),
                              onTap: () {
                                // iOS App Store link
                                launchUrl(Uri.parse(
                                    'https://apps.apple.com/rw/app/flipperrw/id6711352372'));
                                // Show a snackbar for feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Opening App Store...'),
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/appstore.svg',
                                  package: 'flipper_login',
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Play Store button with visual feedback
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              splashColor: Colors.green.withValues(alpha: 0.3),
                              hoverColor: Colors.grey.withValues(alpha: 0.1),
                              onTap: () {
                                // Google Play Store link
                                launchUrl(Uri.parse(
                                    'https://play.google.com/store/apps/details?id=rw.flipper&hl=en'));
                                // Show a snackbar for feedback
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Opening Play Store...'),
                                    duration: Duration(seconds: 1),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SvgPicture.asset(
                                  'assets/playstore.svg',
                                  package: 'flipper_login',
                                  height: 40,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: 380,
                child: OutlinedButton(
                  key: const Key('pinLogin_desktop'),
                  child: const Text(
                    'Switch to PIN login',
                    style: TextStyle(color: Color(0xff006AFE)),
                  ),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                        (states) => RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    side: WidgetStateProperty.resolveWith<BorderSide>(
                        (states) => BorderSide(
                              color: const Color(0xff006AFE)
                                  .withValues(alpha: 0.1),
                            )),
                    backgroundColor: WidgetStateProperty.all<Color>(
                        const Color(0xff006AFE).withValues(alpha: 0.1)),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {
                          return const Color(0xff006AFE).withValues(alpha: 0.1);
                        }
                        if (states.contains(WidgetState.focused) ||
                            states.contains(WidgetState.pressed)) {
                          return const Color(0xff006AFE).withValues(alpha: 0.2);
                        }
                        return null;
                      },
                    ),
                  ),
                  onPressed: _switchToPinLogin,
                ),
              ),
              // show a text to show if device is offline
              StreamBuilder<List<ConnectivityResult>>(
                stream: _connectivityStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    if (snapshot.data!.contains(ConnectivityResult.none)) {
                      return const Text(
                        'Device is offline',
                        style: TextStyle(color: Colors.red),
                      );
                    }
                  }
                  return const SizedBox();
                },
              ),
              const Spacer(),
            ],
          )),
    );
  }
}
