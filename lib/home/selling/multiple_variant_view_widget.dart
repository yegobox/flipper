import 'package:customappbar/customappbar.dart';
import 'package:flipper/data/main_database.dart';
import 'package:flipper/domain/redux/app_actions/actions.dart';
import 'package:flipper/domain/redux/app_state.dart';
import 'package:flipper/generated/l10n.dart';
import 'package:flipper/home/selling/actions.dart';
import 'package:flipper/home/selling/control_widget.dart';
import 'package:flipper/model/product.dart';
import 'package:flipper/model/variation.dart';
import 'package:flipper/presentation/home/common_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MultipleVariantViewWidget extends StatelessWidget {
  final List<StockTableData> stocks;
  final CommonViewModel vm;

  final Product activeItem;
  const MultipleVariantViewWidget(
      {Key key, this.stocks, this.vm, this.activeItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppBar(
        onPop: () {},
        disableButton: false,
        showActionButton: true,
        actionButtonName: S.of(context).add,
        title: vm.currentActiveSaleProduct == null
            ? null
            : vm.currentActiveSaleProduct.name +
                " " +
                vm.total?.value.toString(),
        onPressedCallback: () {
          _saveCart(vm, context);
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
      isVariantActive(stocks, i, context);

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
      leading: Text(vm.currentActiveSaleProduct == null
          ? "CHOOSE ONE"
          : vm.currentActiveSaleProduct.name + " CHOOSE ONE"),
    );
  }

  void isVariantActive(
      List<StockTableData> stocks, int i, BuildContext context) {
    if (stocks[i].isActive) {
      StoreProvider.of<AppState>(context).dispatch(
        IncrementAction(
          increment: vm.currentIncrement == null ? 1 : vm.currentIncrement,
        ),
      );
      StoreProvider.of<AppState>(context)
          .dispatch(OnSellingVariant(variantId: stocks[i].variantId));

      Variation v =
          vm.itemVariations.firstWhere((b) => b.id == stocks[i].variantId);

      Product cartItem = Product(
        (b) => b
          ..id = v.id
          ..name = v.name
          ..count = vm.currentIncrement,
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
          groupValue: stocks[i].isActive ? stocks[i].idLocal : 0,
          onChanged: (Object value) {},
        ),
      ),
    );
  }

  void _saveCart(CommonViewModel vm, context) {
    StoreProvider.of<AppState>(context).dispatch(SaveCart());
  }
}
