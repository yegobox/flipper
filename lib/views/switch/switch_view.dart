import 'package:flipper_models/switcher.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper_services/flipperNavigation_service.dart';

import 'package:flipper/viewmodels/switch_model.dart';
import 'package:flipper/views/home_view.dart';
import 'package:flipper/views/open_close_drawerview.dart';
import 'package:flipper/views/welcome/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:flipper_services/proxy.dart';
import 'package:flipper/utils/HexColor.dart';

class SwitchView extends StatelessWidget {
  SwitchView({
    Key key,
    this.vm,
    this.sideOpenController,
  }) : super(key: key);

  final CommonViewModel vm;
  final ValueNotifier<bool> sideOpenController;
  final FlipperNavigationService _navigationService = ProxyService.nav;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SwitchModel>.reactive(
      // initialiseSpecialViewModelsOnce: true,

      builder: (BuildContext context, SwitchModel model, Widget child) {
        // ignore: always_specify_types
        final Switcher drawer = model.data;
        // drawer can not be null as we start with business closed. i.e we check drawer!=null
        if (drawer != null && !drawer.isSocial && drawer.isClosed) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Wrap(
                children: <Widget>[
                  const Center(
                    child: Text(
                      'Open your business to start selling',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Divider(height: 20),
                  Center(
                    child: Container(
                      color: HexColor('#2996CC'),
                      child: SizedBox(
                        width: 380,
                        height: 60,
                        child: FlatButton(
                          onPressed: () {
                            _navigationService.navigateTo(
                                Routing.openCloseDrawerview,
                                arguments: OpenCloseDrawerViewArguments(
                                    vm: vm, businessState: BusinessState.OPEN));
                          },
                          color: Colors.blue,
                          child: const Text(
                            'Open',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return HomeView(
            vm: vm,
            sideOpenController: sideOpenController,
          );
        }
      },
      viewModelBuilder: () => SwitchModel(),
    );
  }
}
