import 'package:flipper_login/loginCode.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Once open time someone else solved issue: https://github.com/ente-io/ente/commit/be7f4b71073c8a1086d654c01f61925ffbf6abe5#diff-5ca3a4f36b6e5b25b9776be6945ade02382219f8f0a7c8ec1ecd1ccc018c73aaR19
//

class DesktopLoginView extends StatefulHookConsumerWidget {
  const DesktopLoginView({Key? key}) : super(key: key);

  @override
  _DesktopLoginViewState createState() => _DesktopLoginViewState();
}

class _DesktopLoginViewState extends ConsumerState<DesktopLoginView> {
  bool switchToPinLogin = false;
  final _routerService = locator<RouterService>();
  final double qrSize = 200.0;
  final String logoAsset = 'assets/logo.png';
  final double logoSize = 100.0;

  @override
  Widget build(BuildContext context) {
    final loginCode = ref.watch(loginCodeProvider);
    return ViewModelBuilder<LoginViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (model) {
        ProxyService.event
            .subscribeLoginEvent(channel: loginCode.split('-')[1]);

        Future.delayed(const Duration(seconds: 10)).then((_) {
          if (mounted) {
            setState(() {
              switchToPinLogin = true;
            });
          }
        });
      },
      builder: (context, model, child) {
        return Center(
          child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Spacer(),
                  SizedBox(
                    height: 250.0,
                    width: 250.0,
                    child: QrImageView(
                      data: loginCode,
                      version: QrVersions.auto,
                      // embeddedImage:
                      //     AssetImage(logoAsset, package: "flipper_login"),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(logoSize, logoSize),
                      ),
                      size: 200.0,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: ProxyService.event.isLoadingStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data!) {
                        // Show loader widget
                        return Text(
                          'Logging in ...',
                          style: TextStyle(color: Colors.green),
                        );
                      } else {
                        // Show an empty container widget
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 120.0),
                    child: SizedBox(
                        width: 450,
                        child: Text(
                          'Log in to Flipper by QR Code',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.black),
                        )),
                  ),
                  SizedBox(height: 10),
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
                      child: Text(
                          '2. Go to Settings > Devices > Link Desktop Device',
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
                  SizedBox(height: 30),
                  SizedBox(
                    height: 40,
                    width: 350,
                    child: OutlinedButton(
                      key: Key('pinLogin_desktop'),
                      child: Text(
                        'Switch to PIN login',
                        style: TextStyle(color: Color(0xff006AFE)),
                      ),
                      style: ButtonStyle(
                        shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
                            (states) => RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0))),
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
                              return Color(0xff006AFE).withValues(alpha: 0.5);
                            }
                            if (states.contains(WidgetState.focused) ||
                                states.contains(WidgetState.pressed)) {
                              return Color(0xff006AFE).withValues(alpha: 0.5);
                            }
                            return Color(0xff006AFE).withValues(alpha: 0.5);
                          },
                        ),
                      ),
                      onPressed: () {
                        LoginInfo().redirecting = true;
                        _routerService.navigateTo(PinLoginRoute());
                      },
                    ),
                  ),
                  // show a text to show if device is offline
                  StreamBuilder<List<ConnectivityResult>>(
                    stream: Connectivity().onConnectivityChanged,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data == ConnectivityResult.none) {
                          return const Text(
                            'Device is offline',
                            style: TextStyle(color: Colors.red),
                          );
                        }
                      }
                      return const SizedBox();
                    },
                  ),
                  Spacer(),
                ],
              )),
        );
      },
    );
  }
}
