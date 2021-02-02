import 'package:flipper_models/product.dart';
import 'package:flipper/views/product/products_viewmodel.dart';
import 'package:flipper/views/product/widget/build_product_row.dart';

import 'package:flipper/views/stock/stock_viewmodel.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:stacked/stacked.dart';

List<Widget> buildProductList(
    {List<Product> products,
    BuildContext context,
    String userId,
    ProductsViewModel model,
    @required bool showCreateItemOnTop,
    @required String createButtonName,
    @required bool shouldSeeItem}) {
  final List<Widget> list = <Widget>[];

  buildProductRowHeader(
    list: list,
    context: context,
    createButtonName: createButtonName,
    userId: userId,
    type: 'add', //on top of product there should be Add buttom
  );

  if (products.isEmpty) {
    return list;
  }

  // build a list of products.
  for (Product product in products) {
    if (product != null && product.name != 'tmp') {
      list.add(
        GestureDetector(
          onTap: () {
            if (shouldSeeItem) {
              model.shouldSeeItemOnly(context, product);
            } else {
              model.onSellingItem(context, product);
            }
          },
          onLongPress: () {
            if (shouldSeeItem) {
              model.shouldSeeItemOnly(context, product);
            } else {
              model.onSellingItem(context, product);
            }
          },
          child: ListTile(
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
            leading: SizedBox(
              width: 45.0,
              height: 45.0,
              child: TextDrawable(
                backgroundColor: HexColor(product.color),
                text: product.name,
                isTappable: true,
                onTap: null,
                boxShape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            title: Text(
              product.name,
              style: const TextStyle(color: Colors.black),
            ),
            trailing: ViewModelBuilder<StockViewModel>.reactive(
              viewModelBuilder: () => StockViewModel(),
              onModelReady: (StockViewModel stockModel) =>
                  stockModel.loadStockByProductId(
                      productId: product.id, context: context),
              builder: (BuildContext context, StockViewModel stockModel,
                  Widget child) {
                // FIXME: fix showing prices when a product has more than one variant
                return stockModel.stock.isEmpty || stockModel.stock.length > 1
                    ? const Text(
                        ' Prices',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'RWF ' +
                            stockModel.stock[0].retailPrice.toInt().toString(),
                        style: const TextStyle(color: Colors.black),
                      );
              },
            ),
          ),
        ),
      );
    }
  }
  if (!showCreateItemOnTop) {
    buildProductRowHeader(
      list: list,
      context: context,
      createButtonName: createButtonName,
      userId: userId,
      type: 'add',
    );
  }

  return list;
}
