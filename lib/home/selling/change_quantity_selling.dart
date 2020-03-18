import 'package:customappbar/commonappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flipper/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ChangeQuantityForSelling extends StatefulWidget {
  ChangeQuantityForSelling({Key key, @required this.productId})
      : super(key: key);
  final String productId;

  @override
  _ChangeQuantityForSellingState createState() =>
      _ChangeQuantityForSellingState();
}

class _ChangeQuantityForSellingState extends State<ChangeQuantityForSelling> {
  final incrementController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CommonViewModel>(
        distinct: true,
        converter: CommonViewModel.fromStore,
        builder: (context, vm) {
          return StreamBuilder(
              stream: vm.database.stockDao.getStockByProductIdStream(
                  branchId: vm.branch.id, productId: widget.productId),
              builder: (context, AsyncSnapshot<List<StockTableData>> snapshot) {
                if (snapshot.data == null) {
                  return Text("");
                }
                return SellMultipleItems(
                  stocks: snapshot.data,
                  vm: vm,
                );
              });
        });
  }
}

class ControlSaleWidget extends StatelessWidget {
  const ControlSaleWidget({Key key, @required this.vm}) : super(key: key);
  final CommonViewModel vm;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      title: Center(
        child: Container(
          width: 80,
          child: TextField(
            textDirection: TextDirection.rtl,
            onChanged: (count) {
              //todo: work on entering count from keyboard right now it is messing around with other inputs
            },
            controller: TextEditingController(
              text: vm.currentIncrement == null
                  ? "1"
                  : vm.currentIncrement.toString(),
            ),
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
      leading: IconButton(
        enableFeedback: false,
        icon: Icon(Icons.remove),
        onPressed: () {
          if (vm.itemVariations.length > 0) {
            for (var i = 0; i < vm.itemVariations.length; i++) {
              if (vm.currentActiveSaleItem.id == vm.itemVariations[i].id) {
                if (vm.currentIncrement == null) {
                  return;
                }
                if (vm.currentIncrement - 1 == -1) {
                  return;
                }
                var increment = vm.currentIncrement - 1;
                StoreProvider.of<AppState>(context).dispatch(
                  IncrementAction(
                    increment: vm.currentIncrement == null ? 0 : increment,
                  ),
                );
                Product cartProduct = buildItem(i, increment);
                StoreProvider.of<AppState>(context).dispatch(
                  AddItemToCartAction(cartItem: cartProduct),
                );
              }
            }
          }
        },
      ),
      trailing: IconButton(
        enableFeedback: false,
        icon: Icon(Icons.add),
        onPressed: () {
          print(vm.currentActiveSaleItem.id);
          print(vm.itemVariations);
          for (var i = 0; i < vm.itemVariations.length; i++) {
            if (vm.currentActiveSaleItem.id == vm.itemVariations[i].productId) {
              var increment =
                  vm.currentIncrement == null ? 1 : vm.currentIncrement + 1;

              StoreProvider.of<AppState>(context).dispatch(
                IncrementAction(
                  increment: vm.currentIncrement == null ? 1 : increment,
                ),
              );
              Product cartItem = buildItem(i, increment);
              StoreProvider.of<AppState>(context).dispatch(
                AddItemToCartAction(cartItem: cartItem),
              );
            }
          }
        },
      ),
    );
  }

  Product buildItem(int i, int increment) {
    return Product(
      (b) => b
        ..id = vm.itemVariations[i].id
        ..name = vm.itemVariations[i].name
        ..count = increment,
    );
  }
}

class SellMultipleItems extends StatelessWidget {
  final List<StockTableData> stocks;
  final CommonViewModel vm;

