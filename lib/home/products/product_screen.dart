import 'package:flipper/home/products/product_view_widget.dart';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';
import 'product_viewmodel.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({Key key}) : super(key: key);
  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
 

  @override
  Widget build(BuildContext context) {
    // final InputDecorationTheme theme = _hasErrors
    return ViewModelBuilder<ProductViewModel>.reactive(
      viewModelBuilder: () => ProductViewModel(),
      onModelReady: (ProductViewModel model) => model.getProducts(context: context),
      builder: (BuildContext context, ProductViewModel model, Widget child) {
        return Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: <Widget>[
            // TextFormField(
            //   autofocus: false,
            //   keyboardType: TextInputType.text,
            //   maxLength: 20,
            //   enabled: true,
            // ),
            ProductsView(
              context: context,
              data: model.data,
              shouldSeeItem: false,
              showCreateItemOnTop: true,
              createButtonName: 'Add Product',
            )
          ],
        );
      },
    );
  }
}
