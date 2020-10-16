import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/locator.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/data_manager.dart';
import 'package:flipper/util/flitter_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CreateOptionsWidget extends StatelessWidget {
  final FlipperNavigationService _navigationService = locator<FlipperNavigationService>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
      distinct: true,
      converter: CommonViewModel.fromStore,
      builder: (BuildContext context, CommonViewModel vm) {
        return Dialog(
          child: Container(
            width: 400,
            height: 200,
            child: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        color: HexColor(FlipperColors.blue),
                        onPressed: () async {
                          //create a temp item that can be deleted anytime on discard
                          await _createTemporalItem(vm, context);
                          _navigationService.navigateTo(Routing.addItemScreen);
                        },
                        child:const Text(
                          'Create Item'
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      color: Colors.white70,
                      width: double.infinity,
                      child: OutlineButton(
                        onPressed: () {},
                        child:const Text(
                          'Create Discount'
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlatButton(
                        child:const Text(
                          'Dismiss'
                        ),
                        onPressed: () {
                          _navigationService.pop();
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //create a temporal product with default regular variant to be updated along the way while creating the product
  //if such product with tmp name exist return it.
  Future<void> _createTemporalItem(CommonViewModel vm, BuildContext context) async {
    if(vm.user.id!=null){
      DataManager.createTempProduct(store: StoreProvider.of<AppState>(context),userId: vm.user.id,productName: 'tmp');
    }
    
  }
}
