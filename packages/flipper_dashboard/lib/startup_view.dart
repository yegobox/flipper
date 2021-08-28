library flipper_dashboard;

import 'package:flipper_dashboard/loader_percentage.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      fireOnModelReadyOnce: true,
      onModelReady: (model) =>
          SchedulerBinding.instance?.addPostFrameCallback((timeStamp) {
        model.runStartupLogic();
      }),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        return LoadingWithPercentage();
      },
    );
  }
}
