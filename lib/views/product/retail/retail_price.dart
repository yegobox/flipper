

import 'package:flipper/views/product/add/add_product_viewmodel.dart';
import 'package:flipper/views/product/retail/retail_price_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'retail_view.dart';

class RetailPrice extends StatelessWidget {
  const RetailPrice({Key key, this.models}) : super(key: key);
  final AddProductViewmodel models;
  @override
  Widget build(BuildContext context) {
    
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,RetailPriceViewModel model, Widget child){
      return model.busy ?const SizedBox.shrink():  RetailView(model: models);
    }, 
    onModelReady: (RetailPriceViewModel model) => model.getVariations(context: context,productId: models.product.id),
    viewModelBuilder: ()=>RetailPriceViewModel());
  }
}
