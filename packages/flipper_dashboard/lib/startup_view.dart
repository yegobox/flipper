library flipper_dashboard;

import 'package:flipper_dashboard/loader.dart';
import 'package:flipper_login/signup_form_view.dart';
import 'package:flipper_models/view_models/startup_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_login/login_view.dart';

import 'business_home_view.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      fireOnModelReadyOnce: true,
      onModelReady: (model) async {
        await model.didWeSync();
        await model.appInit();
      },
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) {
        if (model.isBusy) {
          return LoaderView();
        }
        if (!model.isLoggedIn()) {
          return LoginView();
        }
        if (!model.didSync) {
          //go signupform
          // ProxyService.box.remove(key: 'userId');
          return SignUpFormView();
        } else {
          //go to home.
          return BusinessHomeView();
        }
      },
    );
  }
}
