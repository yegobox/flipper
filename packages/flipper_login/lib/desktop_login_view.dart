import 'package:flipper_dashboard/no_net.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/isar_models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class DesktopLoginView extends StatefulWidget {
  const DesktopLoginView({Key? key}) : super(key: key);

  @override
  State<DesktopLoginView> createState() => _DesktopLoginViewState();
}

class _DesktopLoginViewState extends State<DesktopLoginView> {
  String? loginCode;
  bool switchToPinLogin = false;

  Future<bool> internet() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    return (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi);
  }

  @override
  void initState() {
    DateTime now = DateTime.now();
    setState(() {
      loginCode = 'login-' + now.millisecondsSinceEpoch.toString();
    });
    super.initState();
  }

  @override
  void dispose() {
    loginCode = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      fireOnViewModelReadyOnce: true,
      viewModelBuilder: () => LoginViewModel(),
      onViewModelReady: (model) {
        if (loginCode != null) {
          ProxyService.event.connect();
          try {
            ProxyService.event.subscribeLoginEvent(
                channel: loginCode!.split('-')[1], context: context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.red,
                content: Text("Failed to log in try again"),
              ),
            );
          }

          Future.delayed(const Duration(seconds: 10)).then((_) {
            setState(() {
              switchToPinLogin = true;
            });
          });
        }
      },
      builder: (context, model, child) {
        return FutureBuilder<bool>(
          future: internet(),
          builder: (context, snapshot) {
            if (snapshot.data == true) {
              return Center(
                child: Column(
                  children: [
                    Spacer(),
                    SizedBox(
                      height: 250.0,
                      width: 250.0,
                      child: QrImageView(
                        data: loginCode ?? '000',
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    SizedBox(
                        width: 450,
                        child: Text(
                          'Log in to Flipper by QR Code',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 20,
                              color: Colors.black),
                        )),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 380,
                      child: Text('1.Open Flipper on your phone',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w400,
                              fontSize: 15,
                              color: Colors.black)),
                    ),
                    SizedBox(
                        width: 380,
                        child: Text(
                            '2.Go to Settings > Devices > Link Desktop Device',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black))),
                    SizedBox(
                        width: 380,
                        child: Text(
                            '3.Point your phone at this screen to confirm login',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 15,
                                color: Colors.black))),
                    SizedBox(height: 10),
                    SizedBox(
                      height: 40,
                      width: 350,
                      child: OutlinedButton(
                        child: Text(
                          'Switch to PIN login',
                          style: TextStyle(color: Color(0xff006AFE)),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.resolveWith<OutlinedBorder>(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0))),
                          side: MaterialStateProperty.resolveWith<BorderSide>(
                              (states) => BorderSide(
                                    color: const Color(0xff006AFE)
                                        .withOpacity(0.1),
                                  )),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff006AFE).withOpacity(0.1)),
                          overlayColor:
                              MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return Color(0xff006AFE).withOpacity(0.5);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return Color(0xff006AFE).withOpacity(0.5);
                              }
                              return Color(0xff006AFE).withOpacity(0.5);
                            },
                          ),
                        ),
                        onPressed: () {
                          LoginInfo().redirecting = true;
                          GoRouter.of(context).push("/pin");
                        },
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              );
            } else {
              return const NoNet();
            }
          },
        );
      },
    );
  }
}
