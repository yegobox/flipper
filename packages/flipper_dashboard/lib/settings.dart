import 'package:flipper_dashboard/customappbar.dart';
import 'package:flipper_dashboard/widgets/SettingLayout.dart';
import 'package:flipper_models/realm_model_export.dart';
import 'package:flutter/material.dart';
import 'package:flipper_routing/app.locator.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:stacked/stacked.dart';

class SettingPage extends StatelessWidget {
  SettingPage({Key? key}) : super(key: key);
  final _routerService = locator<RouterService>();
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SettingViewModel>.reactive(
      viewModelBuilder: () => SettingViewModel(),
      onViewModelReady: (model) async => await model.createPin(),
      builder: (context, model, child) {
        return SafeArea(
          child: Scaffold(
            appBar: CustomAppBar(
              onPop: () async {
                _routerService.pop();
              },
              title: 'Settings',
              disableButton: false,
              showActionButton: false,
            ),
            backgroundColor: Theme.of(context).canvasColor,
            body: SafeArea(
              child: SettingLayout(model: model, context: context),
            ),
          ),
        );
      },
    );
  }
}
