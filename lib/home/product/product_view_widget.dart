import 'package:flipper/domain/redux/functions.dart';
import 'package:flipper/home/stock/stock_viewmodel.dart';

import 'package:flipper/home/widget/create_options_widget.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/dispatcher.dart';
import 'package:flipper/utils/flitter_color.dart';

import 'package:flutter/material.dart';

import 'package:stacked/stacked.dart';

import 'widget/build_variant.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({
    Key key,
    @required this.context,
    @required this.data,
    @required this.showCreateItemOnTop,
    @required this.createButtonName,
    @required this.shouldSeeItem,
  }) : super(key: key);

  final BuildContext context;
  final List<Product> data;

  final bool showCreateItemOnTop;
  final String createButtonName;
  final bool shouldSeeItem;

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final FlipperNavigationService _navigationService =
     ProxyService.nav;

  List<Widget> getProducts(List<Product> products, BuildContext context) {
    final List<Widget> list = <Widget>[];
     if (widget.showCreateItemOnTop) {
      addItemRow(list, context, widget.createButtonName);
    }
    if (!widget.showCreateItemOnTop) {
      itemRow(list, context);
    }
    if(products==null) {
      return list;
    }
   

    for (Product product in products) {
      if (product != null &&
          product.name != 'tmp' ) {
        list.add(
          GestureDetector(
            onTap: () {
              if (widget.shouldSeeItem) {
                shouldSeeItemOnly(context, product);
              } else {
                onSellingItem(context, product);
              }
            },
            onLongPress: () {
              if (widget.shouldSeeItem) {
                shouldSeeItemOnly(context, product);
              } else {
                onSellingItem(context, product);
              }
            },
            child: ListTile(
              contentPadding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
              leading: Container(
                color: HexColor(product.color),
                width: 50,
                child: FlatButton(
                  child: Text(
                    product.name.length > 2
                        ? product.name.substring(0, 2)
                        : product.name,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              title: Text(
                product.name,
                style: const TextStyle(color: Colors.black),
              ),
              // ignore: always_specify_types
              trailing: ViewModelBuilder<StockViewModel>.reactive(
                  viewModelBuilder: () => StockViewModel(),
                  onModelReady: (StockViewModel model) => model.loadStockById(
                      productId: product.id, context: context),
                  builder: (BuildContext context, StockViewModel model,
                      Widget child) {
                    return model.data.length == 1
                        ? const Text(
                            'RWF 500',
                            // 'RWF ' + model.data[0].retailPrice.toString(),
                            style: TextStyle(color: Colors.black),
                          )
                        : const Text(
                            ' Prices',
                            style: TextStyle(color: Colors.black),
                          );
                  }),
            ),
          ),
        );
      }
    }
    if (!widget.showCreateItemOnTop) {
      addItemRow(list, context, widget.createButtonName);
    }

    return list;
  }

  void onSellingItem(
      BuildContext context, Product product) async {
    final List<Variation> variants =
        await buildVariantsList(context, product);

    dispatchCurrentProductVariants(context, variants, product);

    _navigationService.navigateTo(Routing.editQuantityItemScreen,
        arguments:
            ChangeQuantityForSellingArguments(productId: product.id));
  }

  void itemRow(List<Widget> list, BuildContext context) {
    return list.add(
      ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          width: 50,
          color: HexColor(FlipperColors.gray),
          child: IconButton(
            icon: const Icon(Icons.star_border),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
        title: const Text(
          'Reedeem Rewards',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  void addItemRow(
      List<Widget> list, BuildContext context, String createButtonName) {
    return list.add(
      GestureDetector(
        onTap: () {
          //clearn state first
          // clear();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateOptionsWidget();
            },
          );
        },
        child: ListTile(
          leading: const Icon(Icons.add),
          title: Text(
            createButtonName,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return getProducts(widget.data, context).isEmpty?const SizedBox.shrink(): ListView(
      shrinkWrap: true,
      children: ListTile.divideTiles(
        context: context,
        tiles: getProducts(widget.data, context),
      ).toList(),
    );
  }
}
