import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_models/models/view_models/login_viewmodel.dart';
import 'package:flipper_services/proxy.dart';
import 'package:google_ui/google_ui.dart';

class DesktopLoginView extends StatefulWidget {
  const DesktopLoginView({Key? key}) : super(key: key);

  @override
  State<DesktopLoginView> createState() => _DesktopLoginViewState();
}

class _DesktopLoginViewState extends State<DesktopLoginView> {
  String? loginCode;
  bool switchToPinLogin = false;
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

          ProxyService.event.subscribeLoginEvent(
              channel: loginCode!.split('-')[1], context: context);
          Future.delayed(const Duration(seconds: 10)).then((_) {
            setState(() {
              switchToPinLogin = true;
            });
          });
        }
      },
      builder: (context, model, child) {
        return Center(
          child: Column(
            children: [
              SizedBox(
                height: 400.0,
                width: 400.0,
                child: QrImage(
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
                        GoRouter.of(context).push("/pin");
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}
