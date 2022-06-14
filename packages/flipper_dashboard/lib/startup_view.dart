library flipper_dashboard;

import 'package:flipper_models/isar_models.dart';
import 'package:flipper_models/view_models/gate.dart';

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
            navigationCallback: (nav) {
              if (nav == "login") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.red,
                    content: Text("A Fresh login is required!"),
                  ),
                );
                GoRouter.of(context).go("/login");
              }
              if (nav == "needOpenDrawer") {
                GoRouter.of(context).push("/drawer/open");
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
