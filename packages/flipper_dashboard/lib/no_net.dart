import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'gerror_message.dart';

class NoNet extends StatelessWidget {
  NoNet({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GErrorMessage(
        icon: const Icon(Icons.wifi_off_outlined),
        title: "No internet",
        subtitle:
            "Can't connect to the internet.\nPlease check your internet connection",
        onPressed: () async {
          _routerService.clearStackAndShow(LoginViewRoute());
        },
      ),
    );
  }
}
