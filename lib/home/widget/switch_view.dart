import 'package:flipper/home/homescreen.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/viewmodels/business_operation_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SwitchView extends StatelessWidget {
  const SwitchView({
    Key key,
    this.vm,
    this.sideOpenController,
  }) : super(key: key);

  final CommonViewModel vm;
  final ValueNotifier<bool> sideOpenController;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessOperation>.reactive(
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () {
        return BusinessOperation(id: vm.user.id);
      },
      builder: (BuildContext context, BusinessOperation model, Widget child) {
        final dynamic drawer = model.data;
        if (drawer == null || drawer['isClosed']) {
          return const Scaffold(
              body: Text('open your business to start selling'));
        } else {
          return HomeScreen(
            vm: vm,
            sideOpenController: sideOpenController,
          );
        }
      },
    );
  }
}
