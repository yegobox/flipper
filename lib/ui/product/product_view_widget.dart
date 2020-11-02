import 'package:flipper/domain/redux/functions.dart';
import 'package:flipper/ui/stock/stock_viewmodel.dart';

import 'package:flipper/ui/widget/create_options_widget.dart';
import 'package:flipper/services/proxy.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';

import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/services/flipperNavigation_service.dart';
import 'package:flipper/utils/HexColor.dart';
import 'package:flipper/utils/dispatcher.dart';
import 'package:flipper/utils/flitter_color.dart';
import 'package:flipper/utils/logger.dart';

import 'package:flutter/material.dart';
import 'package:flutter_text_drawable/flutter_text_drawable.dart';
import 'package:logger/logger.dart';

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
    @required this.userId,
  }) : super(key: key);

  final BuildContext context;
  final String createButtonName;
  final List<Product> data;
  final bool shouldSeeItem;
  final bool showCreateItemOnTop;
  final String userId;

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final Logger log = Logging.getLogger('product view');

  final FlipperNavigationService _navigationService = ProxyService.nav;

  List<Widget> buildProductView(
      List<Product> products, BuildContext context, String userId) {
   
    final List<Widget> list = <Widget>[];
    if (widget.showCreateItemOnTop) {
      addItemRow(list, context, widget.createButtonName, userId);
    }
    if (!widget.showCreateItemOnTop) {
      itemRow(list, context);
    }
    if (products == null) {
      return list;
    }

    for (Product product in products) {
      if (product != null && product.name != 'tmp') {
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
    if (!widget.showCreateItemOnTop) {
      addItemRow(list, context, widget.createButtonName, userId);
    }

    return list;
  }

  void onSellingItem(BuildContext context, Product product) async {
    final List<Variation> variants = await buildVariantsList(context, product);

    dispatchCurrentProductVariants(context, variants, product);

    _navigationService.navigateTo(Routing.editQuantityItemScreen,
        arguments: ChangeQuantityForSellingArguments(productId: product.id));
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

  void addItemRow(List<Widget> list, BuildContext context,
      String createButtonName, String userId) {
    return list.add(
      GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateOptionsWidget(
                userId: userId,
              );
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
    return buildProductView(widget.data, context, widget.userId).isEmpty
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: ListView(
              shrinkWrap: true,
              children: ListTile.divideTiles(
                context: context,
                tiles: buildProductView(widget.data, context, widget.userId),
              ).toList(),
            ),
          );
  }
}
