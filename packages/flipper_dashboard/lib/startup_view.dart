library flipper_dashboard;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/gate.dart';
import 'package:flipper_routing/routes.router.dart';
import 'package:flipper_services/proxy.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key, this.invokeLogin}) : super(key: key);
  final bool? invokeLogin;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      fireOnModelReadyOnce: true,
      onModelReady: (model) => SchedulerBinding.instance.addPostFrameCallback(
        (timeStamp) {
          model.runStartupLogic(
            invokeLogin: invokeLogin ?? false,
            loginInfo: loginInfo,
            navigationCallback: (nav) async {
              if (nav == "login") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("A Fresh login is required!"),
                  ),
                );
                GoRouter.of(context).go("/login");
              }
              if (nav == "drawer") {
                GoRouter.of(context).push("/drawer/open");
              }
              if (nav == "home") {
                GoRouter.of(context).push(Routes.home);
              }
              if (nav == "login_choices") {
                GoRouter.of(context).push("/tenants");
              }
              if (nav == "signup") {
                String? countryName =
                    await ProxyService.country.getCountryName();
                loginInfo.country = countryName!;
                loginInfo.needSignUp = true;
                loginInfo.isLoggedIn = false;
                loginInfo.redirecting = false;
                GoRouter.of(context).push("/signup/$countryName");
              }
            },
          );
        },
      ),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
