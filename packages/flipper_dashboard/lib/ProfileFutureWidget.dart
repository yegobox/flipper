import 'package:flipper_dashboard/profile.dart';
import 'package:flipper_models/realm/schemas.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flutter/material.dart';

class ProfileFutureWidget extends StatelessWidget {
  const ProfileFutureWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Branch>(
      future: ProxyService.local.activeBranch(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            !snapshot.hasData) {
          return const SizedBox.shrink();
        }
        final data = snapshot.data;
        return Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: SizedBox(
            height: 40,
            width: 40,
            child: ProfileWidget(
              branch: data!,
              sessionActive: true,
              size: 25,
              showIcon: false,
            ),
          ),
        );
      },
    );
  }
}
