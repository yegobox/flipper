import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flipper_rw/gate.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_ui/google_ui.dart';

class NoNet extends StatelessWidget {
  const NoNet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GErrorMessage(
        icon: const Icon(Icons.wifi_off_outlined),
        title: "No internet",
        subtitle:
            "Can't connect to the internet.\nPlease check your internet connection",
        onPressed: () async {
          GoRouter.of(context).go("/login");
        },
      ),
    );
  }
}
