import 'package:customappbar/customappbar.dart';
import 'package:flipper/home/products/product_viewmodel.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'product_view_widget.dart';

class ViewProductsScreen extends StatefulWidget {
  const ViewProductsScreen({Key key}) : super(key: key);

  @override
  _ViewProductsScreenState createState() => _ViewProductsScreenState();
}

class _ViewProductsScreenState extends State<ViewProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          Routing.navigator.pop();
        },
        title: 'All Items',
        showActionButton: false,
        onPressedCallback: () async {},
        icon: Icons.close,
        multi: 1,
        bottomSpacer: 48,
      ),
      body: ViewModelBuilder<ProductViewModel>.reactive(
        viewModelBuilder: () => ProductViewModel(),
        onModelReady: (ProductViewModel model) => model.getProducts(),
        builder: (BuildContext context, ProductViewModel model, Widget child) {
          if (model.busy) {
            return const CircularProgressIndicator();
          }
          return Column(
            children: <Widget>[
              ProductsView(
                context: context,
                shouldSeeItem: true,
                data: model.data,
                showCreateItemOnTop: true,
                createButtonName: 'Create Item',
              )
            ],
          );
        },
      ),
    );
  }
}
