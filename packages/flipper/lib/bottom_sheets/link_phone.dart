import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutterfire_ui/auth.dart';
import 'package:flipper_ui/flipper_ui.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:flipper_dashboard/setting_view_model.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flipper_models/models/models.dart';

final isWindows = UniversalPlatform.isWindows;

class LinkPhone extends StatefulWidget {
  const LinkPhone({Key? key}) : super(key: key);

  @override
  _LinkPhoneState createState() => _LinkPhoneState();
}

class _LinkPhoneState extends State<LinkPhone> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      builder: (context, model, child) {
        // this is not done has some error!
        return const Scaffold(body: PhoneInputScreen());
      },
    );
  }
}
