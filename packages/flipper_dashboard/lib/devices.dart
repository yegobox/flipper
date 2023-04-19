import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:flipper_routing/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:flutter/material.dart';

class Devices extends StatelessWidget {
  Devices({Key? key, this.pin}) : super(key: key);
  final int? pin;
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPop: () async {
          _routerService.clearStackAndShow(LoginViewRoute());
        },
        title: 'Link Device',
        disableButton: false,
        showActionButton: false,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.devices,
                size: 64,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const Text("Use Flipper on other Devices"),
          SizedBox(
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: ElevatedButton(
              child: Text('Link A Device'),
              onPressed: () {
                _routerService.navigateTo(ScannViewRoute(intent: "login"));
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white70,
            width: MediaQuery.of(context).size.width - 40,
            height: 40,
            child: OutlinedButton(
              child: Text('PIN: $pin'),
              onPressed: () {
                Navigator.maybePop(context);
              },
            ),
          )
        ],
      ),
    );
  }
}
