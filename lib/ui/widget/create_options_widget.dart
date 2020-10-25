import 'package:flipper/services/proxy.dart';

import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/ui/product/add/add_product_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/flitter_color.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CreateOptionsWidget extends StatelessWidget {
  final FlipperNavigationService _navigationService = ProxyService.nav;


  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,AddProductViewmodel model, Widget child){
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
                        color: Theme.of(context).copyWith(canvasColor:HexColor(FlipperColors.blue)).canvasColor,
                        onPressed: () async {
                          model.navigateAddProduct();
                        },
                        child: Text(
                          'Add Product',
                          style:Theme.of(context).textTheme.bodyText1.copyWith(color:Colors.white)
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
    }, viewModelBuilder: ()=>AddProductViewmodel());
  }
}
