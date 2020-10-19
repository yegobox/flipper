

import 'package:flipper/home/product/retail/retail_price_viewmodel.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'retail_view.dart';

class RetailPriceWidget extends StatefulWidget {
  const RetailPriceWidget({Key key, this.productId}) : super(key: key);
  final String productId;

  @override
  _RetailPriceWidgetState createState() => _RetailPriceWidgetState();
}

class _RetailPriceWidgetState extends State<RetailPriceWidget> {
  @override
  Widget build(BuildContext context) {
    // ignore: always_specify_types
    return ViewModelBuilder.reactive(builder: (BuildContext context,RetailPriceViewModel model, Widget child){
      return model.busy || model.data == null?const SizedBox.shrink():const  RetailView();
    }, 
    onModelReady: (RetailPriceViewModel model) => model.getVariations(context: context,productId: widget.productId),
    viewModelBuilder: ()=>RetailPriceViewModel());
  }
}
