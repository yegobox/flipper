import 'package:flipper_dashboard/no_net.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/models/models.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_ui/google_ui.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_rw/gate.dart';

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
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      onModelReady: (model) {
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
                    SizedBox(
                      height: 400.0,
                      width: 400.0,
                      child: QrImageView(
                        data: loginCode ?? '000',
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                    !switchToPinLogin
                        ? const Text('Use mobile app to scan and log in')
                        : GOutlinedButton(
                            'Switch to PIN login',
                            onPressed: () {
                              loginInfo.redirecting = true;
                              GoRouter.of(context).push("/pin");
                            },
                          ),
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
