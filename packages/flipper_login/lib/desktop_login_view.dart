import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_view_models/login_viewmodel.dart';
import 'package:flipper_services/proxy.dart';

class DesktopLoginView extends StatefulWidget {
  @override
  State<DesktopLoginView> createState() => _DesktopLoginViewState();
}

class _DesktopLoginViewState extends State<DesktopLoginView> {
  String? loginCode = null;
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
          ProxyService.loginService.connect();
          ProxyService.loginService
              .subscribe(channel: loginCode!.split('-')[1]);
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
              Text('Use mobile app to scan and log in')
            ],
          ),
        );
      },
    );
  }
}
