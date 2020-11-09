import 'package:flipper/model/product.dart';
import 'package:flipper/ui/product/product_viewmodel.dart';
import 'package:flipper/ui/product/widget/build_product_row.dart';

import 'package:flipper/ui/stock/stock_viewmodel.dart';
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
              onModelReady: (StockViewModel stockModel) => stockModel
                  .loadStockById(productId: product.id, context: context),
              builder: (BuildContext context, StockViewModel stockModel,
                  Widget child) {
                return stockModel.stock.isEmpty || stockModel.busy
                    ? const Text(
                        ' Prices',
                        style: TextStyle(color: Colors.black),
                      )
                    : Text(
                        'RWF ' + stockModel.stock[0].retailPrice.toString(),
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
