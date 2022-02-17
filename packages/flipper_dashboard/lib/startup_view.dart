library flipper_dashboard;

import 'package:flipper_models/models/models.dart';
import 'package:flipper_rw/gate.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';
import 'package:provider/provider.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key, this.invokeLogin}) : super(key: key);
  final bool? invokeLogin;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      fireOnModelReadyOnce: true,
      onModelReady: (model) =>
          SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        model.runStartupLogic(invokeLogin: invokeLogin, loginInfo: loginInfo);
      }),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        return ChangeNotifierProvider<LoginInfo>.value(
          value: loginInfo,
          child: const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
