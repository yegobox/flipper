import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/widget/create_options_widget.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flipper/util/HexColor.dart';
import 'package:flipper/util/flitter_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({
    Key key,
    @required this.context,
    @required this.data,
    @required this.vm,
    @required this.showCreateItemOnTop,
    @required this.createButtonName,
    @required this.shouldSeeItem,
  }) : super(key: key);

  final BuildContext context;
  final List<ProductTableData> data;
  final CommonViewModel vm;
  final bool showCreateItemOnTop;
  final String createButtonName;
  final bool shouldSeeItem;

  @override
  _ProductsViewState createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  List<Widget> getProducts(List<ProductTableData> products,
      BuildContext context, CommonViewModel vm) {
    List<Widget> list = new List<Widget>();

    if (widget.showCreateItemOnTop) {
      addItemRow(list, context, widget.createButtonName);
    }
    if (!widget.showCreateItemOnTop) {
      itemRow(list, context);
    }

    for (var i = 0; i < products.length; i++) {
      if (products[i] != null &&
          products[i].name != "custom" &&
          products[i].name != 'tmp') {
        list.add(
          GestureDetector(
            onTap: () {
              if (widget.shouldSeeItem) {
                shouldSeeItemOnly(context, products, i);
              } else {
                onSellingItem(context, products, i);
              }
            },
            onLongPress: () {
              if (widget.shouldSeeItem) {
                shouldSeeItemOnly(context, products, i);
              } else {
                onSellingItem(context, products, i);
              }
            },
            child: ListTile(
              contentPadding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              leading: Container(
                color: HexColor(products[i].color),
                width: 50,
                child: FlatButton(
                  child: Text(
                    products[i].name.length > 2
                        ? products[i].name.substring(0, 2)
                        : products[i].name,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
              title: Text(
                products[i].name,
                style: TextStyle(color: Colors.black),
              ),
              trailing: StreamBuilder(
                stream: vm.database.stockDao.getStockByProductIdStream(
                    branchId: vm.branch.id, productId: products[i].id),
                builder:
                    (context, AsyncSnapshot<List<StockTableData>> snapshot) {
                  if (snapshot.data == null) {
                    return Text("");
                  }

                  print(vm.branch.id);
                  return snapshot.data.length == 1
                      ? Text(
                          "RWF " + snapshot.data[0].retailPrice.toString(),
                          style: TextStyle(color: Colors.black),
                        )
                      : Text(
                          snapshot.data.length.toString() + " Prices",
                          style: TextStyle(color: Colors.black),
                        );
                },
              ),
            ),
          ),
        );
      }
    }
    if (!widget.showCreateItemOnTop) {
      addItemRow(list, context, widget.createButtonName);
    }
    ;
    return list;
  }

  void onSellingItem(
      BuildContext context, List<ProductTableData> products, int i) async {
    List<Variation> variants = await buildVariantsList(context, products, i);

    dispatchCurrentProductVariants(context, variants, products, i);

    Router.navigator.pushNamed(Router.editQuantityItemScreen,
        arguments:
            ChangeQuantityForSellingArguments(productId: products[i].id));
  }

  void dispatchCurrentProductVariants(BuildContext context,
      List<Variation> variants, List<ProductTableData> products, int i) {
    StoreProvider.of<AppState>(context)
        .dispatch(ItemsVariation(variations: variants));

    print(products[i].id);

    StoreProvider.of<AppState>(context).dispatch(
      CurrentActiveSaleProduct(
        product: Product(
          (b) => b
            ..name = products[i].name
            ..description = products[i].description
            ..isCurrentUpdate = products[i].isCurrentUpdate
            ..isDraft = products[i].isDraft
            ..categoryId = products[i].categoryId
            ..supplierId = products[i].supplierId
            ..businessId = products[i].businessId
            ..color = products[i].color
            ..taxId = products[i].taxId
            ..hasPicture = products[i].hasPicture
            ..active = products[i].active
            ..picture = products[i].picture
            ..id = products[i].id,
        ),
      ),
    );
  }

  Future<List<Variation>> buildVariantsList(
      BuildContext context, List<ProductTableData> products, int i) async {
    List<VariationTableData> variations =
        await StoreProvider.of<AppState>(context)
            .state
            .database
            .variationDao
            .getVariationByItemId(productId: products[i].id);

    List<Variation> variants = [];
    for (var i = 0; i < variations.length; i++) {
      variants.add(
        Variation(
          (b) => b
            ..sku = variations[i].sku ??
                'none' //todo: check if a variant can be save with no default sku
            ..productId = variations[i].productId
            ..id = variations[i].id
            ..name = variations[i].name,
        ),
      );
    }
    return variants;
  }

  void shouldSeeItemOnly(
      BuildContext context, List<ProductTableData> products, int i) {
    StoreProvider.of<AppState>(context).dispatch(
      CurrentActiveSaleProduct(
        product: Product(
          (b) => b
            ..name = products[i].name
            ..description = products[i].description
            ..picture = products[i].picture
            ..taxId = products[i].taxId
            ..active = products[i].active
            ..hasPicture = products[i].hasPicture
            ..isDraft = products[i].isDraft
            ..color = products[i].color
            ..isCurrentUpdate = products[i].isCurrentUpdate
            ..supplierId = products[i].supplierId
            ..categoryId = products[i].categoryId
            ..businessId = products[i].businessId
            ..id = products[i].id,
        ),
      ),
    );
    Router.navigator.pushNamed(
      Router.viewSingleItem,
      arguments: ViewSingleItemScreenArguments(
        productId: products[i].id,
        itemName: products[i].name,
        itemColor: products[i].color,
      ),
    );
  }

  void itemRow(List<Widget> list, BuildContext context) {
    return list.add(
      ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Container(
          width: 50,
          color: HexColor(FlipperColors.gray),
          child: IconButton(
            icon: Icon(Icons.star_border),
            color: Colors.white,
            onPressed: () {},
          ),
        ),
        title: Text(
          S.of(context).reedeemRewards,
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
          StoreProvider.of<AppState>(context).dispatch(CleanVariation());
          StoreProvider.of<AppState>(context).dispatch(CleanAppActions());
          StoreProvider.of<AppState>(context).dispatch(CleanCurrentColor());

          showDialog(
            context: context,
            builder: (BuildContext context) {
              return CreateOptionsWidget();
            },
          );
        },
        child: ListTile(
          leading: Icon(Icons.add),
          title: Text(
            createButtonName,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: getProducts(widget.data, context, widget.vm),
      ).toList(),
    );
  }
}