  final Product activeItem;
  const SellMultipleItems({Key key, this.stocks, this.vm, this.activeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {
          Router.navigator.pop();
        },
        disableButton: false,
        showActionButton: true,
        actionButtonName: S.of(context).add,
        title: vm.currentActiveSaleItem == null
            ? null
            : vm.currentActiveSaleItem.name,
//            +
//                " RWF " +
//                //todo:  vm.currentActiveSaleItem.picture => vm.currentActiveSaleItem.price i.e variant price
//                (vm.currentActiveSaleItem.color *
//                        (vm.currentIncrement == null || vm.currentIncrement == 0
//                            ? 1
//                            : vm.currentIncrement))
//                    .toString(),
        onPressedCallback: () {
          //todo: show animation like square that item has been added to the current sale
          if (StoreProvider.of<AppState>(context).state.cartItem == null) {
            Product cartItem = Product(
              (b) => b
                ..id = vm.itemVariations[0].id
                ..name = vm.itemVariations[0].name
                ..count = 1,
            );
            StoreProvider.of<AppState>(context).dispatch(
              AddItemToCartAction(cartItem: cartItem),
            );
            StoreProvider.of<AppState>(context).dispatch(SaveCart());
          } else {
            _saveCart(vm, context);
          }
          // Router.navigator.pop();
        },
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _variantsList(context, stocks),
          )
        ],
      ),
    );
  }

  Widget _variantsList(BuildContext context, List<StockTableData> stocks) {
    return ListView(
      children: ListTile.divideTiles(
        context: context,
        tiles: getVariantsRow(stocks, context),
      ).toList(),
    );
  }

  List<Widget> getVariantsRow(
      List<StockTableData> stocks, BuildContext context) {
    List<Widget> list = new List<Widget>();
    list.add(
      chooserRow(),
    );
    for (var i = 0; i < stocks.length; i++) {
      isItemActive(stocks, i, context);

      list.add(
        itemRow(context, stocks, i),
      );
    }
    list.add(ControlSaleWidget(vm: vm));
    return list;
  }

  ListTile chooserRow() {
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(20, 20, 0, 0),
      leading: Text(vm.currentActiveSaleItem == null
          ? "CHOOSE ONE"
          : vm.currentActiveSaleItem.name + " CHOOSE ONE"),
    );
  }

  void isItemActive(List<StockTableData> stocks, int i, BuildContext context) {
    if (stocks[i].isActive) {
      StoreProvider.of<AppState>(context).dispatch(
        IncrementAction(
          increment: vm.currentIncrement == null ? 1 : vm.currentIncrement,
        ),
      );
      StoreProvider.of<AppState>(context).dispatch(
        CurrentActiveSaleProduct(
          product: Product((ui) => ui
            ..id = stocks[i].id
            ..name = vm.currentActiveSaleItem.name),
        ),
      );
      Product cartItem = Product(
        (item) => item
          ..count = vm.currentIncrement == null ? 1 : vm.currentIncrement
          ..id = stocks[i].productId
          ..name = vm.currentActiveSaleItem.name,
      );
      StoreProvider.of<AppState>(context).dispatch(
        AddItemToCartAction(cartItem: cartItem),
      );
    }
  }

  GestureDetector itemRow(
      BuildContext context, List<StockTableData> stocks, int i) {
    return GestureDetector(
      onTap: () {
        for (var y = 0; y < stocks.length; y++) {
          vm.database.stockDao.updateStock(stocks[y].copyWith(isActive: false));
        }
        vm.database.stockDao
            .updateStock(stocks[i].copyWith(isActive: !stocks[i].isActive));
        StoreProvider.of<AppState>(context).dispatch(
          CurrentActiveSaleProduct(
            product: Product((ui) => ui
              ..id = stocks[i].id
              ..name = vm.currentActiveSaleItem.name),
          ),
        );

        List<Product> cartItems = [];
        cartItems.add(
          buildActiveItem(stocks, i),
        );
      },
      child: ListTile(
        contentPadding: EdgeInsets.fromLTRB(20, 20, 40, 10),
        dense: false,
        title: Align(
          alignment: Alignment.topRight,
          child: Text(
            "FRW " + stocks[i].retailPrice.toString(),
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
        leading: StreamBuilder(
            stream: vm.database.variationDao
                .getVariationByIdStream(stocks[i].variantId),
            builder:
                (context, AsyncSnapshot<List<VariationTableData>> snapshot) {
              if (snapshot.data == null || snapshot.data.length == 0) {
                return Text("");
              }
              return Text(
                snapshot.data[0].name,
                style: TextStyle(
                  color: Colors.black,
                ),
              );
            }),
        trailing: Radio(
          value: stocks[i].idLocal,
          groupValue: stocks[i].isActive ? stocks[i].id : 0,
          onChanged: (Object value) {},
        ),
      ),
    );
  }

  Product buildActiveItem(List<StockTableData> stocks, int i) {
    return Product((updated) => updated
      ..count = vm.currentIncrement
      ..id = stocks[i].id);
  }

  void _saveCart(CommonViewModel vm, context) {
    StoreProvider.of<AppState>(context).dispatch(SaveCart());
  }
}
