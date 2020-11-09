import 'package:flipper/model/product.dart';
import 'package:flipper/ui/product/widget/build_product_list.dart';
import 'package:flipper/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'package:stacked/stacked.dart';
import 'product_viewmodel.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({Key key, @required this.userId}) : super(key: key);
  final String userId;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ProductsViewModel>.reactive(
      viewModelBuilder: () => ProductsViewModel(),
      onModelReady: (ProductsViewModel model) {
        model.initializeNeededIds(userId: userId);
        model.getProducts(context: context);
      },
      builder: (BuildContext context, ProductsViewModel model, Widget child) {
        if (model.data == null)
          return const Text('Data is empty show add button');
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            BuildProductsView(
                context: context,
                data: model.data,
                shouldSeeItem: false,
                showCreateItemOnTop: true,
                createButtonName: 'Add Products',
                userId: userId)
          ],
        );
      },
    );
  }
}

class BuildProductsView extends ViewModelWidget<ProductsViewModel> {
  BuildProductsView({
    Key key,
    @required this.context,
    @required this.data,
    @required this.showCreateItemOnTop,
    @required this.createButtonName,
    @required this.shouldSeeItem,
    @required this.userId,
  }) : super(key: key);

  final BuildContext context;
  final String createButtonName;
  final List<Product> data;
  final bool shouldSeeItem;
  final bool showCreateItemOnTop;
  final String userId;

  final Logger log = Logging.getLogger('product view');

  @override
  Widget build(BuildContext context, ProductsViewModel viewModel) {
    return buildProductList(
                products: data,
                context: context,
                userId: userId,
                createButtonName: createButtonName,
                showCreateItemOnTop: showCreateItemOnTop,
                shouldSeeItem: shouldSeeItem)
            .isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ListView(
              shrinkWrap: true,
              children: ListTile.divideTiles(
                context: context,
                tiles: buildProductList(
                    model:viewModel,
                    products: data,
                    context: context,
                    userId: userId,
                    createButtonName: createButtonName,
                    showCreateItemOnTop: showCreateItemOnTop,
                    shouldSeeItem: shouldSeeItem),
              ).toList(),
            ),
          );
  }
}
