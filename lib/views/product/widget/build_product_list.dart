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

  if (products.isEmpty) {
    return list;
  }

  buildProductRowHeader(
    list: list,
    context: context,
    createButtonName: createButtonName,
    userId: userId,
    type: 'reward', //on top of product there should be Add buttom
  );

  // build a list of products.
  for (Product product in products) {
    if (product != null &&
        product.name != 'tmp' &&
        product.name != 'Custom Amount') {
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
          child: Column(children: <Widget>[
            ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              // leading: callImageBox(context, product),
              leading: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: 58,
                child: product.picture == null
                    ? TextDrawable(
                        backgroundColor: HexColor(product.color),
                        text: product.name,
                        isTappable: true,
                        onTap: null,
                        boxShape: BoxShape.rectangle,
                      )
                    : Image.network(
                        product.picture,
                        fit: BoxFit.cover,
                        frameBuilder: (BuildContext context, Widget child,
                            int frame, bool wasSynchronouslyLoaded) {
                          if (wasSynchronouslyLoaded) {
                            return child;
                          }
                          return AnimatedOpacity(
                            child: child,
                            opacity: frame == null ? 0 : 1,
                            duration: const Duration(seconds: 1),
                            curve: Curves.easeOut,
                          );
                        },
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
                              stockModel.stock[0].retailPrice
                                  .toInt()
                                  .toString(),
                          style: const TextStyle(color: Colors.black),
                        );
                },
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black26,
            ),
          ]),
        ),
      );
    }
  }
  //
  // buildProductRowHeader(
  //   list: list,
  //   context: context,
  //   createButtonName: createButtonName,
  //   userId: userId,
  //   type: 'add', //on top of product there should be Add buttom
  // );

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

callImageBox(BuildContext context, Product product) {
  if (product.hasPicture) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 58,
      child: ImageIcon(
        AssetImage(
          product.picture,
        ),
        color: Colors.white,
      ),
    );
  } else {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: 58,
      child: TextDrawable(
        backgroundColor: Colors.black38,
        text: product.name,
        isTappable: true,
        onTap: null,
        boxShape: BoxShape.rectangle,
      ),
    );
  }
}
