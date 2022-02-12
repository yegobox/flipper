import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_ui/google_ui.dart';

class Devices extends StatelessWidget {
  const Devices({Key? key, this.pin}) : super(key: key);
  final int? pin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onPop: () async {
          GoRouter.of(context).pop();
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
            child: GElevatedButton(
              'Link A Device',
              onPressed: () {
                GoRouter.of(context).push(Routes.scann + "/login");
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
            child: GOutlinedButton(
              'PIN: $pin',
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
