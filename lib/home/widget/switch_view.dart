import 'package:flipper/home/homescreen.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/model/converters/switcher.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/viewmodels/business_operation_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SwitchView extends StatelessWidget {
   SwitchView({
    Key key,
    this.vm,
    this.sideOpenController,
  }) : super(key: key);

  final CommonViewModel vm;
  final ValueNotifier<bool> sideOpenController;
  final _navigationService = locator<FlipperNavigationService>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BusinessOperation>.reactive(
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () {
        return BusinessOperation(id: vm.userId.toString());
      },

      builder: (BuildContext context, BusinessOperation model, Widget child) {
        // ignore: always_specify_types
        final Switcher drawer = model.data;
       
        if(drawer == null ){
          return Container();
        }
        // ignore: null_aware_in_logical_operator
        if (drawer.isClosed) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Wrap(
                children:<Widget> [
                  const Center(
                    child:  Text(
                      'open your business to start selling',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: Container(
                      color: Colors.blue,
                      child: SizedBox(
                        width: 380,
                        height: 60,
                        child: FlatButton(
                          onPressed: () {
                            _navigationService.navigateTo(Routing.openCloseDrawerview);
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
          return HomeScreen(
            vm: vm,
            sideOpenController: sideOpenController,
          );
        }
      },
    );
  }
}
