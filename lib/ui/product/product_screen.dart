

import 'package:flipper/ui/product/product_view_widget.dart';
import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'product_viewmodel.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key key,@required this.userId}) : super(key: key);
  final String userId;
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    
    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      
      onModelReady: (ProductViewModel model){
        model.initializeNeededIds(userId: widget.userId);
        model.getProducts(context: context);
      },
      builder: (BuildContext context, ProductViewModel model, Widget child) {
        if( model.data ==null)
          return const Text('Data is empty show add button');
        return Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[

            ProductsView(
              context: context,
              data: model.data,
              shouldSeeItem: false,
              showCreateItemOnTop: true,
              createButtonName: 'Add Products',
              userId: widget.userId
            )
          ],
        );
      },
    );
  }
}
