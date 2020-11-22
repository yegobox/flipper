import 'package:flipper/services/proxy.dart';
import 'package:flipper/views/product/add/add_product_modal_viewmodal.dart';

import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/flitter_color.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// TODO: this is where we show the modal  to add a product
class AddProductModal extends StatelessWidget {
  

  const AddProductModal({Key key,this.userId}) : super(key: key);
  
  final String userId;

  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,AddProductModalViewModal model, Widget child){
      return Dialog(
          child: Padding(
            padding: const EdgeInsets.only(left:18.0,right: 18.0),
            child: Container(
              width: double.infinity,
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
                            // NOTE: navigate to add product screen
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
                            ProxyService.nav.pop();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
    }, 
    
    onModelReady: (AddProductModalViewModal model){
      // NOTE: this is where we start adding a product, create a temporal prroduct
      model.createTemporalProduct(productName: 'tmp',userId: userId);
    },
    viewModelBuilder: ()=>AddProductModalViewModal());
  }
}
